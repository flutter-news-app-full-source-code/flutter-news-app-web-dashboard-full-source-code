import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/content_management/bloc/edit_topic/edit_topic_bloc.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/shared/shared.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:ht_ui_kit/ht_ui_kit.dart';

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
        topicsRepository: context.read<HtDataRepository<Topic>>(),
        topicId: topicId,
      )..add(const EditTopicLoaded()),
      child: const _EditTopicView(),
    );
  }
}

class _EditTopicView extends StatefulWidget {
  const _EditTopicView();

  @override
  State<_EditTopicView> createState() => _EditTopicViewState();
}

class _EditTopicViewState extends State<_EditTopicView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _iconUrlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<EditTopicBloc>().state;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editTopic),
        actions: [
          BlocBuilder<EditTopicBloc, EditTopicState>(
            builder: (context, state) {
              if (state.status == EditTopicStatus.submitting) {
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
                    ? () => context.read<EditTopicBloc>().add(
                        const EditTopicSubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<EditTopicBloc, EditTopicState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.initialTopic != current.initialTopic,
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
              TopicUpdated(state.updatedTopic!),
            );
            context.pop();
          }
          if (state.status == EditTopicStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.exception!.toFriendlyMessage(context)),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
          if (state.initialTopic != null) {
            _nameController.text = state.name;
            _descriptionController.text = state.description;
            _iconUrlController.text = state.iconUrl;
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

          if (state.status == EditTopicStatus.failure &&
              state.initialTopic == null) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<EditTopicBloc>().add(
                const EditTopicLoaded(),
              ),
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
                    TextFormField(
                      controller: _iconUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.iconUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context.read<EditTopicBloc>().add(
                        EditTopicIconUrlChanged(value),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<ContentStatus>(
                      value: state.contentStatus,
                      decoration: InputDecoration(
                        labelText: l10n.status,
                        border: const OutlineInputBorder(),
                      ),
                      items: ContentStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.l10n(context)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<EditTopicBloc>().add(
                          EditTopicStatusChanged(value),
                        );
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
