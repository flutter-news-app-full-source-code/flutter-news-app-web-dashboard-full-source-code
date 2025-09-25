part of 'content_management_bloc.dart';

/// Represents the status of content management operations.
enum ContentManagementStatus {
  /// The operation is in its initial state.
  initial,

  /// Data is currently being loaded or an operation is in progress.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred during data loading or an operation.
  failure,
}

/// {@template content_management_state}
/// The state for the content management feature.
/// {@endtemplate}
class ContentManagementState extends Equatable {
  /// {@macro content_management_state}
  const ContentManagementState({
    this.activeTab = ContentManagementTab.headlines,
    this.headlinesStatus = ContentManagementStatus.initial,
    this.headlines = const [],
    this.headlinesCursor,
    this.headlinesHasMore = false,
    this.topicsStatus = ContentManagementStatus.initial,
    this.topics = const [],
    this.topicsCursor,
    this.topicsHasMore = false,
    this.sourcesStatus = ContentManagementStatus.initial,
    this.sources = const [],
    this.sourcesCursor,
    this.sourcesHasMore = false,
    this.exception,
    this.lastPendingDeletionId,
    this.snackbarMessage,
  });

  /// The currently active tab in the content management section.
  final ContentManagementTab activeTab;

  /// The status of the headlines loading operation.
  final ContentManagementStatus headlinesStatus;

  /// The list of headlines currently displayed.
  final List<Headline> headlines;

  /// The cursor for fetching the next page of headlines.
  final String? headlinesCursor;

  /// Indicates if there are more headlines available to load.
  final bool headlinesHasMore;

  /// The status of the topics loading operation.
  final ContentManagementStatus topicsStatus;

  /// The list of topics currently displayed.
  final List<Topic> topics;

  /// The cursor for fetching the next page of topics.
  final String? topicsCursor;

  /// Indicates if there are more topics available to load.
  final bool topicsHasMore;

  /// The status of the sources loading operation.
  final ContentManagementStatus sourcesStatus;

  /// The list of sources currently displayed.
  final List<Source> sources;

  /// The cursor for fetching the next page of sources.
  final String? sourcesCursor;

  /// Indicates if there are more sources available to load.
  final bool sourcesHasMore;

  /// The exception encountered during a failed operation, if any.
  final HttpException? exception;

  /// The ID of the item that was most recently added to pending deletions.
  /// Used to trigger the snackbar display.
  final String? lastPendingDeletionId;

  /// The message to display in the snackbar for pending deletions or other
  /// transient messages.
  final String? snackbarMessage;

  /// Creates a copy of this [ContentManagementState] with updated values.
  ContentManagementState copyWith({
    ContentManagementTab? activeTab,
    ContentManagementStatus? headlinesStatus,
    List<Headline>? headlines,
    String? headlinesCursor,
    bool? headlinesHasMore,
    ContentManagementStatus? topicsStatus,
    List<Topic>? topics,
    String? topicsCursor,
    bool? topicsHasMore,
    ContentManagementStatus? sourcesStatus,
    List<Source>? sources,
    String? sourcesCursor,
    bool? sourcesHasMore,
    HttpException? exception,
    String? lastPendingDeletionId,
    String? snackbarMessage,
  }) {
    return ContentManagementState(
      activeTab: activeTab ?? this.activeTab,
      headlinesStatus: headlinesStatus ?? this.headlinesStatus,
      headlines: headlines ?? this.headlines,
      headlinesCursor: headlinesCursor ?? this.headlinesCursor,
      headlinesHasMore: headlinesHasMore ?? this.headlinesHasMore,
      topicsStatus: topicsStatus ?? this.topicsStatus,
      topics: topics ?? this.topics,
      topicsCursor: topicsCursor ?? this.topicsCursor,
      topicsHasMore: topicsHasMore ?? this.topicsHasMore,
      sourcesStatus: sourcesStatus ?? this.sourcesStatus,
      sources: sources ?? this.sources,
      sourcesCursor: sourcesCursor ?? this.sourcesCursor,
      sourcesHasMore: sourcesHasMore ?? this.sourcesHasMore,
      exception: exception, // Explicitly set to null if not provided
      lastPendingDeletionId:
          lastPendingDeletionId, // Explicitly set to null if not provided
      snackbarMessage:
          snackbarMessage, // Explicitly set to null if not provided
    );
  }

  @override
  List<Object?> get props => [
    activeTab,
    headlinesStatus,
    headlines,
    headlinesCursor,
    headlinesHasMore,
    topicsStatus,
    topics,
    topicsCursor,
    topicsHasMore,
    sourcesStatus,
    sources,
    sourcesCursor,
    sourcesHasMore,
    exception,
    lastPendingDeletionId,
    snackbarMessage,
  ];
}
