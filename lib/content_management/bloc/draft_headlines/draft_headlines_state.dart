part of 'draft_headlines_bloc.dart';

/// Represents the status of draft content operations.
enum DraftHeadlinesStatus {
  /// The operation is in its initial state.
  initial,

  /// Data is currently being loaded or an operation is in progress.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred during data loading or an operation.
  failure,
}

/// {@template draft_headlines_state}
/// The state for the draft content feature.
///
/// Manages the list of draft headlines, pagination details,
/// and any pending deletion operations.
/// {@endtemplate}
class DraftHeadlinesState extends Equatable {
  /// {@macro draft_headlines_state}
  const DraftHeadlinesState({
    this.status = DraftHeadlinesStatus.initial,
    this.headlines = const [],
    this.cursor,
    this.hasMore = false,
    this.exception,
    this.publishedHeadline,
    this.lastPendingDeletionId,
    this.snackbarHeadlineTitle,
  });

  /// The current status of the draft headlines operations.
  final DraftHeadlinesStatus status;

  /// The list of draft headlines currently displayed.
  final List<Headline> headlines;

  /// The cursor for fetching the next page of draft headlines.
  /// A `null` value indicates no more pages.
  final String? cursor;

  /// Indicates if there are more draft headlines available to load.
  final bool hasMore;

  /// The exception encountered during a failed operation, if any.
  final HttpException? exception;

  /// The headline that was most recently published, if any.
  final Headline? publishedHeadline;

  /// The ID of the headline that was most recently added to pending deletions.
  /// Used to trigger the snackbar display.
  final String? lastPendingDeletionId;

  /// The title of the headline for which the snackbar should be displayed.
  /// This is set when a deletion is requested and cleared when the snackbar
  /// is no longer needed.
  final String? snackbarHeadlineTitle;

  /// Creates a copy of this [DraftHeadlinesState] with updated values.
  DraftHeadlinesState copyWith({
    DraftHeadlinesStatus? status,
    List<Headline>? headlines,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
    Headline? publishedHeadline,
    String? lastPendingDeletionId,
    String? snackbarHeadlineTitle,
  }) {
    return DraftHeadlinesState(
      status: status ?? this.status,
      headlines: headlines ?? this.headlines,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      // Exception and publishedHeadline are explicitly set to null if not provided
      // to ensure they are cleared after being handled.
      exception: exception,
      publishedHeadline: publishedHeadline,
      lastPendingDeletionId: lastPendingDeletionId,
      snackbarHeadlineTitle: snackbarHeadlineTitle,
    );
  }

  @override
  List<Object?> get props => [
    status,
    headlines,
    cursor,
    hasMore,
    exception,
    publishedHeadline,
    lastPendingDeletionId,
    snackbarHeadlineTitle,
  ];
}
