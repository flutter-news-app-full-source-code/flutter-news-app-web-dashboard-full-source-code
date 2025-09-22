part of 'draft_sources_bloc.dart';

/// Represents the status of draft content operations.
enum DraftSourcesStatus {
  /// The operation is in its initial state.
  initial,

  /// Data is currently being loaded or an operation is in progress.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred during data loading or an operation.
  failure,
}

/// {@template draft_sources_state}
/// The state for the draft content feature.
///
/// Manages the list of draft sources, pagination details,
/// and any pending deletion operations.
/// {@endtemplate}
class DraftSourcesState extends Equatable {
  /// {@macro draft_sources_state}
  const DraftSourcesState({
    this.status = DraftSourcesStatus.initial,
    this.sources = const [],
    this.cursor,
    this.hasMore = false,
    this.exception,
    this.publishedSource,
    this.lastPendingDeletionId,
    this.snackbarSourceTitle,
  });

  /// The current status of the draft sources operations.
  final DraftSourcesStatus status;

  /// The list of draft sources currently displayed.
  final List<Source> sources;

  /// The cursor for fetching the next page of draft sources.
  /// A `null` value indicates no more pages.
  final String? cursor;

  /// Indicates if there are more draft sources available to load.
  final bool hasMore;

  /// The exception encountered during a failed operation, if any.
  final HttpException? exception;

  /// The source that was most recently published, if any.
  final Source? publishedSource;

  /// The ID of the source that was most recently added to pending deletions.
  /// Used to trigger the snackbar display.
  final String? lastPendingDeletionId;

  /// The title of the source for which the snackbar should be displayed.
  /// This is set when a deletion is requested and cleared when the snackbar
  /// is no longer needed.
  final String? snackbarSourceTitle;

  /// Creates a copy of this [DraftSourcesState] with updated values.
  DraftSourcesState copyWith({
    DraftSourcesStatus? status,
    List<Source>? sources,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
    Source? publishedSource,
    String? lastPendingDeletionId,
    String? snackbarSourceTitle,
  }) {
    return DraftSourcesState(
      status: status ?? this.status,
      sources: sources ?? this.sources,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      // Exception and publishedSource are explicitly set to null if not provided
      // to ensure they are cleared after being handled.
      exception: exception,
      publishedSource: publishedSource,
      lastPendingDeletionId: lastPendingDeletionId,
      snackbarSourceTitle: snackbarSourceTitle,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sources,
    cursor,
    hasMore,
    exception,
    publishedSource,
    lastPendingDeletionId,
    snackbarSourceTitle,
  ];
}
