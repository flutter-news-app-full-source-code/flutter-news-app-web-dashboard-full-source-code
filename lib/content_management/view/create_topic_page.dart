import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_topic/create_topic_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
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
    return BlocProvider(
      create: (context) => CreateTopicBloc(
        topicsRepository: context.read<DataRepository<Topic>>(),
        mediaRepository: context.read<MediaRepository>(),
        logger: Logger('CreateTopicBloc'),
      ),
      child: const CreateTopicView(),
    );
  }
}

class CreateTopicView extends StatefulWidget {
  const CreateTopicView({super.key});

  @override
  State<CreateTopicView> createState() => _CreateTopicViewState();
}

class _CreateTopicViewState extends State<CreateTopicView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateTopicBloc>().state;
    _nameController = TextEditingController(text: state.name);
    _descriptionController = TextEditingController(text: state.description);
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
        title: Text(l10n.saveTopicTitle),
        content: Text(l10n.saveTopicMessage),
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
                          context.read<CreateTopicBloc>().add(
                            const CreateTopicPublished(),
                          );
                        } else if (selectedStatus == ContentStatus.draft &&
                            context.mounted) {
                          context.read<CreateTopicBloc>().add(
                            const CreateTopicSavedAsDraft(),
                          );
                        }
                      }
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
              state.createdTopic != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.topicCreatedSuccessfully)),
              );
            context.read<ContentManagementBloc>().add(
              // Refresh the list to show the new topic
              const LoadTopicsRequested(limit: kDefaultRowsPerPage),
            );
            context.pop();
          }
          if (state.status == CreateTopicStatus.imageUploadFailure ||
              state.status == CreateTopicStatus.entitySubmitFailure) {
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
                      onChanged: (value) => context.read<CreateTopicBloc>().add(
                        CreateTopicNameChanged(value),
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
                      onChanged: (value) => context.read<CreateTopicBloc>().add(
                        CreateTopicDescriptionChanged(value),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ImageUploadField(
                      onChanged: (Uint8List? bytes, String? fileName) {
                        if (bytes != null && fileName != null) {
                          context.read<CreateTopicBloc>().add(
                            CreateTopicImageChanged(
                              imageFileBytes: bytes,
                              imageFileName: fileName,
                            ),
                          );
                        } else {
                          context.read<CreateTopicBloc>().add(
                            const CreateTopicImageRemoved(),
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
