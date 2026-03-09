part of 'edit_sync_bloc.dart';

enum EditSyncStatus { initial, loading, success, failure, submitting }

final class EditSyncState extends Equatable {
  const EditSyncState({
    this.status = EditSyncStatus.initial,
    this.task,
    this.source,
    this.exception,
  });

  final EditSyncStatus status;
  final NewsAutomationTask? task;
  final Source? source;
  final HttpException? exception;

  bool get isFormValid => task != null && source != null;

  EditSyncState copyWith({
    EditSyncStatus? status,
    NewsAutomationTask? task,
    Source? source,
    HttpException? exception,
  }) {
    return EditSyncState(
      status: status ?? this.status,
      task: task ?? this.task,
      source: source ?? this.source,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, task, source, exception];
}
