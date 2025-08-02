part of 'archived_sources_bloc.dart';

sealed class ArchivedSourcesEvent extends Equatable {
  const ArchivedSourcesEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request loading of archived sources.
final class LoadArchivedSourcesRequested extends ArchivedSourcesEvent {
  const LoadArchivedSourcesRequested({this.startAfterId, this.limit});

  final String? startAfterId;
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// Event to restore an archived source.
final class RestoreSourceRequested extends ArchivedSourcesEvent {
  const RestoreSourceRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
