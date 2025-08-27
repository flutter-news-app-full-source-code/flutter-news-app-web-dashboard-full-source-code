part of 'content_management_bloc.dart';

/// Represents the status of content loading and operations.
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

/// Defines the state for the content management feature.
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
  });

  /// The currently active tab in the content management section.
  final ContentManagementTab activeTab;

  /// Status of headline data operations.
  final ContentManagementStatus headlinesStatus;

  /// List of headlines.
  final List<Headline> headlines;

  /// Cursor for headline pagination.
  final String? headlinesCursor;

  /// Indicates if there are more headlines to load.
  final bool headlinesHasMore;

  /// Status of topic data operations.
  final ContentManagementStatus topicsStatus;

  /// List of topics.
  final List<Topic> topics;

  /// Cursor for topic pagination.
  final String? topicsCursor;

  /// Indicates if there are more topics to load.
  final bool topicsHasMore;

  /// Status of source data operations.
  final ContentManagementStatus sourcesStatus;

  /// List of sources.
  final List<Source> sources;

  /// Cursor for source pagination.
  final String? sourcesCursor;

  /// Indicates if there are more sources to load.
  final bool sourcesHasMore;

  /// The error describing an operation failure, if any.
  final HttpException? exception;

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
     
      exception: exception ?? this.exception,
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
  ];
}
