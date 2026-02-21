import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/utils/future_utils.dart';

part 'content_analytics_event.dart';
part 'content_analytics_state.dart';

class ContentAnalyticsBloc
    extends Bloc<ContentAnalyticsEvent, ContentAnalyticsState> {
  ContentAnalyticsBloc({
    required AnalyticsService analyticsService,
  }) : _analyticsService = analyticsService,
       super(const ContentAnalyticsState()) {
    on<ContentAnalyticsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final AnalyticsService _analyticsService;

  static const List<KpiCardId> kpiCards = [
    KpiCardId.contentHeadlinesTotalPublished,
    KpiCardId.contentSourcesTotalSources,
    KpiCardId.contentTopicsTotalTopics,
  ];

  static const List<ChartCardId> chartCards = [
    ChartCardId.contentHeadlinesViewsOverTime,
    ChartCardId.contentSourcesStatusDistribution,
    ChartCardId.contentTopicsEngagementByTopic,
  ];

  Future<void> _onSubscriptionRequested(
    ContentAnalyticsSubscriptionRequested event,
    Emitter<ContentAnalyticsState> emit,
  ) async {
    if (state.status == ContentAnalyticsStatus.success) return;

    emit(state.copyWith(status: ContentAnalyticsStatus.loading));

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
          status: ContentAnalyticsStatus.success,
          kpiData: kpiData,
          chartData: chartData,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(status: ContentAnalyticsStatus.failure, error: error),
      );
    }
  }
}
