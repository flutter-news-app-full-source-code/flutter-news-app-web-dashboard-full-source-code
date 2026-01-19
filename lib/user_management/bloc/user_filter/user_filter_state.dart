part of 'user_filter_bloc.dart';

/// {@template user_filter_state}
/// The state for the user filter feature.
///
/// This state holds the current filter criteria for the user list, including
/// search query and selected roles.
/// {@endtemplate}
class UserFilterState extends Equatable {
  /// {@macro user_filter_state}
  const UserFilterState({
    this.searchQuery = '',
    this.authenticationFilter = AuthenticationFilter.all,
    this.userRole,
  });

  /// The current search query for filtering users by email.
  final String searchQuery;

  /// The selected authentication status filter.
  final AuthenticationFilter authenticationFilter;

  /// The selected user role filter.
  final UserRole? userRole;

  /// Creates a copy of this [UserFilterState] with updated values.
  UserFilterState copyWith({
    String? searchQuery,
    AuthenticationFilter? authenticationFilter,
    UserRole? userRole,
  }) {
    return UserFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      authenticationFilter: authenticationFilter ?? this.authenticationFilter,
      userRole: userRole ?? this.userRole,
    );
  }

  @override
  List<Object> get props => [
    searchQuery,
    authenticationFilter,
    userRole ?? '',
  ];
}
