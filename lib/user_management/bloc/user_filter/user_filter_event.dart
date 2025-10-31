part of 'user_filter_bloc.dart';

/// Base class for all events related to the [UserFilterBloc].
sealed class UserFilterEvent extends Equatable {
  const UserFilterEvent();

  @override
  List<Object> get props => [];
}

/// Event to update the search query for filtering users.
final class UserFilterSearchQueryChanged extends UserFilterEvent {
  const UserFilterSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

/// Event to update the selected app roles for filtering users.
final class UserFilterAppRolesChanged extends UserFilterEvent {
  const UserFilterAppRolesChanged(this.appRoles);

  final List<AppUserRole> appRoles;

  @override
  List<Object> get props => [appRoles];
}

/// Event to update the selected dashboard roles for filtering users.
final class UserFilterDashboardRolesChanged extends UserFilterEvent {
  const UserFilterDashboardRolesChanged(this.dashboardRoles);

  final List<DashboardUserRole> dashboardRoles;

  @override
  List<Object> get props => [dashboardRoles];
}

/// Event to reset all filters to their default state.
final class UserFilterReset extends UserFilterEvent {
  const UserFilterReset();
}

/// Event dispatched from the filter dialog to apply all selected filters at
/// once.
final class UserFilterApplied extends UserFilterEvent {
  const UserFilterApplied({
    required this.searchQuery,
    required this.selectedAppRoles,
    required this.selectedDashboardRoles,
  });

  final String searchQuery;
  final List<AppUserRole> selectedAppRoles;
  final List<DashboardUserRole> selectedDashboardRoles;

  @override
  List<Object> get props => [
        searchQuery,
        selectedAppRoles,
        selectedDashboardRoles,
      ];
}
