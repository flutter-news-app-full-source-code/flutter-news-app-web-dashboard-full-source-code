part of 'draft_topics_bloc.dart';

sealed class DraftTopicsEvent extends Equatable {
  const DraftTopicsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading of draft topics.
final class LoadDraftTopicsRequested extends DraftTopicsEvent {
  const LoadDraftTopicsRequested({this.startAfterId, this.limit});

  final String? startAfterId;
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// Event to publish a draft topic.
final class PublishDraftTopicRequested extends DraftTopicsEvent {
  const PublishDraftTopicRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to request permanent deletion of a draft topic.
final class DeleteDraftTopicForeverRequested extends DraftTopicsEvent {
  /// {@macro delete_draft_topic_forever_requested}
  const DeleteDraftTopicForeverRequested(this.id);

  /// The ID of the topic to permanently delete.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to undo a pending deletion of a draft topic.
final class UndoDeleteDraftTopicRequested extends DraftTopicsEvent {
  /// {@macro undo_delete_draft_topic_requested}
  const UndoDeleteDraftTopicRequested(this.id);

  /// The ID of the topic whose deletion should be undone.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to clear the published topic from the state.
final class ClearPublishedTopic extends DraftTopicsEvent {
  /// {@macro clear_published_topic}
  const ClearPublishedTopic();

  @override
  List<Object?> get props => [];
}

/// Event to handle updates from the pending deletions service.
final class _DeletionServiceStatusChanged extends DraftTopicsEvent {
  const _DeletionServiceStatusChanged(this.event);

  final DeletionEvent<dynamic> event;

  @override
  List<Object?> get props => [event];
}
