import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart';

part 'draft_topics_event.dart';
part 'draft_topics_state.dart';

/// {@template draft_topics_bloc}
/// A BLoC responsible for managing the state of draft topics.
///
/// It handles loading, publishing, and permanently deleting draft topics,
/// including a temporary "undo" period for deletions.
/// {@endtemplate}
class DraftTopicsBloc extends Bloc<DraftTopicsEvent, DraftTopicsState> {
  /// {@macro draft_topics_bloc}
  DraftTopicsBloc({
    required DataRepository<Topic> topicsRepository,
    required PendingDeletionsService pendingDeletionsService,
  }) : _topicsRepository = topicsRepository,
       _pendingDeletionsService = pendingDeletionsService,
       super(const DraftTopicsState()) {
    on<LoadDraftTopicsRequested>(_onLoadDraftTopicsRequested);
    on<PublishDraftTopicRequested>(_onPublishDraftTopicRequested);
    on<_DeletionServiceStatusChanged>(
      _onDeletionServiceStatusChanged,
    );
    on<DeleteDraftTopicForeverRequested>(
      _onDeleteDraftTopicForeverRequested,
    );
    on<UndoDeleteDraftTopicRequested>(_onUndoDeleteDraftTopicRequested);
    on<ClearPublishedTopic>(_onClearPublishedTopic);

    // Listen to deletion events from the PendingDeletionsService.
    // The filter now correctly checks the type of the item in the event.
    _deletionEventSubscription = _pendingDeletionsService.deletionEvents.listen(
      (event) {
        if (event.item is Topic) {
          add(_DeletionServiceStatusChanged(event));
        }
      },
    );
  }

  final DataRepository<Topic> _topicsRepository;
  final PendingDeletionsService _pendingDeletionsService;

  /// Subscription to deletion events from the PendingDeletionsService.
  late final StreamSubscription<DeletionEvent<dynamic>>
  _deletionEventSubscription;

  @override
  Future<void> close() async {
    // Cancel the subscription to deletion events to prevent memory leaks.
    await _deletionEventSubscription.cancel();
    return super.close();
  }

  /// Handles the request to load draft topics.
  ///
  /// Fetches paginated draft topics from the repository and updates the state.
  Future<void> _onLoadDraftTopicsRequested(
    LoadDraftTopicsRequested event,
    Emitter<DraftTopicsState> emit,
  ) async {
    emit(state.copyWith(status: DraftTopicsStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousTopics = isPaginating ? state.topics : <Topic>[];

      final paginatedTopics = await _topicsRepository.readAll(
        filter: {'status': ContentStatus.draft.name},
        sort: [const SortOption('updatedAt', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          status: DraftTopicsStatus.success,
          topics: [...previousTopics, ...paginatedTopics.items],
          cursor: paginatedTopics.cursor,
          hasMore: paginatedTopics.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: DraftTopicsStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DraftTopicsStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles the request to publish a draft topic.
  ///
  /// Optimistically removes the topic from the UI, updates its status to active
  /// in the repository, and then updates the state. If the topic was pending
  /// deletion, its pending deletion is cancelled.
  Future<void> _onPublishDraftTopicRequested(
    PublishDraftTopicRequested event,
    Emitter<DraftTopicsState> emit,
  ) async {
    final originalTopics = state.topics;
    final topicIndex = originalTopics.indexWhere((t) => t.id == event.id);
    if (topicIndex == -1) return;
    final topicToPublish = originalTopics[topicIndex];
    final updatedTopics = List<Topic>.from(originalTopics)
      ..removeAt(topicIndex);
      
    // Optimistically remove the topic from the UI.
    emit(
      state.copyWith(
        topics: updatedTopics,
        lastPendingDeletionId: state.lastPendingDeletionId == event.id
            ? null
            : state.lastPendingDeletionId,
        snackbarTopicTitle: null,
      ),
    );

    try {
      final publishedTopic = await _topicsRepository.update(
        id: event.id,
        item: topicToPublish.copyWith(status: ContentStatus.active),
      );
      emit(state.copyWith(publishedTopic: publishedTopic));
    } on HttpException catch (e) {
      // If the update fails, revert the change in the UI
      emit(
        state.copyWith(
          topics: originalTopics,
          exception: e,
          lastPendingDeletionId: state.lastPendingDeletionId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          topics: originalTopics,
          exception: UnknownException('An unexpected error occurred: $e'),
          lastPendingDeletionId: state.lastPendingDeletionId,
        ),
      );
    }
  }

  /// Handles deletion events from the [PendingDeletionsService].
  ///
  /// This method is called when an item's deletion is confirmed or undone
  /// by the service. It updates the BLoC's state accordingly.
  Future<void> _onDeletionServiceStatusChanged(
    _DeletionServiceStatusChanged event,
    Emitter<DraftTopicsState> emit,
  ) async {
    final id = event.event.id;
    final status = event.event.status;
    final item = event.event.item;

    if (status == DeletionStatus.confirmed) {
      // Deletion confirmed, no action needed in BLoC as it was optimistically removed.
      // Ensure lastPendingDeletionId and snackbarTopicTitle are cleared if this was the one.
      emit(
        state.copyWith(
          lastPendingDeletionId: state.lastPendingDeletionId == id
              ? null
              : state.lastPendingDeletionId,
          snackbarTopicTitle: null,
        ),
      );
    } else if (status == DeletionStatus.undone) {
      // Deletion undone, restore the topic to the main list.
      if (item is Topic) {
        final insertionIndex = state.topics.indexWhere(
          (t) => t.updatedAt.isBefore(item.updatedAt),
        );
        final updatedTopics = List<Topic>.from(state.topics)
          ..insert(
            insertionIndex != -1 ? insertionIndex : state.topics.length,
            item,
          );
        emit(
          state.copyWith(
            topics: updatedTopics,
            lastPendingDeletionId: state.lastPendingDeletionId == id
                ? null
                : state.lastPendingDeletionId,
            snackbarTopicTitle: null,
          ),
        );
      }
    }
  }

  /// Handles the request to permanently delete a draft topic.
  ///
  /// This optimistically removes the topic from the UI and initiates a
  /// timed deletion via the [PendingDeletionsService].
  Future<void> _onDeleteDraftTopicForeverRequested(
    DeleteDraftTopicForeverRequested event,
    Emitter<DraftTopicsState> emit,
  ) async {
    final topicToDelete = state.topics.firstWhere(
      (t) => t.id == event.id,
    );

    // Optimistically remove the topic from the UI.
    final updatedTopics = List<Topic>.from(state.topics)
      ..removeWhere((t) => t.id == event.id);

    emit(
      state.copyWith(
        topics: updatedTopics,
        lastPendingDeletionId: event.id,
        snackbarTopicTitle: topicToDelete.name,
      ),
    );

    // Request deletion via the service.
    _pendingDeletionsService.requestDeletion(
      item: topicToDelete,
      repository: _topicsRepository,
      undoDuration: const Duration(seconds: 5),
    );
  }

  /// Handles the request to undo a pending deletion of a draft topic.
  ///
  /// This cancels the deletion timer in the [PendingDeletionsService].
  Future<void> _onUndoDeleteDraftTopicRequested(
    UndoDeleteDraftTopicRequested event,
    Emitter<DraftTopicsState> emit,
  ) async {
    _pendingDeletionsService.undoDeletion(event.id);
    // The _onDeletionServiceStatusChanged will handle re-adding to the list
    // and updating pendingDeletions when DeletionStatus.undone is emitted.
  }

  /// Handles the request to clear the published topic from the state.
  ///
  /// This is typically called after the UI has processed the published topic
  /// and no longer needs it in the state.
  void _onClearPublishedTopic(
    ClearPublishedTopic event,
    Emitter<DraftTopicsState> emit,
  ) {
    emit(state.copyWith(publishedTopic: null, snackbarTopicTitle: null));
  }
}
