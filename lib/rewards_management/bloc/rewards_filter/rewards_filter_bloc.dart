import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/enums/reward_type_filter.dart';

part 'rewards_filter_event.dart';
part 'rewards_filter_state.dart';

/// {@template rewards_filter_bloc}
/// A BLoC that manages the state of filters for the rewards list.
///
/// This BLoC is responsible for holding the current filter criteria, such as
/// search queries and selected reward types.
/// {@endtemplate}
class RewardsFilterBloc extends Bloc<RewardsFilterEvent, RewardsFilterState> {
  /// {@macro rewards_filter_bloc}
  RewardsFilterBloc() : super(const RewardsFilterState()) {
    on<RewardsFilterSearchQueryChanged>(_onSearchQueryChanged);
    on<RewardsFilterReset>(_onFilterReset);
    on<RewardsFilterApplied>(_onFilterApplied);
  }

  /// Handles changes to the search query filter.
  void _onSearchQueryChanged(
    RewardsFilterSearchQueryChanged event,
    Emitter<RewardsFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Resets all filters to their default values.
  void _onFilterReset(
    RewardsFilterReset event,
    Emitter<RewardsFilterState> emit,
  ) {
    emit(const RewardsFilterState());
  }

  /// Applies a new set of filters, typically from the filter dialog.
  void _onFilterApplied(
    RewardsFilterApplied event,
    Emitter<RewardsFilterState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.searchQuery,
        rewardTypeFilter: event.rewardTypeFilter,
      ),
    );
  }
}
