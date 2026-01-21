import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_filter/user_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/enums/authentication_filter.dart';
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
    on<UserFilterDialogReset>(_onFilterDialogReset);
    on<UserFilterDialogAuthenticationChanged>(_onAuthenticationChanged);
    on<UserFilterDialogUserRoleChanged>(_onUserRoleChanged);
  }

  /// Initializes the dialog's state from the main [UserFilterBloc]'s state.
  void _onFilterDialogInitialized(
    UserFilterDialogInitialized event,
    Emitter<UserFilterDialogState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.userFilterState.searchQuery,
        authenticationFilter: event.userFilterState.authenticationFilter,
        userRole: event.userFilterState.userRole,
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

  void _onAuthenticationChanged(
    UserFilterDialogAuthenticationChanged event,
    Emitter<UserFilterDialogState> emit,
  ) {
    emit(state.copyWith(authenticationFilter: event.authenticationFilter));
  }

  void _onUserRoleChanged(
    UserFilterDialogUserRoleChanged event,
    Emitter<UserFilterDialogState> emit,
  ) {
    // Directly set the state to the selected role. The UI's `onSelected`
    // will pass `null` when 'Any' is tapped.
    emit(state.copyWith(userRole: event.userRole));
  }

  /// Resets all temporary filter selections in the dialog.
  void _onFilterDialogReset(
    UserFilterDialogReset event,
    Emitter<UserFilterDialogState> emit,
  ) {
    emit(const UserFilterDialogState());
  }
}
