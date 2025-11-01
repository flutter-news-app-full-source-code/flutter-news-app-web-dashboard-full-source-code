part of 'user_filter_dialog_bloc.dart';

/// Base class for all events related to the [UserFilterDialogBloc].
sealed class UserFilterDialogEvent extends Equatable {
  const UserFilterDialogEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the filter dialog's state from the main user filter BLoC.
final class UserFilterDialogInitialized extends UserFilterDialogEvent {
  const UserFilterDialogInitialized({
    required this.userFilterState,
  });

  final UserFilterState userFilterState;

  @override
  List<Object?> get props => [userFilterState];
}

/// Event to update the temporary search query in the dialog.
final class UserFilterDialogSearchQueryChanged extends UserFilterDialogEvent {
  const UserFilterDialogSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to update the temporary selected app roles in the dialog.
final class UserFilterDialogAppRolesChanged extends UserFilterDialogEvent {
  const UserFilterDialogAppRolesChanged(this.appRoles);

  final List<AppUserRole> appRoles;

  @override
  List<Object?> get props => [appRoles];
}

/// Event to update the temporary selected dashboard roles in the dialog.
final class UserFilterDialogDashboardRolesChanged
    extends UserFilterDialogEvent {
  const UserFilterDialogDashboardRolesChanged(this.dashboardRoles);

  final List<DashboardUserRole> dashboardRoles;

  @override
  List<Object?> get props => [dashboardRoles];
}

/// Event to reset all temporary filter selections in the dialog.
final class UserFilterDialogReset extends UserFilterDialogEvent {
  const UserFilterDialogReset();
}
