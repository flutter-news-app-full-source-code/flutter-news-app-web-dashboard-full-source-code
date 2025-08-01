import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

part 'create_source_event.dart';
part 'create_source_state.dart';

const _searchDebounceDuration = Duration(milliseconds: 300);

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

      // Start background fetching for all countries
      while (state.countriesHasMore) {
        final nextCountries = await _countriesRepository.readAll(
          pagination: PaginationOptions(cursor: state.countriesCursor),
          sort: [const SortOption('name', SortOrder.asc)],
        );
        emit(
          state.copyWith(
            countries: List.of(state.countries)..addAll(nextCountries.items),
            countriesCursor: nextCountries.cursor,
            countriesHasMore: nextCountries.hasMore,
          ),
        );
      }

      // Start background fetching for all languages
      while (state.languagesHasMore) {
        final nextLanguages = await _languagesRepository.readAll(
          pagination: PaginationOptions(cursor: state.languagesCursor),
          sort: [const SortOption('name', SortOrder.asc)],
        );
        emit(
          state.copyWith(
            languages: List.of(state.languages)..addAll(nextLanguages.items),
            languagesCursor: nextLanguages.cursor,
            languagesHasMore: nextLanguages.hasMore,
          ),
        );
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
