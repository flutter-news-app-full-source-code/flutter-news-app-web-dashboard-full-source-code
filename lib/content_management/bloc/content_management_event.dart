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

/// {@template create_headline_requested}
/// Event to request creation of a new headline.
/// {@endtemplate}
final class CreateHeadlineRequested extends ContentManagementEvent {
  /// {@macro create_headline_requested}
  const CreateHeadlineRequested(this.headline);

  /// The headline to create.
  final Headline headline;

  @override
  List<Object?> get props => [headline];
}

/// {@template update_headline_requested}
/// Event to request update of an existing headline.
/// {@endtemplate}
final class UpdateHeadlineRequested extends ContentManagementEvent {
  /// {@macro update_headline_requested}
  const UpdateHeadlineRequested({required this.id, required this.headline});

  /// The ID of the headline to update.
  final String id;

  /// The updated headline data.
  final Headline headline;

  @override
  List<Object?> get props => [id, headline];
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

/// {@template create_category_requested}
/// Event to request creation of a new category.
/// {@endtemplate}
final class CreateCategoryRequested extends ContentManagementEvent {
  /// {@macro create_category_requested}
  const CreateCategoryRequested(this.category);

  /// The category to create.
  final Category category;

  @override
  List<Object?> get props => [category];
}

/// {@template update_category_requested}
/// Event to request update of an existing category.
/// {@endtemplate}
final class UpdateCategoryRequested extends ContentManagementEvent {
  /// {@macro update_category_requested}
  const UpdateCategoryRequested({required this.id, required this.category});

  /// The ID of the category to update.
  final String id;

  /// The updated category data.
  final Category category;

  @override
  List<Object?> get props => [id, category];
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

/// {@template create_source_requested}
/// Event to request creation of a new source.
/// {@endtemplate}
final class CreateSourceRequested extends ContentManagementEvent {
  /// {@macro create_source_requested}
  const CreateSourceRequested(this.source);

  /// The source to create.
  final Source source;

  @override
  List<Object?> get props => [source];
}

/// {@template update_source_requested}
/// Event to request update of an existing source.
/// {@endtemplate}
final class UpdateSourceRequested extends ContentManagementEvent {
  /// {@macro update_source_requested}
  const UpdateSourceRequested({required this.id, required this.source});

  /// The ID of the source to update.
  final String id;

  /// The updated source data.
  final Source source;

  @override
  List<Object?> get props => [id, source];
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
