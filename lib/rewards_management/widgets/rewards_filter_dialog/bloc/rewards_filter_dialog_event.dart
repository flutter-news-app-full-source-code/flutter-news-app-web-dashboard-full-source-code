part of 'rewards_filter_dialog_bloc.dart';

/// Base class for all events related to the [RewardsFilterDialogBloc].
sealed class RewardsFilterDialogEvent extends Equatable {
  const RewardsFilterDialogEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the filter dialog's state from the main rewards filter BLoC.
final class RewardsFilterDialogInitialized extends RewardsFilterDialogEvent {
  const RewardsFilterDialogInitialized({required this.rewardsFilterState});

  final RewardsFilterState rewardsFilterState;

  @override
  List<Object?> get props => [rewardsFilterState];
}

/// Event to update the temporary search query in the dialog.
final class RewardsFilterDialogSearchQueryChanged
    extends RewardsFilterDialogEvent {
  const RewardsFilterDialogSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to update the temporary reward type filter in the dialog.
final class RewardsFilterDialogRewardTypeChanged
    extends RewardsFilterDialogEvent {
  const RewardsFilterDialogRewardTypeChanged(this.rewardTypeFilter);

  final RewardTypeFilter rewardTypeFilter;

  @override
  List<Object?> get props => [rewardTypeFilter];
}

/// Event to reset all temporary filter selections in the dialog.
final class RewardsFilterDialogReset extends RewardsFilterDialogEvent {
  const RewardsFilterDialogReset();
}
