part of 'searchable_selection_bloc.dart';

/// Base class for all events related to the [SearchableSelectionBloc].
sealed class SearchableSelectionEvent extends Equatable {
  const SearchableSelectionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request initial loading of items or a refresh.
final class SearchableSelectionLoadRequested extends SearchableSelectionEvent {
  const SearchableSelectionLoadRequested();
}

/// Event for when the search term changes.
final class SearchableSelectionSearchTermChanged
    extends SearchableSelectionEvent {
  const SearchableSelectionSearchTermChanged(this.searchTerm);

  /// The new search term.
  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}

/// Event to request loading of more items (pagination).
final class SearchableSelectionLoadMoreRequested
    extends SearchableSelectionEvent {
  const SearchableSelectionLoadMoreRequested();
}

/// Event to set the selected items (for single or multi-selection).
final class SearchableSelectionSetSelectedItems
    extends SearchableSelectionEvent {
  const SearchableSelectionSetSelectedItems(this.items);

  /// The list of items to set as selected.
  final List<Object> items;

  @override
  List<Object?> get props => [items];
}

/// Event to toggle the selection status of a single item.
///
/// Used in multi-select mode to add or remove an item from the selected list.
final class SearchableSelectionToggleItem extends SearchableSelectionEvent {
  const SearchableSelectionToggleItem(this.item);

  /// The item to toggle.
  final Object item;

  @override
  List<Object?> get props => [item];
}
