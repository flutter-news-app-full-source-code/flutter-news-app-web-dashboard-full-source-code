import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

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
    required DataRepository<Headline> headlinesRepository,
    required DataRepository<Topic> topicsRepository,
    required DataRepository<Source> sourcesRepository,
    required DataRepository<Country> countriesRepository,
    required DataRepository<Language> languagesRepository,
  }) : _headlinesRepository = headlinesRepository,
       _topicsRepository = topicsRepository,
       _sourcesRepository = sourcesRepository,
       _countriesRepository = countriesRepository,
       _languagesRepository = languagesRepository,
       super(const ContentManagementState()) {
    on<ContentManagementTabChanged>(_onContentManagementTabChanged);
    on<LoadHeadlinesRequested>(_onLoadHeadlinesRequested);
    on<HeadlineUpdated>(_onHeadlineUpdated);
    on<ArchiveHeadlineRequested>(_onArchiveHeadlineRequested);
    on<LoadTopicsRequested>(_onLoadTopicsRequested);
    on<TopicUpdated>(_onTopicUpdated);
    on<ArchiveTopicRequested>(_onArchiveTopicRequested);
    on<LoadSourcesRequested>(_onLoadSourcesRequested);
    on<SourceUpdated>(_onSourceUpdated);
    on<ArchiveSourceRequested>(_onArchiveSourceRequested);
  }

  final DataRepository<Headline> _headlinesRepository;
  final DataRepository<Topic> _topicsRepository;
  final DataRepository<Source> _sourcesRepository;
  final DataRepository<Country> _countriesRepository;
  final DataRepository<Language> _languagesRepository;


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
        filter: {'status': ContentStatus.active.name},
        sort: [const SortOption('updatedAt', SortOrder.desc)],
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
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onArchiveHeadlineRequested(
    ArchiveHeadlineRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    // Optimistically remove the headline from the list
    final originalHeadlines = List<Headline>.from(state.headlines);
    final headlineIndex = originalHeadlines.indexWhere((h) => h.id == event.id);
    if (headlineIndex == -1) return; // Headline not found

    final headlineToArchive = originalHeadlines[headlineIndex];
    final updatedHeadlines = originalHeadlines..removeAt(headlineIndex);

    emit(state.copyWith(headlines: updatedHeadlines));

    try {
      await _headlinesRepository.update(
        id: event.id,
        item: headlineToArchive.copyWith(status: ContentStatus.archived),
      );
    } on HttpException catch (e) {
      // If the update fails, revert the change in the UI
      emit(state.copyWith(headlines: originalHeadlines));
      // And then show the error
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
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
        filter: {'status': ContentStatus.active.name},
        sort: [const SortOption('updatedAt', SortOrder.desc)],
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
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          topicsStatus: ContentManagementStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          topicsStatus: ContentManagementStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onArchiveTopicRequested(
    ArchiveTopicRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    // Optimistically remove the topic from the list
    final originalTopics = List<Topic>.from(state.topics);
    final topicIndex = originalTopics.indexWhere((t) => t.id == event.id);
    if (topicIndex == -1) return; // Topic not found

    final topicToArchive = originalTopics[topicIndex];
    final updatedTopics = originalTopics..removeAt(topicIndex);

    emit(state.copyWith(topics: updatedTopics));

    try {
      await _topicsRepository.update(
        id: event.id,
        item: topicToArchive.copyWith(status: ContentStatus.archived),
      );
    } on HttpException catch (e) {
      // If the update fails, revert the change in the UI
      emit(state.copyWith(topics: originalTopics));
      // And then show the error
      emit(
        state.copyWith(
          topicsStatus: ContentManagementStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          topicsStatus: ContentManagementStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
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
        filter: {'status': ContentStatus.active.name},
        sort: [const SortOption('updatedAt', SortOrder.desc)],
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
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onArchiveSourceRequested(
    ArchiveSourceRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    // Optimistically remove the source from the list
    final originalSources = List<Source>.from(state.sources);
    final sourceIndex = originalSources.indexWhere((s) => s.id == event.id);
    if (sourceIndex == -1) return; // Source not found

    final sourceToArchive = originalSources[sourceIndex];
    final updatedSources = originalSources..removeAt(sourceIndex);

    emit(state.copyWith(sources: updatedSources));

    try {
      await _sourcesRepository.update(
        id: event.id,
        item: sourceToArchive.copyWith(status: ContentStatus.archived),
      );
    } on HttpException catch (e) {
      // If the update fails, revert the change in the UI
      emit(state.copyWith(sources: originalSources));
      // And then show the error
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
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
