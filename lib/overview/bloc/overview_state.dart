part of 'overview_bloc.dart';

enum OverviewTab {
  overview,
  audience,
  content,
  community,
  monetization,
}

enum TabAnalyticsStatus { initial, loading, success, failure }

final class TabAnalyticsState extends Equatable {
  const TabAnalyticsState({
    this.status = TabAnalyticsStatus.initial,
    this.kpiData = const [],
    this.chartData = const [],
    this.rankedListData = const [],
    this.error,
  });

  final TabAnalyticsStatus status;
  final List<KpiCardData?> kpiData;
  final List<ChartCardData?> chartData;
  final List<RankedListCardData?> rankedListData;
  final Object? error;

  TabAnalyticsState copyWith({
    TabAnalyticsStatus? status,
    List<KpiCardData?>? kpiData,
    List<ChartCardData?>? chartData,
    List<RankedListCardData?>? rankedListData,
    Object? error,
  }) {
    return TabAnalyticsState(
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

final class OverviewState extends Equatable {
  const OverviewState({
    this.tabStates = const {},
  });

  final Map<OverviewTab, TabAnalyticsState> tabStates;

  OverviewState copyWith({Map<OverviewTab, TabAnalyticsState>? tabStates}) =>
      OverviewState(tabStates: tabStates ?? this.tabStates);

  @override
  List<Object?> get props => [tabStates];
}
