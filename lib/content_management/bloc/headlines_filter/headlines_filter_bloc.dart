import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/models/breaking_news_filter_status.dart';

part 'headlines_filter_event.dart';
part 'headlines_filter_state.dart';

/// {@template headlines_filter_bloc}
/// A BLoC that manages the state of the headlines filter UI.
///
/// It handles user input for search queries, status selections, and other
/// filter criteria, and builds a filter map to be used by the data-fetching BLoC.
/// Filters are applied only when explicitly requested via [HeadlinesFilterApplied].
/// {@endtemplate}
class HeadlinesFilterBloc
    extends Bloc<HeadlinesFilterEvent, HeadlinesFilterState> {
  /// {@macro headlines_filter_bloc}
  HeadlinesFilterBloc() : super(const HeadlinesFilterState()) {
    on<HeadlinesSearchQueryChanged>(_onHeadlinesSearchQueryChanged);
    on<HeadlinesStatusFilterChanged>(_onHeadlinesStatusFilterChanged);
    on<HeadlinesSourceFilterChanged>(_onHeadlinesSourceFilterChanged);
    on<HeadlinesTopicFilterChanged>(_onHeadlinesTopicFilterChanged);
    on<HeadlinesCountryFilterChanged>(_onHeadlinesCountryFilterChanged);
    on<HeadlinesBreakingNewsFilterChanged>(
      _onHeadlinesBreakingNewsFilterChanged,
    );
    on<HeadlinesFilterApplied>(_onHeadlinesFilterApplied);
    on<HeadlinesFilterReset>(_onHeadlinesFilterReset);
  }

  /// Handles changes to the search query text field.
  void _onHeadlinesSearchQueryChanged(
    HeadlinesSearchQueryChanged event,
    Emitter<HeadlinesFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Handles changes to the selected content status.
  ///
  /// This updates the single selected status for the filter.
  void _onHeadlinesStatusFilterChanged(
    HeadlinesStatusFilterChanged event,
    Emitter<HeadlinesFilterState> emit,
  ) {
    emit(state.copyWith(selectedStatus: event.status));
  }

  /// Handles changes to the selected source IDs.
  ///
  /// This updates the list of source IDs for the filter.
  void _onHeadlinesSourceFilterChanged(
    HeadlinesSourceFilterChanged event,
    Emitter<HeadlinesFilterState> emit,
  ) {
    emit(state.copyWith(selectedSourceIds: event.sourceIds));
  }

  /// Handles changes to the selected topic IDs.
  ///
  /// This updates the list of topic IDs for the filter.
  void _onHeadlinesTopicFilterChanged(
    HeadlinesTopicFilterChanged event,
    Emitter<HeadlinesFilterState> emit,
  ) {
    emit(state.copyWith(selectedTopicIds: event.topicIds));
  }

  /// Handles changes to the selected country IDs.
  ///
  /// This updates the list of country IDs for the filter.
  void _onHeadlinesCountryFilterChanged(
    HeadlinesCountryFilterChanged event,
    Emitter<HeadlinesFilterState> emit,
  ) {
    emit(state.copyWith(selectedCountryIds: event.countryIds));
  }

  /// Handles changes to the breaking news filter.
  ///
  /// This updates the `isBreaking` status for the filter using the
  /// [BreakingNewsFilterStatus] enum.
  void _onHeadlinesBreakingNewsFilterChanged(
    HeadlinesBreakingNewsFilterChanged event,
    Emitter<HeadlinesFilterState> emit,
  ) {
    emit(state.copyWith(isBreaking: event.isBreaking));
  }

  /// Handles the application of all current filter settings.
  ///
  /// This event is dispatched when the user explicitly confirms the filters
  /// (e.g., by clicking an "Apply" button). It updates the BLoC's state
  /// with the final filter values.
  void _onHeadlinesFilterApplied(
    HeadlinesFilterApplied event,
    Emitter<HeadlinesFilterState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.searchQuery,
        selectedStatus: event.selectedStatus,
        selectedSourceIds: event.selectedSourceIds,
        selectedTopicIds: event.selectedTopicIds,
        selectedCountryIds: event.selectedCountryIds,
        isBreaking: event.isBreaking,
      ),
    );
  }

  /// Handles the request to reset all filters to their initial state.
  void _onHeadlinesFilterReset(
    HeadlinesFilterReset event,
    Emitter<HeadlinesFilterState> emit,
  ) {
    emit(const HeadlinesFilterState());
  }
}
