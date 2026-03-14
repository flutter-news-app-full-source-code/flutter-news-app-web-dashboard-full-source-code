import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';
import 'package:veritai_dashboard/shared/data/enrichment_repository.dart';

part 'create_person_event.dart';
part 'create_person_state.dart';

/// {@template create_person_bloc}
/// A BLoC to manage the state of creating a new person.
///
/// This BLoC handles form input changes and orchestrates the two-stage
/// submission process: first uploading the image to media services, and then
/// creating the person entity.
/// {@endtemplate}
class CreatePersonBloc extends Bloc<CreatePersonEvent, CreatePersonState> {
  /// {@macro create_person_bloc}
  CreatePersonBloc({
    required DataRepository<Person> personsRepository,
    required MediaRepository mediaRepository,
    required EnrichmentRepository enrichmentRepository,
    required Logger logger,
  }) : _personsRepository = personsRepository,
       _mediaRepository = mediaRepository,
       _enrichmentRepository = enrichmentRepository,
       _logger = logger,
       super(const CreatePersonState()) {
    on<CreatePersonInitialized>(_onInitialized);
    on<CreatePersonNameChanged>(_onNameChanged);
    on<CreatePersonDescriptionChanged>(_onDescriptionChanged);
    on<CreatePersonImageChanged>(_onImageChanged);
    on<CreatePersonImageRemoved>(_onImageRemoved);
    on<CreatePersonLanguageTabChanged>(_onLanguageTabChanged);
    on<CreatePersonSavedAsDraft>(_onSavedAsDraft);
    on<CreatePersonPublished>(_onPublished);
    on<CreatePersonEnrichmentRequested>(_onEnrichmentRequested);
  }

  final DataRepository<Person> _personsRepository;
  final MediaRepository _mediaRepository;
  final EnrichmentRepository _enrichmentRepository;
  final Logger _logger;
  final _uuid = const Uuid();

  void _onInitialized(
    CreatePersonInitialized event,
    Emitter<CreatePersonState> emit,
  ) {
    emit(
      state.copyWith(
        enabledLanguages: event.enabledLanguages,
        defaultLanguage: event.defaultLanguage,
        selectedLanguage:
            event.enabledLanguages.firstOrNull ?? event.defaultLanguage,
      ),
    );
  }

  void _onNameChanged(
    CreatePersonNameChanged event,
    Emitter<CreatePersonState> emit,
  ) {
    emit(
      state.copyWith(
        name: event.name,
        wasNameEnriched: false,
        isEnrichmentSuccessful: false,
      ),
    );
  }

  void _onDescriptionChanged(
    CreatePersonDescriptionChanged event,
    Emitter<CreatePersonState> emit,
  ) {
    emit(
      state.copyWith(
        description: event.description,
        wasDescriptionEnriched: false,
        isEnrichmentSuccessful: false,
      ),
    );
  }

  void _onImageChanged(
    CreatePersonImageChanged event,
    Emitter<CreatePersonState> emit,
  ) {
    emit(
      state.copyWith(
        imageFileBytes: ValueWrapper(event.imageFileBytes),
        imageFileName: ValueWrapper(event.imageFileName),
      ),
    );
  }

  void _onImageRemoved(
    CreatePersonImageRemoved event,
    Emitter<CreatePersonState> emit,
  ) {
    emit(
      state.copyWith(
        imageFileBytes: const ValueWrapper(null),
        imageFileName: const ValueWrapper(null),
      ),
    );
  }

  void _onLanguageTabChanged(
    CreatePersonLanguageTabChanged event,
    Emitter<CreatePersonState> emit,
  ) {
    emit(state.copyWith(selectedLanguage: event.language));
  }

  Future<void> _onSavedAsDraft(
    CreatePersonSavedAsDraft event,
    Emitter<CreatePersonState> emit,
  ) async {
    await _submitPerson(emit, status: ContentStatus.draft);
  }

  Future<void> _onPublished(
    CreatePersonPublished event,
    Emitter<CreatePersonState> emit,
  ) async {
    await _submitPerson(emit, status: ContentStatus.active);
  }

  Future<void> _onEnrichmentRequested(
    CreatePersonEnrichmentRequested event,
    Emitter<CreatePersonState> emit,
  ) async {
    _logger.info('AI Enrichment requested for person...');
    emit(state.copyWith(status: CreatePersonStatus.enriching));

    try {
      final partial = Person(
        id: _uuid.v4(),
        name: state.name,
        description: state.description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: ContentStatus.draft,
      );

      final enriched = await _enrichmentRepository.enrichPerson(partial);

      emit(
        state.copyWith(
          status: CreatePersonStatus.initial,
          name: enriched.name,
          description: enriched.description,
          isEnrichmentSuccessful: true,
          wasNameEnriched: true,
          wasDescriptionEnriched: true,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('Person enrichment failed.', e);
      emit(
        state.copyWith(
          status: CreatePersonStatus.enrichmentFailure,
          exception: ValueWrapper(e),
        ),
      );
    }
  }

  Future<void> _submitPerson(
    Emitter<CreatePersonState> emit, {
    required ContentStatus status,
  }) async {
    _logger.info('Submitting new person...');
    final newPersonId = _uuid.v4();
    String? newMediaAssetId;

    if (state.imageFileBytes != null && state.imageFileName != null) {
      emit(state.copyWith(status: CreatePersonStatus.imageUploading));
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
            status: CreatePersonStatus.imageUploadFailure,
            exception: ValueWrapper(exception),
          ),
        );
        return;
      }
    }

    emit(state.copyWith(status: CreatePersonStatus.entitySubmitting));
    try {
      final newPerson = Person(
        id: newPersonId,
        name: state.name,
        description: state.description,
        mediaAssetId: newMediaAssetId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: status,
      );
      await _personsRepository.create(item: newPerson);
      emit(
        state.copyWith(
          status: CreatePersonStatus.success,
          createdPerson: newPerson,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: CreatePersonStatus.entitySubmitFailure,
          exception: ValueWrapper(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreatePersonStatus.entitySubmitFailure,
          exception: ValueWrapper(
            UnknownException('An unexpected error occurred: $e'),
          ),
        ),
      );
    }
  }
}
