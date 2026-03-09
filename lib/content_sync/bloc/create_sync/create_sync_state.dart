part of 'create_sync_bloc.dart';

enum CreateSyncStatus { initial, loading, success, failure, submitting }

final class CreateSyncState extends Equatable {
  const CreateSyncState({
    this.status = CreateSyncStatus.initial,
    this.source,
    this.frequency = FetchInterval.hourly,
    this.exception,
  });

  final CreateSyncStatus status;
  final Source? source;
  final FetchInterval frequency;
  final HttpException? exception;

  bool get isFormValid => source != null;

  CreateSyncState copyWith({
    CreateSyncStatus? status,
    Source? source,
    FetchInterval? frequency,
    HttpException? exception,
  }) {
    return CreateSyncState(
      status: status ?? this.status,
      source: source ?? this.source,
      frequency: frequency ?? this.frequency,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, source, frequency, exception];
}
