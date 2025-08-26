part of 'overview_bloc.dart';

/// Represents the status of the dashboard data loading.
enum DashboardStatus {
  /// Initial state.
  initial,

  /// Data is being loaded.
  loading,

  /// Data has been successfully loaded.
  success,

  /// An error occurred while loading data.
  failure,
}

/// The state for the [DashboardBloc].
final class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.summary,
    this.recentHeadlines = const [],
    this.exception,
  });

  final DashboardStatus status;
  final DashboardSummary? summary;
  final List<Headline> recentHeadlines;
  final HttpException? exception;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSummary? summary,
    List<Headline>? recentHeadlines,
    HttpException? exception,
  }) {
    return DashboardState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      recentHeadlines: recentHeadlines ?? this.recentHeadlines,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, summary, recentHeadlines, exception];
}
