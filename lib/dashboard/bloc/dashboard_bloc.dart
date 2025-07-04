import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

/// A BLoC to manage the state of the dashboard.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  /// {@macro dashboard_bloc}
  DashboardBloc({
    required HtDataRepository<DashboardSummary> dashboardSummaryRepository,
  }) : _dashboardSummaryRepository = dashboardSummaryRepository,
       super(const DashboardState()) {
    on<DashboardSummaryLoaded>(_onDashboardSummaryLoaded);
  }

  final HtDataRepository<DashboardSummary> _dashboardSummaryRepository;

  Future<void> _onDashboardSummaryLoaded(
    DashboardSummaryLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      // The dashboard summary is a singleton-like resource, fetched by a
      // well-known ID.
      final summary = await _dashboardSummaryRepository.read(id: 'summary');
      emit(
        state.copyWith(
          status: DashboardStatus.success,
          summary: summary,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: 'An unknown error occurred: $e',
        ),
      );
    }
  }
}
