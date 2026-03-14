import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

part 'edit_person_event.dart';
part 'edit_person_state.dart';

/// {@template edit_person_bloc}
/// A BLoC to manage the state of editing a single person.
/// {@endtemplate}
class EditPersonBloc extends Bloc<EditPersonEvent, EditPersonState> {
  /// {@macro edit_person_bloc}
  EditPersonBloc({
    required DataRepository<Person> personsRepository,
    required MediaRepository mediaRepository,
    required String personId,
    required Logger logger,
  }) : _personsRepository = personsRepository,
       _mediaRepository = mediaRepository,
       _logger = logger,
       super(EditPersonState(personId: personId)) {
    on<EditPersonLoaded>(_onLoaded);
    on<EditPersonNameChanged>(_onNameChanged);
    on<EditPersonDescriptionChanged>(_onDescriptionChanged);
    on<EditPersonImageChanged>(_onImageChanged);
    on<EditPersonImageRemoved>(_onImageRemoved);
    on<EditPersonLanguageTabChanged>(_onLanguageTabChanged);
    on<EditPersonSavedAsDraft>(_onSavedAsDraft);
    on<EditPersonPublished>(_onPublished);
  }

  final DataRepository<Person> _personsRepository;
  final MediaRepository _mediaRepository;
  final Logger _logger;

  Future<void> _onLoaded(
    EditPersonLoaded event,
    Emitter<EditPersonState> emit,
  ) async {
    _logger.fine('Loading person for editing with ID: ${state.personId}...');
    emit(state.copyWith(status: EditPersonStatus.loading));
    try {
      final person = await _personsRepository.read(id: state.personId);
      emit(
        state.copyWith(
          status: EditPersonStatus.initial,
          name: person.name,
          description: person.description,
          imageUrl: ValueWrapper(person.imageUrl),
          initialPerson: person,
          enabledLanguages: event.enabledLanguages,
          defaultLanguage: event.defaultLanguage,
          selectedLanguage:
              event.enabledLanguages.firstOrNull ?? event.defaultLanguage,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('Failed to load person: ${state.personId}', e);
      emit(
        state.copyWith(
          status: EditPersonStatus.failure,
          exception: ValueWrapper(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditPersonStatus.failure,
          exception: ValueWrapper(UnknownException('Unexpected error: $e')),
        ),
      );
    }
  }

  void _onNameChanged(
    EditPersonNameChanged event,
    Emitter<EditPersonState> emit,
  ) {
    emit(state.copyWith(name: event.name, status: EditPersonStatus.initial));
  }

  void _onDescriptionChanged(
    EditPersonDescriptionChanged event,
    Emitter<EditPersonState> emit,
  ) {
    emit(
      state.copyWith(
        description: event.description,
        status: EditPersonStatus.initial,
      ),
    );
  }

  void _onImageChanged(
    EditPersonImageChanged event,
    Emitter<EditPersonState> emit,
  ) {
    emit(
      state.copyWith(
        imageFileBytes: ValueWrapper(event.imageFileBytes),
        imageFileName: ValueWrapper(event.imageFileName),
        imageRemoved: false,
        status: EditPersonStatus.initial,
      ),
    );
  }

  void _onImageRemoved(
    EditPersonImageRemoved event,
    Emitter<EditPersonState> emit,
  ) {
    emit(
      state.copyWith(
        imageUrl: const ValueWrapper(null),
        imageFileBytes: const ValueWrapper(null),
        imageFileName: const ValueWrapper(null),
        imageRemoved: true,
        status: EditPersonStatus.initial,
      ),
    );
  }

  void _onLanguageTabChanged(
    EditPersonLanguageTabChanged event,
    Emitter<EditPersonState> emit,
  ) {
    emit(state.copyWith(selectedLanguage: event.language));
  }

  Future<void> _onSavedAsDraft(
    EditPersonSavedAsDraft event,
    Emitter<EditPersonState> emit,
  ) async {
    await _submitPerson(emit, status: ContentStatus.draft);
  }

  Future<void> _onPublished(
    EditPersonPublished event,
    Emitter<EditPersonState> emit,
  ) async {
    await _submitPerson(emit, status: ContentStatus.active);
  }

  Future<void> _submitPerson(
    Emitter<EditPersonState> emit, {
    required ContentStatus status,
  }) async {
    String? newMediaAssetId;

    if (state.imageFileBytes != null && state.imageFileName != null) {
      emit(state.copyWith(status: EditPersonStatus.imageUploading));
      try {
        newMediaAssetId = await _mediaRepository.uploadFile(
          fileBytes: state.imageFileBytes!,
          fileName: state.imageFileName!,
          purpose: MediaAssetPurpose.personPhoto,
        );
      } on HttpException catch (e) {
        final exception = e is BadRequestException
            ? const BadRequestException('File is too large.')
            : e;
        emit(
          state.copyWith(
            status: EditPersonStatus.imageUploadFailure,
            exception: ValueWrapper(exception),
          ),
        );
        return;
      }
    }

    emit(state.copyWith(status: EditPersonStatus.entitySubmitting));
    try {
      if (state.initialPerson == null) {
        throw const OperationFailedException('Initial state missing.');
      }
      final updatedPerson = Person(
        id: state.personId,
        name: state.name,
        description: state.description,
        imageUrl: (newMediaAssetId != null || state.imageRemoved)
            ? null
            : state.initialPerson!.imageUrl,
        mediaAssetId:
            newMediaAssetId ??
            (state.imageRemoved ? null : state.initialPerson!.mediaAssetId),
        createdAt: state.initialPerson!.createdAt,
        updatedAt: DateTime.now(),
        status: status,
      );

      await _personsRepository.update(id: state.personId, item: updatedPerson);
      emit(
        state.copyWith(
          status: EditPersonStatus.success,
          updatedPerson: updatedPerson,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: EditPersonStatus.entitySubmitFailure,
          exception: ValueWrapper(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditPersonStatus.entitySubmitFailure,
          exception: ValueWrapper(UnknownException(e.toString())),
        ),
      );
    }
  }
}
