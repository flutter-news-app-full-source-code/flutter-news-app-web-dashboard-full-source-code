import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

part 'content_management_event.dart';
part 'content_management_state.dart';

/// Defines the tabs available in the content management section.
enum ContentManagementTab {
  /// Represents the Headlines tab.
  headlines,

  /// Represents the Topics tab.
  topics,

  /// Represents the Sources tab.
  sources,
}

class ContentManagementBloc
    extends Bloc<ContentManagementEvent, ContentManagementState> {
  ContentManagementBloc({
    required HtDataRepository<Headline> headlinesRepository,
    required HtDataRepository<Topic> topicsRepository,
    required HtDataRepository<Source> sourcesRepository,
  }) : _headlinesRepository = headlinesRepository,
       _topicsRepository = topicsRepository,
       _sourcesRepository = sourcesRepository,
       super(const ContentManagementState()) {
    on<ContentManagementTabChanged>(_onContentManagementTabChanged);
    on<LoadHeadlinesRequested>(_onLoadHeadlinesRequested);
    on<HeadlineUpdated>(_onHeadlineUpdated);
    on<DeleteHeadlineRequested>(_onDeleteHeadlineRequested);
    on<LoadTopicsRequested>(_onLoadTopicsRequested);
    on<TopicUpdated>(_onTopicUpdated);
    on<DeleteTopicRequested>(_onDeleteTopicRequested);
    on<LoadSourcesRequested>(_onLoadSourcesRequested);
    on<SourceUpdated>(_onSourceUpdated);
    on<DeleteSourceRequested>(_onOnDeleteSourceRequested);
  }

  final HtDataRepository<Headline> _headlinesRepository;
  final HtDataRepository<Topic> _topicsRepository;
  final HtDataRepository<Source> _sourcesRepository;

  void _onContentManagementTabChanged(
    ContentManagementTabChanged event,
    Emitter<ContentManagementState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
  }

  Future<void> _onLoadHeadlinesRequested(
    LoadHeadlinesRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(headlinesStatus: ContentManagementStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousHeadlines = isPaginating ? state.headlines : <Headline>[];

      final paginatedHeadlines = await _headlinesRepository.readAll(
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.success,
          headlines: [...previousHeadlines, ...paginatedHeadlines.items],
          headlinesCursor: paginatedHeadlines.cursor,
          headlinesHasMore: paginatedHeadlines.hasMore,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteHeadlineRequested(
    DeleteHeadlineRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      await _headlinesRepository.delete(id: event.id);
      final updatedHeadlines = state.headlines
          .where((h) => h.id != event.id)
          .toList();
      emit(state.copyWith(headlines: updatedHeadlines));
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onHeadlineUpdated(
    HeadlineUpdated event,
    Emitter<ContentManagementState> emit,
  ) {
    final updatedHeadlines = List<Headline>.from(state.headlines);
    final index = updatedHeadlines.indexWhere((h) => h.id == event.headline.id);
    if (index != -1) {
      updatedHeadlines[index] = event.headline;
      emit(state.copyWith(headlines: updatedHeadlines));
    }
  }

  Future<void> _onLoadTopicsRequested(
    LoadTopicsRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(topicsStatus: ContentManagementStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousTopics = isPaginating ? state.topics : <Topic>[];

      final paginatedTopics = await _topicsRepository.readAll(
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          topicsStatus: ContentManagementStatus.success,
          topics: [...previousTopics, ...paginatedTopics.items],
          topicsCursor: paginatedTopics.cursor,
          topicsHasMore: paginatedTopics.hasMore,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          topicsStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          topicsStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteTopicRequested(
    DeleteTopicRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      await _topicsRepository.delete(id: event.id);
      final updatedTopics = state.topics
          .where((c) => c.id != event.id)
          .toList();
      emit(state.copyWith(topics: updatedTopics));
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          topicsStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          topicsStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onTopicUpdated(
    TopicUpdated event,
    Emitter<ContentManagementState> emit,
  ) {
    final updatedTopics = List<Topic>.from(state.topics);
    final index = updatedTopics.indexWhere((t) => t.id == event.topic.id);
    if (index != -1) {
      updatedTopics[index] = event.topic;
      emit(state.copyWith(topics: updatedTopics));
    }
  }

  Future<void> _onLoadSourcesRequested(
    LoadSourcesRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(sourcesStatus: ContentManagementStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousSources = isPaginating ? state.sources : <Source>[];

      final paginatedSources = await _sourcesRepository.readAll(
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.success,
          sources: [...previousSources, ...paginatedSources.items],
          sourcesCursor: paginatedSources.cursor,
          sourcesHasMore: paginatedSources.hasMore,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onOnDeleteSourceRequested(
    DeleteSourceRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      await _sourcesRepository.delete(id: event.id);
      final updatedSources = state.sources
          .where((s) => s.id != event.id)
          .toList();
      emit(state.copyWith(sources: updatedSources));
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onSourceUpdated(
    SourceUpdated event,
    Emitter<ContentManagementState> emit,
  ) {
    final updatedSources = List<Source>.from(state.sources);
    final index = updatedSources.indexWhere((s) => s.id == event.source.id);
    if (index != -1) {
      updatedSources[index] = event.source;
      emit(state.copyWith(sources: updatedSources));
    }
  }
}
