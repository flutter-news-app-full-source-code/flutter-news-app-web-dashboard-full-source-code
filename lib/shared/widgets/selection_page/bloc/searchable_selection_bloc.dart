import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/selection_page/selection_page_arguments.dart';
import 'package:rxdart/rxdart.dart';

part 'searchable_selection_event.dart';
part 'searchable_selection_state.dart';

/// A transformer to debounce events, typically used for search input.
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

/// {@template searchable_selection_bloc}
/// A BLoC to manage the state of a generic searchable selection page.
///
/// This BLoC handles fetching data from a [DataRepository] or a static list,
/// applying search filters with debouncing, and managing pagination.
/// It supports both single and multi-selection modes.
///
/// Note: This BLoC operates on [Object] due to GoRouter's limitations with
/// passing generic types. Items are expected to be cast to their specific
/// types at the UI layer using the `itemType` from [SelectionPageArguments].
/// {@endtemplate}
class SearchableSelectionBloc
    extends Bloc<SearchableSelectionEvent, SearchableSelectionState> {
  /// {@macro searchable_selection_bloc}
  SearchableSelectionBloc({
    required SelectionPageArguments arguments,
  }) : _arguments = arguments,
       super(
         SearchableSelectionState(
           selectedItems: arguments.initialSelectedItems ?? const [],
         ),
       ) {
    on<SearchableSelectionLoadRequested>(
      _onLoadRequested,
      transformer: restartable(),
    );
    on<SearchableSelectionSearchTermChanged>(
      _onSearchTermChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<SearchableSelectionLoadMoreRequested>(
      _onLoadMoreRequested,
      transformer: sequential(),
    );
    on<SearchableSelectionSetSelectedItems>(_onSetSelectedItems);
    on<SearchableSelectionToggleItem>(_onToggleItem);

    // Initial load
    add(const SearchableSelectionLoadRequested());
  }

  final SelectionPageArguments _arguments;

  Future<void> _onLoadRequested(
    SearchableSelectionLoadRequested event,
    Emitter<SearchableSelectionState> emit,
  ) async {
    emit(state.copyWith(status: SearchableSelectionStatus.loading));
    try {
      var fetchedItems = <Object>[];
      var hasMore = false;
      String? cursor;

      if (_arguments.staticItems != null) {
        // Handle static items
        fetchedItems = _arguments.staticItems!
            .where(
              (item) => _arguments
                  .itemToString(item)
                  .toLowerCase()
                  .contains(
                    state.searchTerm.toLowerCase(),
                  ),
            )
            .toList();
        hasMore = false;
      } else if (_arguments.repository != null) {
        // Handle repository-fetched items
        final baseFilter = _arguments.filterBuilder!(
          state.searchTerm.isEmpty ? null : state.searchTerm,
        );

        // Apply default filter for active items unless includeInactiveSelectedItem is true
        final finalFilter = _arguments.includeInactiveSelectedItem
            ? baseFilter
            : {
                ...baseFilter,
                'status': ContentStatus.active.name,
              };

        final response = await (_arguments.repository!).readAll(
          filter: finalFilter,
          sort: _arguments.sortOptions,
          pagination: const PaginationOptions(
            limit: 20,
          ), // Do not lower it below 20 for the initial fetch, if the list items did not reach the bottom of the screen, the infinity scrolling will not function.
        );

        fetchedItems = response.items;
        cursor = response.cursor;
        hasMore = response.hasMore;

        // If includeInactiveSelectedItem is true and initialSelectedItems are provided,
        // ensure they are in the list, even if they don't match the current filter.
        if (_arguments.includeInactiveSelectedItem &&
            _arguments.initialSelectedItems != null &&
            _arguments.initialSelectedItems!.isNotEmpty) {
          final itemsToAdd = _arguments.initialSelectedItems!
              .where((item) => !fetchedItems.contains(item))
              .toList();
          fetchedItems = [...itemsToAdd, ...fetchedItems];
        }
      } else {
        // This case should ideally not be reached due to the assert in arguments
        emit(
          state.copyWith(
            status: SearchableSelectionStatus.failure,
            exception: const UnknownException(
              'Invalid arguments: No data source provided.',
            ),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: SearchableSelectionStatus.success,
          items: fetchedItems,
          cursor: cursor,
          hasMore: hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: SearchableSelectionStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchableSelectionStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onSearchTermChanged(
    SearchableSelectionSearchTermChanged event,
    Emitter<SearchableSelectionState> emit,
  ) {
    emit(
      state.copyWith(
        searchTerm: event.searchTerm,
        items: [],
        cursor: null,
        hasMore: true,
        status: SearchableSelectionStatus.loading,
      ),
    );
    // Trigger a new load request with the updated search term
    add(const SearchableSelectionLoadRequested());
  }

  Future<void> _onLoadMoreRequested(
    SearchableSelectionLoadMoreRequested event,
    Emitter<SearchableSelectionState> emit,
  ) async {
    if (!state.hasMore ||
        state.status == SearchableSelectionStatus.loading ||
        _arguments.staticItems != null) {
      return;
    }

    emit(state.copyWith(status: SearchableSelectionStatus.loading));
    try {
      final baseFilter = _arguments.filterBuilder!(
        state.searchTerm.isEmpty ? null : state.searchTerm,
      );

      // Apply default filter for active items unless includeInactiveSelectedItem is true
      final finalFilter = _arguments.includeInactiveSelectedItem
          ? baseFilter
          : {
              ...baseFilter,
              'status': ContentStatus.active.name,
            };

      final response = await (_arguments.repository!).readAll(
        filter: finalFilter,
        sort: _arguments.sortOptions,
        pagination: PaginationOptions(
          cursor: state.cursor,
          limit: _arguments.limit,
        ),
      );

      var newItems = <Object>[...state.items, ...response.items];

      // If includeInactiveSelectedItem is true and initialSelectedItems are provided,
      // ensure they are in the list, even if they don't match the current filter.
      // This check is only needed if they weren't already added in the initial load.
      if (_arguments.includeInactiveSelectedItem &&
          _arguments.initialSelectedItems != null &&
          _arguments.initialSelectedItems!.isNotEmpty) {
        final itemsToAdd = _arguments.initialSelectedItems!
            .where((item) => !newItems.contains(item))
            .toList();
        newItems = [...itemsToAdd, ...newItems];
      }

      emit(
        state.copyWith(
          status: SearchableSelectionStatus.success,
          items: newItems,
          cursor: response.cursor,
          hasMore: response.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: SearchableSelectionStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchableSelectionStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles setting the list of selected items.
  void _onSetSelectedItems(
    SearchableSelectionSetSelectedItems event,
    Emitter<SearchableSelectionState> emit,
  ) {
    emit(state.copyWith(selectedItems: event.items));
  }

  /// Handles toggling a single item's selection status.
  ///
  /// This is used in multi-select mode to add or remove an item from the
  /// currently selected list.
  void _onToggleItem(
    SearchableSelectionToggleItem event,
    Emitter<SearchableSelectionState> emit,
  ) {
    final currentSelectedItems = List<Object>.from(state.selectedItems);
    if (currentSelectedItems.contains(event.item)) {
      currentSelectedItems.remove(event.item);
    } else {
      currentSelectedItems.add(event.item);
    }
    emit(state.copyWith(selectedItems: currentSelectedItems));
  }
}
