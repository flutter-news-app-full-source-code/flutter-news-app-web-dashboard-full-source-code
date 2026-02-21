import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/utils/future_utils.dart';

part 'community_analytics_event.dart';
part 'community_analytics_state.dart';

class CommunityAnalyticsBloc
    extends Bloc<CommunityAnalyticsEvent, CommunityAnalyticsState> {
  CommunityAnalyticsBloc({
    required AnalyticsService analyticsService,
  }) : _analyticsService = analyticsService,
       super(const CommunityAnalyticsState()) {
    on<CommunityAnalyticsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final AnalyticsService _analyticsService;

  static const List<KpiCardId> kpiCards = [
    KpiCardId.engagementsTotalReactions,
    KpiCardId.engagementsReportsPending,
    KpiCardId.engagementsAppReviewsTotalFeedback,
  ];

  static const List<ChartCardId> chartCards = [
    ChartCardId.engagementsReactionsOverTime,
    ChartCardId.engagementsReportsByReason,
    ChartCardId.engagementsAppReviewsPositiveVsNegative,
  ];

  Future<void> _onSubscriptionRequested(
    CommunityAnalyticsSubscriptionRequested event,
    Emitter<CommunityAnalyticsState> emit,
  ) async {
    if (state.status == CommunityAnalyticsStatus.success) return;

    emit(state.copyWith(status: CommunityAnalyticsStatus.loading));

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
          status: CommunityAnalyticsStatus.success,
          kpiData: kpiData,
          chartData: chartData,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(status: CommunityAnalyticsStatus.failure, error: error),
      );
    }
  }
}
