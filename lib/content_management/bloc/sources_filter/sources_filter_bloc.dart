import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'sources_filter_event.dart';
part 'sources_filter_state.dart';

/// {@template sources_filter_bloc}
/// A BLoC that manages the state of the sources filter UI.
///
/// It handles user input for search queries, status selections, and other
/// filter criteria, and builds a filter map to be used by the data-fetching BLoC.
/// Filters are applied only when explicitly requested via [SourcesFilterApplied].
/// {@endtemplate}
class SourcesFilterBloc extends Bloc<SourcesFilterEvent, SourcesFilterState> {
  /// {@macro sources_filter_bloc}
  SourcesFilterBloc() : super(const SourcesFilterState()) {
    on<SourcesSearchQueryChanged>(_onSourcesSearchQueryChanged);
    on<SourcesStatusFilterChanged>(_onSourcesStatusFilterChanged);
    on<SourcesSourceTypeFilterChanged>(_onSourcesSourceTypeFilterChanged);
    on<SourcesLanguageFilterChanged>(_onSourcesLanguageFilterChanged);
    on<SourcesHeadquartersFilterChanged>(_onSourcesHeadquartersFilterChanged);
    on<SourcesFilterApplied>(_onSourcesFilterApplied);
    on<SourcesFilterReset>(_onSourcesFilterReset);
  }

  /// Handles changes to the search query text field.
  void _onSourcesSearchQueryChanged(
    SourcesSearchQueryChanged event,
    Emitter<SourcesFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Handles changes to the selected content status.
  ///
  /// This updates the single selected status for the filter.
  void _onSourcesStatusFilterChanged(
    SourcesStatusFilterChanged event,
    Emitter<SourcesFilterState> emit,
  ) {
    emit(state.copyWith(selectedStatus: event.status));
  }

  /// Handles changes to the selected source types.
  ///
  /// This updates the list of source types for the filter.
  void _onSourcesSourceTypeFilterChanged(
    SourcesSourceTypeFilterChanged event,
    Emitter<SourcesFilterState> emit,
  ) {
    emit(state.copyWith(selectedSourceTypes: event.sourceTypes));
  }

  /// Handles changes to the selected language codes.
  ///
  /// This updates the list of language codes for the filter.
  void _onSourcesLanguageFilterChanged(
    SourcesLanguageFilterChanged event,
    Emitter<SourcesFilterState> emit,
  ) {
    emit(state.copyWith(selectedLanguageCodes: event.languageCodes));
  }

  /// Handles changes to the selected headquarters country IDs.
  ///
  /// This updates the list of headquarters country IDs for the filter.
  void _onSourcesHeadquartersFilterChanged(
    SourcesHeadquartersFilterChanged event,
    Emitter<SourcesFilterState> emit,
  ) {
    emit(state.copyWith(selectedHeadquartersCountryIds: event.countryIds));
  }

  /// Handles the application of all current filter settings.
  ///
  /// This event is dispatched when the user explicitly confirms the filters
  /// (e.g., by clicking an "Apply" button). It updates the BLoC's state
  /// with the final filter values.
  void _onSourcesFilterApplied(
    SourcesFilterApplied event,
    Emitter<SourcesFilterState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.searchQuery,
        selectedStatus: event.selectedStatus,
        selectedSourceTypes: event.selectedSourceTypes,
        selectedLanguageCodes: event.selectedLanguageCodes,
        selectedHeadquartersCountryIds: event.selectedHeadquartersCountryIds,
      ),
    );
  }

  /// Handles the request to reset all filters to their initial state.
  void _onSourcesFilterReset(
    SourcesFilterReset event,
    Emitter<SourcesFilterState> emit,
  ) {
    emit(const SourcesFilterState());
  }

  /// Builds the filter map for the data repository query.
  Map<String, dynamic> buildFilterMap() {
    final filter = <String, dynamic>{'status': state.selectedStatus.name};

    if (state.searchQuery.isNotEmpty) {
      filter[r'$or'] = [
        {
          'name': {r'$regex': state.searchQuery, r'$options': 'i'},
        },
        {'_id': state.searchQuery},
      ];
    }

    if (state.selectedSourceTypes.isNotEmpty) {
      filter['sourceType'] = {
        r'$in': state.selectedSourceTypes.map((t) => t.name).toList(),
      };
    }
    if (state.selectedLanguageCodes.isNotEmpty) {
      filter['language.code'] = {r'$in': state.selectedLanguageCodes};
    }
    if (state.selectedHeadquartersCountryIds.isNotEmpty) {
      filter['headquarters.id'] = {
        r'$in': state.selectedHeadquartersCountryIds,
      };
    }
    return filter;
  }
}
