part of 'content_management_bloc.dart';

sealed class ContentManagementEvent extends Equatable {
  const ContentManagementEvent();

  @override
  List<Object?> get props => [];
}

/// {@template content_management_tab_changed}
/// Event to change the active content management tab.
/// {@endtemplate}
final class ContentManagementTabChanged extends ContentManagementEvent {
  /// {@macro content_management_tab_changed}
  const ContentManagementTabChanged(this.tab);

  /// The new active tab.
  final ContentManagementTab tab;

  @override
  List<Object?> get props => [tab];
}

/// {@template load_headlines_requested}
/// Event to request loading of headlines.
/// {@endtemplate}
final class LoadHeadlinesRequested extends ContentManagementEvent {
  /// {@macro load_headlines_requested}
  const LoadHeadlinesRequested({this.startAfterId, this.limit});

  /// Optional ID to start pagination after.
  final String? startAfterId;

  /// Optional maximum number of items to return.
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// {@template delete_headline_requested}
/// Event to request deletion of a headline.
/// {@endtemplate}
final class DeleteHeadlineRequested extends ContentManagementEvent {
  /// {@macro delete_headline_requested}
  const DeleteHeadlineRequested(this.id);

  /// The ID of the headline to delete.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// {@template headline_updated}
/// Event to update an existing headline in the local state.
/// {@endtemplate}
final class HeadlineUpdated extends ContentManagementEvent {
  /// {@macro headline_updated}
  const HeadlineUpdated(this.headline);

  /// The headline that was updated.
  final Headline headline;

  @override
  List<Object?> get props => [headline];
}

/// {@template load_topics_requested}
/// Event to request loading of topics.
/// {@endtemplate}
final class LoadTopicsRequested extends ContentManagementEvent {
  /// {@macro load_topics_requested}
  const LoadTopicsRequested({this.startAfterId, this.limit});

  /// Optional ID to start pagination after.
  final String? startAfterId;

  /// Optional maximum number of items to return.
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// {@template delete_topic_requested}
/// Event to request deletion of a topic.
/// {@endtemplate}
final class DeleteTopicRequested extends ContentManagementEvent {
  /// {@macro delete_topic_requested}
  const DeleteTopicRequested(this.id);

  /// The ID of the topic to delete.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// {@template topic_updated}
/// Event to update an existing topic in the local state.
/// {@endtemplate}
final class TopicUpdated extends ContentManagementEvent {
  /// {@macro topic_updated}
  const TopicUpdated(this.topic);

  /// The topic that was updated.
  final Topic topic;

  @override
  List<Object?> get props => [topic];
}

/// {@template load_sources_requested}
/// Event to request loading of sources.
/// {@endtemplate}
final class LoadSourcesRequested extends ContentManagementEvent {
  /// {@macro load_sources_requested}
  const LoadSourcesRequested({this.startAfterId, this.limit});

  /// Optional ID to start pagination after.
  final String? startAfterId;

  /// Optional maximum number of items to return.
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// {@template delete_source_requested}
/// Event to request deletion of a source.
/// {@endtemplate}
final class DeleteSourceRequested extends ContentManagementEvent {
  /// {@macro delete_source_requested}
  const DeleteSourceRequested(this.id);

  /// The ID of the source to delete.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// {@template source_updated}
/// Event to update an existing source in the local state.
/// {@endtemplate}
final class SourceUpdated extends ContentManagementEvent {
  /// {@macro source_updated}
  const SourceUpdated(this.source);

  /// The source that was updated.
  final Source source;

  @override
  List<Object?> get props => [source];
}
