part of 'user_management_bloc.dart';

/// Base class for all events related to the [UserManagementBloc].
sealed class UserManagementEvent extends Equatable {
  const UserManagementEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading of users with pagination and filtering.
final class LoadUsersRequested extends UserManagementEvent {
  const LoadUsersRequested({
    this.startAfterId,
    this.limit,
    this.forceRefresh = false,
    this.filter,
  });

  /// The ID of the last user from the previous page, used for pagination.
  final String? startAfterId;

  /// The maximum number of users to fetch.
  final int? limit;

  /// Whether to force a refresh of the user list, ignoring any cached data.
  final bool forceRefresh;

  /// An optional filter map to apply to the user query.
  final Map<String, dynamic>? filter;

  @override
  List<Object?> get props => [startAfterId, limit, forceRefresh, filter];
}

/// Event to change a user's dashboard role.
final class UserDashboardRoleChanged extends UserManagementEvent {
  const UserDashboardRoleChanged({
    required this.userId,
    required this.dashboardRole,
  });

  /// The ID of the user to update.
  final String userId;

  /// The new dashboard role to assign to the user.
  final DashboardUserRole dashboardRole;

  @override
  List<Object?> get props => [userId, dashboardRole];
}

/// Event to change a user's app role.
final class UserAppRoleChanged extends UserManagementEvent {
  const UserAppRoleChanged({required this.userId, required this.appRole});

  /// The ID of the user to update.
  final String userId;

  /// The new app role to assign to the user.
  final AppUserRole appRole;

  @override
  List<Object?> get props => [userId, appRole];
}
