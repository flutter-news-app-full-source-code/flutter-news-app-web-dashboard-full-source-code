part of 'rewards_filter_bloc.dart';

/// {@template rewards_filter_state}
/// The state for the rewards filter feature.
///
/// This state holds the current filter criteria for the rewards list, including
/// search query and selected reward type.
/// {@endtemplate}
class RewardsFilterState extends Equatable {
  /// {@macro rewards_filter_state}
  const RewardsFilterState({
    this.searchQuery = '',
    this.rewardTypeFilter = RewardTypeFilter.all,
  });

  /// The current search query for filtering rewards by user ID.
  final String searchQuery;

  /// The selected reward type filter.
  final RewardTypeFilter rewardTypeFilter;

  /// Creates a copy of this [RewardsFilterState] with updated values.
  RewardsFilterState copyWith({
    String? searchQuery,
    RewardTypeFilter? rewardTypeFilter,
  }) {
    return RewardsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      rewardTypeFilter: rewardTypeFilter ?? this.rewardTypeFilter,
    );
  }

  @override
  List<Object> get props => [searchQuery, rewardTypeFilter];
}
