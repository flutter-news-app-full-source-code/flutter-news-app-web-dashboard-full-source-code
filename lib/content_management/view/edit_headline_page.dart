import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/content_management/bloc/edit_headline/edit_headline_bloc.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/shared/shared.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

/// {@template edit_headline_page}
/// A page for editing an existing headline.
/// It uses a [BlocProvider] to create and provide an [EditHeadlineBloc].
/// {@endtemplate}
class EditHeadlinePage extends StatelessWidget {
  /// {@macro edit_headline_page}
  const EditHeadlinePage({required this.headlineId, super.key});

  /// The ID of the headline to be edited.
  final String headlineId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditHeadlineBloc(
        headlinesRepository: context.read<HtDataRepository<Headline>>(),
        sourcesRepository: context.read<HtDataRepository<Source>>(),
        categoriesRepository: context.read<HtDataRepository<Category>>(),
        headlineId: headlineId,
      )..add(const EditHeadlineLoaded()),
      child: const _EditHeadlineView(),
    );
  }
}

class _EditHeadlineView extends StatefulWidget {
  const _EditHeadlineView();

  @override
  State<_EditHeadlineView> createState() => _EditHeadlineViewState();
}

class _EditHeadlineViewState extends State<_EditHeadlineView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _urlController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<EditHeadlineBloc>().state;
    _titleController = TextEditingController(text: state.title);
    _descriptionController = TextEditingController(text: state.description);
    _urlController = TextEditingController(text: state.url);
    _imageUrlController = TextEditingController(text: state.imageUrl);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editHeadline),
        actions: [
          BlocBuilder<EditHeadlineBloc, EditHeadlineState>(
            builder: (context, state) {
              if (state.status == EditHeadlineStatus.submitting) {
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
                    ? () => context.read<EditHeadlineBloc>().add(
                        const EditHeadlineSubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<EditHeadlineBloc, EditHeadlineState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.initialHeadline != current.initialHeadline,
        listener: (context, state) {
          if (state.status == EditHeadlineStatus.success &&
              state.updatedHeadline != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(l10n.headlineUpdatedSuccessfully),
                ),
              );
            context.read<ContentManagementBloc>().add(
              HeadlineUpdated(state.updatedHeadline!),
            );
            context.pop();
          }
          if (state.status == EditHeadlineStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? l10n.unknownError),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
          if (state.initialHeadline != null) {
            _titleController.text = state.title;
            _descriptionController.text = state.description;
            _urlController.text = state.url;
            _imageUrlController.text = state.imageUrl;
          }
        },
        builder: (context, state) {
          if (state.status == EditHeadlineStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.newspaper,
              headline: l10n.loadingHeadline,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.status == EditHeadlineStatus.failure &&
              state.initialHeadline == null) {
            return FailureStateWidget(
              message: state.errorMessage ?? l10n.unknownError,
              onRetry: () => context.read<EditHeadlineBloc>().add(
                const EditHeadlineLoaded(),
              ),
            );
          }

          // Find the correct instances from the lists to ensure
          // the Dropdowns can display the selections correctly.
          Source? selectedSource;
          if (state.source != null) {
            try {
              selectedSource = state.sources.firstWhere(
                (s) => s.id == state.source!.id,
              );
            } catch (_) {
              selectedSource = null;
            }
          }

          Category? selectedCategory;
          if (state.category != null) {
            try {
              selectedCategory = state.categories.firstWhere(
                (c) => c.id == state.category!.id,
              );
            } catch (_) {
              selectedCategory = null;
            }
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
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: l10n.headlineTitle,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineTitleChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineDescriptionChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: l10n.sourceUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.imageUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineImageUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<Source?>(
                      value: selectedSource,
                      decoration: InputDecoration(
                        labelText: l10n.sourceName,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.none)),
                        ...state.sources.map(
                          (source) => DropdownMenuItem(
                            value: source,
                            child: Text(source.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineSourceChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<Category?>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: l10n.categoryName,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.none)),
                        ...state.categories.map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineCategoryChanged(value)),
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
                        context.read<EditHeadlineBloc>().add(
                          EditHeadlineStatusChanged(value),
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
