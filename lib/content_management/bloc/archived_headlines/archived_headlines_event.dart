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

/// Event to permanently delete an archived headline.
final class DeleteHeadlineForeverRequested extends ArchivedHeadlinesEvent {
  const DeleteHeadlineForeverRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
