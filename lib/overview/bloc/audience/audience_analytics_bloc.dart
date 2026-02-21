import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/utils/future_utils.dart';

part 'audience_analytics_event.dart';
part 'audience_analytics_state.dart';

class AudienceAnalyticsBloc
    extends Bloc<AudienceAnalyticsEvent, AudienceAnalyticsState> {
  AudienceAnalyticsBloc({
    required AnalyticsService analyticsService,
  }) : _analyticsService = analyticsService,
       super(const AudienceAnalyticsState()) {
    on<AudienceAnalyticsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final AnalyticsService _analyticsService;

  static const List<KpiCardId> kpiCards = [
    KpiCardId.usersTotalRegistered,
    KpiCardId.usersNewRegistrations,
    KpiCardId.usersActiveUsers,
  ];

  static const List<ChartCardId> chartCards = [
    ChartCardId.usersRegistrationsOverTime,
    ChartCardId.usersActiveUsersOverTime,
    ChartCardId.usersTierDistribution,
    ChartCardId.overviewAppTourFunnel,
    ChartCardId.overviewInitialPersonalizationFunnel,
  ];

  Future<void> _onSubscriptionRequested(
    AudienceAnalyticsSubscriptionRequested event,
    Emitter<AudienceAnalyticsState> emit,
  ) async {
    if (state.status == AudienceAnalyticsStatus.success) return;

    emit(state.copyWith(status: AudienceAnalyticsStatus.loading));

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
          status: AudienceAnalyticsStatus.success,
          kpiData: kpiData,
          chartData: chartData,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(status: AudienceAnalyticsStatus.failure, error: error),
      );
    }
  }
}
