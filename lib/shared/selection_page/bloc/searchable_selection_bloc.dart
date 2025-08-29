import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/selection_page/selection_page_arguments.dart';
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
           selectedItem: arguments.initialSelectedItem,
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
    on<SearchableSelectionSetSelectedItem>(_onSetSelectedItem);

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
      if (_arguments.staticItems != null) {
        // Handle static items
        final filteredItems = _arguments.staticItems!
            .where(
              (item) => _arguments
                  .itemToString(item)
                  .toLowerCase()
                  .contains(
                    state.searchTerm.toLowerCase(),
                  ),
            )
            .toList();
        emit(
          state.copyWith(
            status: SearchableSelectionStatus.success,
            items: filteredItems,
            hasMore: false,
          ),
        );
      } else if (_arguments.repository != null) {
        // Handle repository-fetched items
        final filter = _arguments.filterBuilder!(
          state.searchTerm.isEmpty ? null : state.searchTerm,
        );
        final response = await (_arguments.repository!).readAll(
          filter: filter,
          sort: _arguments.sortOptions,
          pagination: PaginationOptions(limit: _arguments.limit),
        );

        emit(
          state.copyWith(
            status: SearchableSelectionStatus.success,
            items: response.items,
            cursor: response.cursor,
            hasMore: response.hasMore,
          ),
        );
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
      }
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
      return; // No more items, already loading, or static list
    }

    emit(state.copyWith(status: SearchableSelectionStatus.loading));
    try {
      final filter = _arguments.filterBuilder!(
        state.searchTerm.isEmpty ? null : state.searchTerm,
      );
      final response = await (_arguments.repository!).readAll(
        filter: filter,
        sort: _arguments.sortOptions,
        pagination: PaginationOptions(
          cursor: state.cursor,
          limit: _arguments.limit,
        ),
      );

      emit(
        state.copyWith(
          status: SearchableSelectionStatus.success,
          items: [...state.items, ...response.items],
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

  void _onSetSelectedItem(
    SearchableSelectionSetSelectedItem event,
    Emitter<SearchableSelectionState> emit,
  ) {
    emit(state.copyWith(selectedItem: () => event.item));
  }
}
