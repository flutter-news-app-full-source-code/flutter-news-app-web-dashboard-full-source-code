import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/content_management/bloc/create_category/create_category_bloc.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/shared/constants/pagination_constants.dart';
import 'package:ht_dashboard/shared/shared.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

/// {@template create_category_page}
/// A page for creating a new category.
/// It uses a [BlocProvider] to create and provide a [CreateCategoryBloc].
/// {@endtemplate}
class CreateCategoryPage extends StatelessWidget {
  /// {@macro create_category_page}
  const CreateCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCategoryBloc(
        categoriesRepository: context.read<HtDataRepository<Category>>(),
      ),
      child: const _CreateCategoryView(),
    );
  }
}

class _CreateCategoryView extends StatefulWidget {
  const _CreateCategoryView();

  @override
  State<_CreateCategoryView> createState() => _CreateCategoryViewState();
}

class _CreateCategoryViewState extends State<_CreateCategoryView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createCategory),
        actions: [
          BlocBuilder<CreateCategoryBloc, CreateCategoryState>(
            builder: (context, state) {
              if (state.status == CreateCategoryStatus.submitting) {
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
                    ? () => context.read<CreateCategoryBloc>().add(
                        const CreateCategorySubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CreateCategoryBloc, CreateCategoryState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CreateCategoryStatus.success &&
              state.createdCategory != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.categoryCreatedSuccessfully)),
              );
            context.read<ContentManagementBloc>().add(
              // Refresh the list to show the new category
              const LoadCategoriesRequested(limit: kDefaultRowsPerPage),
            );
            context.pop();
          }
          if (state.status == CreateCategoryStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? l10n.unknownError),
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
                      initialValue: state.name,
                      decoration: InputDecoration(
                        labelText: l10n.categoryName,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<CreateCategoryBloc>()
                          .add(CreateCategoryNameChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      initialValue: state.description,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => context
                          .read<CreateCategoryBloc>()
                          .add(CreateCategoryDescriptionChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      initialValue: state.iconUrl,
                      decoration: InputDecoration(
                        labelText: l10n.iconUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<CreateCategoryBloc>()
                          .add(CreateCategoryIconUrlChanged(value)),
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
                        context.read<CreateCategoryBloc>().add(
                          CreateCategoryStatusChanged(value),
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
