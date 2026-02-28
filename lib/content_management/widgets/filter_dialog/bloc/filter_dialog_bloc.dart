import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/sources_filter/sources_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/topics_filter/topics_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/widgets/filter_dialog/filter_dialog.dart'
    show FilterDialog;
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/constants.dart';
import 'package:rxdart/rxdart.dart';

part 'filter_dialog_event.dart';
part 'filter_dialog_state.dart';

/// A transformer to debounce events, typically used for search input.
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

/// {@template filter_dialog_bloc}
/// A BLoC that manages the state and logic for the [FilterDialog].
///
/// This BLoC handles the temporary filter selections, fetches available
/// filter options (sources, topics, countries, languages), and provides
/// the necessary state for the UI to render the filter dialog.
/// {@endtemplate}
class FilterDialogBloc extends Bloc<FilterDialogEvent, FilterDialogState> {
  /// {@macro filter_dialog_bloc}
  FilterDialogBloc({
    required DataRepository<Source> sourcesRepository,
    required DataRepository<Topic> topicsRepository,
    required DataRepository<Country> countriesRepository,
    required DataRepository<Language> languagesRepository,
    required ContentManagementTab activeTab,
  }) : _sourcesRepository = sourcesRepository,
       _topicsRepository = topicsRepository,
       _countriesRepository = countriesRepository,
       _languagesRepository = languagesRepository,
       super(FilterDialogState(activeTab: activeTab)) {
    on<FilterDialogInitialized>(_onFilterDialogInitialized);
    on<FilterOptionsLoadRequested>(
      _onFilterOptionsLoadRequested,
      transformer: restartable(),
    );
    on<FilterDialogSearchQueryChanged>(
      _onFilterDialogSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<FilterDialogStatusChanged>(_onFilterDialogStatusChanged);
    on<FilterDialogHeadlinesSourceIdsChanged>(
      _onFilterDialogHeadlinesSourceIdsChanged,
    );
    on<FilterDialogHeadlinesTopicIdsChanged>(
      _onFilterDialogHeadlinesTopicIdsChanged,
    );
    on<FilterDialogBreakingNewsChanged>(
      _onFilterDialogBreakingNewsChanged,
    );
    on<FilterDialogHeadlinesCountryIdsChanged>(
      _onFilterDialogHeadlinesCountryIdsChanged,
    );
    on<FilterDialogSourceTypesChanged>(_onFilterDialogSourceTypesChanged);
    on<FilterDialogLanguageCodesChanged>(
      _onFilterDialogLanguageCodesChanged,
    );
    on<FilterDialogHeadquartersCountryIdsChanged>(
      _onFilterDialogHeadquartersCountryIdsChanged,
    );
    on<FilterDialogReset>(_onFilterDialogReset);
  }

  final DataRepository<Source> _sourcesRepository;
  final DataRepository<Topic> _topicsRepository;
  final DataRepository<Country> _countriesRepository;
  final DataRepository<Language> _languagesRepository;

  /// Initializes the filter dialog's state from the current filter BLoCs.
  void _onFilterDialogInitialized(
    FilterDialogInitialized event,
    Emitter<FilterDialogState> emit,
  ) {
    emit(state.copyWith(activeTab: event.activeTab));

    switch (event.activeTab) {
      case ContentManagementTab.headlines:
        final headlinesState = event.headlinesFilterState;
        if (headlinesState != null) {
          emit(
            state.copyWith(
              searchQuery: headlinesState.searchQuery,
              selectedStatus: headlinesState.selectedStatus,
              selectedSourceIds: headlinesState.selectedSourceIds,
              selectedTopicIds: headlinesState.selectedTopicIds,
              selectedCountryIds: headlinesState.selectedCountryIds,
              isBreaking: headlinesState.isBreaking,
            ),
          );
        }
      case ContentManagementTab.topics:
        final topicsState = event.topicsFilterState;
        if (topicsState != null) {
          emit(
            state.copyWith(
              searchQuery: topicsState.searchQuery,
              selectedStatus: topicsState.selectedStatus,
            ),
          );
        }
      case ContentManagementTab.sources:
        final sourcesState = event.sourcesFilterState;
        if (sourcesState != null) {
          emit(
            state.copyWith(
              searchQuery: sourcesState.searchQuery,
              selectedStatus: sourcesState.selectedStatus,
              selectedSourceTypes: sourcesState.selectedSourceTypes,
              selectedLanguageCodes: sourcesState.selectedLanguageCodes,
              selectedHeadquartersCountryIds:
                  sourcesState.selectedHeadquartersCountryIds,
            ),
          );
        }
    }
    add(const FilterOptionsLoadRequested());
  }

  /// Loads available filter options (sources, topics, countries, languages).
  Future<void> _onFilterOptionsLoadRequested(
    FilterOptionsLoadRequested event,
    Emitter<FilterDialogState> emit,
  ) async {
    emit(state.copyWith(filterOptionsStatus: FilterDialogStatus.loading));
    try {
      final sourcesResponse = await _sourcesRepository.readAll(
        pagination: const PaginationOptions(
          limit: AppConstants.kMaxItemsPerRequest,
        ),
        sort: const [SortOption('name', SortOrder.asc)],
      );
      final topicsResponse = await _topicsRepository.readAll(
        pagination: const PaginationOptions(
          limit: AppConstants.kMaxItemsPerRequest,
        ),
        sort: const [SortOption('name', SortOrder.asc)],
      );
      final countriesResponse = await _countriesRepository.readAll(
        pagination: const PaginationOptions(
          limit: AppConstants.kMaxItemsPerRequest,
        ),
        sort: const [SortOption('name', SortOrder.asc)],
      );
      final languagesResponse = await _languagesRepository.readAll(
        pagination: const PaginationOptions(
          limit: AppConstants.kMaxItemsPerRequest,
        ),
        sort: const [SortOption('name', SortOrder.asc)],
      );

      emit(
        state.copyWith(
          filterOptionsStatus: FilterDialogStatus.success,
          availableSources: sourcesResponse.items,
          availableTopics: topicsResponse.items,
          availableCountries: countriesResponse.items,
          availableLanguages: languagesResponse.items,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          filterOptionsStatus: FilterDialogStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          filterOptionsStatus: FilterDialogStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Updates the temporary search query.
  void _onFilterDialogSearchQueryChanged(
    FilterDialogSearchQueryChanged event,
    Emitter<FilterDialogState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Updates the temporary selected content status.
  void _onFilterDialogStatusChanged(
    FilterDialogStatusChanged event,
    Emitter<FilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedStatus: event.status));
  }

  /// Updates the temporary selected source IDs for headlines.
  void _onFilterDialogHeadlinesSourceIdsChanged(
    FilterDialogHeadlinesSourceIdsChanged event,
    Emitter<FilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedSourceIds: event.sourceIds));
  }

  /// Updates the temporary selected topic IDs for headlines.
  void _onFilterDialogHeadlinesTopicIdsChanged(
    FilterDialogHeadlinesTopicIdsChanged event,
    Emitter<FilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedTopicIds: event.topicIds));
  }

  /// Updates the temporary selected country IDs for headlines.
  void _onFilterDialogHeadlinesCountryIdsChanged(
    FilterDialogHeadlinesCountryIdsChanged event,
    Emitter<FilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedCountryIds: event.countryIds));
  }

  /// Updates the temporary breaking news filter for headlines.
  void _onFilterDialogBreakingNewsChanged(
    FilterDialogBreakingNewsChanged event,
    Emitter<FilterDialogState> emit,
  ) {
    emit(
      state.copyWith(isBreaking: event.isBreaking),
    );
  }

  /// Updates the temporary selected source types for sources.
  void _onFilterDialogSourceTypesChanged(
    FilterDialogSourceTypesChanged event,
    Emitter<FilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedSourceTypes: event.sourceTypes));
  }

  /// Updates the temporary selected language codes for sources.
  void _onFilterDialogLanguageCodesChanged(
    FilterDialogLanguageCodesChanged event,
    Emitter<FilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedLanguageCodes: event.languageCodes));
  }

  /// Updates the temporary selected headquarters country IDs for sources.
  void _onFilterDialogHeadquartersCountryIdsChanged(
    FilterDialogHeadquartersCountryIdsChanged event,
    Emitter<FilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedHeadquartersCountryIds: event.countryIds));
  }

  /// Resets all temporary filter selections in the dialog to their initial state.
  void _onFilterDialogReset(
    FilterDialogReset event,
    Emitter<FilterDialogState> emit,
  ) {
    emit(
      FilterDialogState(activeTab: state.activeTab).copyWith(isBreaking: false),
    );
  }
}
