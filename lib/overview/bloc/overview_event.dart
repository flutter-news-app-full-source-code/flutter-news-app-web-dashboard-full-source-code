part of 'overview_bloc.dart';

sealed class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object> get props => [];
}

final class AnalyticsDataRequested extends OverviewEvent {
  const AnalyticsDataRequested({required this.tab, this.forceRefresh = false});

  final OverviewTab tab;
  final bool forceRefresh;

  @override
  List<Object> get props => [tab, forceRefresh];
}
