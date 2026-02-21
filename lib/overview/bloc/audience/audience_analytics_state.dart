part of 'audience_analytics_bloc.dart';

enum AudienceAnalyticsStatus { initial, loading, success, failure }

final class AudienceAnalyticsState extends Equatable {
  const AudienceAnalyticsState({
    this.status = AudienceAnalyticsStatus.initial,
    this.kpiData = const [],
    this.chartData = const [],
    this.error,
  });

  final AudienceAnalyticsStatus status;
  final List<KpiCardData?> kpiData;
  final List<ChartCardData?> chartData;
  final Object? error;

  AudienceAnalyticsState copyWith({
    AudienceAnalyticsStatus? status,
    List<KpiCardData?>? kpiData,
    List<ChartCardData?>? chartData,
    Object? error,
  }) {
    return AudienceAnalyticsState(
      status: status ?? this.status,
      kpiData: kpiData ?? this.kpiData,
      chartData: chartData ?? this.chartData,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, kpiData, chartData, error];
}
