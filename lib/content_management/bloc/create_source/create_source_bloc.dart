import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

part 'create_source_event.dart';
part 'create_source_state.dart';

/// A BLoC to manage the state of creating a new source.
class CreateSourceBloc extends Bloc<CreateSourceEvent, CreateSourceState> {
  /// {@macro create_source_bloc}
  CreateSourceBloc({
    required HtDataRepository<Source> sourcesRepository,
    required HtDataRepository<Country> countriesRepository,
  }) : _sourcesRepository = sourcesRepository,
       _countriesRepository = countriesRepository,
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

  final HtDataRepository<Source> _sourcesRepository;
  final HtDataRepository<Country> _countriesRepository;

  Future<void> _onDataLoaded(
    CreateSourceDataLoaded event,
    Emitter<CreateSourceState> emit,
  ) async {
    emit(state.copyWith(status: CreateSourceStatus.loading));
    try {
      final countriesResponse = await _countriesRepository.readAll();
      final countries = (countriesResponse as PaginatedResponse<Country>).items;

      emit(
        state.copyWith(
          status: CreateSourceStatus.initial,
          countries: countries,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: CreateSourceStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateSourceStatus.failure,
          errorMessage: e.toString(),
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
    emit(state.copyWith(language: event.language));
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
      final newSource = Source(
        name: state.name,
        description: state.description.isNotEmpty ? state.description : null,
        url: state.url.isNotEmpty ? state.url : null,
        sourceType: state.sourceType,
        language: state.language.isNotEmpty ? state.language : null,
        headquarters: state.headquarters,
        status: state.contentStatus,
      );

      await _sourcesRepository.create(item: newSource);
      emit(state.copyWith(status: CreateSourceStatus.success));
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: CreateSourceStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateSourceStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
