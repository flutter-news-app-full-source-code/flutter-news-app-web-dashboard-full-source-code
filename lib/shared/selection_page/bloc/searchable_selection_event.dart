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

/// Event to set the selected item.
final class SearchableSelectionSetSelectedItem
    extends SearchableSelectionEvent {
  const SearchableSelectionSetSelectedItem(this.item);

  /// The item to set as selected.
  final Object? item;

  @override
  List<Object?> get props => [item];
}
