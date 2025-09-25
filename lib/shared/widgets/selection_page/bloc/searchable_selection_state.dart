part of 'searchable_selection_bloc.dart';

/// Represents the status of the selection page's data fetching operation.
enum SearchableSelectionStatus {
  /// Initial state, no data loaded.
  initial,

  /// Data is currently being loaded.
  loading,

  /// Data has been successfully loaded.
  success,

  /// An error occurred during data loading.
  failure,
}

/// {@template searchable_selection_state}
/// The state for the [SearchableSelectionBloc].
/// {@endtemplate}
final class SearchableSelectionState extends Equatable {
  /// {@macro searchable_selection_state}
  const SearchableSelectionState({
    this.status = SearchableSelectionStatus.initial,
    this.items = const [],
    this.selectedItems = const [],
    this.searchTerm = '',
    this.cursor,
    this.hasMore = true,
    this.exception,
  });

  /// The current status of the data fetching operation.
  final SearchableSelectionStatus status;

  /// The list of currently loaded items.
  final List<Object> items;

  /// The currently selected items.
  final List<Object> selectedItems;

  /// The current search term applied to the items.
  final String searchTerm;

  /// The cursor for pagination, indicating where to start fetching the next page.
  final String? cursor;

  /// Indicates if there are more items to load.
  final bool hasMore;

  /// The exception that occurred during a failed operation, if any.
  final HttpException? exception;

  /// Creates a copy of this [SearchableSelectionState] with updated values.
  SearchableSelectionState copyWith({
    SearchableSelectionStatus? status,
    List<Object>? items,
    List<Object>? selectedItems,
    String? searchTerm,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
  }) {
    return SearchableSelectionState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedItems: selectedItems ?? this.selectedItems,
      searchTerm: searchTerm ?? this.searchTerm,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      exception: exception,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    selectedItems,
    searchTerm,
    cursor,
    hasMore,
    exception,
  ];
}
