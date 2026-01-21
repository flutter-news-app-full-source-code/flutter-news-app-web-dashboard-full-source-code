part of 'overview_bloc.dart';

enum OverviewStatus { initial, loading, success, failure }

final class OverviewState extends Equatable {
  const OverviewState({
    this.status = OverviewStatus.initial,
    this.kpiData = const [],
    this.chartData = const [],
    this.rankedListData = const [],
    this.error,
  });

  final OverviewStatus status;
  final List<KpiCardData?> kpiData;
  final List<ChartCardData?> chartData;
  final List<RankedListCardData?> rankedListData;
  final Object? error;

  OverviewState copyWith({
    OverviewStatus? status,
    List<KpiCardData?>? kpiData,
    List<ChartCardData?>? chartData,
    List<RankedListCardData?>? rankedListData,
    Object? error,
  }) {
    return OverviewState(
      status: status ?? this.status,
      kpiData: kpiData ?? this.kpiData,
      chartData: chartData ?? this.chartData,
      rankedListData: rankedListData ?? this.rankedListData,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    kpiData,
    chartData,
    rankedListData,
    error,
  ];
}
