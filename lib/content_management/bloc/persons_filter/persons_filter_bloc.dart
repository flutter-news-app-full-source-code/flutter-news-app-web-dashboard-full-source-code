import 'package:bloc/bloc.dart';

import 'package:verity_dashboard/content_management/bloc/persons_filter/persons_filter_event.dart';
import 'package:verity_dashboard/content_management/bloc/persons_filter/persons_filter_state.dart';

/// {@template persons_filter_bloc}
/// A BLoC that manages the state of the persons filter UI.
///
/// It handles user input for search queries and status selections, and builds
/// a filter map to be used by the data-fetching BLoC. Filters are applied
/// only when explicitly requested via [PersonsFilterApplied].
/// {@endtemplate}
class PersonsFilterBloc extends Bloc<PersonsFilterEvent, PersonsFilterState> {
  /// {@macro persons_filter_bloc}
  PersonsFilterBloc() : super(const PersonsFilterState()) {
    on<PersonsSearchQueryChanged>(_onSearchQueryChanged);
    on<PersonsStatusFilterChanged>(_onStatusFilterChanged);
    on<PersonsFilterApplied>(_onFilterApplied);
    on<PersonsFilterReset>(_onFilterReset);
  }

  void _onSearchQueryChanged(
    PersonsSearchQueryChanged event,
    Emitter<PersonsFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onStatusFilterChanged(
    PersonsStatusFilterChanged event,
    Emitter<PersonsFilterState> emit,
  ) {
    emit(state.copyWith(selectedStatus: event.status));
  }

  void _onFilterApplied(
    PersonsFilterApplied event,
    Emitter<PersonsFilterState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.searchQuery,
        selectedStatus: event.selectedStatus,
      ),
    );
  }

  void _onFilterReset(
    PersonsFilterReset event,
    Emitter<PersonsFilterState> emit,
  ) {
    emit(const PersonsFilterState());
  }

  /// Builds the filter map for the data repository query.
  Map<String, dynamic> buildFilterMap() {
    final filter = <String, dynamic>{'status': state.selectedStatus.name};
    if (state.searchQuery.isNotEmpty) filter['q'] = state.searchQuery;
    return filter;
  }
}
