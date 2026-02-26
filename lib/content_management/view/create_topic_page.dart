import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_topic/create_topic_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/supported_language_flag.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/supported_language_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/localized_text_form_field.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template create_topic_page}
/// A page for creating a new topic.
/// It uses a [BlocProvider] to create and provide a [CreateTopicBloc].
/// {@endtemplate}
class CreateTopicPage extends StatelessWidget {
  /// {@macro create_topic_page}
  const CreateTopicPage({super.key});

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
          CreateTopicBloc(
            topicsRepository: context.read<DataRepository<Topic>>(),
            mediaRepository: context.read<MediaRepository>(),
            logger: Logger('CreateTopicBloc'),
          )..add(
            CreateTopicInitialized(
              enabledLanguages:
                  localizationConfig?.enabledLanguages ??
                  [SupportedLanguage.en],
              defaultLanguage:
                  localizationConfig?.defaultLanguage ?? SupportedLanguage.en,
            ),
          ),
      child: const CreateTopicView(),
    );
  }
}

/// The view for creating a new topic, containing the form and logic.
class CreateTopicView extends StatefulWidget {
  /// Creates a [CreateTopicView].
  const CreateTopicView({super.key});

  @override
  State<CreateTopicView> createState() => _CreateTopicViewState();
}

class _CreateTopicViewState extends State<CreateTopicView> {
  final _formKey = GlobalKey<FormState>();

  /// Shows a dialog to the user to choose between publishing or saving as draft.
  Future<ContentStatus?> _showSaveOptionsDialog(BuildContext context) async {
    final l10n = AppLocalizationsX(context).l10n;
    return showDialog<ContentStatus>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.saveChanges),
        content: Text(l10n.saveHeadlineMessage), // Reusing generic save message
        actions: [
          TextButton(
            onPressed: () {
              if (!context.mounted) return;
              Navigator.of(context).pop(ContentStatus.draft);
            },
            child: Text(l10n.saveAsDraft),
          ),
          TextButton(
            onPressed: () {
              if (!context.mounted) return;
              Navigator.of(context).pop(ContentStatus.active);
            },
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
        title: Text(l10n.createTopic),
        actions: [
          BlocBuilder<CreateTopicBloc, CreateTopicState>(
            builder: (context, state) {
              if (state.status == CreateTopicStatus.imageUploading ||
                  state.status == CreateTopicStatus.entitySubmitting) {
                return const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.lg),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.save),
                tooltip: l10n.saveChanges,
                onPressed: state.isFormValid
                    ? () => _handleSave(context, state)
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CreateTopicBloc, CreateTopicState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CreateTopicStatus.success &&
              state.createdTopic != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.topicCreatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == CreateTopicStatus.imageUploadFailure ||
              state.status == CreateTopicStatus.entitySubmitFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Builder(
                    builder: (context) => Text(
                      state.exception!.toFriendlyMessage(context),
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
        },
        builder: (context, state) {
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
                        onTap: (index) => context.read<CreateTopicBloc>().add(
                          CreateTopicLanguageTabChanged(
                            state.enabledLanguages[index],
                          ),
                        ),
                        tabs: state.enabledLanguages.map((lang) {
                          return Tab(
                            icon: Image.network(
                              lang.flagUrl,
                              width: 24,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.flag, size: 16),
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
                            context.read<CreateTopicBloc>().add(
                              CreateTopicNameChanged(values),
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
                            context.read<CreateTopicBloc>().add(
                              CreateTopicDescriptionChanged(values),
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
                      ImageUploadField(
                        onChanged: (Uint8List? bytes, String? fileName) {
                          final bloc = context.read<CreateTopicBloc>();
                          if (bytes == null || fileName == null) {
                            bloc.add(const CreateTopicImageRemoved());
                            return;
                          }
                          bloc.add(
                            CreateTopicImageChanged(
                              imageFileBytes: bytes,
                              imageFileName: fileName,
                            ),
                          );
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

  Future<void> _handleSave(
    BuildContext context,
    CreateTopicState state,
  ) async {
    final selectedStatus = await _showSaveOptionsDialog(context);
    if (selectedStatus == null) return;

    if (!context.mounted) return;

    if (selectedStatus == ContentStatus.active) {
      context.read<CreateTopicBloc>().add(const CreateTopicPublished());
    } else {
      context.read<CreateTopicBloc>().add(const CreateTopicSavedAsDraft());
    }
  }
}
