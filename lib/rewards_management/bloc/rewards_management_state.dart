part of 'rewards_management_bloc.dart';

/// The status of the rewards management feature.
enum RewardsManagementStatus {
  /// The initial state.
  initial,

  /// The data is being loaded.
  loading,

  /// The data has been successfully loaded.
  success,

  /// An error occurred while loading data.
  failure,
}

/// {@template rewards_management_state}
/// The state for the rewards management feature.
///
/// This state holds the list of user rewards, pagination details, and the
/// current status of the data loading process.
/// {@endtemplate}
class RewardsManagementState extends Equatable {
  /// {@macro rewards_management_state}
  const RewardsManagementState({
    this.status = RewardsManagementStatus.initial,
    this.rewards = const [],
    this.hasMore = false,
    this.cursor,
    this.exception,
  });

  /// The current status of the rewards management feature.
  final RewardsManagementStatus status;

  /// The list of user rewards currently loaded.
  final List<UserRewards> rewards;

  /// Whether there are more rewards available to load.
  final bool hasMore;

  /// The cursor for pagination.
  final String? cursor;

  /// The exception that occurred, if any.
  final HttpException? exception;

  /// Creates a copy of this [RewardsManagementState] with updated values.
  RewardsManagementState copyWith({
    RewardsManagementStatus? status,
    List<UserRewards>? rewards,
    bool? hasMore,
    String? cursor,
    HttpException? exception,
  }) {
    return RewardsManagementState(
      status: status ?? this.status,
      rewards: rewards ?? this.rewards,
      hasMore: hasMore ?? this.hasMore,
      cursor: cursor ?? this.cursor,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, rewards, hasMore, cursor, exception];
}
