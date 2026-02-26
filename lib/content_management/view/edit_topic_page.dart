import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_topic/edit_topic_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/supported_language_flag.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/supported_language_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/localized_text_form_field.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template edit_topic_page}
/// A page for editing an existing topic.
/// It uses a [BlocProvider] to create and provide an [EditTopicBloc].
/// {@endtemplate}
class EditTopicPage extends StatelessWidget {
  /// {@macro edit_topic_page}
  const EditTopicPage({required this.topicId, super.key});

  /// The ID of the topic to be edited.
  final String topicId;

  @override
  Widget build(BuildContext context) {
    final localizationConfig = context
        .read<AppBloc>()
        .state
        .remoteConfig
        ?.app
        .localization;

    return BlocProvider(
      create: (context) =>
          EditTopicBloc(
            topicsRepository: context.read<DataRepository<Topic>>(),
            mediaRepository: context.read<MediaRepository>(),
            topicId: topicId,
            logger: Logger('EditTopicBloc'),
          )..add(
            EditTopicLoaded(
              enabledLanguages:
                  localizationConfig?.enabledLanguages ??
                  [SupportedLanguage.en],
              defaultLanguage:
                  localizationConfig?.defaultLanguage ?? SupportedLanguage.en,
            ),
          ),
      child: const EditTopicView(),
    );
  }
}

class EditTopicView extends StatefulWidget {
  const EditTopicView({super.key});

  @override
  State<EditTopicView> createState() => _EditTopicViewState();
}

class _EditTopicViewState extends State<EditTopicView> {
  final _formKey = GlobalKey<FormState>();

  /// Shows a dialog to the user to choose between publishing or saving as draft.
  Future<ContentStatus?> _showSaveOptionsDialog(BuildContext context) async {
    final l10n = AppLocalizationsX(context).l10n;
    return showDialog<ContentStatus>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.updateTopicTitle),
        content: Text(l10n.updateTopicMessage), // Corrected l10n key
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(ContentStatus.draft),
            child: Text(l10n.saveAsDraft),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ContentStatus.active),
            child: Text(l10n.publish),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editTopic),
        actions: [
          BlocBuilder<EditTopicBloc, EditTopicState>(
            builder: (context, state) {
              if (state.status == EditTopicStatus.imageUploading ||
                  state.status == EditTopicStatus.entitySubmitting) {
                return const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.lg),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                );
              }
              // The save button is enabled only if the form is valid.
              return IconButton(
                icon: const Icon(Icons.save),
                tooltip: l10n.saveChanges,
                onPressed: state.isFormValid
                    ? () => _handleSave(context)
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<EditTopicBloc, EditTopicState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == EditTopicStatus.success &&
              state.updatedTopic != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.topicUpdatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == EditTopicStatus.imageUploadFailure ||
              state.status == EditTopicStatus.entitySubmitFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.exception!.toFriendlyMessage(context)),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status == EditTopicStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.topic,
              headline: l10n.loadingTopic,
              subheadline: l10n.pleaseWait,
            );
          }

          if ((state.status == EditTopicStatus.entitySubmitFailure ||
                  state.status == EditTopicStatus.failure) &&
              state.name.isEmpty) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<EditTopicBloc>().add(
                EditTopicLoaded(
                  enabledLanguages: state.enabledLanguages,
                  defaultLanguage: state.defaultLanguage,
                ),
              ),
            );
          }

          return DefaultTabController(
            length: state.enabledLanguages.length,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        onTap: (index) => context.read<EditTopicBloc>().add(
                          EditTopicLanguageTabChanged(
                            state.enabledLanguages[index],
                          ),
                        ),
                        tabs: state.enabledLanguages.map((lang) {
                          return Tab(
                            child: Row(
                              children: [
                                Image.network(
                                  lang.flagUrl,
                                  width: 24,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.flag, size: 16),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Text(lang.l10n(context)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      LocalizedTextFormField(
                        label: l10n.topicName,
                        values: state.name,
                        enabledLanguages: state.enabledLanguages,
                        selectedLanguage: state.selectedLanguage,
                        onChanged: (values) =>
                            context.read<EditTopicBloc>().add(
                              EditTopicNameChanged(values),
                            ),
                        validator: (values) {
                          if (values?[state.defaultLanguage]?.isEmpty ?? true) {
                            return l10n.defaultLanguageRequired(
                              state.defaultLanguage.name.toUpperCase(),
                            );
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      LocalizedTextFormField(
                        label: l10n.description,
                        values: state.description,
                        enabledLanguages: state.enabledLanguages,
                        selectedLanguage: state.selectedLanguage,
                        onChanged: (values) =>
                            context.read<EditTopicBloc>().add(
                              EditTopicDescriptionChanged(values),
                            ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ImageUploadField(
                        initialImageUrl: state.iconUrl,
                        isProcessing:
                            state.initialTopic?.mediaAssetId != null &&
                            state.iconUrl == null,
                        onChanged: (Uint8List? bytes, String? fileName) {
                          if (bytes != null && fileName != null) {
                            context.read<EditTopicBloc>().add(
                              EditTopicImageChanged(
                                imageFileBytes: bytes,
                                imageFileName: fileName,
                              ),
                            );
                          } else {
                            context.read<EditTopicBloc>().add(
                              const EditTopicImageRemoved(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    final selectedStatus = await _showSaveOptionsDialog(context);

    if (selectedStatus == null || !context.mounted) return;

    if (selectedStatus == ContentStatus.active) {
      context.read<EditTopicBloc>().add(
        const EditTopicPublished(),
      );
    } else if (selectedStatus == ContentStatus.draft) {
      context.read<EditTopicBloc>().add(
        const EditTopicSavedAsDraft(),
      );
    }
  }
}
