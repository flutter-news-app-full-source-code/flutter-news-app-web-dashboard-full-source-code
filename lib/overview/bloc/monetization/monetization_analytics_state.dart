part of 'monetization_analytics_bloc.dart';
import 'package:core/core.dart';

enum MonetizationAnalyticsStatus { initial, loading, success, failure }

final class MonetizationAnalyticsState extends Equatable {
  const MonetizationAnalyticsState({
    this.status = MonetizationAnalyticsStatus.initial,
    this.kpiData = const [],
    this.chartData = const [],
    this.error,
  });

  final MonetizationAnalyticsStatus status;
  final List<KpiCardData?> kpiData;
  final List<ChartCardData?> chartData;
  final Object? error;

  MonetizationAnalyticsState copyWith({
    MonetizationAnalyticsStatus? status,
    List<KpiCardData?>? kpiData,
    List<ChartCardData?>? chartData,
    Object? error,
  }) {
    return MonetizationAnalyticsState(
      status: status ?? this.status,
      kpiData: kpiData ?? this.kpiData,
      chartData: chartData ?? this.chartData,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, kpiData, chartData, error];
}
