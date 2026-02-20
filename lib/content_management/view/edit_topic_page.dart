import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_topic/edit_topic_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
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
    return BlocProvider(
      create: (context) => EditTopicBloc(
        topicsRepository: context.read<DataRepository<Topic>>(),
        mediaRepository: context.read<MediaRepository>(),
        topicId: topicId,
        logger: Logger('EditTopicBloc'),
      )..add(const EditTopicLoaded()),
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
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
                    ? () async {
                        final selectedStatus = await _showSaveOptionsDialog(
                          context,
                        );
                        if (selectedStatus == ContentStatus.active &&
                            context.mounted) {
                          context.read<EditTopicBloc>().add(
                            const EditTopicPublished(),
                          );
                        } else if (selectedStatus == ContentStatus.draft &&
                            context.mounted) {
                          context.read<EditTopicBloc>().add(
                            const EditTopicSavedAsDraft(),
                          );
                        }
                      }
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
            context.read<ContentManagementBloc>().add(
              const LoadTopicsRequested(limit: kDefaultRowsPerPage),
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
          // Update text controllers when data is loaded or changed
          if (state.status == EditTopicStatus.initial) {
            _nameController.text = state.name;
            _descriptionController.text = state.description;
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
              onRetry: () =>
                  context.read<EditTopicBloc>().add(const EditTopicLoaded()),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.topicName,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context.read<EditTopicBloc>().add(
                        EditTopicNameChanged(value),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => context.read<EditTopicBloc>().add(
                        EditTopicDescriptionChanged(value),
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
          );
        },
      ),
    );
  }
}
