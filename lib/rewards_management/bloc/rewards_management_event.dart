part of 'rewards_management_bloc.dart';

/// Base class for all events related to the [RewardsManagementBloc].
sealed class RewardsManagementEvent extends Equatable {
  const RewardsManagementEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading of user rewards.
final class LoadRewardsRequested extends RewardsManagementEvent {
  const LoadRewardsRequested({
    this.startAfterId,
    this.limit,
    this.forceRefresh = false,
    this.filter,
  });

  /// The ID of the last item in the previous page, used for pagination.
  final String? startAfterId;

  /// The maximum number of items to load.
  final int? limit;

  /// Whether to force a refresh of the data, ignoring any cached state.
  final bool forceRefresh;

  /// Optional filter criteria to apply to the query.
  final Map<String, dynamic>? filter;

  @override
  List<Object?> get props => [startAfterId, limit, forceRefresh, filter];
}
