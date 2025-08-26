import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

part 'overview_event.dart';
part 'overview_state.dart';

/// A BLoC to manage the state of the dashboard overview.
class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  /// {@macro overview_bloc}
  OverviewBloc({
    required DataRepository<DashboardSummary> dashboardSummaryRepository,
    required DataRepository<Headline> headlinesRepository,
    required DataRepository<Topic> topicsRepository,
    required DataRepository<Source> sourcesRepository,
  }) : _dashboardSummaryRepository = dashboardSummaryRepository,
       _headlinesRepository = headlinesRepository,
       super(const OverviewState()) {
    on<OverviewSummaryRequested>(_onOverviewSummaryRequested);
    on<_OverviewEntityUpdated>(_onOverviewEntityUpdated);

    _entityUpdatedSubscription = headlinesRepository.entityUpdated
        .merge(topicsRepository.entityUpdated)
        .merge(sourcesRepository.entityUpdated)
        .listen((_) => add(const _OverviewEntityUpdated()));
  }

  final DataRepository<DashboardSummary> _dashboardSummaryRepository;
  final DataRepository<Headline> _headlinesRepository;
  late final StreamSubscription<void> _entityUpdatedSubscription;

  @override
  Future<void> close() {
    _entityUpdatedSubscription.cancel();
    return super.close();
  }

  void _onOverviewEntityUpdated(
    _OverviewEntityUpdated event,
    Emitter<OverviewState> emit,
  ) {
    add(OverviewSummaryRequested());
  }

  Future<void> _onOverviewSummaryRequested(
    OverviewSummaryRequested event,
    Emitter<OverviewState> emit,
  ) async {
    emit(state.copyWith(status: OverviewStatus.loading));
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
          status: OverviewStatus.success,
          summary: summary,
          recentHeadlines: recentHeadlines,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: OverviewStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: OverviewStatus.failure,
          exception: UnknownException('An unknown error occurred: $e'),
        ),
      );
    }
  }
}
