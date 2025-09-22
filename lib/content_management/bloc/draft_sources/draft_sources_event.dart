part of 'draft_sources_bloc.dart';

sealed class DraftSourcesEvent extends Equatable {
  const DraftSourcesEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading of draft sources.
final class LoadDraftSourcesRequested extends DraftSourcesEvent {
  const LoadDraftSourcesRequested({this.startAfterId, this.limit});

  final String? startAfterId;
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// Event to publish a draft source.
final class PublishDraftSourceRequested extends DraftSourcesEvent {
  const PublishDraftSourceRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to request permanent deletion of a draft source.
final class DeleteDraftSourceForeverRequested extends DraftSourcesEvent {
  /// {@macro delete_draft_source_forever_requested}
  const DeleteDraftSourceForeverRequested(this.id);

  /// The ID of the source to permanently delete.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to undo a pending deletion of a draft source.
final class UndoDeleteDraftSourceRequested extends DraftSourcesEvent {
  /// {@macro undo_delete_draft_source_requested}
  const UndoDeleteDraftSourceRequested(this.id);

  /// The ID of the source whose deletion should be undone.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to clear the published source from the state.
final class ClearPublishedSource extends DraftSourcesEvent {
  /// {@macro clear_published_source}
  const ClearPublishedSource();

  @override
  List<Object?> get props => [];
}

/// Event to handle updates from the pending deletions service.
final class _DeletionServiceStatusChanged extends DraftSourcesEvent {
  const _DeletionServiceStatusChanged(this.event);

  final DeletionEvent<dynamic> event;

  @override
  List<Object?> get props => [event];
}
