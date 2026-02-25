import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/topics_filter/topics_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/widgets/content_action_buttons.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_dashboard_strip.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template topics_page}
/// A page for displaying and managing Topics in a tabular format.
/// {@endtemplate}
class TopicPage extends StatefulWidget {
  /// {@macro topics_page}
  const TopicPage({super.key});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  @override
  void initState() {
    super.initState();
    final defaultLanguage =
        context
            .read<AppBloc>()
            .state
            .remoteConfig
            ?.app
            .localization
            .defaultLanguage
            .name ??
        'en';
    // Initial load of topics, applying the default filter from TopicsFilterBloc
    context.read<ContentManagementBloc>().add(
      LoadTopicsRequested(
        limit: kDefaultRowsPerPage,
        filter: context.read<TopicsFilterBloc>().buildFilterMap(),
      ),
    );
  }

  /// Checks if any filters are currently active in the TopicsFilterBloc.
  bool _areFiltersActive(TopicsFilterState state) {
    return state.searchQuery.isNotEmpty ||
        state.selectedStatus != ContentStatus.active;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<ContentManagementBloc, ContentManagementState>(
        builder: (context, state) {
          final topicsFilterState = context.watch<TopicsFilterBloc>().state;
          final filtersActive = _areFiltersActive(topicsFilterState);

          if (state.topicsStatus == ContentManagementStatus.loading &&
              state.topics.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.topic,
              headline: l10n.loadingTopics,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.topicsStatus == ContentManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () {
                final defaultLanguage =
                    context
                        .read<AppBloc>()
                        .state
                        .remoteConfig
                        ?.app
                        .localization
                        .defaultLanguage
                        .name ??
                    'en';
                context.read<ContentManagementBloc>().add(
                  LoadTopicsRequested(
                    limit: kDefaultRowsPerPage,
                    forceRefresh: true,
                    filter: context.read<TopicsFilterBloc>().buildFilterMap(),
                  ),
                );
              },
            );
          }

          if (state.topics.isEmpty) {
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
                      onPressed: () {
                        context.read<TopicsFilterBloc>().add(
                          const TopicsFilterReset(),
                        );
                      },
                      child: Text(l10n.resetFiltersButtonText),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text(l10n.noTopicsFound));
          }

          return Column(
            children: [
              // Analytics Dashboard Strip
              const AnalyticsDashboardStrip(
                kpiCards: [
                  KpiCardId.contentTopicsTotalTopics,
                  KpiCardId.contentTopicsNewTopics,
                  KpiCardId.contentTopicsTotalFollowers,
                ],
                chartCards: [
                  ChartCardId.contentHeadlinesBreakingNewsDistribution,
                  ChartCardId.contentTopicsHeadlinesPublishedOverTime,
                  ChartCardId.contentTopicsEngagementByTopic,
                ],
              ),
              if (state.topicsStatus == ContentManagementStatus.loading &&
                  state.topics.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return PaginatedDataTable2(
                      columns: [
                        DataColumn2(
                          label: Text(l10n.topicName),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text(l10n.lastUpdated),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text(l10n.actions),
                          size: ColumnSize.S,
                        ),
                      ],
                      source: _TopicsDataSource(
                        context: context,
                        topics: state.topics,
                        hasMore: state.topicsHasMore,
                        l10n: l10n,
                        isMobile: isMobile,
                      ),
                      rowsPerPage: kDefaultRowsPerPage,
                      availableRowsPerPage: const [kDefaultRowsPerPage],
                      onPageChanged: (pageIndex) {
                        final newOffset = pageIndex * kDefaultRowsPerPage;
                        if (newOffset >= state.topics.length &&
                            state.topicsHasMore &&
                            state.topicsStatus !=
                                ContentManagementStatus.loading) {
                          final defaultLanguage =
                              context
                                  .read<AppBloc>()
                                  .state
                                  .remoteConfig
                                  ?.app
                                  .localization
                                  .defaultLanguage
                                  .name ??
                              'en';
                          context.read<ContentManagementBloc>().add(
                            LoadTopicsRequested(
                              startAfterId: state.topicsCursor,
                              limit: kDefaultRowsPerPage,
                              filter: context
                                  .read<TopicsFilterBloc>()
                                  .buildFilterMap(),
                            ),
                          );
                        }
                      },
                      empty: Center(child: Text(l10n.noTopicsFound)),
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

class _TopicsDataSource extends DataTableSource {
  _TopicsDataSource({
    required this.context,
    required this.topics,
    required this.hasMore,
    required this.l10n,
    required this.isMobile,
  });

  final BuildContext context;
  final List<Topic> topics;
  final bool hasMore;
  final AppLocalizations l10n;
  final bool isMobile;

  @override
  DataRow? getRow(int index) {
    if (index >= topics.length) {
      return null;
    }
    final topic = topics[index];
    return DataRow2(
      onSelectChanged: (selected) {
        if (selected ?? false) {
          context.goNamed(
            Routes.editTopicName,
            pathParameters: {'id': topic.id},
          );
        }
      },
      cells: [
        DataCell(
          Text(
            topic.name[SupportedLanguage.en] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            DateFormat('dd-MM-yyyy').format(topic.updatedAt.toLocal()),
          ),
        ),
        DataCell(
          ContentActionButtons(
            item: topic,
            l10n: l10n,
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => hasMore;

  @override
  int get rowCount {
    return topics.length;
  }

  @override
  int get selectedRowCount => 0;
}
