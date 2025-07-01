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
    this.categoriesStatus = ContentManagementStatus.initial,
    this.categories = const [],
    this.categoriesCursor,
    this.categoriesHasMore = false,
    this.sourcesStatus = ContentManagementStatus.initial,
    this.sources = const [],
    this.sourcesCursor,
    this.sourcesHasMore = false,
    this.errorMessage,
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

  /// Status of category data operations.
  final ContentManagementStatus categoriesStatus;

  /// List of categories.
  final List<Category> categories;

  /// Cursor for category pagination.
  final String? categoriesCursor;

  /// Indicates if there are more categories to load.
  final bool categoriesHasMore;

  /// Status of source data operations.
  final ContentManagementStatus sourcesStatus;

  /// List of sources.
  final List<Source> sources;

  /// Cursor for source pagination.
  final String? sourcesCursor;

  /// Indicates if there are more sources to load.
  final bool sourcesHasMore;

  /// Error message if an operation fails.
  final String? errorMessage;

  /// Creates a copy of this [ContentManagementState] with updated values.
  ContentManagementState copyWith({
    ContentManagementTab? activeTab,
    ContentManagementStatus? headlinesStatus,
    List<Headline>? headlines,
    String? headlinesCursor,
    bool? headlinesHasMore,
    ContentManagementStatus? categoriesStatus,
    List<Category>? categories,
    String? categoriesCursor,
    bool? categoriesHasMore,
    ContentManagementStatus? sourcesStatus,
    List<Source>? sources,
    String? sourcesCursor,
    bool? sourcesHasMore,
    String? errorMessage,
  }) {
    return ContentManagementState(
      activeTab: activeTab ?? this.activeTab,
      headlinesStatus: headlinesStatus ?? this.headlinesStatus,
      headlines: headlines ?? this.headlines,
      headlinesCursor: headlinesCursor ?? this.headlinesCursor,
      headlinesHasMore: headlinesHasMore ?? this.headlinesHasMore,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      categoriesCursor: categoriesCursor ?? this.categoriesCursor,
      categoriesHasMore: categoriesHasMore ?? this.categoriesHasMore,
      sourcesStatus: sourcesStatus ?? this.sourcesStatus,
      sources: sources ?? this.sources,
      sourcesCursor: sourcesCursor ?? this.sourcesCursor,
      sourcesHasMore: sourcesHasMore ?? this.sourcesHasMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
        headlinesStatus,
        headlines,
        headlinesCursor,
        headlinesHasMore,
        categoriesStatus,
        categories,
        categoriesCursor,
        categoriesHasMore,
        sourcesStatus,
        sources,
        sourcesCursor,
        sourcesHasMore,
        errorMessage,
      ];
}
