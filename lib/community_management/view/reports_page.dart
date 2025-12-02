import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_filter/community_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/widgets/community_action_buttons.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:ui_kit/ui_kit.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityManagementBloc>().add(
      LoadReportsRequested(
        limit: kDefaultRowsPerPage,
        filter: context.read<CommunityManagementBloc>().buildReportsFilterMap(
          context.read<CommunityFilterBloc>().state,
        ),
      ),
    );
  }

  bool _areFiltersActive(CommunityFilterState state) {
    return state.searchQuery.isNotEmpty ||
        state.selectedReportStatus.isNotEmpty ||
        state.selectedReportableEntity.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<CommunityManagementBloc, CommunityManagementState>(
        builder: (context, state) {
          final communityFilterState = context
              .watch<CommunityFilterBloc>()
              .state;
          final filtersActive = _areFiltersActive(communityFilterState);

          if (state.reportsStatus == CommunityManagementStatus.loading &&
              state.reports.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.report_problem_outlined,
              headline: l10n.loadingReports,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.reportsStatus == CommunityManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<CommunityManagementBloc>().add(
                LoadReportsRequested(
                  limit: kDefaultRowsPerPage,
                  forceRefresh: true,
                  filter: context
                      .read<CommunityManagementBloc>()
                      .buildReportsFilterMap(
                        context.read<CommunityFilterBloc>().state,
                      ),
                ),
              ),
            );
          }

          if (state.reports.isEmpty) {
            if (filtersActive) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.noResultsWithCurrentFilters,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: () => context.read<CommunityFilterBloc>().add(
                        const CommunityFilterReset(),
                      ),
                      child: Text(l10n.resetFiltersButtonText),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text(l10n.noReportsFound));
          }

          return Column(
            children: [
              if (state.reportsStatus == CommunityManagementStatus.loading &&
                  state.reports.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return PaginatedDataTable2(
                      columns: [
                        DataColumn2(
                          label: Text(l10n.entityType),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text(l10n.reason),
                          size: ColumnSize.M,
                        ),
                        if (!isMobile)
                          DataColumn2(
                            label: Text(l10n.status),
                            size: ColumnSize.S,
                          ),
                        DataColumn2(
                          label: Text(l10n.actions),
                          size: ColumnSize.S,
                        ),
                      ],
                      source: _ReportsDataSource(
                        context: context,
                        reports: state.reports,
                        hasMore: state.hasMoreReports,
                        l10n: l10n,
                        isMobile: isMobile,
                      ),
                      rowsPerPage: kDefaultRowsPerPage,
                      availableRowsPerPage: const [kDefaultRowsPerPage],
                      onPageChanged: (pageIndex) {
                        final newOffset = pageIndex * kDefaultRowsPerPage;
                        if (newOffset >= state.reports.length &&
                            state.hasMoreReports &&
                            state.reportsStatus !=
                                CommunityManagementStatus.loading) {
                          context.read<CommunityManagementBloc>().add(
                            LoadReportsRequested(
                              startAfterId: state.reportsCursor,
                              limit: kDefaultRowsPerPage,
                              filter: context
                                  .read<CommunityManagementBloc>()
                                  .buildReportsFilterMap(
                                    context.read<CommunityFilterBloc>().state,
                                  ),
                            ),
                          );
                        }
                      },
                      empty: Center(child: Text(l10n.noReportsFound)),
                      showCheckboxColumn: false,
                      showFirstLastButtons: true,
                      fit: FlexFit.tight,
                      headingRowHeight: 56,
                      dataRowHeight: 56,
                      columnSpacing: AppSpacing.sm,
                      horizontalMargin: AppSpacing.sm,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportsDataSource extends DataTableSource {
  _ReportsDataSource({
    required this.context,
    required this.reports,
    required this.hasMore,
    required this.l10n,
    required this.isMobile,
  });

  final BuildContext context;
  final List<Report> reports;
  final bool hasMore;
  final AppLocalizations l10n;
  final bool isMobile;

  @override
  DataRow? getRow(int index) {
    if (index >= reports.length) return null;
    final report = reports[index];
    return DataRow2(
      cells: [
        DataCell(
          Chip(
            label: Text(report.entityType.l10n(context)),
            visualDensity: VisualDensity.compact,
          ),
        ),
        DataCell(
          Chip(
            label: Text(report.reason.l10n(context)),
            visualDensity: VisualDensity.compact,
          ),
        ),
        if (!isMobile)
          DataCell(
            Chip(
              avatar: Icon(
                _getReportStatusIcon(report.status),
                size: 16,
              ),
              label: Text(report.status.l10n(context)),
              backgroundColor: _getReportStatusColor(context, report.status),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
          ),
        DataCell(CommunityActionButtons(item: report, l10n: l10n)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => hasMore;

  @override
  int get rowCount => reports.length;

  @override
  int get selectedRowCount => 0;

  Color? _getReportStatusColor(BuildContext context, ReportStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case ReportStatus.resolved:
        return colorScheme.primaryContainer.withOpacity(0.5);
      case ReportStatus.submitted:
        return colorScheme.tertiaryContainer.withOpacity(0.5);
      case ReportStatus.inReview:
        return colorScheme.secondaryContainer.withOpacity(0.5);
    }
  }

  IconData _getReportStatusIcon(ReportStatus status) {
    switch (status) {
      case ReportStatus.resolved:
        return Icons.check_circle_outline;
      case ReportStatus.submitted:
        return Icons.info_outline;
      case ReportStatus.inReview:
        return Icons.hourglass_empty_outlined;
    }
  }
}
