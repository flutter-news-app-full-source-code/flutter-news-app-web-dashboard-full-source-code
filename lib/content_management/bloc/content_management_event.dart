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

/// {@template headline_added}
/// Event to add a new headline to the local state.
/// {@endtemplate}
final class HeadlineAdded extends ContentManagementEvent {
  /// {@macro headline_added}
  const HeadlineAdded(this.headline);

  /// The headline that was added.
  final Headline headline;

  @override
  List<Object?> get props => [headline];
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

/// {@template load_categories_requested}
/// Event to request loading of categories.
/// {@endtemplate}
final class LoadCategoriesRequested extends ContentManagementEvent {
  /// {@macro load_categories_requested}
  const LoadCategoriesRequested({this.startAfterId, this.limit});

  /// Optional ID to start pagination after.
  final String? startAfterId;

  /// Optional maximum number of items to return.
  final int? limit;

  @override
  List<Object?> get props => [startAfterId, limit];
}

/// {@template category_added}
/// Event to add a new category to the local state.
/// {@endtemplate}
final class CategoryAdded extends ContentManagementEvent {
  /// {@macro category_added}
  const CategoryAdded(this.category);

  /// The category that was added.
  final Category category;

  @override
  List<Object?> get props => [category];
}

/// {@template category_updated}
/// Event to update an existing category in the local state.
/// {@endtemplate}
final class CategoryUpdated extends ContentManagementEvent {
  /// {@macro category_updated}
  const CategoryUpdated(this.category);

  /// The category that was updated.
  final Category category;

  @override
  List<Object?> get props => [category];
}

/// {@template delete_category_requested}
/// Event to request deletion of a category.
/// {@endtemplate}
final class DeleteCategoryRequested extends ContentManagementEvent {
  /// {@macro delete_category_requested}
  const DeleteCategoryRequested(this.id);

  /// The ID of the category to delete.
  final String id;

  @override
  List<Object?> get props => [id];
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

/// {@template source_added}
/// Event to add a new source to the local state.
/// {@endtemplate}
final class SourceAdded extends ContentManagementEvent {
  /// {@macro source_added}
  const SourceAdded(this.source);

  /// The source that was added.
  final Source source;

  @override
  List<Object?> get props => [source];
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
