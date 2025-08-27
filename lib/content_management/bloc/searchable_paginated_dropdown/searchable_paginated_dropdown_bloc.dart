import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

part 'searchable_paginated_dropdown_event.dart';
part 'searchable_paginated_dropdown_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

/// {@template searchable_paginated_dropdown_bloc}
/// A BLoC to manage the state of a searchable, paginated dropdown.
///
/// This BLoC handles fetching data from a [DataRepository], applying search
/// filters with debouncing, and managing pagination.
/// {@endtemplate}
class SearchablePaginatedDropdownBloc<T extends Equatable>
    extends
        Bloc<
          SearchablePaginatedDropdownEvent,
          SearchablePaginatedDropdownState<T>
        > {
  /// {@macro searchable_paginated_dropdown_bloc}
  SearchablePaginatedDropdownBloc({
    required DataRepository<T> repository,
    required Map<String, dynamic> Function(String? searchTerm) filterBuilder,
    required List<SortOption> sortOptions,
    required int limit,
    T? initialSelectedItem,
  }) : _repository = repository,
       _filterBuilder = filterBuilder,
       _sortOptions = sortOptions,
       _limit = limit,
       super(
         SearchablePaginatedDropdownState(
           selectedItem: initialSelectedItem,
         ),
       ) {
    on<SearchablePaginatedDropdownLoadRequested>(
      _onLoadRequested,
      transformer: restartable(),
    );
    on<SearchablePaginatedDropdownSearchTermChanged>(
      _onSearchTermChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<SearchablePaginatedDropdownLoadMoreRequested>(
      _onLoadMoreRequested,
      transformer: sequential(),
    );
    on<SearchablePaginatedDropdownClearSelection>(_onClearSelection);

    // Initial load
    add(const SearchablePaginatedDropdownLoadRequested());
  }

  final DataRepository<T> _repository;
  final Map<String, dynamic> Function(String? searchTerm) _filterBuilder;
  final List<SortOption> _sortOptions;
  final int _limit;

  Future<void> _onLoadRequested(
    SearchablePaginatedDropdownLoadRequested event,
    Emitter<SearchablePaginatedDropdownState<T>> emit,
  ) async {
    emit(state.copyWith(status: SearchablePaginatedDropdownStatus.loading));
    try {
      final filter = _filterBuilder(
        state.searchTerm.isEmpty ? null : state.searchTerm,
      );
      final response = await _repository.readAll(
        filter: filter,
        sort: _sortOptions,
        pagination: PaginationOptions(limit: _limit),
      );

      emit(
        state.copyWith(
          status: SearchablePaginatedDropdownStatus.success,
          items: response.items,
          cursor: response.cursor,
          hasMore: response.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: SearchablePaginatedDropdownStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchablePaginatedDropdownStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onSearchTermChanged(
    SearchablePaginatedDropdownSearchTermChanged event,
    Emitter<SearchablePaginatedDropdownState<T>> emit,
  ) async {
    emit(
      state.copyWith(
        searchTerm: event.searchTerm,
        items: [], // Clear items on new search
        cursor: null, // Reset cursor
        hasMore: true, // Assume more results
        status: SearchablePaginatedDropdownStatus.loading,
      ),
    );
    // Trigger a new load request with the updated search term
    add(const SearchablePaginatedDropdownLoadRequested());
  }

  Future<void> _onLoadMoreRequested(
    SearchablePaginatedDropdownLoadMoreRequested event,
    Emitter<SearchablePaginatedDropdownState<T>> emit,
  ) async {
    if (!state.hasMore ||
        state.status == SearchablePaginatedDropdownStatus.loading) {
      return;
    }

    emit(state.copyWith(status: SearchablePaginatedDropdownStatus.loading));
    try {
      final filter = _filterBuilder(
        state.searchTerm.isEmpty ? null : state.searchTerm,
      );
      final response = await _repository.readAll(
        filter: filter,
        sort: _sortOptions,
        pagination: PaginationOptions(cursor: state.cursor, limit: _limit),
      );

      emit(
        state.copyWith(
          status: SearchablePaginatedDropdownStatus.success,
          items: [...state.items, ...response.items],
          cursor: response.cursor,
          hasMore: response.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: SearchablePaginatedDropdownStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchablePaginatedDropdownStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onClearSelection(
    SearchablePaginatedDropdownClearSelection event,
    Emitter<SearchablePaginatedDropdownState<T>> emit,
  ) {
    emit(state.copyWith(selectedItem: () => null));
  }
}
