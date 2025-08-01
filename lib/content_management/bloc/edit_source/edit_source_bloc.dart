import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'edit_source_event.dart';
part 'edit_source_state.dart';

const _searchDebounceDuration = Duration(milliseconds: 300);

/// A BLoC to manage the state of editing a single source.
class EditSourceBloc extends Bloc<EditSourceEvent, EditSourceState> {
  /// {@macro edit_source_bloc}
  EditSourceBloc({
    required DataRepository<Source> sourcesRepository,
    required DataRepository<Country> countriesRepository,
    required DataRepository<Language> languagesRepository,
    required String sourceId,
  }) : _sourcesRepository = sourcesRepository,
       _countriesRepository = countriesRepository,
       _languagesRepository = languagesRepository,
       _sourceId = sourceId,
       super(const EditSourceState()) {
    on<EditSourceLoaded>(_onLoaded);
    on<EditSourceNameChanged>(_onNameChanged);
    on<EditSourceDescriptionChanged>(_onDescriptionChanged);
    on<EditSourceUrlChanged>(_onUrlChanged);
    on<EditSourceTypeChanged>(_onSourceTypeChanged);
    on<EditSourceLanguageChanged>(_onLanguageChanged);
    on<EditSourceHeadquartersChanged>(_onHeadquartersChanged);
    on<EditSourceStatusChanged>(_onStatusChanged);
    on<EditSourceSubmitted>(_onSubmitted);
    on<EditSourceCountrySearchChanged>(
      _onCountrySearchChanged,
      transformer: droppable(),
    );
    on<EditSourceLoadMoreCountriesRequested>(
      _onLoadMoreCountriesRequested,
    );
    on<EditSourceLanguageSearchChanged>(
      _onLanguageSearchChanged,
      transformer: droppable(),
    );
    on<EditSourceLoadMoreLanguagesRequested>(
      _onLoadMoreLanguagesRequested,
    );
  }

  final DataRepository<Source> _sourcesRepository;
  final DataRepository<Country> _countriesRepository;
  final DataRepository<Language> _languagesRepository;
  final String _sourceId;

  Future<void> _onLoaded(
    EditSourceLoaded event,
    Emitter<EditSourceState> emit,
  ) async {
    emit(state.copyWith(status: EditSourceStatus.loading));
    try {
      final responses = await Future.wait<dynamic>([
        _sourcesRepository.read(id: _sourceId),
        _countriesRepository.readAll(
          sort: [const SortOption('name', SortOrder.asc)],
        ),
        _languagesRepository.readAll(
          sort: [const SortOption('name', SortOrder.asc)],
        ),
      ]);

      final source = responses[0] as Source;
      final countriesPaginated = responses[1] as PaginatedResponse<Country>;
      final languagesPaginated = responses[2] as PaginatedResponse<Language>;

      Language? selectedLanguage;
      try {
        // Find the equivalent language object from the full list.
        // This ensures the DropdownButton can identify it by reference.
        selectedLanguage = languagesPaginated.items.firstWhere(
          (listLanguage) => listLanguage.id == source.language?.id,
        );
      } catch (_) {
        selectedLanguage = source.language;
      }

      emit(
        state.copyWith(
          status: EditSourceStatus.initial,
          initialSource: source,
          name: source.name,
          description: source.description,
          url: source.url,
          sourceType: () => source.sourceType,
          language: () => selectedLanguage,
          headquarters: () => source.headquarters,
          contentStatus: source.status,
          countries: countriesPaginated.items,
          countriesCursor: countriesPaginated.cursor,
          countriesHasMore: countriesPaginated.hasMore,
          languages: languagesPaginated.items,
          languagesCursor: languagesPaginated.cursor,
          languagesHasMore: languagesPaginated.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditSourceStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onNameChanged(
    EditSourceNameChanged event,
    Emitter<EditSourceState> emit,
  ) {
    emit(state.copyWith(name: event.name, status: EditSourceStatus.initial));
  }

  void _onDescriptionChanged(
    EditSourceDescriptionChanged event,
    Emitter<EditSourceState> emit,
  ) {
    emit(
      state.copyWith(
        description: event.description,
        status: EditSourceStatus.initial,
      ),
    );
  }

  void _onUrlChanged(
    EditSourceUrlChanged event,
    Emitter<EditSourceState> emit,
  ) {
    emit(state.copyWith(url: event.url, status: EditSourceStatus.initial));
  }

  void _onSourceTypeChanged(
    EditSourceTypeChanged event,
    Emitter<EditSourceState> emit,
  ) {
    emit(
      state.copyWith(
        sourceType: () => event.sourceType,
        status: EditSourceStatus.initial,
      ),
    );
  }

  void _onLanguageChanged(
    EditSourceLanguageChanged event,
    Emitter<EditSourceState> emit,
  ) {
    emit(
      state.copyWith(
        language: () => event.language,
        status: EditSourceStatus.initial,
      ),
    );
  }

  void _onHeadquartersChanged(
    EditSourceHeadquartersChanged event,
    Emitter<EditSourceState> emit,
  ) {
    emit(
      state.copyWith(
        headquarters: () => event.headquarters,
        status: EditSourceStatus.initial,
      ),
    );
  }

  void _onStatusChanged(
    EditSourceStatusChanged event,
    Emitter<EditSourceState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: EditSourceStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditSourceSubmitted event,
    Emitter<EditSourceState> emit,
  ) async {
    if (!state.isFormValid) return;

    final initialSource = state.initialSource;
    if (initialSource == null) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          exception: const UnknownException(
            'Cannot update: Original source data not loaded.',
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(status: EditSourceStatus.submitting));
    try {
      final updatedSource = initialSource.copyWith(
        name: state.name,
        description: state.description,
        url: state.url,
        sourceType: state.sourceType,
        language: state.language,
        headquarters: state.headquarters,
        status: state.contentStatus,
        updatedAt: DateTime.now(),
      );

      await _sourcesRepository.update(id: _sourceId, item: updatedSource);
      emit(
        state.copyWith(
          status: EditSourceStatus.success,
          updatedSource: updatedSource,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditSourceStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onCountrySearchChanged(
    EditSourceCountrySearchChanged event,
    Emitter<EditSourceState> emit,
  ) async {
    await Future<void>.delayed(_searchDebounceDuration);
    emit(state.copyWith(countrySearchTerm: event.searchTerm));
    try {
      final countriesResponse = await _countriesRepository.readAll(
        filter: event.searchTerm.isNotEmpty ? {'name': event.searchTerm} : null,
        sort: [const SortOption('name', SortOrder.asc)],
      );

      emit(
        state.copyWith(
          countries: countriesResponse.items,
          countriesCursor: countriesResponse.cursor,
          countriesHasMore: countriesResponse.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditSourceStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onLoadMoreCountriesRequested(
    EditSourceLoadMoreCountriesRequested event,
    Emitter<EditSourceState> emit,
  ) async {
    if (!state.countriesHasMore || state.countriesIsLoadingMore) return;

    emit(state.copyWith(countriesIsLoadingMore: true));

    try {
      final countriesResponse = await _countriesRepository.readAll(
        pagination: state.countriesCursor != null
            ? PaginationOptions(cursor: state.countriesCursor)
            : null,
        filter: state.countrySearchTerm.isNotEmpty
            ? {'name': state.countrySearchTerm}
            : null,
        sort: [const SortOption('name', SortOrder.asc)],
      );

      emit(
        state.copyWith(
          countries: List.of(state.countries)..addAll(countriesResponse.items),
          countriesCursor: countriesResponse.cursor,
          countriesHasMore: countriesResponse.hasMore,
          countriesIsLoadingMore: false,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          exception: e,
          countriesIsLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
          countriesIsLoadingMore: false,
        ),
      );
    }
  }

  Future<void> _onLanguageSearchChanged(
    EditSourceLanguageSearchChanged event,
    Emitter<EditSourceState> emit,
  ) async {
    await Future<void>.delayed(_searchDebounceDuration);
    emit(state.copyWith(languageSearchTerm: event.searchTerm));
    try {
      final languagesResponse = await _languagesRepository.readAll(
        filter: event.searchTerm.isNotEmpty ? {'name': event.searchTerm} : null,
        sort: [const SortOption('name', SortOrder.asc)],
      );

      emit(
        state.copyWith(
          languages: languagesResponse.items,
          languagesCursor: languagesResponse.cursor,
          languagesHasMore: languagesResponse.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditSourceStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onLoadMoreLanguagesRequested(
    EditSourceLoadMoreLanguagesRequested event,
    Emitter<EditSourceState> emit,
  ) async {
    if (!state.languagesHasMore || state.languagesIsLoadingMore) return;

    emit(state.copyWith(languagesIsLoadingMore: true));

    try {
      final languagesResponse = await _languagesRepository.readAll(
        pagination: state.languagesCursor != null
            ? PaginationOptions(cursor: state.languagesCursor)
            : null,
        filter: state.languageSearchTerm.isNotEmpty
            ? {'name': state.languageSearchTerm}
            : null,
        sort: [const SortOption('name', SortOrder.asc)],
      );

      emit(
        state.copyWith(
          languages: List.of(state.languages)..addAll(languagesResponse.items),
          languagesCursor: languagesResponse.cursor,
          languagesHasMore: languagesResponse.hasMore,
          languagesIsLoadingMore: false,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          exception: e,
          languagesIsLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
          languagesIsLoadingMore: false,
        ),
      );
    }
  }
}
