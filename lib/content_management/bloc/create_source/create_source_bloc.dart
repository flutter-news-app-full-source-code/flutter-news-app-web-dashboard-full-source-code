import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:country_picker/country_picker.dart' as picker;
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/shared.dart';
import 'package:language_picker/languages.dart';
import 'package:uuid/uuid.dart';

part 'create_source_event.dart';
part 'create_source_state.dart';

/// A BLoC to manage the state of creating a new source.
class CreateSourceBloc extends Bloc<CreateSourceEvent, CreateSourceState> {
  /// {@macro create_source_bloc}
  CreateSourceBloc({
    required DataRepository<Source> sourcesRepository,
  }) : _sourcesRepository = sourcesRepository,
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
  final _uuid = const Uuid();

  Future<void> _onDataLoaded(
    CreateSourceDataLoaded event,
    Emitter<CreateSourceState> emit,
  ) async {
    // This event is now a no-op since we don't need to load countries.
    // We just ensure the BLoC is in the initial state.
    emit(state.copyWith(status: CreateSourceStatus.initial));
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
    final packageCountry = event.headquarters;
    if (packageCountry == null) {
      emit(state.copyWith(headquarters: () => null));
    } else {
      final coreCountry = adaptPackageCountryToCoreCountry(packageCountry);
      emit(state.copyWith(headquarters: () => coreCountry));
    }
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
        language: adaptPackageLanguageToLanguageCode(state.language!),
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
