import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/utils/future_utils.dart';

part 'monetization_analytics_event.dart';
part 'monetization_analytics_state.dart';

class MonetizationAnalyticsBloc
    extends Bloc<MonetizationAnalyticsEvent, MonetizationAnalyticsState> {
  MonetizationAnalyticsBloc({
    required AnalyticsService analyticsService,
  }) : _analyticsService = analyticsService,
       super(const MonetizationAnalyticsState()) {
    on<MonetizationAnalyticsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final AnalyticsService _analyticsService;

  static const List<KpiCardId> kpiCards = [
    KpiCardId.rewardsAdsWatchedTotal,
    KpiCardId.rewardsGrantedTotal,
    KpiCardId.rewardsActiveUsersCount,
  ];

  static const List<ChartCardId> chartCards = [
    ChartCardId.rewardsAdsWatchedOverTime,
    ChartCardId.rewardsGrantedOverTime,
    ChartCardId.rewardsActiveByType,
  ];

  Future<void> _onSubscriptionRequested(
    MonetizationAnalyticsSubscriptionRequested event,
    Emitter<MonetizationAnalyticsState> emit,
  ) async {
    if (state.status == MonetizationAnalyticsStatus.success) return;

    emit(state.copyWith(status: MonetizationAnalyticsStatus.loading));

    try {
      final futureProviders = <Future<dynamic> Function()>[
        ...kpiCards.map(
          (id) =>
              () => _analyticsService.getKpi(id),
        ),
        ...chartCards.map(
          (id) =>
              () => _analyticsService.getChart(id),
        ),
      ];

      final allData = await FutureUtils.fetchInBatches(futureProviders);

      final kpiData = allData.sublist(0, kpiCards.length).cast<KpiCardData?>();
      final chartData = allData.sublist(kpiCards.length).cast<ChartCardData?>();

      emit(
        state.copyWith(
          status: MonetizationAnalyticsStatus.success,
          kpiData: kpiData,
          chartData: chartData,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: MonetizationAnalyticsStatus.failure,
          error: error,
        ),
      );
    }
  }
}
