import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'filter_local_ads_event.dart';
part 'filter_local_ads_state.dart';

/// A transformer to debounce events, typically used for search input.
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

/// {@template filter_local_ads_bloc}
/// A BLoC that manages the state of the local ads filter UI.
///
/// It handles user input for search queries, status selections, and ad type
/// criteria, and builds a filter map to be used by the data-fetching BLoC.
/// Filters are applied only when explicitly requested via [FilterLocalAdsApplied].
/// {@endtemplate}
class FilterLocalAdsBloc
    extends Bloc<FilterLocalAdsEvent, FilterLocalAdsState> {
  /// {@macro filter_local_ads_bloc}
  FilterLocalAdsBloc() : super(const FilterLocalAdsState()) {
    on<FilterLocalAdsSearchQueryChanged>(
      _onFilterLocalAdsSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<FilterLocalAdsStatusChanged>(_onFilterLocalAdsStatusChanged);
    on<FilterLocalAdsAdTypeChanged>(_onFilterLocalAdsAdTypeChanged);
    on<FilterLocalAdsApplied>(_onFilterLocalAdsApplied);
    on<FilterLocalAdsReset>(_onFilterLocalAdsReset);
  }

  /// Handles changes to the search query text field.
  void _onFilterLocalAdsSearchQueryChanged(
    FilterLocalAdsSearchQueryChanged event,
    Emitter<FilterLocalAdsState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Handles changes to the selected content status.
  ///
  /// This updates the single selected status for the filter.
  void _onFilterLocalAdsStatusChanged(
    FilterLocalAdsStatusChanged event,
    Emitter<FilterLocalAdsState> emit,
  ) {
    emit(state.copyWith(selectedStatus: event.status));
  }

  /// Handles changes to the selected ad type.
  ///
  /// This updates the single selected ad type for the filter.
  void _onFilterLocalAdsAdTypeChanged(
    FilterLocalAdsAdTypeChanged event,
    Emitter<FilterLocalAdsState> emit,
  ) {
    emit(state.copyWith(selectedAdType: event.adType));
  }

  /// Handles the application of all current filter settings.
  ///
  /// This event is dispatched when the user explicitly confirms the filters
  /// (e.g., by clicking an "Apply" button). It updates the BLoC's state
  /// with the final filter values.
  void _onFilterLocalAdsApplied(
    FilterLocalAdsApplied event,
    Emitter<FilterLocalAdsState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.searchQuery,
        selectedStatus: event.selectedStatus,
        selectedAdType: event.selectedAdType,
      ),
    );
  }

  /// Handles the request to reset all filters to their initial state.
  void _onFilterLocalAdsReset(
    FilterLocalAdsReset event,
    Emitter<FilterLocalAdsState> emit,
  ) {
    emit(const FilterLocalAdsState());
  }
}
