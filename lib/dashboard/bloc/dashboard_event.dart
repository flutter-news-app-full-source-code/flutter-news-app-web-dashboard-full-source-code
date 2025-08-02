part of 'dashboard_bloc.dart';

/// Base class for dashboard events.
sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

/// Event to load the dashboard summary data.
final class DashboardSummaryRequested extends DashboardEvent {}

/// Internal event triggered when a listened-to entity is updated.
final class _DashboardEntityUpdated extends DashboardEvent {
  const _DashboardEntityUpdated();
}
