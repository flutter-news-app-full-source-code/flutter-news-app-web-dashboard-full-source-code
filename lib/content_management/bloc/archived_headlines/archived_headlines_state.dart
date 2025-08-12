part of 'archived_headlines_bloc.dart';

/// Represents the status of archived content operations.
enum ArchivedHeadlinesStatus {
  initial,
  loading,
  success,
  failure,
}

/// The state for the archived content feature.
class ArchivedHeadlinesState extends Equatable {
  const ArchivedHeadlinesState({
    this.status = ArchivedHeadlinesStatus.initial,
    this.headlines = const [],
    this.cursor,
    this.hasMore = false,
    this.exception,
    this.restoredHeadline,
    this.lastDeletedHeadline,
  });

  final ArchivedHeadlinesStatus status;
  final List<Headline> headlines;
  final String? cursor;
  final bool hasMore;
  final HttpException? exception;
  final Headline? restoredHeadline;
  final Headline? lastDeletedHeadline;

  ArchivedHeadlinesState copyWith({
    ArchivedHeadlinesStatus? status,
    List<Headline>? headlines,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
    Headline? restoredHeadline,
    Headline? lastDeletedHeadline,
  }) {
    return ArchivedHeadlinesState(
      status: status ?? this.status,
      headlines: headlines ?? this.headlines,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      exception: exception,
      restoredHeadline: restoredHeadline,
      lastDeletedHeadline: lastDeletedHeadline,
    );
  }

  @override
  List<Object?> get props => [
    status,
    headlines,
    cursor,
    hasMore,
    exception,
    restoredHeadline,
    lastDeletedHeadline,
  ];
}
