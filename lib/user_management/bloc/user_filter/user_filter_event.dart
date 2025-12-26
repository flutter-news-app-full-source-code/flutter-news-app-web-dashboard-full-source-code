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

/// Event to reset all filters to their default state.
final class UserFilterReset extends UserFilterEvent {
  const UserFilterReset();
}

/// Event dispatched from the filter dialog to apply all selected filters at
/// once.
final class UserFilterApplied extends UserFilterEvent {
  const UserFilterApplied({
    required this.searchQuery,
    required this.authenticationFilter,
    required this.subscriptionFilter,
    this.userRole,
  });

  final String searchQuery;
  final AuthenticationFilter authenticationFilter;
  final SubscriptionFilter subscriptionFilter;
  final UserRole? userRole;

  @override
  List<Object> get props => [
    searchQuery,
    authenticationFilter,
    subscriptionFilter,
    userRole ?? '',
  ];
}
