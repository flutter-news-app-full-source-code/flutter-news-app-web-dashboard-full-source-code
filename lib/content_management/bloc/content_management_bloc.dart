import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/sources_filter/sources_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/topics_filter/topics_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart';

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
    required HeadlinesFilterBloc headlinesFilterBloc,
    required TopicsFilterBloc topicsFilterBloc,
    required SourcesFilterBloc sourcesFilterBloc,
    required PendingDeletionsService pendingDeletionsService,
  }) : _headlinesRepository = headlinesRepository,
       _topicsRepository = topicsRepository,
       _sourcesRepository = sourcesRepository,
       _headlinesFilterBloc = headlinesFilterBloc,
       _topicsFilterBloc = topicsFilterBloc,
       _sourcesFilterBloc = sourcesFilterBloc,
       _pendingDeletionsService = pendingDeletionsService,
       super(const ContentManagementState()) {
    on<ContentManagementLanguageChanged>(_onLanguageChanged);
    on<ContentManagementTabChanged>(_onContentManagementTabChanged);

    on<LoadHeadlinesRequested>(_onLoadHeadlinesRequested);
    on<ArchiveHeadlineRequested>(_onArchiveHeadlineRequested);
    on<PublishHeadlineRequested>(_onPublishHeadlineRequested);
    on<RestoreHeadlineRequested>(_onRestoreHeadlineRequested);
    on<DeleteHeadlineForeverRequested>(_onDeleteHeadlineForeverRequested);
    on<UndoDeleteHeadlineRequested>(_onUndoDeleteHeadlineRequested);
    on<DeletionEventReceived>(_onDeletionEventReceived);

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
              // Filter will be rebuilt in the handler using the current state and config
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
              // Filter will be rebuilt in the handler
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
              // Filter will be rebuilt in the handler
            ),
          );
        });

    _deletionEventsSubscription = _pendingDeletionsService.deletionEvents
        .listen(
          (event) => add(DeletionEventReceived(event)),
        );
  }

  final DataRepository<Headline> _headlinesRepository;
  final DataRepository<Topic> _topicsRepository;
  final DataRepository<Source> _sourcesRepository;
  final HeadlinesFilterBloc _headlinesFilterBloc;
  final TopicsFilterBloc _topicsFilterBloc;
  final SourcesFilterBloc _sourcesFilterBloc;
  final PendingDeletionsService _pendingDeletionsService;

  late final StreamSubscription<Type> _headlineUpdateSubscription;
  late final StreamSubscription<Type> _topicUpdateSubscription;
  late final StreamSubscription<Type> _sourceUpdateSubscription;
  late final StreamSubscription<DeletionEvent<dynamic>>
  _deletionEventsSubscription;

  @override
  Future<void> close() {
    _headlineUpdateSubscription.cancel();
    _topicUpdateSubscription.cancel();
    _sourceUpdateSubscription.cancel();
    _deletionEventsSubscription.cancel();
    return super.close();
  }

  /// Tracks the current language to ensure filters are built correctly.
  String _currentLanguageCode = 'en';

  Future<void> _onLanguageChanged(
    ContentManagementLanguageChanged event,
    Emitter<ContentManagementState> emit,
  ) async {
    _currentLanguageCode = event.language.name;

    // Clear existing data to prevent showing stale localized strings.
    emit(
      state.copyWith(
        headlines: [],
        topics: [],
        sources: [],
        headlinesStatus: ContentManagementStatus.initial,
        topicsStatus: ContentManagementStatus.initial,
        sourcesStatus: ContentManagementStatus.initial,
      ),
    );

    // Trigger re-fetch for all tabs.
    add(
      const LoadHeadlinesRequested(
        limit: kDefaultRowsPerPage,
        forceRefresh: true,
      ),
    );
    add(
      const LoadTopicsRequested(limit: kDefaultRowsPerPage, forceRefresh: true),
    );
    add(
      const LoadSourcesRequested(
        limit: kDefaultRowsPerPage,
        forceRefresh: true,
      ),
    );
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

      final filter =
          event.filter ??
          _headlinesFilterBloc.buildFilterMap(
            languageCode: _currentLanguageCode,
          );

      final paginatedHeadlines = await _headlinesRepository.readAll(
        filter: filter,
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
    try {
      final headlineToUpdate = state.headlines.firstWhere(
        (h) => h.id == event.id,
      );
      await _headlinesRepository.update(
        id: event.id,
        item: headlineToUpdate.copyWith(status: ContentStatus.archived),
      );
      add(
        const LoadHeadlinesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          // Filter will be rebuilt in the handler
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

  /// Handles the request to publish a draft headline.
  Future<void> _onPublishHeadlineRequested(
    PublishHeadlineRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      final headlineToUpdate = state.headlines.firstWhere(
        (h) => h.id == event.id,
      );
      await _headlinesRepository.update(
        id: event.id,
        item: headlineToUpdate.copyWith(status: ContentStatus.active),
      );
      add(
        const LoadHeadlinesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          // Filter will be rebuilt in the handler
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

  /// Handles the request to restore an archived headline.
  Future<void> _onRestoreHeadlineRequested(
    RestoreHeadlineRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      final headlineToUpdate = state.headlines.firstWhere(
        (h) => h.id == event.id,
      );
      await _headlinesRepository.update(
        id: event.id,
        item: headlineToUpdate.copyWith(status: ContentStatus.active),
      );
      add(
        const LoadHeadlinesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          // Filter will be rebuilt in the handler
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
        itemPendingDeletion: headlineToDelete,
      ),
    );

    _pendingDeletionsService.requestDeletion(
      item: headlineToDelete,
      repository: _headlinesRepository,
      undoDuration: AppConstants.kSnackbarDuration,
      // messageBuilder is omitted, UI will build the message
    );
  }

  /// Handles the request to undo a pending deletion of a headline.
  void _onUndoDeleteHeadlineRequested(
    UndoDeleteHeadlineRequested event,
    Emitter<ContentManagementState> emit,
  ) {
    _pendingDeletionsService.undoDeletion(event.id);
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

      final filter = event.filter ?? _topicsFilterBloc.buildFilterMap();

      final paginatedTopics = await _topicsRepository.readAll(
        filter: filter,
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
    try {
      final topicToUpdate = state.topics.firstWhere((t) => t.id == event.id);
      await _topicsRepository.update(
        id: event.id,
        item: topicToUpdate.copyWith(status: ContentStatus.archived),
      );
      add(
        const LoadTopicsRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          // Filter will be rebuilt in the handler
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

  /// Handles the request to publish a draft topic.
  Future<void> _onPublishTopicRequested(
    PublishTopicRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      final topicToUpdate = state.topics.firstWhere((t) => t.id == event.id);
      await _topicsRepository.update(
        id: event.id,
        item: topicToUpdate.copyWith(status: ContentStatus.active),
      );
      add(
        const LoadTopicsRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          // Filter will be rebuilt in the handler
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

  /// Handles the request to restore an archived topic.
  Future<void> _onRestoreTopicRequested(
    RestoreTopicRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      final topicToUpdate = state.topics.firstWhere((t) => t.id == event.id);
      await _topicsRepository.update(
        id: event.id,
        item: topicToUpdate.copyWith(status: ContentStatus.active),
      );
      add(
        const LoadTopicsRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          // Filter will be rebuilt in the handler
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
        itemPendingDeletion: topicToDelete,
      ),
    );

    _pendingDeletionsService.requestDeletion(
      item: topicToDelete,
      repository: _topicsRepository,
      undoDuration: AppConstants.kSnackbarDuration,
      // messageBuilder is omitted, UI will build the message
    );
  }

  /// Handles the request to undo a pending deletion of a topic.
  void _onUndoDeleteTopicRequested(
    UndoDeleteTopicRequested event,
    Emitter<ContentManagementState> emit,
  ) {
    _pendingDeletionsService.undoDeletion(event.id);
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

      final filter = event.filter ?? _sourcesFilterBloc.buildFilterMap();

      final paginatedSources = await _sourcesRepository.readAll(
        filter: filter,
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
    try {
      final sourceToUpdate = state.sources.firstWhere((s) => s.id == event.id);
      await _sourcesRepository.update(
        id: event.id,
        item: sourceToUpdate.copyWith(status: ContentStatus.archived),
      );
      add(
        const LoadSourcesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          // Filter will be rebuilt in the handler
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

  /// Handles the request to publish a draft source.
  Future<void> _onPublishSourceRequested(
    PublishSourceRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      final sourceToUpdate = state.sources.firstWhere((s) => s.id == event.id);
      await _sourcesRepository.update(
        id: event.id,
        item: sourceToUpdate.copyWith(status: ContentStatus.active),
      );
      add(
        const LoadSourcesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          // Filter will be rebuilt in the handler
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

  /// Handles the request to restore an archived source.
  Future<void> _onRestoreSourceRequested(
    RestoreSourceRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      final sourceToUpdate = state.sources.firstWhere((s) => s.id == event.id);
      await _sourcesRepository.update(
        id: event.id,
        item: sourceToUpdate.copyWith(status: ContentStatus.active),
      );
      add(
        const LoadSourcesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          // Filter will be rebuilt in the handler
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
        itemPendingDeletion: sourceToDelete,
      ),
    );

    _pendingDeletionsService.requestDeletion(
      item: sourceToDelete,
      repository: _sourcesRepository,
      undoDuration: AppConstants.kSnackbarDuration,
      // messageBuilder is omitted, UI will build the message
    );
  }

  /// Handles the request to undo a pending deletion of a source.
  void _onUndoDeleteSourceRequested(
    UndoDeleteSourceRequested event,
    Emitter<ContentManagementState> emit,
  ) {
    _pendingDeletionsService.undoDeletion(event.id);
  }

  /// Handles deletion events from the [PendingDeletionsService].
  ///
  /// This method is responsible for updating the BLoC state based on whether
  /// a deletion was confirmed or undone.
  Future<void> _onDeletionEventReceived(
    DeletionEventReceived event,
    Emitter<ContentManagementState> emit,
  ) async {
    switch (event.event.status) {
      case DeletionStatus.requested:
        // This case is now handled by the optimistic UI update in the
        // specific delete handlers (e.g., _onDeleteHeadlineForeverRequested).
        // The itemPendingDeletion is set there, which the UI uses to build
        // the snackbar message.
        break;
      case DeletionStatus.confirmed:
        // If deletion is confirmed, clear pending status.
        // The item was already optimistically removed from the list.
        emit(
          state.copyWith(
            lastPendingDeletionId: null, // Clear the pending ID
            // Clear the item so the snackbar doesn't reappear on rebuilds
            itemPendingDeletion: null,
          ),
        );
      case DeletionStatus.undone:
        // If deletion is undone, re-add the item to the appropriate list.
        final item = event.event.item;
        if (item is Headline) {
          final updatedHeadlines = List<Headline>.from(state.headlines)
            ..add(item)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          emit(
            state.copyWith(
              headlines: updatedHeadlines,
              lastPendingDeletionId: null, // Clear the pending ID
              itemPendingDeletion: null,
            ),
          );
        } else if (item is Topic) {
          final updatedTopics = List<Topic>.from(state.topics)
            ..add(item)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          emit(
            state.copyWith(
              topics: updatedTopics,
              lastPendingDeletionId: null, // Clear the pending ID
              itemPendingDeletion: null,
            ),
          );
        } else if (item is Source) {
          final updatedSources = List<Source>.from(state.sources)
            ..add(item)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          emit(
            state.copyWith(
              sources: updatedSources,
              lastPendingDeletionId: null, // Clear the pending ID
              itemPendingDeletion: null,
            ),
          );
        }
    }
  }
}
