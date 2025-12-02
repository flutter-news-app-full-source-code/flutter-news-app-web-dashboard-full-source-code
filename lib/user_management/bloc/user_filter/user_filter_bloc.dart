import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_management_bloc.dart'
    show UserManagementBloc;

part 'user_filter_event.dart';
part 'user_filter_state.dart';

/// {@template user_filter_bloc}
/// A BLoC that manages the state of filters for the user list.
///
/// This BLoC is responsible for holding the current filter criteria, such as
/// search queries and selected roles, which are then used by the
/// [UserManagementBloc] to fetch the filtered list of users.
/// {@endtemplate}
class UserFilterBloc extends Bloc<UserFilterEvent, UserFilterState> {
  /// {@macro user_filter_bloc}
  UserFilterBloc() : super(const UserFilterState()) {
    on<UserFilterSearchQueryChanged>(_onSearchQueryChanged);
    on<UserFilterAppRolesChanged>(_onAppRolesChanged);
    on<UserFilterDashboardRolesChanged>(_onDashboardRolesChanged);
    on<UserFilterReset>(_onFilterReset);
    on<UserFilterApplied>(_onFilterApplied);
  }

  /// Handles changes to the search query filter.
  void _onSearchQueryChanged(
    UserFilterSearchQueryChanged event,
    Emitter<UserFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Handles changes to the selected app roles filter.
  void _onAppRolesChanged(
    UserFilterAppRolesChanged event,
    Emitter<UserFilterState> emit,
  ) {
    emit(state.copyWith(selectedAppRoles: event.appRoles));
  }

  /// Handles changes to the selected dashboard roles filter.
  void _onDashboardRolesChanged(
    UserFilterDashboardRolesChanged event,
    Emitter<UserFilterState> emit,
  ) {
    emit(state.copyWith(selectedDashboardRoles: event.dashboardRoles));
  }

  /// Resets all filters to their default values.
  void _onFilterReset(
    UserFilterReset event,
    Emitter<UserFilterState> emit,
  ) {
    emit(const UserFilterState());
  }

  /// Applies a new set of filters, typically from the filter dialog.
  void _onFilterApplied(
    UserFilterApplied event,
    Emitter<UserFilterState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.searchQuery,
        selectedAppRoles: event.selectedAppRoles,
        selectedDashboardRoles: event.selectedDashboardRoles,
      ),
    );
  }

  /// Builds the filter map for the data repository query.
  Map<String, dynamic> buildFilterMap() {
    final filter = <String, dynamic>{};

    if (state.searchQuery.isNotEmpty) {
      filter[r'$or'] = [
        {
          'email': {r'$regex': state.searchQuery, r'$options': 'i'},
        },
        {'_id': state.searchQuery},
      ];
    }

    if (state.selectedAppRoles.isNotEmpty) {
      filter['appRole'] = {
        r'$in': state.selectedAppRoles.map((r) => r.name).toList(),
      };
    }
    if (state.selectedDashboardRoles.isNotEmpty) {
      filter['dashboardRole'] = {
        r'$in': state.selectedDashboardRoles.map((r) => r.name).toList(),
      };
    }
    return filter;
  }
}
