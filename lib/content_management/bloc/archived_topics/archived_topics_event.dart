part of 'archived_topics_bloc.dart';

sealed class ArchivedTopicsEvent extends Equatable {
  const ArchivedTopicsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading of archived topics.
final class LoadArchivedTopicsRequested extends ArchivedTopicsEvent {
  const LoadArchivedTopicsRequested({this.startAfterId, this.limit});

  final String? startAfterId;
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// Event to restore an archived topic.
final class RestoreTopicRequested extends ArchivedTopicsEvent {
  const RestoreTopicRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
