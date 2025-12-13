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
    this.subscriptionFilter = SubscriptionFilter.all,
    this.dashboardRole,
  });

  /// The current search query for filtering users by email.
  final String searchQuery;

  /// The selected authentication status filter.
  final AuthenticationFilter authenticationFilter;

  /// The selected subscription status filter.
  final SubscriptionFilter subscriptionFilter;

  /// The selected dashboard role filter.
  final DashboardUserRole? dashboardRole;

  /// Creates a copy of this [UserFilterState] with updated values.
  UserFilterState copyWith({
    String? searchQuery,
    AuthenticationFilter? authenticationFilter,
    SubscriptionFilter? subscriptionFilter,
    DashboardUserRole? dashboardRole,
  }) {
    return UserFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      authenticationFilter: authenticationFilter ?? this.authenticationFilter,
      subscriptionFilter: subscriptionFilter ?? this.subscriptionFilter,
      dashboardRole: dashboardRole ?? this.dashboardRole,
    );
  }

  @override
  List<Object> get props => [
    searchQuery,
    authenticationFilter,
    subscriptionFilter,
    dashboardRole ?? '',
  ];
}
