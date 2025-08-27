part of 'searchable_paginated_dropdown_bloc.dart';

/// Represents the status of the dropdown's data fetching operation.
enum SearchablePaginatedDropdownStatus {
  /// Initial state, no data loaded.
  initial,

  /// Data is currently being loaded.
  loading,

  /// Data has been successfully loaded.
  success,

  /// An error occurred during data loading.
  failure,
}

/// {@template searchable_paginated_dropdown_state}
/// The state for the [SearchablePaginatedDropdownBloc].
/// {@endtemplate}
final class SearchablePaginatedDropdownState<T extends Equatable>
    extends Equatable {
  /// {@macro searchable_paginated_dropdown_state}
  const SearchablePaginatedDropdownState({
    this.status = SearchablePaginatedDropdownStatus.initial,
    this.items = const [],
    this.selectedItem,
    this.searchTerm = '',
    this.cursor,
    this.hasMore = true,
    this.exception,
  });

  /// The current status of the data fetching operation.
  final SearchablePaginatedDropdownStatus status;

  /// The list of currently loaded items.
  final List<T> items;

  /// The currently selected item in the dropdown.
  final T? selectedItem;

  /// The current search term applied to the items.
  final String searchTerm;

  /// The cursor for pagination, indicating where to start fetching the next page.
  final String? cursor;

  /// Indicates if there are more items to load.
  final bool hasMore;

  /// The exception that occurred during a failed operation, if any.
  final HttpException? exception;

  /// Creates a copy of this [SearchablePaginatedDropdownState] with updated values.
  SearchablePaginatedDropdownState<T> copyWith({
    SearchablePaginatedDropdownStatus? status,
    List<T>? items,
    ValueGetter<T?>? selectedItem,
    String? searchTerm,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
  }) {
    return SearchablePaginatedDropdownState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedItem: selectedItem != null ? selectedItem() : this.selectedItem,
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
    selectedItem,
    searchTerm,
    cursor,
    hasMore,
    exception,
  ];
}
