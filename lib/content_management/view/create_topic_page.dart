import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_topic/create_topic_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
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
      ),
      child: const _CreateTopicView(),
    );
  }
}

class _CreateTopicView extends StatefulWidget {
  const _CreateTopicView();

  @override
  State<_CreateTopicView> createState() => _CreateTopicViewState();
}

class _CreateTopicViewState extends State<_CreateTopicView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _iconUrlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateTopicBloc>().state;
    _nameController = TextEditingController(text: state.name);
    _descriptionController = TextEditingController(text: state.description);
    _iconUrlController = TextEditingController(text: state.iconUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  /// Shows a dialog to the user when the form is invalid, offering options
  /// to complete the form or discard changes.
  Future<void> _showInvalidFormDialog(BuildContext context) async {
    final l10n = AppLocalizationsX(context).l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.invalidFormTitle),
        content: Text(l10n.invalidFormMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.completeForm),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.discard),
          ),
        ],
      ),
    );

    if (result ?? false) {
      // If user chooses to discard, pop the page.
      if (context.mounted) {
        context.pop();
      }
    }
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
              if (state.status == CreateTopicStatus.submitting) {
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
                onPressed: () async {
                  if (state.isFormValid) {
                    final selectedStatus = await _showSaveOptionsDialog(
                      context,
                    );
                    if (selectedStatus == ContentStatus.active) {
                      context.read<CreateTopicBloc>().add(
                        const CreateTopicPublished(),
                      );
                    } else if (selectedStatus == ContentStatus.draft) {
                      context.read<CreateTopicBloc>().add(
                        const CreateTopicSavedAsDraft(),
                      );
                    }
                  } else {
                    await _showInvalidFormDialog(context);
                  }
                },
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
          if (state.status == CreateTopicStatus.failure) {
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
                    TextFormField(
                      controller: _iconUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.iconUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context.read<CreateTopicBloc>().add(
                        CreateTopicIconUrlChanged(value),
                      ),
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
