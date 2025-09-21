import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'archived_headlines_event.dart';
part 'archived_headlines_state.dart';

/// {@template archived_headlines_bloc}
/// A BLoC responsible for managing the state of archived headlines.
///
/// It handles loading, restoring, and permanently deleting archived headlines,
/// including a temporary "undo" period for deletions.
/// {@endtemplate}
class ArchivedHeadlinesBloc
    extends Bloc<ArchivedHeadlinesEvent, ArchivedHeadlinesState> {
  /// {@macro archived_headlines_bloc}
  ArchivedHeadlinesBloc({
    required DataRepository<Headline> headlinesRepository,
  }) : _headlinesRepository = headlinesRepository,
       super(const ArchivedHeadlinesState()) {
    on<LoadArchivedHeadlinesRequested>(_onLoadArchivedHeadlinesRequested);
    on<RestoreHeadlineRequested>(_onRestoreHeadlineRequested);
    on<DeleteHeadlineForeverRequested>(_onDeleteHeadlineForeverRequested);
    on<UndoDeleteHeadlineRequested>(_onUndoDeleteHeadlineRequested);
    on<_ConfirmDeleteHeadlineRequested>(_onConfirmDeleteHeadlineRequested);
  }

  final DataRepository<Headline> _headlinesRepository;

  /// Manages individual subscriptions for delayed permanent deletions.
  ///
  /// Each entry maps a headline ID to its corresponding StreamSubscription,
  /// allowing for independent undo functionality.
  final Map<String, StreamSubscription<void>> _pendingDeletionSubscriptions =
      {};

  @override
  Future<void> close() async {
    // Cancel all pending deletion subscriptions to prevent memory leaks
    // and ensure no unexpected deletions occur after the bloc is closed.
    for (final subscription in _pendingDeletionSubscriptions.values) {
      await subscription.cancel();
    }
    return super.close();
  }

  /// Handles the request to load archived headlines.
  ///
  /// Fetches paginated archived headlines from the repository and updates the state.
  Future<void> _onLoadArchivedHeadlinesRequested(
    LoadArchivedHeadlinesRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) async {
    emit(state.copyWith(status: ArchivedHeadlinesStatus.loading));
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
          status: ArchivedHeadlinesStatus.success,
          headlines: [...previousHeadlines, ...paginatedHeadlines.items],
          cursor: paginatedHeadlines.cursor,
          hasMore: paginatedHeadlines.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: ArchivedHeadlinesStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ArchivedHeadlinesStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles the request to restore an archived headline.
  ///
  /// Optimistically removes the headline from the UI, updates its status to active
  /// in the repository, and then updates the state. If the headline was pending
  /// deletion, its pending deletion is cancelled.
  Future<void> _onRestoreHeadlineRequested(
    RestoreHeadlineRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) async {
    final originalHeadlines = List<Headline>.from(state.headlines);
    final headlineIndex = originalHeadlines.indexWhere((h) => h.id == event.id);
    if (headlineIndex == -1) return;

    final headlineToRestore = originalHeadlines[headlineIndex];
    final updatedHeadlines = originalHeadlines..removeAt(headlineIndex);

    // If the headline was pending deletion, cancel its subscription and remove it
    // from pendingDeletions.
    final subscription = _pendingDeletionSubscriptions.remove(event.id);
    if (subscription != null) {
      await subscription.cancel();
    }

    emit(
      state.copyWith(
        headlines: updatedHeadlines,
        pendingDeletions: Map.from(state.pendingDeletions)..remove(event.id),
      ),
    );

    try {
      final restoredHeadline = await _headlinesRepository.update(
        id: event.id,
        item: headlineToRestore.copyWith(status: ContentStatus.active),
      );
      emit(state.copyWith(restoredHeadline: restoredHeadline));
    } on HttpException catch (e) {
      // If the update fails, revert the change in the UI and re-add to pendingDeletions
      emit(
        state.copyWith(
          headlines: originalHeadlines,
          exception: e,
          pendingDeletions: Map.from(state.pendingDeletions)
            ..[event.id] = headlineToRestore,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          headlines: originalHeadlines,
          exception: UnknownException('An unexpected error occurred: $e'),
          pendingDeletions: Map.from(state.pendingDeletions)
            ..[event.id] = headlineToRestore,
        ),
      );
    }
  }

  /// Handles the request to permanently delete a headline.
  ///
  /// Optimistically removes the headline from the UI and starts a 5-second timer.
  /// If the timer completes without an undo, a `_ConfirmDeleteHeadlineRequested`
  /// event is dispatched.
  Future<void> _onDeleteHeadlineForeverRequested(
    DeleteHeadlineForeverRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) async {
    // Cancel any existing subscription for this headline if it was already pending
    final subscription = _pendingDeletionSubscriptions.remove(event.id);
    if (subscription != null) {
      await subscription.cancel();
    }

    final headlineIndex = state.headlines.indexWhere((h) => h.id == event.id);
    if (headlineIndex == -1) return;

    final headlineToDelete = state.headlines[headlineIndex];
    final updatedHeadlines = List<Headline>.from(state.headlines)
      ..removeAt(headlineIndex);

    final updatedPendingDeletions = Map<String, Headline>.from(
      state.pendingDeletions,
    )..[event.id] = headlineToDelete;

    emit(
      state.copyWith(
        headlines: updatedHeadlines,
        pendingDeletions: updatedPendingDeletions,
        lastPendingDeletionId: event.id,
      ),
    );

    // Start a new delayed deletion subscription.
    // The `add` method returns a Future, which is intentionally not awaited here.
    _pendingDeletionSubscriptions[event.id] =
        Future.delayed(
          const Duration(seconds: 5),
          () => add(_ConfirmDeleteHeadlineRequested(event.id)),
        ).asStream().listen(
          (_) {}, // No-op, just to keep the stream alive
          onError: (Object error) {
            // Handle potential errors during the delay, though unlikely.
            // Explicitly cast error to Object to satisfy addError signature.
            addError(error, StackTrace.current);
          },
          onDone: () {
            // Clean up the subscription once it's done.
            _pendingDeletionSubscriptions.remove(event.id);
          },
        );
  }

  /// Handles the internal event to confirm the permanent deletion of a headline.
  ///
  /// This event is typically dispatched after the undo timer expires.
  Future<void> _onConfirmDeleteHeadlineRequested(
    _ConfirmDeleteHeadlineRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) async {
    // Ensure the subscription is cancelled and removed, as the deletion is now confirmed.
    final subscription = _pendingDeletionSubscriptions.remove(event.id);
    if (subscription != null) {
      await subscription.cancel();
    }

    final headlineToDelete = state.pendingDeletions[event.id];
    if (headlineToDelete == null) {
      // Headline not found in pending deletions, might have been undone or already deleted.
      return;
    }

    final updatedPendingDeletions = Map<String, Headline>.from(
      state.pendingDeletions,
    )..remove(event.id);

    try {
      await _headlinesRepository.delete(id: event.id);
      emit(state.copyWith(pendingDeletions: updatedPendingDeletions));
    } on HttpException catch (e) {
      // If deletion fails, restore the headline to the list and re-add to pendingDeletions
      // (without restarting the timer, as the user can undo it from the UI if they are still on the page).
      final originalHeadlines = List<Headline>.from(state.headlines)
        ..insert(
          state.headlines.indexWhere(
                    (h) => h.updatedAt.isBefore(
                      headlineToDelete.updatedAt,
                    ),
                  ) !=
                  -1
              ? state.headlines.indexWhere(
                  (h) => h.updatedAt.isBefore(
                    headlineToDelete.updatedAt,
                  ),
                )
              : state.headlines.length,
          headlineToDelete,
        );
      emit(
        state.copyWith(
          headlines: originalHeadlines,
          exception: e,
          pendingDeletions: updatedPendingDeletions
            ..[event.id] = headlineToDelete,
        ),
      );
    } catch (e) {
      final originalHeadlines = List<Headline>.from(state.headlines)
        ..insert(
          state.headlines.indexWhere(
                    (h) => h.updatedAt.isBefore(
                      headlineToDelete.updatedAt,
                    ),
                  ) !=
                  -1
              ? state.headlines.indexWhere(
                  (h) => h.updatedAt.isBefore(
                    headlineToDelete.updatedAt,
                  ),
                )
              : state.headlines.length,
          headlineToDelete,
        );
      emit(
        state.copyWith(
          headlines: originalHeadlines,
          exception: UnknownException('An unexpected error occurred: $e'),
          pendingDeletions: updatedPendingDeletions
            ..[event.id] = headlineToDelete,
        ),
      );
    }
  }

  /// Handles the request to undo a pending headline deletion.
  ///
  /// Cancels the permanent deletion for the specified headline and restores it to the UI.
  void _onUndoDeleteHeadlineRequested(
    UndoDeleteHeadlineRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) {
    // Cancel the specific pending deletion subscription.
    final subscription = _pendingDeletionSubscriptions.remove(event.id);
    if (subscription != null) {
      // No await here as this is a void method and we don't want to block.
      // The subscription will eventually cancel.
      subscription.cancel();
    }

    final undoneHeadline = state.pendingDeletions[event.id];
    if (undoneHeadline == null) {
      // Headline not found in pending deletions, might have been already confirmed or not pending.
      return;
    }

    final updatedHeadlines = List<Headline>.from(state.headlines)
      ..insert(
        state.headlines.indexWhere(
                  (h) => h.updatedAt.isBefore(
                    undoneHeadline.updatedAt,
                  ),
                ) !=
                -1
            ? state.headlines.indexWhere(
                (h) => h.updatedAt.isBefore(
                  undoneHeadline.updatedAt,
                ),
              )
            : state.headlines.length,
        undoneHeadline,
      );

    final updatedPendingDeletions = Map<String, Headline>.from(
      state.pendingDeletions,
    )..remove(event.id);

    emit(
      state.copyWith(
        headlines: updatedHeadlines,
        pendingDeletions: updatedPendingDeletions,
      ),
    );
  }
}
