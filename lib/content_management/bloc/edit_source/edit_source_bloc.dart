import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'edit_source_event.dart';
part 'edit_source_state.dart';

/// A BLoC to manage the state of editing a single source.
class EditSourceBloc extends Bloc<EditSourceEvent, EditSourceState> {
  /// {@macro edit_source_bloc}
  EditSourceBloc({
    required DataRepository<Source> sourcesRepository,
    required List<Country> countries,
    required List<Language> languages,
    required String sourceId,
  }) : _sourcesRepository = sourcesRepository,
       _sourceId = sourceId,
       super(
         EditSourceState(
           countries: countries,
           languages: languages,
         ),
       ) {
    on<EditSourceLoaded>(_onLoaded);
    on<EditSourceNameChanged>(_onNameChanged);
    on<EditSourceDescriptionChanged>(_onDescriptionChanged);
    on<EditSourceUrlChanged>(_onUrlChanged);
    on<EditSourceTypeChanged>(_onSourceTypeChanged);
    on<EditSourceLanguageChanged>(_onLanguageChanged);
    on<EditSourceHeadquartersChanged>(_onHeadquartersChanged);
    on<EditSourceStatusChanged>(_onStatusChanged);
    on<EditSourceSubmitted>(_onSubmitted);
  }

  final DataRepository<Source> _sourcesRepository;
  final String _sourceId;

  Future<void> _onLoaded(
    EditSourceLoaded event,
    Emitter<EditSourceState> emit,
  ) async {
    emit(state.copyWith(status: EditSourceStatus.loading));
    try {
      final source = await _sourcesRepository.read(id: _sourceId);

      emit(
        state.copyWith(
          status: EditSourceStatus.initial,
          initialSource: source,
          name: source.name,
          description: source.description,
          url: source.url,
          sourceType: () => source.sourceType,
          language: () => source.language,
          headquarters: () => source.headquarters,
          contentStatus: source.status,
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

  // --- Background Data Fetching for Dropdown ---
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
