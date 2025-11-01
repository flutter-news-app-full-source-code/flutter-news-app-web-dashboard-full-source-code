part of 'user_management_bloc.dart';

/// Represents the status of user management operations.
enum UserManagementStatus {
  /// The operation is in its initial state.
  initial,

  /// Data is currently being loaded or an operation is in progress.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred during data loading or an operation.
  failure,
}

/// {@template user_management_state}
/// The state for the user management feature.
///
/// This state holds the list of users, their loading status, pagination
/// details, and any exceptions that may have occurred.
/// {@endtemplate}
class UserManagementState extends Equatable {
  /// {@macro user_management_state}
  const UserManagementState({
    this.status = UserManagementStatus.initial,
    this.users = const [],
    this.cursor,
    this.hasMore = false,
    this.exception,
  });

  /// The status of the users loading operation.
  final UserManagementStatus status;

  /// The list of users currently displayed.
  final List<User> users;

  /// The cursor for fetching the next page of users.
  final String? cursor;

  /// Indicates if there are more users available to load.
  final bool hasMore;

  /// The exception encountered during a failed operation, if any.
  final HttpException? exception;

  /// Creates a copy of this [UserManagementState] with updated values.
  UserManagementState copyWith({
    UserManagementStatus? status,
    List<User>? users,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
  }) {
    return UserManagementState(
      status: status ?? this.status,
      users: users ?? this.users,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      exception: exception,
    );
  }

  @override
  List<Object?> get props => [
    status,
    users,
    cursor,
    hasMore,
    exception,
  ];
}
