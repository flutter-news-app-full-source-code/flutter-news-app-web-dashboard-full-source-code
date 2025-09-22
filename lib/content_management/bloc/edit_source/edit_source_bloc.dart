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
    required String sourceId,
  }) : _sourcesRepository = sourcesRepository,
       super(
         EditSourceState(sourceId: sourceId, status: EditSourceStatus.loading),
       ) {
    on<EditSourceLoaded>(_onEditSourceLoaded);
    on<EditSourceNameChanged>(_onNameChanged);
    on<EditSourceDescriptionChanged>(_onDescriptionChanged);
    on<EditSourceUrlChanged>(_onUrlChanged);
    on<EditSourceTypeChanged>(_onSourceTypeChanged);
    on<EditSourceLanguageChanged>(_onLanguageChanged);
    on<EditSourceHeadquartersChanged>(_onHeadquartersChanged);
    on<EditSourceSavedAsDraft>(_onSavedAsDraft);
    on<EditSourcePublished>(_onPublished);

    add(const EditSourceLoaded());
  }

  final DataRepository<Source> _sourcesRepository;

  Future<void> _onEditSourceLoaded(
    EditSourceLoaded event,
    Emitter<EditSourceState> emit,
  ) async {
    try {
      final source = await _sourcesRepository.read(id: state.sourceId);
      emit(
        state.copyWith(
          status: EditSourceStatus.initial,
          name: source.name,
          description: source.description,
          url: source.url,
          sourceType: () => source.sourceType,
          language: () => source.language,
          headquarters: () => source.headquarters,
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
    emit(
      state.copyWith(name: event.name, status: EditSourceStatus.initial),
    );
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

  /// Handles saving the source as a draft.
  Future<void> _onSavedAsDraft(
    EditSourceSavedAsDraft event,
    Emitter<EditSourceState> emit,
  ) async {
    emit(state.copyWith(status: EditSourceStatus.submitting));
    try {
      final originalSource = await _sourcesRepository.read(id: state.sourceId);
      final updatedSource = originalSource.copyWith(
        name: state.name,
        description: state.description,
        url: state.url,
        sourceType: state.sourceType,
        language: state.language,
        headquarters: state.headquarters,
        status: ContentStatus.draft,
        updatedAt: DateTime.now(),
      );

      await _sourcesRepository.update(
        id: state.sourceId,
        item: updatedSource,
      );
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

  /// Handles publishing the source.
  Future<void> _onPublished(
    EditSourcePublished event,
    Emitter<EditSourceState> emit,
  ) async {
    emit(state.copyWith(status: EditSourceStatus.submitting));
    try {
      final originalSource = await _sourcesRepository.read(id: state.sourceId);
      final updatedSource = originalSource.copyWith(
        name: state.name,
        description: state.description,
        url: state.url,
        sourceType: state.sourceType,
        language: state.language,
        headquarters: state.headquarters,
        status: ContentStatus.active,
        updatedAt: DateTime.now(),
      );

      await _sourcesRepository.update(
        id: state.sourceId,
        item: updatedSource,
      );
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
