import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

/// A BLoC to manage the state of the dashboard.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  /// {@macro dashboard_bloc}
  DashboardBloc({
    required DataRepository<DashboardSummary> dashboardSummaryRepository,
    required DataRepository<Headline> headlinesRepository,
  }) : _dashboardSummaryRepository = dashboardSummaryRepository,
       _headlinesRepository = headlinesRepository,
       super(const DashboardState()) {
    on<DashboardSummaryLoaded>(_onDashboardSummaryLoaded);
  }

  final DataRepository<DashboardSummary> _dashboardSummaryRepository;
  final DataRepository<Headline> _headlinesRepository;

  Future<void> _onDashboardSummaryLoaded(
    DashboardSummaryLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      // Fetch summary and recent headlines concurrently
      final [summaryResponse, recentHeadlinesResponse] = await Future.wait([
        _dashboardSummaryRepository.read(id: kDashboardSummaryId),
        _headlinesRepository.readAll(
          pagination: const PaginationOptions(limit: 5),
          sort: const [SortOption('updatedAt', SortOrder.desc)],
          filter: {'status': ContentStatus.active.name},
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
    } on HttpException catch (e) {
      emit(state.copyWith(status: DashboardStatus.failure, exception: e));
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
