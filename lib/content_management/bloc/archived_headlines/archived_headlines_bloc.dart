import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart'; // Import the pending deletions service

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
    required PendingDeletionsService
    pendingDeletionsService, // Inject PendingDeletionsService
  }) : _headlinesRepository = headlinesRepository,
       _pendingDeletionsService =
           pendingDeletionsService, // Initialize the service
       super(const ArchivedHeadlinesState()) {
    on<LoadArchivedHeadlinesRequested>(_onLoadArchivedHeadlinesRequested);
    on<RestoreHeadlineRequested>(_onRestoreHeadlineRequested);
    on<_DeletionServiceStatusChanged>(
      _onDeletionServiceStatusChanged,
    ); // Handle deletion service events

    // Listen to deletion events from the PendingDeletionsService.
    // The filter now correctly checks the type of the item in the event.
    _deletionEventSubscription = _pendingDeletionsService.deletionEvents.listen(
      (event) {
        if (event.item is Headline) {
          add(_DeletionServiceStatusChanged(event));
        }
      },
    );

    on<DeleteHeadlineForeverRequested>(_onDeleteHeadlineForeverRequested);
    on<UndoDeleteHeadlineRequested>(_onUndoDeleteHeadlineRequested);
    on<ClearRestoredHeadline>(_onClearRestoredHeadline);
  }

  final DataRepository<Headline> _headlinesRepository;
  final PendingDeletionsService
  _pendingDeletionsService; // The injected service

  /// Subscription to deletion events from the PendingDeletionsService.
  late final StreamSubscription<DeletionEvent<dynamic>> _deletionEventSubscription;

  @override
  Future<void> close() async {
    // Cancel the subscription to deletion events to prevent memory leaks.
    await _deletionEventSubscription.cancel();
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

    // Optimistically remove the headline from the UI.
    emit(
      state.copyWith(
        headlines: updatedHeadlines,
        lastPendingDeletionId: state.lastPendingDeletionId == event.id
            ? null
            : state.lastPendingDeletionId,
        snackbarHeadlineTitle: null, // Clear snackbar when restoring
      ),
    );

    try {
      final restoredHeadline = await _headlinesRepository.update(
        id: event.id,
        item: headlineToRestore.copyWith(status: ContentStatus.active),
      );
      emit(state.copyWith(restoredHeadline: restoredHeadline));
    } on HttpException catch (e) {
      // If the update fails, revert the change in the UI
      emit(
        state.copyWith(
          headlines: originalHeadlines,
          exception: e,
          lastPendingDeletionId: state.lastPendingDeletionId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          headlines: originalHeadlines,
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
    Emitter<ArchivedHeadlinesState> emit,
  ) async {
    final id = event.event.id;
    final status = event.event.status;
    final item = event.event.item;

    if (status == DeletionStatus.confirmed) {
      // Deletion confirmed, no action needed in BLoC as it was optimistically removed.
      // Ensure lastPendingDeletionId and snackbarHeadlineTitle are cleared if this was the one.
      emit(
        state.copyWith(
          lastPendingDeletionId: state.lastPendingDeletionId == id
              ? null
              : state.lastPendingDeletionId,
          snackbarHeadlineTitle: null,
        ),
      );
    } else if (status == DeletionStatus.undone) {
      // Deletion undone, restore the headline to the main list.
      if (item is Headline) {
        final updatedHeadlines = List<Headline>.from(state.headlines)
          ..insert(
            state.headlines.indexWhere(
                      (h) => h.updatedAt.isBefore(
                        item.updatedAt,
                      ),
                    ) !=
                    -1
                ? state.headlines.indexWhere(
                    (h) => h.updatedAt.isBefore(
                      item.updatedAt,
                    ),
                  )
                : state.headlines.length,
            item,
          );
        emit(
          state.copyWith(
            headlines: updatedHeadlines,
            lastPendingDeletionId: state.lastPendingDeletionId == id
                ? null
                : state.lastPendingDeletionId,
            snackbarHeadlineTitle: null,
          ),
        );
      }
    }
  }

  /// Handles the request to permanently delete an archived headline.
  ///
  /// This optimistically removes the headline from the UI and initiates a
  /// timed deletion via the [PendingDeletionsService].
  Future<void> _onDeleteHeadlineForeverRequested(
    DeleteHeadlineForeverRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) async {
    final headlineToDelete = state.headlines.firstWhere(
      (h) => h.id == event.id,
    );

    // Optimistically remove the headline from the UI.
    final updatedHeadlines = List<Headline>.from(state.headlines)
      ..removeWhere((h) => h.id == event.id);

    emit(
      state.copyWith(
        headlines: updatedHeadlines,
        lastPendingDeletionId: event.id,
        snackbarHeadlineTitle: headlineToDelete.title, // Set title for snackbar
      ),
    );

    // Request deletion via the service.
    _pendingDeletionsService.requestDeletion(
      item: headlineToDelete,
      repository: _headlinesRepository,
      undoDuration: const Duration(seconds: 5), // Configurable undo duration
    );
  }

  /// Handles the request to undo a pending deletion of an archived headline.
  ///
  /// This cancels the deletion timer in the [PendingDeletionsService].
  Future<void> _onUndoDeleteHeadlineRequested(
    UndoDeleteHeadlineRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) async {
    _pendingDeletionsService.undoDeletion(event.id);
    // The _onDeletionServiceStatusChanged will handle re-adding to the list
    // and updating pendingDeletions when DeletionStatus.undone is emitted.
  }

  /// Handles the request to clear the restored headline from the state.
  ///
  /// This is typically called after the UI has processed the restored headline
  /// and no longer needs it in the state.
  void _onClearRestoredHeadline(
    ClearRestoredHeadline event,
    Emitter<ArchivedHeadlinesState> emit,
  ) {
    emit(state.copyWith(restoredHeadline: null, snackbarHeadlineTitle: null));
  }
}
