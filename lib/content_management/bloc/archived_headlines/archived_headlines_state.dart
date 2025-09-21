part of 'archived_headlines_bloc.dart';

/// Represents the status of archived content operations.
enum ArchivedHeadlinesStatus {
  /// The operation is in its initial state.
  initial,

  /// Data is currently being loaded or an operation is in progress.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred during data loading or an operation.
  failure,
}

/// {@template archived_headlines_state}
/// The state for the archived content feature.
///
/// Manages the list of archived headlines, pagination details,
/// and any pending deletion operations.
/// {@endtemplate}
class ArchivedHeadlinesState extends Equatable {
  /// {@macro archived_headlines_state}
  const ArchivedHeadlinesState({
    this.status = ArchivedHeadlinesStatus.initial,
    this.headlines = const [],
    this.cursor,
    this.hasMore = false,
    this.exception,
    this.restoredHeadline,
    this.pendingDeletions = const {},
    this.lastPendingDeletionId,
  });

  /// The current status of the archived headlines operations.
  final ArchivedHeadlinesStatus status;

  /// The list of archived headlines currently displayed.
  final List<Headline> headlines;

  /// The cursor for fetching the next page of archived headlines.
  /// A `null` value indicates no more pages.
  final String? cursor;

  /// Indicates if there are more archived headlines available to load.
  final bool hasMore;

  /// The exception encountered during a failed operation, if any.
  final HttpException? exception;

  /// The headline that was most recently restored, if any.
  final Headline? restoredHeadline;

  /// A map of headlines that are currently in a "pending deletion" state.
  ///
  /// The key is the headline ID, and the value is the Headline object.
  /// These headlines have been optimistically removed from the main list
  /// and are awaiting permanent deletion after an undo period.
  final Map<String, Headline> pendingDeletions;

  /// The ID of the headline that was most recently moved to pending deletion.
  ///
  /// Used to identify which headline's undo snackbar should be displayed.
  final String? lastPendingDeletionId;

  /// Creates a copy of this [ArchivedHeadlinesState] with updated values.
  ArchivedHeadlinesState copyWith({
    ArchivedHeadlinesStatus? status,
    List<Headline>? headlines,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
    Headline? restoredHeadline,
    Map<String, Headline>? pendingDeletions,
    String? lastPendingDeletionId,
  }) {
    return ArchivedHeadlinesState(
      status: status ?? this.status,
      headlines: headlines ?? this.headlines,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      // Exception and restoredHeadline are explicitly set to null if not provided
      // to ensure they are cleared after being handled.
      exception: exception,
      restoredHeadline: restoredHeadline,
      pendingDeletions: pendingDeletions ?? this.pendingDeletions,
      lastPendingDeletionId:
          lastPendingDeletionId ?? this.lastPendingDeletionId,
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
    pendingDeletions,
    lastPendingDeletionId,
  ];
}
