import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';
import 'package:logging/logging.dart';

part 'edit_topic_event.dart';
part 'edit_topic_state.dart';

/// {@template edit_topic_bloc}
/// A BLoC to manage the state of editing a single topic.
///
/// This BLoC handles loading the existing topic, managing form input
/// changes, and orchestrating the two-stage update process.
/// {@endtemplate}
class EditTopicBloc extends Bloc<EditTopicEvent, EditTopicState> {
  /// {@macro edit_topic_bloc}
  EditTopicBloc({
    required DataRepository<Topic> topicsRepository,
    required MediaRepository mediaRepository,
    required OptimisticImageCacheService optimisticImageCacheService,
    required String topicId,
    Logger? logger,
  }) : _topicsRepository = topicsRepository,
       _mediaRepository = mediaRepository,
       _optimisticImageCacheService = optimisticImageCacheService,
       _logger = logger ?? Logger('EditTopicBloc'),
       super(
         EditTopicState(topicId: topicId, status: EditTopicStatus.loading),
       ) {
    on<EditTopicLoaded>(_onEditTopicLoaded);
    on<EditTopicNameChanged>(_onNameChanged);
    on<EditTopicDescriptionChanged>(_onDescriptionChanged);
    on<EditTopicImageChanged>(_onImageChanged);
    on<EditTopicImageRemoved>(_onImageRemoved);
    on<EditTopicSavedAsDraft>(_onSavedAsDraft);
    on<EditTopicPublished>(_onPublished);

    add(const EditTopicLoaded());
  }

  final DataRepository<Topic> _topicsRepository;
  final MediaRepository _mediaRepository;
  final Logger _logger;
  final OptimisticImageCacheService _optimisticImageCacheService;

  Future<void> _onEditTopicLoaded(
    EditTopicLoaded event,
    Emitter<EditTopicState> emit,
  ) async {
    _logger.fine(
      'Loading topic for editing with ID: ${state.topicId}...',
    );
    emit(state.copyWith(status: EditTopicStatus.loading));
    try {
      final topic = await _topicsRepository.read(id: state.topicId);
      emit(
        state.copyWith(
          status: EditTopicStatus.initial,
          name: topic.name,
          description: topic.description,
          iconUrl: ValueWrapper(topic.iconUrl),
          initialTopic: topic,
        ),
      );
      _logger.info('Successfully loaded topic: ${topic.id}');
    } on HttpException catch (e) {
      _logger.severe('Failed to load topic: ${state.topicId}', e);
      emit(
        state.copyWith(
          status: EditTopicStatus.failure,
          exception: ValueWrapper(e),
        ),
      );
    } catch (e) {
      _logger.severe(
        'An unexpected error occurred while loading topic: ${state.topicId}',
      );
      emit(
        state.copyWith(
          status: EditTopicStatus.failure,
          exception: ValueWrapper(
            UnknownException('An unexpected error occurred: $e'),
          ),
        ),
      );
    }
  }

  void _onNameChanged(
    EditTopicNameChanged event,
    Emitter<EditTopicState> emit,
  ) {
    _logger.finer('Name changed: ${event.name}');
    emit(
      state.copyWith(name: event.name, status: EditTopicStatus.initial),
    );
  }

  void _onDescriptionChanged(
    EditTopicDescriptionChanged event,
    Emitter<EditTopicState> emit,
  ) {
    _logger.finer('Description changed: ${event.description}');
    emit(
      state.copyWith(
        description: event.description,
        status: EditTopicStatus.initial,
      ),
    );
  }

  void _onImageChanged(
    EditTopicImageChanged event,
    Emitter<EditTopicState> emit,
  ) {
    _logger.finer('Image changed: ${event.imageFileName}');
    emit(
      state.copyWith(
        imageFileBytes: ValueWrapper(event.imageFileBytes),
        imageFileName: ValueWrapper(event.imageFileName),
        imageRemoved: false,
        status: EditTopicStatus.initial,
      ),
    );
  }

  void _onImageRemoved(
    EditTopicImageRemoved event,
    Emitter<EditTopicState> emit,
  ) {
    _logger.finer('Image removed.');
    emit(
      state.copyWith(
        imageFileBytes: const ValueWrapper(null),
        imageFileName: const ValueWrapper(null),
        imageRemoved: true,
        status: EditTopicStatus.initial,
      ),
    );
  }

  /// Handles saving the topic as a draft.
  Future<void> _onSavedAsDraft(
    EditTopicSavedAsDraft event,
    Emitter<EditTopicState> emit,
  ) async {
    _logger.info('Saving topic as draft...');
    await _submitTopic(emit, status: ContentStatus.draft);
  }

  /// Handles publishing the topic.
  Future<void> _onPublished(
    EditTopicPublished event,
    Emitter<EditTopicState> emit,
  ) async {
    _logger.info('Publishing topic...');
    await _submitTopic(emit, status: ContentStatus.active);
  }

  /// Orchestrates the two-stage process of updating a topic.
  ///
  /// First, it uploads a new image file if one has been provided. If the
  /// upload is successful (or if no new image was provided), it proceeds to
  /// update the topic entity in the database.
  Future<void> _submitTopic(
    Emitter<EditTopicState> emit, {
    required ContentStatus status,
  }) async {
    String? newMediaAssetId;

    // --- Stage 1: Image Upload (if applicable) ---
    if (state.imageFileBytes != null && state.imageFileName != null) {
      emit(state.copyWith(status: EditTopicStatus.imageUploading));
      _logger.fine('Starting image upload for topic: ${state.topicId}');
      try {
        newMediaAssetId = await _mediaRepository.uploadFile(
          fileBytes: state.imageFileBytes!,
          fileName: state.imageFileName!,
          purpose: MediaAssetPurpose.topicImage,
        );
        _optimisticImageCacheService.cacheImage(
          state.topicId,
          state.imageFileBytes!,
        );
        _logger.info(
          'Image upload successful for topic ${state.topicId}. New MediaAssetId: $newMediaAssetId',
        );
      } on HttpException catch (e) {
        _logger.severe('Image upload failed for topic: ${state.topicId}', e);
        final exception = e is BadRequestException
            ? const BadRequestException('File is too large.')
            : e;
        emit(
          state.copyWith(
            status: EditTopicStatus.imageUploadFailure,
            exception: ValueWrapper(exception),
          ),
        );
        return;
      }
    }

    // --- Stage 2: Entity Submission ---
    emit(state.copyWith(status: EditTopicStatus.entitySubmitting));
    _logger.fine('Starting entity update for topic: ${state.topicId}');
    try {
      // CRITICAL: Use `state.initialTopic` as the base for the update.
      // This prevents a race condition where another user's edits could be
      // overwritten. By using the topic state as it was when the page
      // was loaded, we ensure that we are only applying the changes made
      // in *this* editing session.
      if (state.initialTopic == null) {
        throw const OperationFailedException(
          'Cannot update topic: initial state is missing.',
        );
      }
      final updatedTopic = state.initialTopic!.copyWith(
        name: state.name,
        description: state.description,
        status: status,
        updatedAt: DateTime.now(),
        iconUrl: (newMediaAssetId != null || state.imageRemoved)
            ? const ValueWrapper(null)
            : ValueWrapper(state.initialTopic!.iconUrl),
        mediaAssetId: newMediaAssetId != null
            ? ValueWrapper(newMediaAssetId)
            : state.imageRemoved
            ? const ValueWrapper(null)
            : ValueWrapper(state.initialTopic!.mediaAssetId),
      );

      _logger.finer('Submitting updated topic data: ${updatedTopic.toJson()}');
      await _topicsRepository.update(id: state.topicId, item: updatedTopic);
      _logger.info('Topic entity updated successfully: ${state.topicId}');
      emit(
        state.copyWith(
          status: EditTopicStatus.success,
          updatedTopic: updatedTopic,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('Topic entity update failed: ${state.topicId}', e);
      emit(
        state.copyWith(
          status: EditTopicStatus.entitySubmitFailure,
          exception: ValueWrapper(e),
        ),
      );
    } catch (e) {
      _logger.severe(
        'An unexpected error occurred during entity update: ${state.topicId}',
      );
      emit(
        state.copyWith(
          status: EditTopicStatus.entitySubmitFailure,
          exception: ValueWrapper(
            UnknownException('An unexpected error occurred: $e'),
          ),
        ),
      );
    }
  }
}
