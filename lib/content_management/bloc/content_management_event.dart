part of 'content_management_bloc.dart';

sealed class ContentManagementEvent extends Equatable {
  const ContentManagementEvent();

  @override
  List<Object?> get props => [];
}

/// Event to notify the BLoC that the active tab has changed.
final class ContentManagementTabChanged extends ContentManagementEvent {
  const ContentManagementTabChanged(this.tab);

  final ContentManagementTab tab;

  @override
  List<Object?> get props => [tab];
}

/// Event to notify the BLoC that the application language has changed.
final class ContentManagementLanguageChanged extends ContentManagementEvent {
  const ContentManagementLanguageChanged(this.language);

  final SupportedLanguage language;

  @override
  List<Object?> get props => [language];
}

/// Event to request loading of headlines.
final class LoadHeadlinesRequested extends ContentManagementEvent {
  const LoadHeadlinesRequested({
    this.startAfterId,
    this.limit,
    this.forceRefresh = false,
    this.filter,
  });

  final String? startAfterId;
  final int? limit;
  final bool forceRefresh;

  /// Optional filter to apply to the headlines query.
  final Map<String, dynamic>? filter;

  @override
  List<Object?> get props => [startAfterId, limit, forceRefresh, filter];
}

/// Event to archive a headline.
final class ArchiveHeadlineRequested extends ContentManagementEvent {
  const ArchiveHeadlineRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event received when a deletion event occurs in the PendingDeletionsService.
final class DeletionEventReceived extends ContentManagementEvent {
  const DeletionEventReceived(this.event);

  final DeletionEvent<dynamic> event;

  @override
  List<Object?> get props => [event];
}

/// Event to publish a draft headline.
final class PublishHeadlineRequested extends ContentManagementEvent {
  const PublishHeadlineRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to restore an archived headline.
final class RestoreHeadlineRequested extends ContentManagementEvent {
  const RestoreHeadlineRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to request permanent deletion of a headline.
final class DeleteHeadlineForeverRequested extends ContentManagementEvent {
  const DeleteHeadlineForeverRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to undo a pending deletion of a headline.
final class UndoDeleteHeadlineRequested extends ContentManagementEvent {
  const UndoDeleteHeadlineRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to request loading of topics.
final class LoadTopicsRequested extends ContentManagementEvent {
  const LoadTopicsRequested({
    this.startAfterId,
    this.limit,
    this.forceRefresh = false,
    this.filter,
  });

  final String? startAfterId;
  final int? limit;
  final bool forceRefresh;

  /// Optional filter to apply to the topics query.
  final Map<String, dynamic>? filter;

  @override
  List<Object?> get props => [startAfterId, limit, forceRefresh, filter];
}

/// Event to archive a topic.
final class ArchiveTopicRequested extends ContentManagementEvent {
  const ArchiveTopicRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to publish a draft topic.
final class PublishTopicRequested extends ContentManagementEvent {
  const PublishTopicRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to restore an archived topic.
final class RestoreTopicRequested extends ContentManagementEvent {
  const RestoreTopicRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to request permanent deletion of a topic.
final class DeleteTopicForeverRequested extends ContentManagementEvent {
  const DeleteTopicForeverRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to undo a pending deletion of a topic.
final class UndoDeleteTopicRequested extends ContentManagementEvent {
  const UndoDeleteTopicRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to request loading of sources.
final class LoadSourcesRequested extends ContentManagementEvent {
  const LoadSourcesRequested({
    this.startAfterId,
    this.limit,
    this.forceRefresh = false,
    this.filter,
  });

  final String? startAfterId;
  final int? limit;
  final bool forceRefresh;

  /// Optional filter to apply to the sources query.
  final Map<String, dynamic>? filter;

  @override
  List<Object?> get props => [startAfterId, limit, forceRefresh, filter];
}

/// Event to archive a source.
final class ArchiveSourceRequested extends ContentManagementEvent {
  const ArchiveSourceRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to publish a draft source.
final class PublishSourceRequested extends ContentManagementEvent {
  const PublishSourceRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to restore an archived source.
final class RestoreSourceRequested extends ContentManagementEvent {
  const RestoreSourceRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to request permanent deletion of a source.
final class DeleteSourceForeverRequested extends ContentManagementEvent {
  const DeleteSourceForeverRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to undo a pending deletion of a source.
final class UndoDeleteSourceRequested extends ContentManagementEvent {
  const UndoDeleteSourceRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
