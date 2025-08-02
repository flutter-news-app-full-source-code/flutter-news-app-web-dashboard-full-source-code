import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'edit_source_event.dart';
part 'edit_source_state.dart';

final class _FetchNextCountryPage extends EditSourceEvent {
  const _FetchNextCountryPage();
}

final class _FetchNextLanguagePage extends EditSourceEvent {
  const _FetchNextLanguagePage();
}

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
    on<_FetchNextCountryPage>(_onFetchNextCountryPage);
    on<_FetchNextLanguagePage>(_onFetchNextLanguagePage);
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
          filter: {'status': ContentStatus.active.name},
        ),
        _languagesRepository.readAll(
          sort: [const SortOption('name', SortOrder.asc)],
          filter: {'status': ContentStatus.active.name},
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
          (listLanguage) => listLanguage.id == source.language.id,
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

      // After the initial page is loaded, start background processes to
      // fetch all remaining pages for countries and languages.
      if (state.countriesHasMore) {
        add(const _FetchNextCountryPage());
      }
      if (state.languagesHasMore) {
        add(const _FetchNextLanguagePage());
      }
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
    Emitter<EditSourceState> emit,
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
    Emitter<EditSourceState> emit,
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
}
