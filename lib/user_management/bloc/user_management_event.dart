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

/// Event to change a user's role.
final class UserRoleChanged extends UserManagementEvent {
  const UserRoleChanged({
    required this.userId,
    required this.role,
  });

  /// The ID of the user to update.
  final String userId;

  /// The new role to assign to the user.
  final UserRole role;

  @override
  List<Object?> get props => [userId, role];
}

/// Event to change a user's access tier.
final class UserAccessTierChanged extends UserManagementEvent {
  const UserAccessTierChanged({required this.userId, required this.tier});

  /// The ID of the user to update.
  final String userId;

  /// The new access tier to assign to the user.
  final AccessTier tier;

  @override
  List<Object?> get props => [userId, tier];
}
