part of 'edit_sync_bloc.dart';

sealed class EditSyncEvent extends Equatable {
  const EditSyncEvent();

  @override
  List<Object?> get props => [];
}

final class EditSyncStarted extends EditSyncEvent {
  const EditSyncStarted(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

final class EditSyncFrequencyChanged extends EditSyncEvent {
  const EditSyncFrequencyChanged(this.frequency);
  final FetchInterval frequency;

  @override
  List<Object?> get props => [frequency];
}

final class EditSyncStatusChanged extends EditSyncEvent {
  const EditSyncStatusChanged(this.status);
  final IngestionStatus status;

  @override
  List<Object?> get props => [status];
}

final class EditSyncSubmitted extends EditSyncEvent {
  const EditSyncSubmitted();
}
