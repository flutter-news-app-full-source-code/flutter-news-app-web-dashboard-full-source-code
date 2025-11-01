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
    this.selectedAppRoles = const [],
    this.selectedDashboardRoles = const [],
  });

  /// The current search query for filtering users by email.
  final String searchQuery;

  /// The list of selected app roles to filter users by.
  final List<AppUserRole> selectedAppRoles;

  /// The list of selected dashboard roles to filter users by.
  final List<DashboardUserRole> selectedDashboardRoles;

  /// Creates a copy of this [UserFilterState] with updated values.
  UserFilterState copyWith({
    String? searchQuery,
    List<AppUserRole>? selectedAppRoles,
    List<DashboardUserRole>? selectedDashboardRoles,
  }) {
    return UserFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedAppRoles: selectedAppRoles ?? this.selectedAppRoles,
      selectedDashboardRoles:
          selectedDashboardRoles ?? this.selectedDashboardRoles,
    );
  }

  @override
  List<Object> get props => [
    searchQuery,
    selectedAppRoles,
    selectedDashboardRoles,
  ];
}
