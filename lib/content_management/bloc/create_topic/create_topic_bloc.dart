import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';
import 'package:uuid/uuid.dart';

part 'create_topic_event.dart';
part 'create_topic_state.dart';

/// A BLoC to manage the state of creating a new topic.
class CreateTopicBloc extends Bloc<CreateTopicEvent, CreateTopicState> {
  /// {@macro create_topic_bloc}
  CreateTopicBloc({
    required DataRepository<Topic> topicsRepository,
    required MediaRepository mediaRepository,
    required OptimisticImageCacheService optimisticImageCacheService,
  }) : _topicsRepository = topicsRepository,
       _mediaRepository = mediaRepository,
       _optimisticImageCacheService = optimisticImageCacheService,
       super(const CreateTopicState()) {
    on<CreateTopicNameChanged>(_onNameChanged);
    on<CreateTopicDescriptionChanged>(_onDescriptionChanged);
    on<CreateTopicImageChanged>(_onImageChanged);
    on<CreateTopicImageRemoved>(_onImageRemoved);
    on<CreateTopicSavedAsDraft>(_onSavedAsDraft);
    on<CreateTopicPublished>(_onPublished);
  }

  final DataRepository<Topic> _topicsRepository;
  final MediaRepository _mediaRepository;
  final OptimisticImageCacheService _optimisticImageCacheService;
  final _uuid = const Uuid();

  void _onNameChanged(
    CreateTopicNameChanged event,
    Emitter<CreateTopicState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onDescriptionChanged(
    CreateTopicDescriptionChanged event,
    Emitter<CreateTopicState> emit,
  ) {
    emit(
      state.copyWith(
        description: event.description,
      ),
    );
  }

  void _onImageChanged(
    CreateTopicImageChanged event,
    Emitter<CreateTopicState> emit,
  ) {
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
    emit(state.copyWith(status: CreateTopicStatus.submitting));
    try {
      final newTopicId = _uuid.v4();
      final newMediaAssetId = await _uploadImage(newTopicId);

      final now = DateTime.now();
      final newTopic = Topic(
        id: newTopicId,
        name: state.name,
        description: state.description,
        mediaAssetId: newMediaAssetId,
        status: ContentStatus.draft,
        createdAt: now,
        updatedAt: now,
      );

      await _topicsRepository.create(item: newTopic);
      emit(
        state.copyWith(
          status: CreateTopicStatus.success,
          createdTopic: newTopic,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: CreateTopicStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateTopicStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles publishing the topic.
  Future<void> _onPublished(
    CreateTopicPublished event,
    Emitter<CreateTopicState> emit,
  ) async {
    emit(state.copyWith(status: CreateTopicStatus.submitting));
    try {
      final newTopicId = _uuid.v4();
      final newMediaAssetId = await _uploadImage(newTopicId);

      final now = DateTime.now();
      final newTopic = Topic(
        id: newTopicId,
        name: state.name,
        description: state.description,
        mediaAssetId: newMediaAssetId,
        status: ContentStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      await _topicsRepository.create(item: newTopic);
      emit(
        state.copyWith(
          status: CreateTopicStatus.success,
          createdTopic: newTopic,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: CreateTopicStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateTopicStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<String?> _uploadImage(String topicId) async {
    if (state.imageFileBytes != null && state.imageFileName != null) {
      final mediaAssetId = await _mediaRepository.uploadFile(
        fileBytes: state.imageFileBytes!,
        fileName: state.imageFileName!,
        purpose: MediaAssetPurpose.topicImage,
      );

      // Cache the new image optimistically.
      _optimisticImageCacheService.cacheImage(
        topicId,
        state.imageFileBytes!,
      );

      return mediaAssetId;
    }
    return null;
  }
}
