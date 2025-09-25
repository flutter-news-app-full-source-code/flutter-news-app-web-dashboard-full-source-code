import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'topics_filter_event.dart';
part 'topics_filter_state.dart';

/// {@template topics_filter_bloc}
/// A BLoC that manages the state of the topics filter UI.
///
/// It handles user input for search queries and status selections,
/// and builds a filter map to be used by the data-fetching BLoC.
/// Filters are applied only when explicitly requested via [TopicsFilterApplied].
/// {@endtemplate}
class TopicsFilterBloc extends Bloc<TopicsFilterEvent, TopicsFilterState> {
  /// {@macro topics_filter_bloc}
  TopicsFilterBloc() : super(const TopicsFilterState()) {
    on<TopicsSearchQueryChanged>(_onTopicsSearchQueryChanged);
    on<TopicsStatusFilterChanged>(_onTopicsStatusFilterChanged);
    on<TopicsFilterApplied>(_onTopicsFilterApplied);
    on<TopicsFilterReset>(_onTopicsFilterReset);
  }

  /// Handles changes to the search query text field.
  void _onTopicsSearchQueryChanged(
    TopicsSearchQueryChanged event,
    Emitter<TopicsFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Handles changes to the selected content status.
  ///
  /// This updates the single selected status for the filter.
  void _onTopicsStatusFilterChanged(
    TopicsStatusFilterChanged event,
    Emitter<TopicsFilterState> emit,
  ) {
    emit(state.copyWith(selectedStatus: event.status));
  }

  /// Handles the application of all current filter settings.
  ///
  /// This event is dispatched when the user explicitly confirms the filters
  /// (e.g., by clicking an "Apply" button). It updates the BLoC's state
  /// with the final filter values.
  void _onTopicsFilterApplied(
    TopicsFilterApplied event,
    Emitter<TopicsFilterState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.searchQuery,
        selectedStatus: event.selectedStatus,
      ),
    );
  }

  /// Handles the request to reset all filters to their initial state.
  void _onTopicsFilterReset(
    TopicsFilterReset event,
    Emitter<TopicsFilterState> emit,
  ) {
    emit(const TopicsFilterState());
  }
}
