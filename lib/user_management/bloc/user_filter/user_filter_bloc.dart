import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_management_bloc.dart'
    show UserManagementBloc;
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/enums/authentication_filter.dart';

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
        authenticationFilter: event.authenticationFilter,
        userRole: event.userRole,
      ),
    );
  }
}
