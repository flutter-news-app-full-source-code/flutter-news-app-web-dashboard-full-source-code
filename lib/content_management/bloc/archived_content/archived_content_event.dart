part of 'archived_content_bloc.dart';

sealed class ArchivedContentEvent extends Equatable {
  const ArchivedContentEvent();

  @override
  List<Object?> get props => [];
}

/// Event to change the active archived content tab.
final class ArchivedContentTabChanged extends ArchivedContentEvent {
  const ArchivedContentTabChanged(this.tab);

  final ArchivedContentTab tab;

  @override
  List<Object?> get props => [tab];
}

/// Event to request loading of archived headlines.
final class LoadArchivedHeadlinesRequested extends ArchivedContentEvent {
  const LoadArchivedHeadlinesRequested({this.startAfterId, this.limit});

  final String? startAfterId;
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// Event to request loading of archived topics.
final class LoadArchivedTopicsRequested extends ArchivedContentEvent {
  const LoadArchivedTopicsRequested({this.startAfterId, this.limit});

  final String? startAfterId;
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// Event to request loading of archived sources.
final class LoadArchivedSourcesRequested extends ArchivedContentEvent {
  const LoadArchivedSourcesRequested({this.startAfterId, this.limit});

  final String? startAfterId;
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// Event to restore an archived headline.
final class RestoreHeadlineRequested extends ArchivedContentEvent {
  const RestoreHeadlineRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to restore an archived topic.
final class RestoreTopicRequested extends ArchivedContentEvent {
  const RestoreTopicRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to restore an archived source.
final class RestoreSourceRequested extends ArchivedContentEvent {
  const RestoreSourceRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to permanently delete an archived headline.
final class DeleteHeadlineForeverRequested extends ArchivedContentEvent {
  const DeleteHeadlineForeverRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
