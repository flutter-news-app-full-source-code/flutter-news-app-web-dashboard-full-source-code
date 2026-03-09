part of 'create_sync_bloc.dart';

sealed class CreateSyncEvent extends Equatable {
  const CreateSyncEvent();

  @override
  List<Object?> get props => [];
}

final class CreateSyncStarted extends CreateSyncEvent {
  const CreateSyncStarted();
}

final class CreateSyncSourceChanged extends CreateSyncEvent {
  const CreateSyncSourceChanged(this.source);
  final Source? source;

  @override
  List<Object?> get props => [source];
}

final class CreateSyncFrequencyChanged extends CreateSyncEvent {
  const CreateSyncFrequencyChanged(this.frequency);
  final FetchInterval frequency;

  @override
  List<Object?> get props => [frequency];
}

final class CreateSyncSubmitted extends CreateSyncEvent {
  const CreateSyncSubmitted();
}
