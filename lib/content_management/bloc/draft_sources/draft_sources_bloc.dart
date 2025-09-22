import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart';

part 'draft_sources_event.dart';
part 'draft_sources_state.dart';

/// {@template draft_sources_bloc}
/// A BLoC responsible for managing the state of draft sources.
///
/// It handles loading, publishing, and permanently deleting draft sources,
/// including a temporary "undo" period for deletions.
/// {@endtemplate}
class DraftSourcesBloc extends Bloc<DraftSourcesEvent, DraftSourcesState> {
  /// {@macro draft_sources_bloc}
  DraftSourcesBloc({
    required DataRepository<Source> sourcesRepository,
    required PendingDeletionsService pendingDeletionsService,
  }) : _sourcesRepository = sourcesRepository,
       _pendingDeletionsService = pendingDeletionsService,
       super(const DraftSourcesState()) {
    on<LoadDraftSourcesRequested>(_onLoadDraftSourcesRequested);
    on<PublishDraftSourceRequested>(_onPublishDraftSourceRequested);
    on<_DeletionServiceStatusChanged>(
      _onDeletionServiceStatusChanged,
    );
    on<DeleteDraftSourceForeverRequested>(
      _onDeleteDraftSourceForeverRequested,
    );
    on<UndoDeleteDraftSourceRequested>(_onUndoDeleteDraftSourceRequested);
    on<ClearPublishedSource>(_onClearPublishedSource);

    // Listen to deletion events from the PendingDeletionsService.
    // The filter now correctly checks the type of the item in the event.
    _deletionEventSubscription = _pendingDeletionsService.deletionEvents.listen(
      (event) {
        if (event.item is Source) {
          add(_DeletionServiceStatusChanged(event));
        }
      },
    );
  }

  final DataRepository<Source> _sourcesRepository;
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

  /// Handles the request to load draft sources.
  ///
  /// Fetches paginated draft sources from the repository and updates the state.
  Future<void> _onLoadDraftSourcesRequested(
    LoadDraftSourcesRequested event,
    Emitter<DraftSourcesState> emit,
  ) async {
    emit(state.copyWith(status: DraftSourcesStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousSources = isPaginating ? state.sources : <Source>[];

      final paginatedSources = await _sourcesRepository.readAll(
        filter: {'status': ContentStatus.draft.name},
        sort: [const SortOption('updatedAt', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          status: DraftSourcesStatus.success,
          sources: [...previousSources, ...paginatedSources.items],
          cursor: paginatedSources.cursor,
          hasMore: paginatedSources.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: DraftSourcesStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DraftSourcesStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles the request to publish a draft source.
  ///
  /// Optimistically removes the source from the UI, updates its status to active
  /// in the repository, and then updates the state. If the source was pending
  /// deletion, its pending deletion is cancelled.
  Future<void> _onPublishDraftSourceRequested(
    PublishDraftSourceRequested event,
    Emitter<DraftSourcesState> emit,
  ) async {
    final originalSources = state.sources;
    final sourceIndex = originalSources.indexWhere((s) => s.id == event.id);
    if (sourceIndex == -1) return;
    final sourceToPublish = originalSources[sourceIndex];
    final updatedSources = List<Source>.from(originalSources)
      ..removeAt(sourceIndex);

    // Optimistically remove the source from the UI.
    emit(
      state.copyWith(
        sources: updatedSources,
        lastPendingDeletionId: state.lastPendingDeletionId == event.id
            ? null
            : state.lastPendingDeletionId,
        snackbarSourceTitle: null,
      ),
    );

    try {
      final publishedSource = await _sourcesRepository.update(
        id: event.id,
        item: sourceToPublish.copyWith(status: ContentStatus.active),
      );
      emit(state.copyWith(publishedSource: publishedSource));
    } on HttpException catch (e) {
      // If the update fails, revert the change in the UI
      emit(
        state.copyWith(
          sources: originalSources,
          exception: e,
          lastPendingDeletionId: state.lastPendingDeletionId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sources: originalSources,
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
    Emitter<DraftSourcesState> emit,
  ) async {
    final id = event.event.id;
    final status = event.event.status;
    final item = event.event.item;

    if (status == DeletionStatus.confirmed) {
      // Deletion confirmed, no action needed in BLoC as it was optimistically removed.
      // Ensure lastPendingDeletionId and snackbarSourceTitle are cleared if this was the one.
      emit(
        state.copyWith(
          lastPendingDeletionId: state.lastPendingDeletionId == id
              ? null
              : state.lastPendingDeletionId,
          snackbarSourceTitle: null,
        ),
      );
    } else if (status == DeletionStatus.undone) {
      // Deletion undone, restore the source to the main list.
      if (item is Source) {
        final insertionIndex = state.sources.indexWhere(
          (s) => s.updatedAt.isBefore(item.updatedAt),
        );
        final updatedSources = List<Source>.from(state.sources)
          ..insert(
            insertionIndex != -1 ? insertionIndex : state.sources.length,
            item,
          );
        emit(
          state.copyWith(
            sources: updatedSources,
            lastPendingDeletionId: state.lastPendingDeletionId == id
                ? null
                : state.lastPendingDeletionId,
            snackbarSourceTitle: null,
          ),
        );
      }
    }
  }

  /// Handles the request to permanently delete a draft source.
  ///
  /// This optimistically removes the source from the UI and initiates a
  /// timed deletion via the [PendingDeletionsService].
  Future<void> _onDeleteDraftSourceForeverRequested(
    DeleteDraftSourceForeverRequested event,
    Emitter<DraftSourcesState> emit,
  ) async {
    final sourceToDelete = state.sources.firstWhere(
      (s) => s.id == event.id,
    );

    // Optimistically remove the source from the UI.
    final updatedSources = List<Source>.from(state.sources)
      ..removeWhere((s) => s.id == event.id);

    emit(
      state.copyWith(
        sources: updatedSources,
        lastPendingDeletionId: event.id,
        snackbarSourceTitle: sourceToDelete.name,
      ),
    );

    // Request deletion via the service.
    _pendingDeletionsService.requestDeletion(
      item: sourceToDelete,
      repository: _sourcesRepository,
      undoDuration: const Duration(seconds: 5),
    );
  }

  /// Handles the request to undo a pending deletion of a draft source.
  ///
  /// This cancels the deletion timer in the [PendingDeletionsService].
  Future<void> _onUndoDeleteDraftSourceRequested(
    UndoDeleteDraftSourceRequested event,
    Emitter<DraftSourcesState> emit,
  ) async {
    _pendingDeletionsService.undoDeletion(event.id);
    // The _onDeletionServiceStatusChanged will handle re-adding to the list
    // and updating pendingDeletions when DeletionStatus.undone is emitted.
  }

  /// Handles the request to clear the published source from the state.
  ///
  /// This is typically called after the UI has processed the published source
  /// and no longer needs it in the state.
  void _onClearPublishedSource(
    ClearPublishedSource event,
    Emitter<DraftSourcesState> emit,
  ) {
    emit(state.copyWith(publishedSource: null, snackbarSourceTitle: null));
  }
}
