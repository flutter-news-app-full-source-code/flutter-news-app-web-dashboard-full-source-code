import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart'; // Corrected import
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/content_status_l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

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
            return Center(child: Text(l10n.noHeadlinesFound));
          }

          return Column(
            children: [
              if (state.headlinesStatus == ContentManagementStatus.loading &&
                  state.headlines.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: PaginatedDataTable2(
                  columns: [
                    DataColumn2(
                      label: Text(l10n.headlineTitle),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text(l10n.sourceName),
                      size: ColumnSize.M,
                    ),
                    DataColumn2(label: Text(l10n.status), size: ColumnSize.S),
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
                    hasMore: state.headlinesHasMore,
                    l10n: l10n,
                  ),
                  rowsPerPage: kDefaultRowsPerPage,
                  availableRowsPerPage: const [kDefaultRowsPerPage],
                  onPageChanged: (pageIndex) {
                    final newOffset = pageIndex * kDefaultRowsPerPage;
                    if (newOffset >= state.headlines.length &&
                        state.headlinesHasMore &&
                        state.headlinesStatus !=
                            ContentManagementStatus.loading) {
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
                ),
              ),
            ],
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
    required this.hasMore,
    required this.l10n,
  });

  final BuildContext context;
  final List<Headline> headlines;
  final bool hasMore;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= headlines.length) {
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
        DataCell(
          Text(
            headline.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
                icon: const Icon(Icons.archive),
                tooltip: l10n.archive,
                onPressed: () {
                  context.read<ContentManagementBloc>().add(
                        ArchiveHeadlineRequested(headline.id),
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
    return headlines.length;
  }

  @override
  int get selectedRowCount => 0;
}
