import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/content_management/bloc/edit_category/edit_category_bloc.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/shared/constants/pagination_constants.dart';
import 'package:ht_dashboard/shared/shared.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

/// {@template edit_category_page}
/// A page for editing an existing category.
/// It uses a [BlocProvider] to create and provide an [EditCategoryBloc].
/// {@endtemplate}
class EditCategoryPage extends StatelessWidget {
  /// {@macro edit_category_page}
  const EditCategoryPage({required this.categoryId, super.key});

  /// The ID of the category to be edited.
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditCategoryBloc(
        categoriesRepository: context.read<HtDataRepository<Category>>(),
        categoryId: categoryId,
      )..add(const EditCategoryLoaded()),
      child: const _EditCategoryView(),
    );
  }
}

class _EditCategoryView extends StatefulWidget {
  const _EditCategoryView();

  @override
  State<_EditCategoryView> createState() => _EditCategoryViewState();
}

class _EditCategoryViewState extends State<_EditCategoryView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _iconUrlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<EditCategoryBloc>().state;
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editCategory),
        actions: [
          BlocBuilder<EditCategoryBloc, EditCategoryState>(
            builder: (context, state) {
              if (state.status == EditCategoryStatus.submitting) {
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
                    ? () => context.read<EditCategoryBloc>().add(
                        const EditCategorySubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<EditCategoryBloc, EditCategoryState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.initialCategory != current.initialCategory,
        listener: (context, state) {
          if (state.status == EditCategoryStatus.success &&
              state.initialCategory != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                // TODO(l10n): Localize this message.
                const SnackBar(content: Text('Category updated successfully.')),
              );
            context.read<ContentManagementBloc>().add(
                  const LoadCategoriesRequested(
                    limit: kDefaultRowsPerPage,
                  ),
            );
            context.pop();
          }
          if (state.status == EditCategoryStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? l10n.unknownError),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
          if (state.initialCategory != null) {
            _nameController.text = state.name;
            _descriptionController.text = state.description;
            _iconUrlController.text = state.iconUrl;
          }
        },
        builder: (context, state) {
          if (state.status == EditCategoryStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.category,
              // TODO(l10n): Localize this message.
              headline: 'Loading Category...',
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.status == EditCategoryStatus.failure &&
              state.initialCategory == null) {
            return FailureStateWidget(
              message: state.errorMessage ?? l10n.unknownError,
              onRetry: () => context.read<EditCategoryBloc>().add(
                const EditCategoryLoaded(),
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
                        labelText: l10n.categoryName,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<EditCategoryBloc>()
                          .add(EditCategoryNameChanged(value)),
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
                          .read<EditCategoryBloc>()
                          .add(EditCategoryDescriptionChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _iconUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.iconUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<EditCategoryBloc>()
                          .add(EditCategoryIconUrlChanged(value)),
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
