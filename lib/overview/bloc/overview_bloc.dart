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
    on<OverviewSubscriptionRequested>(_onSubscriptionRequested);
  }

  final AnalyticsService _analyticsService;

  // Define the cards used on this page to ensure consistent ordering.
  static const List<KpiCardId> kpiCards = [
    KpiCardId.usersTotalRegistered,
    KpiCardId.contentHeadlinesTotalViews,
    KpiCardId.rewardsActiveUsersCount,
  ];

  static const List<ChartCardId> chartCards = [
    ChartCardId.usersRegistrationsOverTime,
    ChartCardId.contentHeadlinesViewsOverTime,
  ];

  static const List<RankedListCardId> rankedListCards = [
    RankedListCardId.overviewHeadlinesMostViewed,
    RankedListCardId.overviewSourcesMostFollowed,
  ];

  Future<void> _onSubscriptionRequested(
    OverviewSubscriptionRequested event,
    Emitter<OverviewState> emit,
  ) async {
    emit(state.copyWith(status: OverviewStatus.loading));

    try {
      // Create a list of future providers to be executed in batches.
      // The order here MUST match the order used when unpacking the data.
      final futureProviders = <Future<dynamic> Function()>[
        ...kpiCards.map(
          (id) =>
              () => _analyticsService.getKpi(id),
        ),
        ...chartCards.map(
          (id) =>
              () => _analyticsService.getChart(id),
        ),
        ...rankedListCards.map(
          (id) =>
              () => _analyticsService.getRankedList(id),
        ),
      ];

      // Use the utility to fetch data in controlled batches.
      final allData = await FutureUtils.fetchInBatches(futureProviders);

      // Unpack the flat list back into specific data lists.
      var currentIndex = 0;

      final kpiData = allData
          .sublist(currentIndex, currentIndex + kpiCards.length)
          .cast<KpiCardData?>();
      currentIndex += kpiCards.length;

      final chartData = allData
          .sublist(currentIndex, currentIndex + chartCards.length)
          .cast<ChartCardData?>();
      currentIndex += chartCards.length;

      final rankedListData = allData
          .sublist(currentIndex, currentIndex + rankedListCards.length)
          .cast<RankedListCardData?>();

      emit(
        state.copyWith(
          status: OverviewStatus.success,
          kpiData: kpiData,
          chartData: chartData,
          rankedListData: rankedListData,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: OverviewStatus.failure,
          error: error,
        ),
      );
    }
  }
}
