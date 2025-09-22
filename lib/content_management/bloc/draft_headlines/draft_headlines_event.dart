part of 'draft_headlines_bloc.dart';

sealed class DraftHeadlinesEvent extends Equatable {
  const DraftHeadlinesEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading of draft headlines.
final class LoadDraftHeadlinesRequested extends DraftHeadlinesEvent {
  const LoadDraftHeadlinesRequested({this.startAfterId, this.limit});

  final String? startAfterId;
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// Event to publish a draft headline.
final class PublishDraftHeadlineRequested extends DraftHeadlinesEvent {
  const PublishDraftHeadlineRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to request permanent deletion of a draft headline.
final class DeleteDraftHeadlineForeverRequested extends DraftHeadlinesEvent {
  /// {@macro delete_draft_headline_forever_requested}
  const DeleteDraftHeadlineForeverRequested(this.id);

  /// The ID of the headline to permanently delete.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to undo a pending deletion of a draft headline.
final class UndoDeleteDraftHeadlineRequested extends DraftHeadlinesEvent {
  /// {@macro undo_delete_draft_headline_requested}
  const UndoDeleteDraftHeadlineRequested(this.id);

  /// The ID of the headline whose deletion should be undone.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to clear the published headline from the state.
final class ClearPublishedHeadline extends DraftHeadlinesEvent {
  /// {@macro clear_published_headline}
  const ClearPublishedHeadline();

  @override
  List<Object?> get props => [];
}

/// Event to handle updates from the pending deletions service.
final class _DeletionServiceStatusChanged extends DraftHeadlinesEvent {
  const _DeletionServiceStatusChanged(this.event);

  final DeletionEvent<dynamic> event;

  @override
  List<Object?> get props => [event];
}
