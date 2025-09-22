part of 'draft_topics_bloc.dart';

/// Represents the status of draft content operations.
enum DraftTopicsStatus {
  /// The operation is in its initial state.
  initial,

  /// Data is currently being loaded or an operation is in progress.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred during data loading or an operation.
  failure,
}

/// {@template draft_topics_state}
/// The state for the draft content feature.
///
/// Manages the list of draft topics, pagination details,
/// and any pending deletion operations.
/// {@endtemplate}
class DraftTopicsState extends Equatable {
  /// {@macro draft_topics_state}
  const DraftTopicsState({
    this.status = DraftTopicsStatus.initial,
    this.topics = const [],
    this.cursor,
    this.hasMore = false,
    this.exception,
    this.publishedTopic,
    this.lastPendingDeletionId,
    this.snackbarTopicTitle,
  });

  /// The current status of the draft topics operations.
  final DraftTopicsStatus status;

  /// The list of draft topics currently displayed.
  final List<Topic> topics;

  /// The cursor for fetching the next page of draft topics.
  /// A `null` value indicates no more pages.
  final String? cursor;

  /// Indicates if there are more draft topics available to load.
  final bool hasMore;

  /// The exception encountered during a failed operation, if any.
  final HttpException? exception;

  /// The topic that was most recently published, if any.
  final Topic? publishedTopic;

  /// The ID of the topic that was most recently added to pending deletions.
  /// Used to trigger the snackbar display.
  final String? lastPendingDeletionId;

  /// The title of the topic for which the snackbar should be displayed.
  /// This is set when a deletion is requested and cleared when the snackbar
  /// is no longer needed.
  final String? snackbarTopicTitle;

  /// Creates a copy of this [DraftTopicsState] with updated values.
  DraftTopicsState copyWith({
    DraftTopicsStatus? status,
    List<Topic>? topics,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
    Topic? publishedTopic,
    String? lastPendingDeletionId,
    String? snackbarTopicTitle,
  }) {
    return DraftTopicsState(
      status: status ?? this.status,
      topics: topics ?? this.topics,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      // Exception and publishedTopic are explicitly set to null if not provided
      // to ensure they are cleared after being handled.
      exception: exception,
      publishedTopic: publishedTopic,
      lastPendingDeletionId:
          lastPendingDeletionId ?? this.lastPendingDeletionId,
      snackbarTopicTitle: snackbarTopicTitle ?? this.snackbarTopicTitle,
    );
  }

  @override
  List<Object?> get props => [
    status,
    topics,
    cursor,
    hasMore,
    exception,
    publishedTopic,
    lastPendingDeletionId,
    snackbarTopicTitle,
  ];
}
