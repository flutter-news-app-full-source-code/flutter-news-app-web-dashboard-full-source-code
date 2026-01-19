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

/// Event to update the temporary authentication filter in the dialog.
final class UserFilterDialogAuthenticationChanged
    extends UserFilterDialogEvent {
  const UserFilterDialogAuthenticationChanged(this.authenticationFilter);

  final AuthenticationFilter authenticationFilter;

  @override
  List<Object?> get props => [authenticationFilter];
}

/// Event to update the temporary user role filter in the dialog.
final class UserFilterDialogUserRoleChanged extends UserFilterDialogEvent {
  const UserFilterDialogUserRoleChanged(this.userRole);

  final UserRole? userRole;

  @override
  List<Object?> get props => [userRole];
}

/// Event to reset all temporary filter selections in the dialog.
final class UserFilterDialogReset extends UserFilterDialogEvent {
  const UserFilterDialogReset();
}
