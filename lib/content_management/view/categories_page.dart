import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/l10n/app_localizations.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/routes.dart';
import 'package:ht_dashboard/shared/constants/app_spacing.dart';
import 'package:ht_dashboard/shared/widgets/failure_state_widget.dart';
import 'package:ht_dashboard/shared/widgets/loading_state_widget.dart';
import 'package:ht_shared/ht_shared.dart';

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
  static const int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    context.read<ContentManagementBloc>().add(
          const LoadCategoriesRequested(limit: _rowsPerPage),
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
                    const LoadCategoriesRequested(limit: _rowsPerPage),
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
                label: Text(l10n.description),
                size: ColumnSize.M,
              ),
              DataColumn2(
                label: Text(l10n.actions),
                size: ColumnSize.S,
              ),
            ],
            source: _CategoriesDataSource(
              context: context,
              categories: state.categories,
              l10n: l10n,
            ),
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: const [_rowsPerPage],
            onPageChanged: (pageIndex) {
              final newOffset = pageIndex * _rowsPerPage;
              if (newOffset >= state.categories.length &&
                  state.categoriesHasMore) {
                context.read<ContentManagementBloc>().add(
                      LoadCategoriesRequested(
                        startAfterId: state.categoriesCursor,
                        limit: _rowsPerPage,
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
    required this.l10n,
  });

  final BuildContext context;
  final List<Category> categories;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= categories.length) {
      return null;
    }
    final category = categories[index];
    return DataRow2(
      cells: [
        DataCell(Text(category.name)),
        DataCell(Text(category.description ?? l10n.notAvailable)),
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
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories.length;

  @override
  int get selectedRowCount => 0;
}
