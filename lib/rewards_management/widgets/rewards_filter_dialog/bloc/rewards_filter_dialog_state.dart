part of 'rewards_filter_dialog_bloc.dart';

/// {@template rewards_filter_dialog_state}
/// The state for the [RewardsFilterDialogBloc].
///
/// This state holds the temporary filter selections made by the user within
/// the filter dialog before they are applied to the main rewards list.
/// {@endtemplate}
final class RewardsFilterDialogState extends Equatable {
  /// {@macro rewards_filter_dialog_state}
  const RewardsFilterDialogState({
    this.searchQuery = '',
    this.rewardTypeFilter = RewardTypeFilter.all,
  });

  /// The current text in the search query field.
  final String searchQuery;

  /// The selected reward type filter.
  final RewardTypeFilter rewardTypeFilter;

  /// Creates a copy of this [RewardsFilterDialogState] with updated values.
  RewardsFilterDialogState copyWith({
    String? searchQuery,
    RewardTypeFilter? rewardTypeFilter,
  }) {
    return RewardsFilterDialogState(
      searchQuery: searchQuery ?? this.searchQuery,
      rewardTypeFilter: rewardTypeFilter ?? this.rewardTypeFilter,
    );
  }

  @override
  List<Object?> get props => [searchQuery, rewardTypeFilter];
}
