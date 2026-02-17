import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';

part 'edit_topic_event.dart';
part 'edit_topic_state.dart';

/// A BLoC to manage the state of editing a single topic.
class EditTopicBloc extends Bloc<EditTopicEvent, EditTopicState> {
  /// {@macro edit_topic_bloc}
  EditTopicBloc({
    required DataRepository<Topic> topicsRepository,
    required MediaRepository mediaRepository,
    required OptimisticImageCacheService optimisticImageCacheService,
    required String topicId,
  }) : _topicsRepository = topicsRepository,
       _mediaRepository = mediaRepository,
       _optimisticImageCacheService = optimisticImageCacheService,
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
  final OptimisticImageCacheService _optimisticImageCacheService;

  Future<void> _onEditTopicLoaded(
    EditTopicLoaded event,
    Emitter<EditTopicState> emit,
  ) async {
    emit(state.copyWith(status: EditTopicStatus.loading));
    try {
      final topic = await _topicsRepository.read(id: state.topicId);
      emit(
        state.copyWith(
          status: EditTopicStatus.initial,
          name: topic.name,
          description: topic.description,
          iconUrl: ValueWrapper(topic.iconUrl),
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditTopicStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditTopicStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onNameChanged(
    EditTopicNameChanged event,
    Emitter<EditTopicState> emit,
  ) {
    emit(
      state.copyWith(name: event.name, status: EditTopicStatus.initial),
    );
  }

  void _onDescriptionChanged(
    EditTopicDescriptionChanged event,
    Emitter<EditTopicState> emit,
  ) {
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
    emit(
      state.copyWith(
        imageFileBytes: ValueWrapper(event.imageFileBytes),
        imageFileName: ValueWrapper(event.imageFileName),
        status: EditTopicStatus.initial,
      ),
    );
  }

  void _onImageRemoved(
    EditTopicImageRemoved event,
    Emitter<EditTopicState> emit,
  ) {
    emit(
      state.copyWith(
        imageFileBytes: const ValueWrapper(null),
        imageFileName: const ValueWrapper(null),
        status: EditTopicStatus.initial,
      ),
    );
  }

  /// Handles saving the topic as a draft.
  Future<void> _onSavedAsDraft(
    EditTopicSavedAsDraft event,
    Emitter<EditTopicState> emit,
  ) async {
    emit(state.copyWith(status: EditTopicStatus.submitting));
    try {
      final newMediaAssetId = await _uploadImage();

      final originalTopic = await _topicsRepository.read(id: state.topicId);
      final updatedTopic = originalTopic.copyWith(
        name: state.name,
        description: state.description,
        iconUrl: newMediaAssetId != null
            ? const ValueWrapper(null)
            : ValueWrapper(originalTopic.iconUrl),
        mediaAssetId: newMediaAssetId != null
            ? ValueWrapper(newMediaAssetId)
            : ValueWrapper(originalTopic.mediaAssetId),
        status: ContentStatus.draft,
        updatedAt: DateTime.now(),
      );

      await _topicsRepository.update(id: state.topicId, item: updatedTopic);
      emit(
        state.copyWith(
          status: EditTopicStatus.success,
          updatedTopic: updatedTopic,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditTopicStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditTopicStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles publishing the topic.
  Future<void> _onPublished(
    EditTopicPublished event,
    Emitter<EditTopicState> emit,
  ) async {
    emit(state.copyWith(status: EditTopicStatus.submitting));
    try {
      final newMediaAssetId = await _uploadImage();

      final originalTopic = await _topicsRepository.read(id: state.topicId);
      final updatedTopic = originalTopic.copyWith(
        name: state.name,
        description: state.description,
        iconUrl: newMediaAssetId != null
            ? const ValueWrapper(null)
            : ValueWrapper(originalTopic.iconUrl),
        mediaAssetId: newMediaAssetId != null
            ? ValueWrapper(newMediaAssetId)
            : ValueWrapper(originalTopic.mediaAssetId),
        status: ContentStatus.active,
        updatedAt: DateTime.now(),
      );

      await _topicsRepository.update(id: state.topicId, item: updatedTopic);
      emit(
        state.copyWith(
          status: EditTopicStatus.success,
          updatedTopic: updatedTopic,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditTopicStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditTopicStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<String?> _uploadImage() async {
    if (state.imageFileBytes != null && state.imageFileName != null) {
      final mediaAssetId = await _mediaRepository.uploadFile(
        fileBytes: state.imageFileBytes!,
        fileName: state.imageFileName!,
        purpose: MediaAssetPurpose.topicImage,
      );

      // Cache the new image optimistically.
      _optimisticImageCacheService.cacheImage(
        state.topicId,
        state.imageFileBytes!,
      );

      return mediaAssetId;
    }
    return null;
  }
}
