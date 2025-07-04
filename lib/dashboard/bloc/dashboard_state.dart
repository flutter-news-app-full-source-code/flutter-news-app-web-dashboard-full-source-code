part of 'dashboard_bloc.dart';

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
    this.errorMessage,
  });

  final DashboardStatus status;
  final DashboardSummary? summary;
  final String? errorMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSummary? summary,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage];
}
