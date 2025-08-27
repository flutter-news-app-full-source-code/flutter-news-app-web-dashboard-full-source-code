part of 'searchable_paginated_dropdown_bloc.dart';

/// Base class for all events related to the [SearchablePaginatedDropdownBloc].
sealed class SearchablePaginatedDropdownEvent extends Equatable {
  const SearchablePaginatedDropdownEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request initial loading of items or a refresh.
final class SearchablePaginatedDropdownLoadRequested
    extends SearchablePaginatedDropdownEvent {
  const SearchablePaginatedDropdownLoadRequested();
}

/// Event for when the search term changes.
final class SearchablePaginatedDropdownSearchTermChanged
    extends SearchablePaginatedDropdownEvent {
  const SearchablePaginatedDropdownSearchTermChanged(this.searchTerm);

  /// The new search term.
  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}

/// Event to request loading of more items (pagination).
final class SearchablePaginatedDropdownLoadMoreRequested
    extends SearchablePaginatedDropdownEvent {
  const SearchablePaginatedDropdownLoadMoreRequested();
}

/// Event to clear the selected item.
final class SearchablePaginatedDropdownClearSelection
    extends SearchablePaginatedDropdownEvent {
  const SearchablePaginatedDropdownClearSelection();
}
