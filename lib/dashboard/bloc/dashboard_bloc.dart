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
    required HtDataRepository<AppConfig> appConfigRepository,
    required HtDataRepository<Headline> headlinesRepository,
  }) : _dashboardSummaryRepository = dashboardSummaryRepository,
       _appConfigRepository = appConfigRepository,
       _headlinesRepository = headlinesRepository,
       super(const DashboardState()) {
    on<DashboardSummaryLoaded>(_onDashboardSummaryLoaded);
  }

  final HtDataRepository<DashboardSummary> _dashboardSummaryRepository;
  final HtDataRepository<AppConfig> _appConfigRepository;
  final HtDataRepository<Headline> _headlinesRepository;

  Future<void> _onDashboardSummaryLoaded(
    DashboardSummaryLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      // Fetch summary, app config, and recent headlines concurrently
      final [
        summaryResponse,
        appConfigResponse,
        recentHeadlinesResponse,
      ] = await Future.wait([
        _dashboardSummaryRepository.read(id: 'summary'),
        _appConfigRepository.read(id: 'app_config'),
        _headlinesRepository.readAll(
          sortBy: 'createdAt',
          sortOrder: SortOrder.desc,
          limit: 5,
        ),
      ]);

      final summary = summaryResponse as DashboardSummary;
      final appConfig = appConfigResponse as AppConfig;
      final recentHeadlines =
          (recentHeadlinesResponse as PaginatedResponse<Headline>).items;
      emit(
        state.copyWith(
          status: DashboardStatus.success,
          summary: summary,
          appConfig: appConfig,
          recentHeadlines: recentHeadlines,
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
