import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

part 'create_topic_event.dart';
part 'create_topic_state.dart';

/// {@template create_topic_bloc}
/// A BLoC to manage the state of creating a new topic.
///
/// This BLoC handles form input changes and orchestrates the two-stage
/// submission process: first uploading the image to media services, and then
/// creating the topic entity with the returned media asset ID.
/// {@endtemplate}
class CreateTopicBloc extends Bloc<CreateTopicEvent, CreateTopicState> {
  /// {@macro create_topic_bloc}
  CreateTopicBloc({
    required DataRepository<Topic> topicsRepository,
    required MediaRepository mediaRepository,
    required Logger logger,
  }) : _topicsRepository = topicsRepository,
       _mediaRepository = mediaRepository,
       _logger = logger,
       super(const CreateTopicState()) {
    on<CreateTopicInitialized>(_onInitialized);
    on<CreateTopicNameChanged>(_onNameChanged);
    on<CreateTopicDescriptionChanged>(_onDescriptionChanged);
    on<CreateTopicImageChanged>(_onImageChanged);
    on<CreateTopicImageRemoved>(_onImageRemoved);
    on<CreateTopicSavedAsDraft>(_onSavedAsDraft);
    on<CreateTopicPublished>(_onPublished);
    on<CreateTopicLanguageTabChanged>(_onLanguageTabChanged);
  }

  final DataRepository<Topic> _topicsRepository;
  final MediaRepository _mediaRepository;
  final Logger _logger;
  final _uuid = const Uuid();

  void _onInitialized(
    CreateTopicInitialized event,
    Emitter<CreateTopicState> emit,
  ) {
    emit(
      state.copyWith(
        enabledLanguages: event.enabledLanguages,
        defaultLanguage: event.defaultLanguage,
      ),
    );
  }

  void _onNameChanged(
    CreateTopicNameChanged event,
    Emitter<CreateTopicState> emit,
  ) {
    _logger.fine('Name changed: ${event.name}');
    emit(state.copyWith(name: event.name));
  }

  void _onDescriptionChanged(
    CreateTopicDescriptionChanged event,
    Emitter<CreateTopicState> emit,
  ) {
    _logger.fine('Description changed: ${event.description}');
    emit(state.copyWith(description: event.description));
  }

  void _onLanguageTabChanged(
    CreateTopicLanguageTabChanged event,
    Emitter<CreateTopicState> emit,
  ) {
    emit(state.copyWith(selectedLanguage: event.language));
  }

  void _onImageChanged(
    CreateTopicImageChanged event,
    Emitter<CreateTopicState> emit,
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
    CreateTopicImageRemoved event,
    Emitter<CreateTopicState> emit,
  ) {
    _logger.fine('Image removed.');
    emit(
      state.copyWith(
        imageFileBytes: const ValueWrapper(null),
        imageFileName: const ValueWrapper(null),
      ),
    );
  }

  /// Handles saving the topic as a draft.
  Future<void> _onSavedAsDraft(
    CreateTopicSavedAsDraft event,
    Emitter<CreateTopicState> emit,
  ) async {
    _logger.info('Saving topic as draft...');
    await _submitTopic(emit, status: ContentStatus.draft);
  }

  /// Handles publishing the topic.
  Future<void> _onPublished(
    CreateTopicPublished event,
    Emitter<CreateTopicState> emit,
  ) async {
    _logger.info('Publishing topic...');
    await _submitTopic(emit, status: ContentStatus.active);
  }

  /// Orchestrates the two-stage process of creating a topic.
  ///
  /// First, it uploads the image file if one is present. If the upload is
  /// successful, it proceeds to create the topic entity in the database.
  Future<void> _submitTopic(
    Emitter<CreateTopicState> emit, {
    required ContentStatus status,
  }) async {
    final newTopicId = _uuid.v4();
    String? newMediaAssetId;

    // --- Stage 1: Image Upload ---
    if (state.imageFileBytes != null && state.imageFileName != null) {
      emit(state.copyWith(status: CreateTopicStatus.imageUploading));
      _logger.fine(
        'Starting image upload for new topic ID: $newTopicId...',
      );
      try {
        newMediaAssetId = await _mediaRepository.uploadFile(
          fileBytes: state.imageFileBytes!,
          fileName: state.imageFileName!,
          purpose: MediaAssetPurpose.topicImage,
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
            status: CreateTopicStatus.imageUploadFailure,
            exception: ValueWrapper(exception),
          ),
        );
        return;
      }
    }

    // --- Stage 2: Entity Submission ---
    emit(state.copyWith(status: CreateTopicStatus.entitySubmitting));
    _logger.fine('Starting entity submission for topic ID: $newTopicId');
    try {
      final now = DateTime.now();
      final newTopic = Topic(
        id: newTopicId,
        name: state.name,
        description: state.description,
        mediaAssetId: newMediaAssetId,
        status: status,
        createdAt: now,
        updatedAt: now,
      );

      _logger.finer('Submitting new topic data: ${newTopic.toJson()}');
      await _topicsRepository.create(item: newTopic);
      _logger.info('Topic entity created successfully.');
      emit(
        state.copyWith(
          status: CreateTopicStatus.success,
          createdTopic: newTopic,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('Topic entity submission failed.', e);
      emit(
        state.copyWith(
          status: CreateTopicStatus.entitySubmitFailure,
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
          status: CreateTopicStatus.entitySubmitFailure,
          exception: ValueWrapper(
            UnknownException('An unexpected error occurred: $e'),
          ),
        ),
      );
    }
  }
}
