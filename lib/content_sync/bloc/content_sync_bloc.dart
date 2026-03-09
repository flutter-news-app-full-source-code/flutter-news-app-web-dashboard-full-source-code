import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:verity_dashboard/shared/constants/app_constants.dart';

part 'content_sync_event.dart';
part 'content_sync_state.dart';

class ContentSyncBloc extends Bloc<ContentSyncEvent, ContentSyncState> {
  ContentSyncBloc({
    required DataRepository<NewsAutomationTask> automationRepository,
    required DataRepository<Source> sourcesRepository,
  }) : _automationRepository = automationRepository,
       _sourcesRepository = sourcesRepository,
       super(const ContentSyncState()) {
    on<ContentSyncStarted>(_onStarted);
    on<ContentSyncStatusToggled>(_onStatusToggled);
    on<ContentSyncTaskDeleted>(_onTaskDeleted);

    _automationSubscription = _automationRepository.entityUpdated
        .where((type) => type == NewsAutomationTask)
        .listen((_) => add(const ContentSyncStarted(forceRefresh: true)));
  }

  final DataRepository<NewsAutomationTask> _automationRepository;
  final DataRepository<Source> _sourcesRepository;
  late final StreamSubscription<Type> _automationSubscription;

  Future<void> _onStarted(
    ContentSyncStarted event,
    Emitter<ContentSyncState> emit,
  ) async {
    if (state.status == ContentSyncStatus.loading && !event.forceRefresh) {
      return;
    }

    emit(state.copyWith(status: ContentSyncStatus.loading));

    try {
      final isPaginating = event.cursor != null;
      final previousTasks = isPaginating ? state.tasks : <NewsAutomationTask>[];
      final previousSources = isPaginating ? state.sources : <String, Source>{};

      final response = await _automationRepository.readAll(
        pagination: PaginationOptions(
          cursor: event.cursor,
          limit: AppConstants.kDefaultRowsPerPage,
        ),
        sort: [const SortOption('updatedAt', SortOrder.desc)],
      );

      final newTasks = response.items;
      final sourceIds = newTasks.map((t) => t.sourceId).toSet();
      final newSources = <String, Source>{};

      final missingIds = sourceIds
          .where((id) => !previousSources.containsKey(id))
          .toList();

      if (missingIds.isNotEmpty) {
        final sourcesResponse = await _sourcesRepository.readAll(
          filter: {
            '_id': {r'$in': missingIds},
          },
        );
        for (final source in sourcesResponse.items) {
          newSources[source.id] = source;
        }
      }

      emit(
        state.copyWith(
          status: ContentSyncStatus.success,
          tasks: [...previousTasks, ...newTasks],
          sources: {...previousSources, ...newSources},
          cursor: response.cursor,
          hasMore: response.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: ContentSyncStatus.failure, exception: e));
    }
  }

  Future<void> _onStatusToggled(
    ContentSyncStatusToggled event,
    Emitter<ContentSyncState> emit,
  ) async {
    try {
      final task = state.tasks.firstWhere((t) => t.id == event.id);
      await _automationRepository.update(
        id: event.id,
        item: task.copyWith(status: event.status, updatedAt: DateTime.now()),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: ContentSyncStatus.failure, exception: e));
    }
  }

  Future<void> _onTaskDeleted(
    ContentSyncTaskDeleted event,
    Emitter<ContentSyncState> emit,
  ) async {
    try {
      await _automationRepository.delete(id: event.id);
    } on HttpException catch (e) {
      emit(state.copyWith(status: ContentSyncStatus.failure, exception: e));
    }
  }

  @override
  Future<void> close() {
    _automationSubscription.cancel();
    return super.close();
  }
}
