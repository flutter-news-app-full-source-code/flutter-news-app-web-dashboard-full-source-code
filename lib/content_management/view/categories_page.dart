import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/routes.dart';
import 'package:ht_dashboard/shared/constants/pagination_constants.dart';
import 'package:ht_dashboard/shared/constants/app_spacing.dart';
import 'package:ht_dashboard/shared/shared.dart';
import 'package:ht_dashboard/shared/widgets/failure_state_widget.dart';
import 'package:ht_dashboard/shared/widgets/loading_state_widget.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:ht_dashboard/shared/extensions/content_status_l10n.dart';

/// {@template categories_page}
/// A page for displaying and managing Categories in a tabular format.
/// {@endtemplate}
class CategoriesPage extends StatefulWidget {
  /// {@macro categories_page}
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContentManagementBloc>().add(
      const LoadCategoriesRequested(limit: kDefaultRowsPerPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: BlocBuilder<ContentManagementBloc, ContentManagementState>(
        builder: (context, state) {
          if (state.categoriesStatus == ContentManagementStatus.loading &&
              state.categories.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.category,
              headline: l10n.loadingCategories,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.categoriesStatus == ContentManagementStatus.failure) {
            return FailureStateWidget(
              message: state.errorMessage ?? l10n.unknownError,
              onRetry: () => context.read<ContentManagementBloc>().add(
                const LoadCategoriesRequested(limit: kDefaultRowsPerPage),
              ),
            );
          }

          if (state.categories.isEmpty) {
            return Center(
              child: Text(l10n.noCategoriesFound),
            );
          }

          return PaginatedDataTable2(
            columns: [
              DataColumn2(
                label: Text(l10n.categoryName),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Text(l10n.status),
                size: ColumnSize.S,
              ),
              DataColumn2(
                label: Text(l10n.lastUpdated),
                size: ColumnSize.M,
              ),
              DataColumn2(
                label: Text(l10n.actions),
                size: ColumnSize.S,
                fixedWidth: 120,
              ),
            ],
            source: _CategoriesDataSource(
              context: context,
              categories: state.categories,
              isLoading: state.categoriesStatus == ContentManagementStatus.loading,
              hasMore: state.categoriesHasMore,
              l10n: l10n,
            ),
            rowsPerPage: kDefaultRowsPerPage,
            availableRowsPerPage: const [kDefaultRowsPerPage],
            onPageChanged: (pageIndex) {
              final newOffset = pageIndex * kDefaultRowsPerPage;
              if (newOffset >= state.categories.length &&
                  state.categoriesHasMore &&
                  state.categoriesStatus != ContentManagementStatus.loading) {
                context.read<ContentManagementBloc>().add(
                  LoadCategoriesRequested(
                    startAfterId: state.categoriesCursor,
                    limit: kDefaultRowsPerPage,
                  ),
                );
              }
            },
            empty: Center(child: Text(l10n.noCategoriesFound)),
            showCheckboxColumn: false,
            showFirstLastButtons: true,
            fit: FlexFit.tight,
            headingRowHeight: 56,
            dataRowHeight: 56,
            columnSpacing: AppSpacing.md,
            horizontalMargin: AppSpacing.md,
          );
        },
      ),
    );
  }
}

class _CategoriesDataSource extends DataTableSource {
  _CategoriesDataSource({
    required this.context,
    required this.categories,
    required this.isLoading,
    required this.hasMore,
    required this.l10n,
  });

  final BuildContext context;
  final List<Category> categories;
  final bool isLoading;
  final bool hasMore;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= categories.length) {
      // This can happen if hasMore is true and the user is on the last page.
      // If we are loading, show a spinner. Otherwise, we've reached the end.
      if (isLoading) {
        return DataRow2(
          cells: List.generate(
            4,
            (_) => const DataCell(Center(child: CircularProgressIndicator())),
          ),
        );
      }
      return null;
    }
    final category = categories[index];
    return DataRow2(
      onSelectChanged: (selected) {
        if (selected ?? false) {
          context.goNamed(Routes.editCategoryName, pathParameters: {'id': category.id});
        }
      },
      cells: [
        DataCell(Text(category.name)),
        DataCell(Text(category.status.l10n(context))),
        DataCell(
          Text(
            category.updatedAt != null
                // TODO(fulleni): Make date format configurable by admin.
                ? DateFormat('dd-MM-yyyy').format(category.updatedAt!.toLocal())
                : l10n.notAvailable,
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Navigate to edit page
                  context.goNamed(
                    Routes.editCategoryName, // Assuming an edit route exists
                    pathParameters: {'id': category.id},
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Dispatch delete event
                  context.read<ContentManagementBloc>().add(
                    DeleteCategoryRequested(category.id),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => hasMore;

  @override
  int get rowCount {
    // If we have more items to fetch, we add 1 to the current length.
    // This signals to PaginatedDataTable2 that there is at least one more page,
    // which enables the 'next page' button.
    if (hasMore) {
      // When loading, we show an extra row for the spinner.
      // Otherwise, we just indicate that there are more rows.
      return isLoading ? categories.length + 1 : categories.length + kDefaultRowsPerPage;
    }
    return categories.length;
  }

  @override
  int get selectedRowCount => 0;
}
