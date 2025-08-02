import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'archived_content_event.dart';
part 'archived_content_state.dart';

class ArchivedContentBloc
    extends Bloc<ArchivedContentEvent, ArchivedContentState> {
  ArchivedContentBloc({
    required DataRepository<Headline> headlinesRepository,
    required DataRepository<Topic> topicsRepository,
    required DataRepository<Source> sourcesRepository,
  })  : _headlinesRepository = headlinesRepository,
        _topicsRepository = topicsRepository,
        _sourcesRepository = sourcesRepository,
        super(const ArchivedContentState()) {
    on<ArchivedContentTabChanged>(_onArchivedContentTabChanged);
    on<LoadArchivedHeadlinesRequested>(_onLoadArchivedHeadlinesRequested);
    on<RestoreHeadlineRequested>(_onRestoreHeadlineRequested);
    on<DeleteHeadlineForeverRequested>(_onDeleteHeadlineForeverRequested);
    on<LoadArchivedTopicsRequested>(_onLoadArchivedTopicsRequested);
    on<RestoreTopicRequested>(_onRestoreTopicRequested);
    on<LoadArchivedSourcesRequested>(_onLoadArchivedSourcesRequested);
    on<RestoreSourceRequested>(_onRestoreSourceRequested);
  }

  final DataRepository<Headline> _headlinesRepository;
  final DataRepository<Topic> _topicsRepository;
  final DataRepository<Source> _sourcesRepository;

  void _onArchivedContentTabChanged(
    ArchivedContentTabChanged event,
    Emitter<ArchivedContentState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
  }

  Future<void> _onLoadArchivedHeadlinesRequested(
    LoadArchivedHeadlinesRequested event,
    Emitter<ArchivedContentState> emit,
  ) async {
    emit(state.copyWith(headlinesStatus: ArchivedContentStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousHeadlines = isPaginating ? state.headlines : <Headline>[];

      final paginatedHeadlines = await _headlinesRepository.readAll(
        filter: {'status': ContentStatus.archived.name},
        sort: [const SortOption('updatedAt', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          headlinesStatus: ArchivedContentStatus.success,
          headlines: [...previousHeadlines, ...paginatedHeadlines.items],
          headlinesCursor: paginatedHeadlines.cursor,
          headlinesHasMore: paginatedHeadlines.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ArchivedContentStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ArchivedContentStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onRestoreHeadlineRequested(
    RestoreHeadlineRequested event,
    Emitter<ArchivedContentState> emit,
  ) async {
    final originalHeadlines = List<Headline>.from(state.headlines);
    final headlineIndex = originalHeadlines.indexWhere((h) => h.id == event.id);
    if (headlineIndex == -1) return;

    final headlineToRestore = originalHeadlines[headlineIndex];
    final updatedHeadlines = originalHeadlines..removeAt(headlineIndex);

    emit(state.copyWith(headlines: updatedHeadlines));

    try {
      await _headlinesRepository.update(
        id: event.id,
        item: headlineToRestore.copyWith(status: ContentStatus.active),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(headlines: originalHeadlines, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          headlines: originalHeadlines,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onDeleteHeadlineForeverRequested(
    DeleteHeadlineForeverRequested event,
    Emitter<ArchivedContentState> emit,
  ) async {
    final originalHeadlines = List<Headline>.from(state.headlines);
    final headlineIndex = originalHeadlines.indexWhere((h) => h.id == event.id);
    if (headlineIndex == -1) return;

    final updatedHeadlines = originalHeadlines..removeAt(headlineIndex);
    emit(state.copyWith(headlines: updatedHeadlines));

    try {
      await _headlinesRepository.delete(id: event.id);
    } on HttpException catch (e) {
      emit(state.copyWith(headlines: originalHeadlines, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          headlines: originalHeadlines,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onLoadArchivedTopicsRequested(
    LoadArchivedTopicsRequested event,
    Emitter<ArchivedContentState> emit,
  ) async {
    emit(state.copyWith(topicsStatus: ArchivedContentStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousTopics = isPaginating ? state.topics : <Topic>[];

      final paginatedTopics = await _topicsRepository.readAll(
        filter: {'status': ContentStatus.archived.name},
        sort: [const SortOption('updatedAt', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          topicsStatus: ArchivedContentStatus.success,
          topics: [...previousTopics, ...paginatedTopics.items],
          topicsCursor: paginatedTopics.cursor,
          topicsHasMore: paginatedTopics.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          topicsStatus: ArchivedContentStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          topicsStatus: ArchivedContentStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onRestoreTopicRequested(
    RestoreTopicRequested event,
    Emitter<ArchivedContentState> emit,
  ) async {
    final originalTopics = List<Topic>.from(state.topics);
    final topicIndex = originalTopics.indexWhere((t) => t.id == event.id);
    if (topicIndex == -1) return;

    final topicToRestore = originalTopics[topicIndex];
    final updatedTopics = originalTopics..removeAt(topicIndex);

    emit(state.copyWith(topics: updatedTopics));

    try {
      await _topicsRepository.update(
        id: event.id,
        item: topicToRestore.copyWith(status: ContentStatus.active),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(topics: originalTopics, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          topics: originalTopics,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onLoadArchivedSourcesRequested(
    LoadArchivedSourcesRequested event,
    Emitter<ArchivedContentState> emit,
  ) async {
    emit(state.copyWith(sourcesStatus: ArchivedContentStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousSources = isPaginating ? state.sources : <Source>[];

      final paginatedSources = await _sourcesRepository.readAll(
        filter: {'status': ContentStatus.archived.name},
        sort: [const SortOption('updatedAt', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          sourcesStatus: ArchivedContentStatus.success,
          sources: [...previousSources, ...paginatedSources.items],
          sourcesCursor: paginatedSources.cursor,
          sourcesHasMore: paginatedSources.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ArchivedContentStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ArchivedContentStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onRestoreSourceRequested(
    RestoreSourceRequested event,
    Emitter<ArchivedContentState> emit,
  ) async {
    final originalSources = List<Source>.from(state.sources);
    final sourceIndex = originalSources.indexWhere((s) => s.id == event.id);
    if (sourceIndex == -1) return;

    final sourceToRestore = originalSources[sourceIndex];
    final updatedSources = originalSources..removeAt(sourceIndex);

    emit(state.copyWith(sources: updatedSources));

    try {
      await _sourcesRepository.update(
        id: event.id,
        item: sourceToRestore.copyWith(status: ContentStatus.active),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(sources: originalSources, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          sources: originalSources,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
