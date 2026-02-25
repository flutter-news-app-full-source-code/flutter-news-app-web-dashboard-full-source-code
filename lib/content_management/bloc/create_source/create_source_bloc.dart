import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

part 'create_source_event.dart';
part 'create_source_state.dart';

/// {@template create_source_bloc}
/// A BLoC to manage the state of creating a new source.
///
/// This BLoC handles form input changes and orchestrates the two-stage
/// submission process: first uploading the logo to media services, and then
/// creating the source entity with the returned media asset ID.
/// {@endtemplate}
class CreateSourceBloc extends Bloc<CreateSourceEvent, CreateSourceState> {
  /// {@macro create_source_bloc}
  CreateSourceBloc({
    required DataRepository<Source> sourcesRepository,
    required MediaRepository mediaRepository,
    required Logger logger,
  }) : _sourcesRepository = sourcesRepository,
       _mediaRepository = mediaRepository,
       _logger = logger,
       super(const CreateSourceState()) {
    on<CreateSourceLoaded>(_onLoaded);
    on<CreateSourceNameChanged>(_onNameChanged);
    on<CreateSourceDescriptionChanged>(_onDescriptionChanged);
    on<CreateSourceUrlChanged>(_onUrlChanged);
    on<CreateSourceTypeChanged>(_onSourceTypeChanged);
    on<CreateSourceLanguageChanged>(_onLanguageChanged);
    on<CreateSourceHeadquartersChanged>(_onHeadquartersChanged);
    on<CreateSourceImageChanged>(_onImageChanged);
    on<CreateSourceImageRemoved>(_onImageRemoved);
    on<CreateSourceSavedAsDraft>(_onSavedAsDraft);
    on<CreateSourcePublished>(_onPublished);
  }

  final DataRepository<Source> _sourcesRepository;
  final MediaRepository _mediaRepository;
  final Logger _logger;
  final _uuid = const Uuid();

  void _onLoaded(
    CreateSourceLoaded event,
    Emitter<CreateSourceState> emit,
  ) {
    emit(
      state.copyWith(
        enabledLanguages: event.enabledLanguages,
        defaultLanguage: event.defaultLanguage,
      ),
    );
  }

  void _onNameChanged(
    CreateSourceNameChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    final newName = Map<SupportedLanguage, String>.from(state.name);
    newName[event.language] = event.name;
    _logger.fine('Name changed for ${event.language}: ${event.name}');
    emit(state.copyWith(name: newName));
  }

  void _onDescriptionChanged(
    CreateSourceDescriptionChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    final newDescription = Map<SupportedLanguage, String>.from(
      state.description,
    );
    newDescription[event.language] = event.description;
    _logger.fine(
      'Description changed for ${event.language}: ${event.description}',
    );
    emit(state.copyWith(description: newDescription));
  }

  void _onUrlChanged(
    CreateSourceUrlChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    _logger.fine('URL changed: ${event.url}');
    emit(state.copyWith(url: event.url));
  }

  void _onSourceTypeChanged(
    CreateSourceTypeChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    _logger.fine('Source type changed: ${event.sourceType?.name}');
    emit(state.copyWith(sourceType: () => event.sourceType));
  }

  void _onLanguageChanged(
    CreateSourceLanguageChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    _logger.fine('Language changed: ${event.language?.name}');
    emit(state.copyWith(language: () => event.language));
  }

  void _onHeadquartersChanged(
    CreateSourceHeadquartersChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    _logger.fine('Headquarters changed: ${event.headquarters?.name}');
    emit(state.copyWith(headquarters: () => event.headquarters));
  }

  void _onImageChanged(
    CreateSourceImageChanged event,
    Emitter<CreateSourceState> emit,
  ) {
    _logger.fine('Image changed: ${event.imageFileName}');
    emit(
      state.copyWith(
        imageFileBytes: ValueWrapper(event.imageFileBytes),
        imageFileName: ValueWrapper(event.imageFileName),
      ),
    );
  }

  void _onImageRemoved(
    CreateSourceImageRemoved event,
    Emitter<CreateSourceState> emit,
  ) {
    _logger.fine('Image removed.');
    emit(
      state.copyWith(
        imageFileBytes: const ValueWrapper(null),
        imageFileName: const ValueWrapper(null),
      ),
    );
  }

  /// Handles saving the source as a draft.
  Future<void> _onSavedAsDraft(
    CreateSourceSavedAsDraft event,
    Emitter<CreateSourceState> emit,
  ) async {
    _logger.info('Saving source as draft...');
    await _submitSource(emit, status: ContentStatus.draft);
  }

  /// Handles publishing the source.
  Future<void> _onPublished(
    CreateSourcePublished event,
    Emitter<CreateSourceState> emit,
  ) async {
    _logger.info('Publishing source...');
    await _submitSource(emit, status: ContentStatus.active);
  }

  /// Orchestrates the two-stage process of creating a source.
  ///
  /// First, it uploads the logo file if one is present. If the upload is
  /// successful, it proceeds to create the source entity in the database.
  Future<void> _submitSource(
    Emitter<CreateSourceState> emit, {
    required ContentStatus status,
  }) async {
    final newSourceId = _uuid.v4();
    String? newMediaAssetId;

    // --- Stage 1: Image Upload ---
    if (state.imageFileBytes != null && state.imageFileName != null) {
      emit(state.copyWith(status: CreateSourceStatus.imageUploading));
      _logger.fine(
        'Starting image upload for new source ID: $newSourceId...',
      );
      try {
        newMediaAssetId = await _mediaRepository.uploadFile(
          fileBytes: state.imageFileBytes!,
          fileName: state.imageFileName!,
          purpose: MediaAssetPurpose.sourceImage,
        );
        _logger.info(
          'Image upload successful. MediaAssetId: $newMediaAssetId',
        );
      } on HttpException catch (e) {
        _logger.severe('Image upload failed.', e);
        final exception = e is BadRequestException
            ? const BadRequestException('File is too large.')
            : e;
        emit(
          state.copyWith(
            status: CreateSourceStatus.imageUploadFailure,
            exception: ValueWrapper(exception),
          ),
        );
        return;
      }
    }

    // --- Stage 2: Entity Submission ---
    emit(state.copyWith(status: CreateSourceStatus.entitySubmitting));
    _logger.fine('Starting entity submission for source ID: $newSourceId');
    try {
      final now = DateTime.now();
      final newSource = Source(
        id: newSourceId,
        name: state.name,
        mediaAssetId: newMediaAssetId,
        description: state.description,
        url: state.url,
        sourceType: state.sourceType!,
        language: state.language!,
        createdAt: now,
        updatedAt: now,
        headquarters: state.headquarters!,
        status: status,
      );

      _logger.finer('Submitting new source data: ${newSource.toJson()}');
      await _sourcesRepository.create(item: newSource);
      _logger.info('Source entity created successfully.');

      emit(
        state.copyWith(
          status: CreateSourceStatus.success,
          createdSource: newSource,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('Source entity submission failed.', e);
      emit(
        state.copyWith(
          status: CreateSourceStatus.entitySubmitFailure,
          exception: ValueWrapper(e),
        ),
      );
    } catch (e) {
      _logger.severe(
        'An unexpected error occurred during entity submission.',
        e,
      );
      emit(
        state.copyWith(
          status: CreateSourceStatus.entitySubmitFailure,
          exception: ValueWrapper(
            UnknownException('An unexpected error occurred: $e'),
          ),
        ),
      );
    }
  }
}
