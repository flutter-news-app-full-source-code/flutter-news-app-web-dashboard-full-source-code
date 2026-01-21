import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_filter/rewards_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/enums/reward_type_filter.dart';

part 'rewards_filter_dialog_event.dart';
part 'rewards_filter_dialog_state.dart';

/// {@template rewards_filter_dialog_bloc}
/// Manages the temporary state and logic for the RewardsFilterDialog.
///
/// This BLoC is initialized with the current state of the main
/// [RewardsFilterBloc]. It allows users to modify filter criteria in a temporary
/// state. When the user applies the changes, the new state is dispatched
/// back to the main [RewardsFilterBloc].
/// {@endtemplate}
class RewardsFilterDialogBloc
    extends Bloc<RewardsFilterDialogEvent, RewardsFilterDialogState> {
  /// {@macro rewards_filter_dialog_bloc}
  RewardsFilterDialogBloc() : super(const RewardsFilterDialogState()) {
    on<RewardsFilterDialogInitialized>(_onFilterDialogInitialized);
    on<RewardsFilterDialogSearchQueryChanged>(_onSearchQueryChanged);
    on<RewardsFilterDialogRewardTypeChanged>(_onRewardTypeChanged);
    on<RewardsFilterDialogReset>(_onFilterDialogReset);
  }

  /// Initializes the dialog's state from the main [RewardsFilterBloc]'s state.
  void _onFilterDialogInitialized(
    RewardsFilterDialogInitialized event,
    Emitter<RewardsFilterDialogState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.rewardsFilterState.searchQuery,
        rewardTypeFilter: event.rewardsFilterState.rewardTypeFilter,
      ),
    );
  }

  /// Updates the temporary search query.
  void _onSearchQueryChanged(
    RewardsFilterDialogSearchQueryChanged event,
    Emitter<RewardsFilterDialogState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Updates the temporary reward type filter.
  void _onRewardTypeChanged(
    RewardsFilterDialogRewardTypeChanged event,
    Emitter<RewardsFilterDialogState> emit,
  ) {
    emit(state.copyWith(rewardTypeFilter: event.rewardTypeFilter));
  }

  /// Resets all temporary filter selections in the dialog.
  void _onFilterDialogReset(
    RewardsFilterDialogReset event,
    Emitter<RewardsFilterDialogState> emit,
  ) {
    emit(const RewardsFilterDialogState());
  }
}
