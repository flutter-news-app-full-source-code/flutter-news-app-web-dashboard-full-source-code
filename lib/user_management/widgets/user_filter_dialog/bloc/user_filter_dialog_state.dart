part of 'user_filter_dialog_bloc.dart';

/// {@template user_filter_dialog_state}
/// The state for the [UserFilterDialogBloc].
///
/// This state holds the temporary filter selections made by the user within
/// the filter dialog before they are applied to the main user list.
/// {@endtemplate}
final class UserFilterDialogState extends Equatable {
  /// {@macro user_filter_dialog_state}
  const UserFilterDialogState({
    this.searchQuery = '',
    this.authenticationFilter = AuthenticationFilter.all,
    this.userRole,
  });

  /// The current text in the search query field.
  final String searchQuery;

  /// The selected authentication status filter.
  final AuthenticationFilter authenticationFilter;

  /// The selected user role filter.
  final UserRole? userRole;

  /// Creates a copy of this [UserFilterDialogState] with updated values.
  UserFilterDialogState copyWith({
    String? searchQuery,
    AuthenticationFilter? authenticationFilter,
    UserRole? userRole,
  }) {
    return UserFilterDialogState(
      searchQuery: searchQuery ?? this.searchQuery,
      authenticationFilter: authenticationFilter ?? this.authenticationFilter,
      userRole: userRole ?? this.userRole,
    );
  }

  @override
  List<Object?> get props => [
    searchQuery,
    authenticationFilter,
    userRole,
  ];
}
