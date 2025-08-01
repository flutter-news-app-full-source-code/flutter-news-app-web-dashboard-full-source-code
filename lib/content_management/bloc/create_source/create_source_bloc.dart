import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

part 'create_source_event.dart';
part 'create_source_state.dart';

final class _FetchNextCountryPage extends CreateSourceEvent {
  const _FetchNextCountryPage();
}

final class _FetchNextLanguagePage extends CreateSourceEvent {
  const _FetchNextLanguagePage();
}

/// A BLoC to manage the state of creating a new source.
class CreateSourceBloc extends Bloc<CreateSourceEvent, CreateSourceState> {
  /// {@macro create_source_bloc}
  CreateSourceBloc({
    required DataRepository<Source> sourcesRepository,
    required DataRepository<Country> countriesRepository,
    required DataRepository<Language> languagesRepository,
  }) : _sourcesRepository = sourcesRepository,
       _countriesRepository = countriesRepository,
       _languagesRepository = languagesRepository,
       super(const CreateSourceState()) {
    on<CreateSourceDataLoaded>(_onDataLoaded);
    on<CreateSourceNameChanged>(_onNameChanged);
    on<CreateSourceDescriptionChanged>(_onDescriptionChanged);
    on<CreateSourceUrlChanged>(_onUrlChanged);
    on<CreateSourceTypeChanged>(_onSourceTypeChanged);
    on<CreateSourceLanguageChanged>(_onLanguageChanged);
    on<CreateSourceHeadquartersChanged>(_onHeadquartersChanged);
    on<CreateSourceStatusChanged>(_onStatusChanged);
    on<CreateSourceSubmitted>(_onSubmitted);
    on<_FetchNextCountryPage>(_onFetchNextCountryPage);
    on<_FetchNextLanguagePage>(_onFetchNextLanguagePage);
  }

  final DataRepository<Source> _sourcesRepository;
  final DataRepository<Country> _countriesRepository;
  final DataRepository<Language> _languagesRepository;
  final _uuid = const Uuid();

  Future<void> _onDataLoaded(
    CreateSourceDataLoaded event,
    Emitter<CreateSourceState> emit,
  ) async {
    emit(state.copyWith(status: CreateSourceStatus.loading));
    try {
      final responses = await Future.wait([
        _countriesRepository.readAll(
          sort: [const SortOption('name', SortOrder.asc)],
        ),
        _languagesRepository.readAll(
          sort: [const SortOption('name', SortOrder.asc)],
        ),
      ]);
      final countriesPaginated = responses[0] as PaginatedResponse<Country>;
      final languagesPaginated = responses[1] as PaginatedResponse<Language>;
      emit(
        state.copyWith(
          status: CreateSourceStatus.initial,
          countries: countriesPaginated.items,
          countriesCursor: countriesPaginated.cursor,
          countriesHasMore: countriesPaginated.hasMore,
          languages: languagesPaginated.items,
          languagesCursor: languagesPaginated.cursor,
          languagesHasMore: languagesPaginated.hasMore,
        ),
      );

      // After the initial page is loaded, start background processes to
      // fetch all remaining pages for countries and languages.
      if (state.countriesHasMore) {
        add(const _FetchNextCountryPage());
      }
      if (state.languagesHasMore) {
        add(const _FetchNextLanguagePage());
      }
    } on HttpException catch (e) {
      emit(state.copyWith(status: CreateSourceStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateSourceStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onNameChanged(
    CreateSourceNameChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onDescriptionChanged(
    CreateSourceDescriptionChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onUrlChanged(
    CreateSourceUrlChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    emit(state.copyWith(url: event.url));
  }

  void _onSourceTypeChanged(
    CreateSourceTypeChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    emit(state.copyWith(sourceType: () => event.sourceType));
  }

  void _onLanguageChanged(
    CreateSourceLanguageChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    emit(state.copyWith(language: () => event.language));
  }

  void _onHeadquartersChanged(
    CreateSourceHeadquartersChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    emit(state.copyWith(headquarters: () => event.headquarters));
  }

  void _onStatusChanged(
    CreateSourceStatusChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: CreateSourceStatus.initial,
      ),
    );
  }

  // --- Background Data Fetching for Dropdown ---
  // The DropdownButtonFormField widget does not natively support on-scroll
  // pagination. To preserve UI consistency across the application, this BLoC
  // employs an event-driven background fetching mechanism.
  //
  // After the first page of items is loaded, a chain of events is initiated
  // to progressively fetch all remaining pages. This process is throttled
  // and runs in the background, ensuring the UI remains responsive while the
  // full list of dropdown options is populated over time.
  Future<void> _onFetchNextCountryPage(
    _FetchNextCountryPage event,
    Emitter<CreateSourceState> emit,
  ) async {
    if (!state.countriesHasMore || state.countriesIsLoadingMore) return;

    try {
      emit(state.copyWith(countriesIsLoadingMore: true));

      // ignore: inference_failure_on_instance_creation
      await Future.delayed(const Duration(milliseconds: 400));

      final nextCountries = await _countriesRepository.readAll(
        pagination: PaginationOptions(cursor: state.countriesCursor),
        sort: [const SortOption('name', SortOrder.asc)],
      );

      emit(
        state.copyWith(
          countries: List.of(state.countries)..addAll(nextCountries.items),
          countriesCursor: nextCountries.cursor,
          countriesHasMore: nextCountries.hasMore,
          countriesIsLoadingMore: false,
        ),
      );

      if (nextCountries.hasMore) {
        add(const _FetchNextCountryPage());
      }
    } catch (e) {
      emit(state.copyWith(countriesIsLoadingMore: false));
      // Optionally log the error without disrupting the user
    }
  }

  Future<void> _onFetchNextLanguagePage(
    _FetchNextLanguagePage event,
    Emitter<CreateSourceState> emit,
  ) async {
    if (!state.languagesHasMore || state.languagesIsLoadingMore) return;

    try {
      emit(state.copyWith(languagesIsLoadingMore: true));

      // ignore: inference_failure_on_instance_creation
      await Future.delayed(const Duration(milliseconds: 400));

      final nextLanguages = await _languagesRepository.readAll(
        pagination: PaginationOptions(cursor: state.languagesCursor),
        sort: [const SortOption('name', SortOrder.asc)],
      );

      emit(
        state.copyWith(
          languages: List.of(state.languages)..addAll(nextLanguages.items),
          languagesCursor: nextLanguages.cursor,
          languagesHasMore: nextLanguages.hasMore,
          languagesIsLoadingMore: false,
        ),
      );

      if (nextLanguages.hasMore) {
        add(const _FetchNextLanguagePage());
      }
    } catch (e) {
      emit(state.copyWith(languagesIsLoadingMore: false));
      // Optionally log the error without disrupting the user
    }
  }

  Future<void> _onSubmitted(
    CreateSourceSubmitted event,
    Emitter<CreateSourceState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: CreateSourceStatus.submitting));
    try {
      final now = DateTime.now();
      final newSource = Source(
        id: _uuid.v4(),
        name: state.name,
        description: state.description,
        url: state.url,
        sourceType: state.sourceType!,
        language: state.language!,
        createdAt: now,
        updatedAt: now,
        headquarters: state.headquarters!,
        status: state.contentStatus,
      );

      await _sourcesRepository.create(item: newSource);
      emit(
        state.copyWith(
          status: CreateSourceStatus.success,
          createdSource: newSource,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: CreateSourceStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateSourceStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
