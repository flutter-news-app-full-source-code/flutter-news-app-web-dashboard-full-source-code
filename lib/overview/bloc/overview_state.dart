part of 'overview_bloc.dart';

/// Represents the status of the dashboard overview data loading.
enum OverviewStatus {
  /// Initial state.
  initial,

  /// Data is being loaded.
  loading,

  /// Data has been successfully loaded.
  success,

  /// An error occurred while loading data.
  failure,
}

/// The state for the [OverviewBloc].
final class OverviewState extends Equatable {
  const OverviewState({
    this.status = OverviewStatus.initial,
    this.summary,
    this.recentHeadlines = const [],
    this.exception,
  });

  final OverviewStatus status;
  final DashboardSummary? summary;
  final List<Headline> recentHeadlines;
  final HttpException? exception;

  OverviewState copyWith({
    OverviewStatus? status,
    DashboardSummary? summary,
    List<Headline>? recentHeadlines,
    HttpException? exception,
  }) {
    return OverviewState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      recentHeadlines: recentHeadlines ?? this.recentHeadlines,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, summary, recentHeadlines, exception];
}
