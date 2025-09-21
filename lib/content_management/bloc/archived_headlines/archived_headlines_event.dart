part of 'archived_headlines_bloc.dart';

sealed class ArchivedHeadlinesEvent extends Equatable {
  const ArchivedHeadlinesEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading of archived headlines.
final class LoadArchivedHeadlinesRequested extends ArchivedHeadlinesEvent {
  const LoadArchivedHeadlinesRequested({this.startAfterId, this.limit});

  final String? startAfterId;
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// Event to restore an archived headline.
final class RestoreHeadlineRequested extends ArchivedHeadlinesEvent {
  const RestoreHeadlineRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to request permanent deletion of an archived headline.
final class DeleteHeadlineForeverRequested extends ArchivedHeadlinesEvent {
  /// {@macro delete_headline_forever_requested}
  const DeleteHeadlineForeverRequested(this.id);

  /// The ID of the headline to permanently delete.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to undo a pending deletion of an archived headline.
final class UndoDeleteHeadlineRequested extends ArchivedHeadlinesEvent {
  /// {@macro undo_delete_headline_requested}
  const UndoDeleteHeadlineRequested(this.id);

  /// The ID of the headline whose deletion should be undone.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to clear the restored headline from the state.
final class ClearRestoredHeadline extends ArchivedHeadlinesEvent {
  /// {@macro clear_restored_headline}
  const ClearRestoredHeadline();

  @override
  List<Object?> get props => [];
}

/// Event to handle updates from the pending deletions service.
final class _DeletionServiceStatusChanged extends ArchivedHeadlinesEvent {
  const _DeletionServiceStatusChanged(this.event);

  final DeletionEvent event;

  @override
  List<Object?> get props => [event];
}
