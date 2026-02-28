import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/utils/future_utils.dart';

part 'overview_event.dart';
part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  OverviewBloc({
    required AnalyticsService analyticsService,
  }) : _analyticsService = analyticsService,
       super(const OverviewState()) {
    on<AnalyticsDataRequested>(_onAnalyticsDataRequested);
    on<OverviewLanguageChanged>(_onLanguageChanged);
  }

  final AnalyticsService _analyticsService;

  static const List<RankedListCardId> _overviewRankedListCards = [
    RankedListCardId.overviewHeadlinesMostViewed,
    RankedListCardId.overviewSourcesMostFollowed,
  ];

  static const List<KpiCardId> _overviewKpiCards = [
    KpiCardId.usersTotalRegistered,
    KpiCardId.contentHeadlinesTotalViews,
    KpiCardId.engagementsTotalReactions,
    KpiCardId.rewardsGrantedTotal,
  ];

  static const List<KpiCardId> _audienceKpiCards = [
    KpiCardId.usersTotalRegistered,
    KpiCardId.usersNewRegistrations,
    KpiCardId.usersActiveUsers,
  ];

  static const List<ChartCardId> _audienceChartCards = [
    ChartCardId.usersRegistrationsOverTime,
    ChartCardId.usersActiveUsersOverTime,
    ChartCardId.usersTierDistribution,
  ];

  static const List<KpiCardId> _communityKpiCards = [
    KpiCardId.engagementsTotalReactions,
    KpiCardId.engagementsTotalComments,
    KpiCardId.engagementsAverageEngagementRate,
  ];

  static const List<ChartCardId> _communityChartCards = [
    ChartCardId.engagementsReactionsOverTime,
    ChartCardId.engagementsCommentsOverTime,
    ChartCardId.engagementsReactionsByType,
  ];

  static const List<KpiCardId> _contentKpiCards = [
    KpiCardId.contentHeadlinesTotalPublished,
    KpiCardId.contentSourcesTotalSources,
    KpiCardId.contentTopicsTotalTopics,
  ];
  static const List<ChartCardId> _contentChartCards = [
    ChartCardId.contentHeadlinesViewsOverTime,
    ChartCardId.contentSourcesHeadlinesPublishedOverTime,
    ChartCardId.contentTopicsHeadlinesPublishedOverTime,
  ];

  static const List<KpiCardId> _monetizationKpiCards = [
    KpiCardId.rewardsAdsWatchedTotal,
    KpiCardId.rewardsGrantedTotal,
    KpiCardId.rewardsActiveUsersCount,
  ];
  static const List<ChartCardId> _monetizationChartCards = [
    ChartCardId.rewardsAdsWatchedOverTime,
    ChartCardId.rewardsGrantedOverTime,
    ChartCardId.rewardsActiveByType,
  ];

  Future<void> _onAnalyticsDataRequested(
    AnalyticsDataRequested event,
    Emitter<OverviewState> emit,
  ) async {
    final currentTabState =
        state.tabStates[event.tab] ?? const TabAnalyticsState();
    if (currentTabState.status == TabAnalyticsStatus.success &&
        !event.forceRefresh) {
      return;
    }

    final newTabStates =
        Map<OverviewTab, TabAnalyticsState>.from(state.tabStates)
          ..[event.tab] = currentTabState.copyWith(
            status: TabAnalyticsStatus.loading,
          );
    emit(state.copyWith(tabStates: newTabStates));

    try {
      final futureProviders = <Future<dynamic> Function()>[];
      var kpiIds = <KpiCardId>[];
      var chartIds = <ChartCardId>[];
      var rankedListIds = <RankedListCardId>[];

      switch (event.tab) {
        case OverviewTab.overview:
          kpiIds = _overviewKpiCards;
          rankedListIds = _overviewRankedListCards;
        case OverviewTab.audience:
          kpiIds = _audienceKpiCards;
          chartIds = _audienceChartCards;
        case OverviewTab.community:
          kpiIds = _communityKpiCards;
          chartIds = _communityChartCards;
        case OverviewTab.content:
          kpiIds = _contentKpiCards;
          chartIds = _contentChartCards;
        case OverviewTab.monetization:
          kpiIds = _monetizationKpiCards;
          chartIds = _monetizationChartCards;
      }

      futureProviders
        ..addAll(
          kpiIds.map(
            (id) =>
                () => _analyticsService.getKpi(id),
          ),
        )
        ..addAll(
          chartIds.map(
            (id) =>
                () => _analyticsService.getChart(id),
          ),
        )
        ..addAll(
          rankedListIds.map(
            (id) =>
                () => _analyticsService.getRankedList(id),
          ),
        );

      final allData = await FutureUtils.fetchInBatches(futureProviders);

      final kpiData = allData.sublist(0, kpiIds.length).cast<KpiCardData?>();
      final chartData = allData
          .sublist(kpiIds.length, kpiIds.length + chartIds.length)
          .cast<ChartCardData?>();
      final rankedListData = allData
          .sublist(kpiIds.length + chartIds.length)
          .cast<RankedListCardData?>();

      final successTabState = TabAnalyticsState(
        status: TabAnalyticsStatus.success,
        kpiData: kpiData,
        chartData: chartData,
        rankedListData: rankedListData,
      );

      final updatedTabStates = Map<OverviewTab, TabAnalyticsState>.from(
        state.tabStates,
      )..[event.tab] = successTabState;
      emit(state.copyWith(tabStates: updatedTabStates));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      final failureTabState = TabAnalyticsState(
        status: TabAnalyticsStatus.failure,
        error: error,
      );
      final updatedTabStates = Map<OverviewTab, TabAnalyticsState>.from(
        state.tabStates,
      )..[event.tab] = failureTabState;
      emit(state.copyWith(tabStates: updatedTabStates));
    }
  }

  Future<void> _onLanguageChanged(
    OverviewLanguageChanged event,
    Emitter<OverviewState> emit,
  ) async {
    // 1. Clear the service cache so subsequent requests hit the API with the new token.
    _analyticsService.clearCache();

    // 2. Identify which tabs have already been loaded (or attempted).
    // We only want to refresh tabs the user has actually visited/requested.
    final tabsToRefresh = state.tabStates.keys.toList();

    // 3. Trigger a forced refresh for each of these tabs.
    // This will set their status to 'loading' and fetch fresh data.
    for (final tab in tabsToRefresh) {
      add(AnalyticsDataRequested(tab: tab, forceRefresh: true));
    }
  }
}
