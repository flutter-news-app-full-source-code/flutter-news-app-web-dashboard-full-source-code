import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/sources_filter/sources_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/topics_filter/topics_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart';
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
            LoadHeadlinesRequested(
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
              filter: buildHeadlinesFilterMap(_headlinesFilterBloc.state),
            ),
          );
        });

    _topicUpdateSubscription = _topicsRepository.entityUpdated
        .where((type) => type == Topic)
        .listen((_) {
          add(
            LoadTopicsRequested(
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
              filter: buildTopicsFilterMap(_topicsFilterBloc.state),
            ),
          );
        });

    _sourceUpdateSubscription = _sourcesRepository.entityUpdated
        .where((type) => type == Source)
        .listen((_) {
          add(
            LoadSourcesRequested(
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
              filter: buildSourcesFilterMap(_sourcesFilterBloc.state),
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

  /// Builds a filter map for headlines from the given filter state.
  Map<String, dynamic> buildHeadlinesFilterMap(HeadlinesFilterState state) {
    final filter = <String, dynamic>{};

    if (state.searchQuery.isNotEmpty) {
      filter['title'] = {r'$regex': state.searchQuery, r'$options': 'i'};
    }

    filter['status'] = state.selectedStatus.name;

    if (state.selectedSourceIds.isNotEmpty) {
      filter['source.id'] = {r'$in': state.selectedSourceIds};
    }
    if (state.selectedTopicIds.isNotEmpty) {
      filter['topic.id'] = {r'$in': state.selectedTopicIds};
    }
    if (state.selectedCountryIds.isNotEmpty) {
      filter['eventCountry.id'] = {r'$in': state.selectedCountryIds};
    }

    if (state.isBreaking != null) {
      filter['isBreaking'] = state.isBreaking;
    }

    return filter;
  }

  /// Builds a filter map for topics from the given filter state.
  Map<String, dynamic> buildTopicsFilterMap(TopicsFilterState state) {
    final filter = <String, dynamic>{};

    if (state.searchQuery.isNotEmpty) {
      filter['name'] = {r'$regex': state.searchQuery, r'$options': 'i'};
    }

    filter['status'] = state.selectedStatus.name;

    return filter;
  }

  /// Builds a filter map for sources from the given filter state.
  Map<String, dynamic> buildSourcesFilterMap(SourcesFilterState state) {
    final filter = <String, dynamic>{};

    if (state.searchQuery.isNotEmpty) {
      filter['name'] = {r'$regex': state.searchQuery, r'$options': 'i'};
    }

    filter['status'] = state.selectedStatus.name;

    if (state.selectedSourceTypes.isNotEmpty) {
      filter['sourceType'] = {
        r'$in': state.selectedSourceTypes.map((s) => s.name).toList(),
      };
    }
    if (state.selectedLanguageCodes.isNotEmpty) {
      filter['language.code'] = {r'$in': state.selectedLanguageCodes};
    }
    if (state.selectedHeadquartersCountryIds.isNotEmpty) {
      filter['headquarters.id'] = {
        r'$in': state.selectedHeadquartersCountryIds,
      };
    }

    return filter;
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
        filter:
            event.filter ?? buildHeadlinesFilterMap(_headlinesFilterBloc.state),
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
        LoadHeadlinesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildHeadlinesFilterMap(_headlinesFilterBloc.state),
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
        LoadHeadlinesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildHeadlinesFilterMap(_headlinesFilterBloc.state),
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
        LoadHeadlinesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildHeadlinesFilterMap(_headlinesFilterBloc.state),
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
        snackbarMessage: 'Headline "${headlineToDelete.title}" deleted.',
      ),
    );

    _pendingDeletionsService.requestDeletion(
      item: headlineToDelete,
      repository: _headlinesRepository,
      undoDuration: AppConstants.kSnackbarDuration,
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

      final paginatedTopics = await _topicsRepository.readAll(
        filter: event.filter ?? buildTopicsFilterMap(_topicsFilterBloc.state),
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
        LoadTopicsRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildTopicsFilterMap(_topicsFilterBloc.state),
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
        LoadTopicsRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildTopicsFilterMap(_topicsFilterBloc.state),
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
        LoadTopicsRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildTopicsFilterMap(_topicsFilterBloc.state),
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
        snackbarMessage: 'Topic "${topicToDelete.name}" deleted.',
      ),
    );

    _pendingDeletionsService.requestDeletion(
      item: topicToDelete,
      repository: _topicsRepository,
      undoDuration: AppConstants.kSnackbarDuration,
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

      final paginatedSources = await _sourcesRepository.readAll(
        filter: event.filter ?? buildSourcesFilterMap(_sourcesFilterBloc.state),
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
        LoadSourcesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildSourcesFilterMap(_sourcesFilterBloc.state),
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
        LoadSourcesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildSourcesFilterMap(_sourcesFilterBloc.state),
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
        LoadSourcesRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildSourcesFilterMap(_sourcesFilterBloc.state),
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
        snackbarMessage: 'Source "${sourceToDelete.name}" deleted.',
      ),
    );

    _pendingDeletionsService.requestDeletion(
      item: sourceToDelete,
      repository: _sourcesRepository,
      undoDuration: AppConstants.kSnackbarDuration,
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
      case DeletionStatus.confirmed:
        // If deletion is confirmed, clear pending status.
        // The item was already optimistically removed from the list.
        emit(
          state.copyWith(
            lastPendingDeletionId: null,
            snackbarMessage: null,
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
              lastPendingDeletionId: null,
              snackbarMessage: null,
            ),
          );
        } else if (item is Topic) {
          final updatedTopics = List<Topic>.from(state.topics)
            ..add(item)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          emit(
            state.copyWith(
              topics: updatedTopics,
              lastPendingDeletionId: null,
              snackbarMessage: null,
            ),
          );
        } else if (item is Source) {
          final updatedSources = List<Source>.from(state.sources)
            ..add(item)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          emit(
            state.copyWith(
              sources: updatedSources,
              lastPendingDeletionId: null,
              snackbarMessage: null,
            ),
          );
        }
    }
  }
}
