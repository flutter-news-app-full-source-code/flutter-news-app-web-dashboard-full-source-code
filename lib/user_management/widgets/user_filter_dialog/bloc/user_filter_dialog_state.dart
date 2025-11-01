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
    this.selectedAppRoles = const [],
    this.selectedDashboardRoles = const [],
  });

  /// The current text in the search query field.
  final String searchQuery;

  /// The list of app roles to be included in the filter.
  final List<AppUserRole> selectedAppRoles;

  /// The list of dashboard roles to be included in the filter.
  final List<DashboardUserRole> selectedDashboardRoles;

  /// Creates a copy of this [UserFilterDialogState] with updated values.
  UserFilterDialogState copyWith({
    String? searchQuery,
    List<AppUserRole>? selectedAppRoles,
    List<DashboardUserRole>? selectedDashboardRoles,
  }) {
    return UserFilterDialogState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedAppRoles: selectedAppRoles ?? this.selectedAppRoles,
      selectedDashboardRoles:
          selectedDashboardRoles ?? this.selectedDashboardRoles,
    );
  }

  @override
  List<Object?> get props => [
    searchQuery,
    selectedAppRoles,
    selectedDashboardRoles,
  ];
}
