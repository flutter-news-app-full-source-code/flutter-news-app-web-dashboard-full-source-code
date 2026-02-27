import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_filter/community_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/widgets/community_action_buttons.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_review_feedback_extension.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_dashboard_strip.dart';
import 'package:intl/intl.dart';
import 'package:core_ui/core_ui.dart';

class AppReviewsPage extends StatefulWidget {
  const AppReviewsPage({super.key});

  @override
  State<AppReviewsPage> createState() => _AppReviewsPageState();
}

class _AppReviewsPageState extends State<AppReviewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityManagementBloc>().add(
      LoadAppReviewsRequested(
        limit: kDefaultRowsPerPage,
        filter: context
            .read<CommunityManagementBloc>()
            .buildAppReviewsFilterMap(
              context.read<CommunityFilterBloc>().state.appReviewsFilter,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<CommunityManagementBloc, CommunityManagementState>(
        builder: (context, state) {
          final filtersActive = context
              .watch<CommunityFilterBloc>()
              .state
              .appReviewsFilter
              .isFilterActive;

          if (state.appReviewsStatus == CommunityManagementStatus.loading &&
              state.appReviews.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.reviews_outlined,
              headline: l10n.loadingAppReviews,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.appReviewsStatus == CommunityManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<CommunityManagementBloc>().add(
                LoadAppReviewsRequested(
                  limit: kDefaultRowsPerPage,
                  forceRefresh: true,
                  filter: context
                      .read<CommunityManagementBloc>()
                      .buildAppReviewsFilterMap(
                        context
                            .read<CommunityFilterBloc>()
                            .state
                            .appReviewsFilter,
                      ),
                ),
              ),
            );
          }

          if (state.appReviews.isEmpty) {
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
            return Center(child: Text(l10n.noAppReviewsFound));
          }

          return Column(
            children: [
              // Analytics Dashboard Strip
              const AnalyticsDashboardStrip(
                kpiCards: [
                  KpiCardId.engagementsAppReviewsTotalFeedback,
                  KpiCardId.engagementsAppReviewsPositiveFeedback,
                  KpiCardId.engagementsAppReviewsStoreRequests,
                ],
                chartCards: [
                  ChartCardId.engagementsAppReviewsFeedbackOverTime,
                  ChartCardId.engagementsAppReviewsPositiveVsNegative,
                  ChartCardId.engagementsAppReviewsStoreRequestsOverTime,
                ],
              ),
              if (state.appReviewsStatus == CommunityManagementStatus.loading &&
                  state.appReviews.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return PaginatedDataTable2(
                      columns: [
                        DataColumn2(
                          label: Text(l10n.feedback),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text(l10n.lastInteraction),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text(l10n.actions),
                          size: ColumnSize.S,
                        ),
                      ],
                      source: _AppReviewsDataSource(
                        context: context,
                        appReviews: state.appReviews,
                        hasMore: state.hasMoreAppReviews,
                        l10n: l10n,
                        isMobile: isMobile,
                      ),
                      rowsPerPage: kDefaultRowsPerPage,
                      availableRowsPerPage: const [kDefaultRowsPerPage],
                      onPageChanged: (pageIndex) {
                        final newOffset = pageIndex * kDefaultRowsPerPage;
                        if (newOffset >= state.appReviews.length &&
                            state.hasMoreAppReviews &&
                            state.appReviewsStatus !=
                                CommunityManagementStatus.loading) {
                          context.read<CommunityManagementBloc>().add(
                            LoadAppReviewsRequested(
                              startAfterId: state.appReviewsCursor,
                              limit: kDefaultRowsPerPage,
                              filter: context
                                  .read<CommunityManagementBloc>()
                                  .buildAppReviewsFilterMap(
                                    context
                                        .read<CommunityFilterBloc>()
                                        .state
                                        .appReviewsFilter,
                                  ),
                            ),
                          );
                        }
                      },
                      empty: Center(child: Text(l10n.noAppReviewsFound)),
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

class _AppReviewsDataSource extends DataTableSource {
  _AppReviewsDataSource({
    required this.context,
    required this.appReviews,
    required this.hasMore,
    required this.l10n,
    required this.isMobile,
  });

  final BuildContext context;
  final List<AppReview> appReviews;
  final bool hasMore;
  final AppLocalizations l10n;
  final bool isMobile;

  @override
  DataRow? getRow(int index) {
    if (index >= appReviews.length) return null;
    final appReview = appReviews[index];
    return DataRow2(
      cells: [
        DataCell(
          Chip(
            avatar: Icon(
              _getFeedbackIcon(appReview.feedback),
              size: 16,
            ),
            label: Text(appReview.feedback.l10n(context)),
            backgroundColor: _getFeedbackColor(context, appReview.feedback),
            side: BorderSide.none,
          ),
        ),
        DataCell(
          Text(
            DateFormat('dd-MM-yyyy').format(appReview.updatedAt.toLocal()),
          ),
        ),
        DataCell(CommunityActionButtons(item: appReview, l10n: l10n)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => hasMore;

  @override
  int get rowCount => appReviews.length;

  @override
  int get selectedRowCount => 0;

  Color? _getFeedbackColor(BuildContext context, AppReviewFeedback feedback) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (feedback) {
      case AppReviewFeedback.positive:
        return colorScheme.primaryContainer;
      case AppReviewFeedback.negative:
        return colorScheme.errorContainer;
    }
  }

  IconData _getFeedbackIcon(AppReviewFeedback feedback) {
    switch (feedback) {
      case AppReviewFeedback.positive:
        return Icons.thumb_up;
      case AppReviewFeedback.negative:
        return Icons.thumb_down;
    }
  }
}
