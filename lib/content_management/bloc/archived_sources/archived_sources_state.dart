part of 'archived_sources_bloc.dart';

/// Represents the status of archived content operations.
enum ArchivedSourcesStatus {
  initial,
  loading,
  success,
  failure,
}

/// The state for the archived content feature.
class ArchivedSourcesState extends Equatable {
  const ArchivedSourcesState({
    this.status = ArchivedSourcesStatus.initial,
    this.sources = const [],
    this.cursor,
    this.hasMore = false,
    this.exception,
    this.restoredSource,
  });

  final ArchivedSourcesStatus status;
  final List<Source> sources;
  final String? cursor;
  final bool hasMore;
  final HttpException? exception;
  final Source? restoredSource;

  ArchivedSourcesState copyWith({
    ArchivedSourcesStatus? status,
    List<Source>? sources,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
    Source? restoredSource,
  }) {
    return ArchivedSourcesState(
      status: status ?? this.status,
      sources: sources ?? this.sources,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      exception: exception ?? this.exception,
      restoredSource: restoredSource,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sources,
    cursor,
    hasMore,
    exception,
    restoredSource,
  ];
}
