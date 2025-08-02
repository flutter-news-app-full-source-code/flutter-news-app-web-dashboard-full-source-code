part of 'archived_topics_bloc.dart';

/// Represents the status of archived content operations.
enum ArchivedTopicsStatus {
  initial,
  loading,
  success,
  failure,
}

/// The state for the archived content feature.
class ArchivedTopicsState extends Equatable {
  const ArchivedTopicsState({
    this.status = ArchivedTopicsStatus.initial,
    this.topics = const [],
    this.cursor,
    this.hasMore = false,
    this.exception,
  });

  final ArchivedTopicsStatus status;
  final List<Topic> topics;
  final String? cursor;
  final bool hasMore;
  final HttpException? exception;

  ArchivedTopicsState copyWith({
    ArchivedTopicsStatus? status,
    List<Topic>? topics,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
  }) {
    return ArchivedTopicsState(
      status: status ?? this.status,
      topics: topics ?? this.topics,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
        status,
        topics,
        cursor,
        hasMore,
        exception,
      ];
}
