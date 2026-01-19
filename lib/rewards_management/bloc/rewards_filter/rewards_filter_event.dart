part of 'rewards_filter_bloc.dart';

/// Base class for all events related to the [RewardsFilterBloc].
sealed class RewardsFilterEvent extends Equatable {
  const RewardsFilterEvent();

  @override
  List<Object> get props => [];
}

/// Event to update the search query for filtering rewards.
final class RewardsFilterSearchQueryChanged extends RewardsFilterEvent {
  const RewardsFilterSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

/// Event to reset all filters to their default state.
final class RewardsFilterReset extends RewardsFilterEvent {
  const RewardsFilterReset();
}

/// Event dispatched from the filter dialog to apply all selected filters at
/// once.
final class RewardsFilterApplied extends RewardsFilterEvent {
  const RewardsFilterApplied({
    required this.searchQuery,
    required this.rewardTypeFilter,
  });

  final String searchQuery;
  final RewardTypeFilter rewardTypeFilter;

  @override
  List<Object> get props => [searchQuery, rewardTypeFilter];
}
