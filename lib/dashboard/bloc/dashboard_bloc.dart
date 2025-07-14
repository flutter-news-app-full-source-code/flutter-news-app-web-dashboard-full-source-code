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
    required HtDataRepository<Headline> headlinesRepository,
  }) : _dashboardSummaryRepository = dashboardSummaryRepository,
       _headlinesRepository = headlinesRepository,
       super(const DashboardState()) {
    on<DashboardSummaryLoaded>(_onDashboardSummaryLoaded);
  }

  final HtDataRepository<DashboardSummary> _dashboardSummaryRepository;
  final HtDataRepository<Headline> _headlinesRepository;

  Future<void> _onDashboardSummaryLoaded(
    DashboardSummaryLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      // Fetch summary and recent headlines concurrently
      final [
        summaryResponse,
        recentHeadlinesResponse,
      ] = await Future.wait([
        _dashboardSummaryRepository.read(id: kDashboardSummaryId),
        _headlinesRepository.readAll(
          pagination: const PaginationOptions(limit: 5),
          sort: const [SortOption('createdAt', SortOrder.desc)],
        ),
      ]);

      final summary = summaryResponse as DashboardSummary;
      final recentHeadlines =
          (recentHeadlinesResponse as PaginatedResponse<Headline>).items;
      emit(
        state.copyWith(
          status: DashboardStatus.success,
          summary: summary,
          recentHeadlines: recentHeadlines,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          exception: UnknownException('An unknown error occurred: $e'),
        ),
      );
    }
  }
}
