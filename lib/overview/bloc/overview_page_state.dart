part of 'overview_page_bloc.dart';

enum OverviewPageStatus { initial, loading, success, failure }

final class OverviewPageState extends Equatable {
  const OverviewPageState({
    this.status = OverviewPageStatus.initial,
    this.kpiData = const [],
    this.chartData = const [],
    this.rankedListData = const [],
    this.error,
  });

  final OverviewPageStatus status;
  final List<KpiCardData?> kpiData;
  final List<ChartCardData?> chartData;
  final List<RankedListCardData?> rankedListData;
  final Object? error;

  OverviewPageState copyWith({
    OverviewPageStatus? status,
    List<KpiCardData?>? kpiData,
    List<ChartCardData?>? chartData,
    List<RankedListCardData?>? rankedListData,
    Object? error,
  }) {
    return OverviewPageState(
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
