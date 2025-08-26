part of 'overview_bloc.dart';

/// Base class for dashboard overviews events.
sealed class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object> get props => [];
}

/// Event to load the dashboard overview summary data.
final class OverviewSummaryRequested extends OverviewEvent {}

/// Internal event triggered when a listened-to entity is updated.
final class _OverviewEntityUpdated extends OverviewEvent {
  const _OverviewEntityUpdated();
}
