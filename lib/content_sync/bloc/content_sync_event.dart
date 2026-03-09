part of 'content_sync_bloc.dart';

sealed class ContentSyncEvent extends Equatable {
  const ContentSyncEvent();

  @override
  List<Object?> get props => [];
}

final class ContentSyncStarted extends ContentSyncEvent {
  const ContentSyncStarted({this.cursor, this.forceRefresh = false});
  final String? cursor;
  final bool forceRefresh;

  @override
  List<Object?> get props => [cursor, forceRefresh];
}

final class ContentSyncStatusToggled extends ContentSyncEvent {
  const ContentSyncStatusToggled(this.id, this.status);
  final String id;
  final IngestionStatus status;

  @override
  List<Object?> get props => [id, status];
}

final class ContentSyncTaskDeleted extends ContentSyncEvent {
  const ContentSyncTaskDeleted(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}
