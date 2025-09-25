import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:ui_kit/ui_kit.dart';

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
  }) : _headlinesRepository = headlinesRepository,
       _topicsRepository = topicsRepository,
       _sourcesRepository = sourcesRepository,
       super(const ContentManagementState()) {
    on<ContentManagementTabChanged>(_onContentManagementTabChanged);
    on<LoadHeadlinesRequested>(_onLoadHeadlinesRequested);
    on<ArchiveHeadlineRequested>(_onArchiveHeadlineRequested);
    on<PublishHeadlineRequested>(_onPublishHeadlineRequested);
    on<RestoreHeadlineRequested>(_onRestoreHeadlineRequested);
    on<DeleteHeadlineForeverRequested>(_onDeleteHeadlineForeverRequested);
    on<UndoDeleteHeadlineRequested>(_onUndoDeleteHeadlineRequested);

    on<LoadTopicsRequested>(_onLoadTopicsRequested);
    on<ArchiveTopicRequested>(_onArchiveTopicRequested);
    on<PublishTopicRequested>(_onPublishTopicRequested);
    on<RestoreTopicRequested>(_onRestoreTopicRequested);
    on<DeleteTopicForeverRequested>(_onDeleteTopicForeverRequested);
    on<UndoDeleteTopicRequested>(_onUndoDeleteTopicRequested);

    on<LoadSourcesRequested>(_onLoadSourcesRequested);
    on<ArchiveSourceRequested>(_onArchiveSourceRequested);
    on<PublishSourceRequested>(_onPublishSourceRequested);
    on<RestoreSourceRequested>(_onRestoreSourceRequested);
    on<DeleteSourceForeverRequested>(_onDeleteSourceForeverRequested);
    on<UndoDeleteSourceRequested>(_onUndoDeleteSourceRequested);

    _headlineUpdateSubscription = _headlinesRepository.entityUpdated
        .where((type) => type == Headline)
        .listen((_) {
          add(
            const LoadHeadlinesRequested(
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
            ),
          );
        });

    _topicUpdateSubscription = _topicsRepository.entityUpdated
        .where((type) => type == Topic)
        .listen((_) {
          add(
            const LoadTopicsRequested(
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
            ),
          );
        });

    _sourceUpdateSubscription = _sourcesRepository.entityUpdated
        .where((type) => type == Source)
        .listen((_) {
          add(
            const LoadSourcesRequested(
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
            ),
          );
        });
  }

  final DataRepository<Headline> _headlinesRepository;
  final DataRepository<Topic> _topicsRepository;
  final DataRepository<Source> _sourcesRepository;

  late final StreamSubscription<Type> _headlineUpdateSubscription;
  late final StreamSubscription<Type> _topicUpdateSubscription;
  late final StreamSubscription<Type> _sourceUpdateSubscription;

  @override
  Future<void> close() {
    _headlineUpdateSubscription.cancel();
    _topicUpdateSubscription.cancel();
    _sourceUpdateSubscription.cancel();
    return super.close();
  }

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
    // If headlines are already loaded and it's not a pagination request,
    // do not re-fetch unless forceRefresh is true or a filter is applied.
    if (state.headlinesStatus == ContentManagementStatus.success &&
        state.headlines.isNotEmpty &&
        event.startAfterId == null &&
        !event.forceRefresh &&
        event.filter == null) {
      return;
    }

    emit(state.copyWith(headlinesStatus: ContentManagementStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousHeadlines = isPaginating ? state.headlines : <Headline>[];

      final paginatedHeadlines = await _headlinesRepository.readAll(
        filter: event.filter, // Use the provided filter
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
    if (headlineIndex == -1) return;

    final headlineToArchive = originalHeadlines[headlineIndex];
    final updatedHeadlines = originalHeadlines..removeAt(headlineIndex);

    emit(state.copyWith(headlines: updatedHeadlines));

    try {
      await _headlinesRepository.update(
        id: event.id,
        item: headlineToArchive.copyWith(status: ContentStatus.archived),
      );
      // No need to re-fetch, the entityUpdated stream will trigger a refresh
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

  /// Handles the request to publish a draft headline.
  Future<void> _onPublishHeadlineRequested(
    PublishHeadlineRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    final originalHeadlines = List<Headline>.from(state.headlines);
    final headlineIndex = originalHeadlines.indexWhere((h) => h.id == event.id);
    if (headlineIndex == -1) return;

    final headlineToPublish = originalHeadlines[headlineIndex];
    final updatedHeadlines = originalHeadlines..removeAt(headlineIndex);

    emit(state.copyWith(headlines: updatedHeadlines));

    try {
      await _headlinesRepository.update(
        id: event.id,
        item: headlineToPublish.copyWith(status: ContentStatus.active),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(headlines: originalHeadlines));
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

  /// Handles the request to restore an archived headline.
  Future<void> _onRestoreHeadlineRequested(
    RestoreHeadlineRequested event,
    Emitter<ContentManagementState> emit,
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
      emit(state.copyWith(headlines: originalHeadlines));
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

  /// Handles the request to permanently delete a headline.
  Future<void> _onDeleteHeadlineForeverRequested(
    DeleteHeadlineForeverRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    final headlineToDelete = state.headlines.firstWhere(
      (h) => h.id == event.id,
    );

    final updatedHeadlines = List<Headline>.from(state.headlines)
      ..removeWhere((h) => h.id == event.id);

    emit(
      state.copyWith(
        headlines: updatedHeadlines,
        lastPendingDeletionId: event.id,
        snackbarMessage: 'Headline "${headlineToDelete.title}" deleted.',
      ),
    );

    // Simulate pending deletion with undo option
    Future.delayed(const Duration(seconds: 5), () {
      if (state.lastPendingDeletionId == event.id) {
        // ignore: inference_failure_on_untyped_parameter
        _headlinesRepository.delete(id: event.id).catchError((e) {
          // Handle error if actual deletion fails after undo period
          emit(
            state.copyWith(
              headlinesStatus: ContentManagementStatus.failure,
              exception: e is HttpException
                  ? e
                  : UnknownException('Failed to delete headline: $e'),
            ),
          );
        });
        emit(
          state.copyWith(lastPendingDeletionId: null, snackbarMessage: null),
        );
      }
    });
  }

  /// Handles the request to undo a pending deletion of a headline.
  void _onUndoDeleteHeadlineRequested(
    UndoDeleteHeadlineRequested event,
    Emitter<ContentManagementState> emit,
  ) {
    // Find the headline that was optimistically removed
    // This would typically involve storing the removed item temporarily
    // For now, we'll just clear the pending deletion status
    emit(state.copyWith(lastPendingDeletionId: null, snackbarMessage: null));
    // A real implementation would re-add the item to the list here
    // and cancel the actual deletion.
  }

  Future<void> _onLoadTopicsRequested(
    LoadTopicsRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    // If topics are already loaded and it's not a pagination request,
    // do not re-fetch unless forceRefresh is true or a filter is applied.
    if (state.topicsStatus == ContentManagementStatus.success &&
        state.topics.isNotEmpty &&
        event.startAfterId == null &&
        !event.forceRefresh &&
        event.filter == null) {
      return;
    }

    emit(state.copyWith(topicsStatus: ContentManagementStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousTopics = isPaginating ? state.topics : <Topic>[];

      final paginatedTopics = await _topicsRepository.readAll(
        filter: event.filter, // Use the provided filter
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
    if (topicIndex == -1) return;

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

  /// Handles the request to publish a draft topic.
  Future<void> _onPublishTopicRequested(
    PublishTopicRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    final originalTopics = List<Topic>.from(state.topics);
    final topicIndex = originalTopics.indexWhere((t) => t.id == event.id);
    if (topicIndex == -1) return;

    final topicToPublish = originalTopics[topicIndex];
    final updatedTopics = originalTopics..removeAt(topicIndex);

    emit(state.copyWith(topics: updatedTopics));

    try {
      await _topicsRepository.update(
        id: event.id,
        item: topicToPublish.copyWith(status: ContentStatus.active),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(topics: originalTopics));
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

  /// Handles the request to restore an archived topic.
  Future<void> _onRestoreTopicRequested(
    RestoreTopicRequested event,
    Emitter<ContentManagementState> emit,
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
      emit(state.copyWith(topics: originalTopics));
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

  /// Handles the request to permanently delete a topic.
  Future<void> _onDeleteTopicForeverRequested(
    DeleteTopicForeverRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    final topicToDelete = state.topics.firstWhere(
      (t) => t.id == event.id,
    );

    final updatedTopics = List<Topic>.from(state.topics)
      ..removeWhere((t) => t.id == event.id);

    emit(
      state.copyWith(
        topics: updatedTopics,
        lastPendingDeletionId: event.id,
        snackbarMessage: 'Topic "${topicToDelete.name}" deleted.',
      ),
    );

    // Simulate pending deletion with undo option
    Future.delayed(const Duration(seconds: 5), () {
      if (state.lastPendingDeletionId == event.id) {
        // ignore: inference_failure_on_untyped_parameter
        _topicsRepository.delete(id: event.id).catchError((e) {
          // Handle error if actual deletion fails after undo period
          emit(
            state.copyWith(
              topicsStatus: ContentManagementStatus.failure,
              exception: e is HttpException
                  ? e
                  : UnknownException('Failed to delete topic: $e'),
            ),
          );
        });
        emit(
          state.copyWith(lastPendingDeletionId: null, snackbarMessage: null),
        );
      }
    });
  }

  /// Handles the request to undo a pending deletion of a topic.
  void _onUndoDeleteTopicRequested(
    UndoDeleteTopicRequested event,
    Emitter<ContentManagementState> emit,
  ) {
    emit(state.copyWith(lastPendingDeletionId: null, snackbarMessage: null));
  }

  Future<void> _onLoadSourcesRequested(
    LoadSourcesRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    // If sources are already loaded and it's not a pagination request,
    // do not re-fetch unless forceRefresh is true or a filter is applied.
    if (state.sourcesStatus == ContentManagementStatus.success &&
        state.sources.isNotEmpty &&
        event.startAfterId == null &&
        !event.forceRefresh &&
        event.filter == null) {
      return;
    }

    emit(state.copyWith(sourcesStatus: ContentManagementStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousSources = isPaginating ? state.sources : <Source>[];

      final paginatedSources = await _sourcesRepository.readAll(
        filter: event.filter, // Use the provided filter
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
    if (sourceIndex == -1) return;

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

  /// Handles the request to publish a draft source.
  Future<void> _onPublishSourceRequested(
    PublishSourceRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    final originalSources = List<Source>.from(state.sources);
    final sourceIndex = originalSources.indexWhere((s) => s.id == event.id);
    if (sourceIndex == -1) return;

    final sourceToPublish = originalSources[sourceIndex];
    final updatedSources = originalSources..removeAt(sourceIndex);

    emit(state.copyWith(sources: updatedSources));

    try {
      await _sourcesRepository.update(
        id: event.id,
        item: sourceToPublish.copyWith(status: ContentStatus.active),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(sources: originalSources));
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

  /// Handles the request to restore an archived source.
  Future<void> _onRestoreSourceRequested(
    RestoreSourceRequested event,
    Emitter<ContentManagementState> emit,
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
      emit(state.copyWith(sources: originalSources));
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

  /// Handles the request to permanently delete a source.
  Future<void> _onDeleteSourceForeverRequested(
    DeleteSourceForeverRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    final sourceToDelete = state.sources.firstWhere(
      (s) => s.id == event.id,
    );

    final updatedSources = List<Source>.from(state.sources)
      ..removeWhere((s) => s.id == event.id);

    emit(
      state.copyWith(
        sources: updatedSources,
        lastPendingDeletionId: event.id,
        snackbarMessage: 'Source "${sourceToDelete.name}" deleted.',
      ),
    );

    // Simulate pending deletion with undo option
    Future.delayed(const Duration(seconds: 5), () {
      if (state.lastPendingDeletionId == event.id) {
        // ignore: inference_failure_on_untyped_parameter
        _sourcesRepository.delete(id: event.id).catchError((e) {
          // Handle error if actual deletion fails after undo period
          emit(
            state.copyWith(
              sourcesStatus: ContentManagementStatus.failure,
              exception: e is HttpException
                  ? e
                  : UnknownException('Failed to delete source: $e'),
            ),
          );
        });
        emit(
          state.copyWith(lastPendingDeletionId: null, snackbarMessage: null),
        );
      }
    });
  }

  /// Handles the request to undo a pending deletion of a source.
  void _onUndoDeleteSourceRequested(
    UndoDeleteSourceRequested event,
    Emitter<ContentManagementState> emit,
  ) {
    emit(state.copyWith(lastPendingDeletionId: null, snackbarMessage: null));
  }
}
