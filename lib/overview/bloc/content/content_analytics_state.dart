part of 'content_analytics_bloc.dart';

enum ContentAnalyticsStatus { initial, loading, success, failure }

final class ContentAnalyticsState extends Equatable {
  const ContentAnalyticsState({
    this.status = ContentAnalyticsStatus.initial,
    this.kpiData = const [],
    this.chartData = const [],
    this.error,
  });

  final ContentAnalyticsStatus status;
  final List<KpiCardData?> kpiData;
  final List<ChartCardData?> chartData;
  final Object? error;

  ContentAnalyticsState copyWith({
    ContentAnalyticsStatus? status,
    List<KpiCardData?>? kpiData,
    List<ChartCardData?>? chartData,
    Object? error,
  }) {
    return ContentAnalyticsState(
      status: status ?? this.status,
      kpiData: kpiData ?? this.kpiData,
      chartData: chartData ?? this.chartData,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, kpiData, chartData, error];
}
