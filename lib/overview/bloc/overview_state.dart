part of 'overview_bloc.dart';

enum OverviewStatus { initial, loading, success, failure }

final class OverviewState extends Equatable {
  const OverviewState({
    this.status = OverviewStatus.initial,
    this.rankedListData = const [],
    this.error,
  });

  final OverviewStatus status;
  final List<RankedListCardData?> rankedListData;
  final Object? error;

  OverviewState copyWith({
    OverviewStatus? status,
    List<RankedListCardData?>? rankedListData,
    Object? error,
  }) {
    return OverviewState(
      status: status ?? this.status,
      rankedListData: rankedListData ?? this.rankedListData,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, rankedListData, error];
}
