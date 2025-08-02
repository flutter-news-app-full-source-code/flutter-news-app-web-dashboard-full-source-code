part of 'archived_content_bloc.dart';

/// Defines the tabs available in the archived content section.
enum ArchivedContentTab {
  /// Represents the Headlines tab.
  headlines,

  /// Represents the Topics tab.
  topics,

  /// Represents the Sources tab.
  sources,
}

/// Represents the status of archived content operations.
enum ArchivedContentStatus {
  initial,
  loading,
  success,
  failure,
}

/// The state for the archived content feature.
class ArchivedContentState extends Equatable {
  const ArchivedContentState({
    this.activeTab = ArchivedContentTab.headlines,
    this.headlinesStatus = ArchivedContentStatus.initial,
    this.headlines = const [],
    this.headlinesCursor,
    this.headlinesHasMore = false,
    this.topicsStatus = ArchivedContentStatus.initial,
    this.topics = const [],
    this.topicsCursor,
    this.topicsHasMore = false,
    this.sourcesStatus = ArchivedContentStatus.initial,
    this.sources = const [],
    this.sourcesCursor,
    this.sourcesHasMore = false,
    this.exception,
  });

  final ArchivedContentTab activeTab;
  final ArchivedContentStatus headlinesStatus;
  final List<Headline> headlines;
  final String? headlinesCursor;
  final bool headlinesHasMore;
  final ArchivedContentStatus topicsStatus;
  final List<Topic> topics;
  final String? topicsCursor;
  final bool topicsHasMore;
  final ArchivedContentStatus sourcesStatus;
  final List<Source> sources;
  final String? sourcesCursor;
  final bool sourcesHasMore;
  final HttpException? exception;

  ArchivedContentState copyWith({
    ArchivedContentTab? activeTab,
    ArchivedContentStatus? headlinesStatus,
    List<Headline>? headlines,
    String? headlinesCursor,
    bool? headlinesHasMore,
    ArchivedContentStatus? topicsStatus,
    List<Topic>? topics,
    String? topicsCursor,
    bool? topicsHasMore,
    ArchivedContentStatus? sourcesStatus,
    List<Source>? sources,
    String? sourcesCursor,
    bool? sourcesHasMore,
    HttpException? exception,
  }) {
    return ArchivedContentState(
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
        exception,
      ];
}
