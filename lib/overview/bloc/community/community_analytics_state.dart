part of 'community_analytics_bloc.dart';

enum CommunityAnalyticsStatus { initial, loading, success, failure }

final class CommunityAnalyticsState extends Equatable {
  const CommunityAnalyticsState({
    this.status = CommunityAnalyticsStatus.initial,
    this.kpiData = const [],
    this.chartData = const [],
    this.error,
  });

  final CommunityAnalyticsStatus status;
  final List<KpiCardData?> kpiData;
  final List<ChartCardData?> chartData;
  final Object? error;

  CommunityAnalyticsState copyWith({
    CommunityAnalyticsStatus? status,
    List<KpiCardData?>? kpiData,
    List<ChartCardData?>? chartData,
    Object? error,
  }) {
    return CommunityAnalyticsState(
      status: status ?? this.status,
      kpiData: kpiData ?? this.kpiData,
      chartData: chartData ?? this.chartData,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, kpiData, chartData, error];
}
