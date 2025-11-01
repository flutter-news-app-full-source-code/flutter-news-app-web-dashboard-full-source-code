import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_filter/user_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/widgets/user_filter_dialog/user_filter_dialog.dart'
    show UserFilterDialog;

part 'user_filter_dialog_event.dart';
part 'user_filter_dialog_state.dart';

/// {@template user_filter_dialog_bloc}
/// Manages the temporary state and logic for the [UserFilterDialog].
///
/// This BLoC is initialized with the current state of the main
/// [UserFilterBloc]. It allows users to modify filter criteria in a temporary
/// state. When the user applies the changes, the new state is dispatched
/// back to the main [UserFilterBloc].
/// {@endtemplate}
class UserFilterDialogBloc
    extends Bloc<UserFilterDialogEvent, UserFilterDialogState> {
  /// {@macro user_filter_dialog_bloc}
  UserFilterDialogBloc() : super(const UserFilterDialogState()) {
    on<UserFilterDialogInitialized>(_onFilterDialogInitialized);
    on<UserFilterDialogSearchQueryChanged>(_onSearchQueryChanged);
    on<UserFilterDialogAppRolesChanged>(_onAppRolesChanged);
    on<UserFilterDialogDashboardRolesChanged>(_onDashboardRolesChanged);
    on<UserFilterDialogReset>(_onFilterDialogReset);
  }

  /// Initializes the dialog's state from the main [UserFilterBloc]'s state.
  void _onFilterDialogInitialized(
    UserFilterDialogInitialized event,
    Emitter<UserFilterDialogState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.userFilterState.searchQuery,
        selectedAppRoles: event.userFilterState.selectedAppRoles,
        selectedDashboardRoles: event.userFilterState.selectedDashboardRoles,
      ),
    );
  }

  /// Updates the temporary search query.
  void _onSearchQueryChanged(
    UserFilterDialogSearchQueryChanged event,
    Emitter<UserFilterDialogState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Updates the temporary selected app roles.
  void _onAppRolesChanged(
    UserFilterDialogAppRolesChanged event,
    Emitter<UserFilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedAppRoles: event.appRoles));
  }

  /// Updates the temporary selected dashboard roles.
  void _onDashboardRolesChanged(
    UserFilterDialogDashboardRolesChanged event,
    Emitter<UserFilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedDashboardRoles: event.dashboardRoles));
  }

  /// Resets all temporary filter selections in the dialog.
  void _onFilterDialogReset(
    UserFilterDialogReset event,
    Emitter<UserFilterDialogState> emit,
  ) {
    emit(const UserFilterDialogState());
  }
}
