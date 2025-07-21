import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/l10n/app_localizations.dart'; // Corrected import
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/routes.dart';
import 'package:ht_dashboard/shared/extensions/content_status_l10n.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:ht_ui_kit/ht_ui_kit.dart';
import 'package:intl/intl.dart';

/// {@template headlines_page}
/// A page for displaying and managing Headlines in a tabular format.
/// {@endtemplate}
class HeadlinesPage extends StatefulWidget {
  /// {@macro headlines_page}
  const HeadlinesPage({super.key});

  @override
  State<HeadlinesPage> createState() => _HeadlinesPageState();
}

class _HeadlinesPageState extends State<HeadlinesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContentManagementBloc>().add(
      const LoadHeadlinesRequested(limit: kDefaultRowsPerPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: BlocBuilder<ContentManagementBloc, ContentManagementState>(
        builder: (context, state) {
          if (state.headlinesStatus == ContentManagementStatus.loading &&
              state.headlines.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.newspaper,
              headline: l10n.loadingHeadlines,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.headlinesStatus == ContentManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<ContentManagementBloc>().add(
                const LoadHeadlinesRequested(limit: kDefaultRowsPerPage),
              ),
            );
          }

          if (state.headlines.isEmpty) {
            return Center(
              child: Text(l10n.noHeadlinesFound),
            );
          }

          return PaginatedDataTable2(
            columns: [
              DataColumn2(
                label: Text(l10n.headlineTitle),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Text(l10n.sourceName),
                size: ColumnSize.M,
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
            source: _HeadlinesDataSource(
              context: context,
              headlines: state.headlines,
              isLoading:
                  state.headlinesStatus == ContentManagementStatus.loading,
              hasMore: state.headlinesHasMore,
              l10n: l10n,
            ),
            rowsPerPage: kDefaultRowsPerPage,
            availableRowsPerPage: const [kDefaultRowsPerPage],
            onPageChanged: (pageIndex) {
              final newOffset = pageIndex * kDefaultRowsPerPage;
              if (newOffset >= state.headlines.length &&
                  state.headlinesHasMore &&
                  state.headlinesStatus != ContentManagementStatus.loading) {
                context.read<ContentManagementBloc>().add(
                  LoadHeadlinesRequested(
                    startAfterId: state.headlinesCursor,
                    limit: kDefaultRowsPerPage,
                  ),
                );
              }
            },
            empty: Center(child: Text(l10n.noHeadlinesFound)),
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

class _HeadlinesDataSource extends DataTableSource {
  _HeadlinesDataSource({
    required this.context,
    required this.headlines,
    required this.isLoading,
    required this.hasMore,
    required this.l10n,
  });

  final BuildContext context;
  final List<Headline> headlines;
  final bool isLoading;
  final bool hasMore;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= headlines.length) {
      // This can happen if hasMore is true and the user is on the last page.
      // If we are loading, show a spinner. Otherwise, we've reached the end.
      if (isLoading) {
        return DataRow2(
          cells: List.generate(
            5,
            (_) => const DataCell(Center(child: CircularProgressIndicator())),
          ),
        );
      }
      return null;
    }
    final headline = headlines[index];
    return DataRow2(
      onSelectChanged: (selected) {
        if (selected ?? false) {
          context.goNamed(
            Routes.editHeadlineName,
            pathParameters: {'id': headline.id},
          );
        }
      },
      cells: [
        DataCell(Text(headline.title)),
        DataCell(Text(headline.source.name)),
        DataCell(Text(headline.status.l10n(context))),
        DataCell(
          Text(
            // TODO(fulleni): Make date format configurable by admin.
            DateFormat('dd-MM-yyyy').format(headline.updatedAt.toLocal()),
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
                    Routes.editHeadlineName,
                    pathParameters: {'id': headline.id},
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Dispatch delete event
                  context.read<ContentManagementBloc>().add(
                    DeleteHeadlineRequested(headline.id),
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
      return isLoading
          ? headlines.length + 1
          : headlines.length + kDefaultRowsPerPage;
    }
    return headlines.length;
  }

  @override
  int get selectedRowCount => 0;
}
