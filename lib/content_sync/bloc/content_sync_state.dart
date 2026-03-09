part of 'content_sync_bloc.dart';

enum ContentSyncStatus { initial, loading, success, failure }

final class ContentSyncState extends Equatable {
  const ContentSyncState({
    this.status = ContentSyncStatus.initial,
    this.tasks = const [],
    this.sources = const {},
    this.cursor,
    this.hasMore = false,
    this.exception,
  });

  final ContentSyncStatus status;
  final List<NewsAutomationTask> tasks;
  final Map<String, Source> sources;
  final String? cursor;
  final bool hasMore;
  final HttpException? exception;

  ContentSyncState copyWith({
    ContentSyncStatus? status,
    List<NewsAutomationTask>? tasks,
    Map<String, Source>? sources,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
  }) {
    return ContentSyncState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      sources: sources ?? this.sources,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tasks,
    sources,
    cursor,
    hasMore,
    exception,
  ];
}
