import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';

part 'edit_source_event.dart';
part 'edit_source_state.dart';

/// A BLoC to manage the state of editing a single source.
class EditSourceBloc extends Bloc<EditSourceEvent, EditSourceState> {
  /// {@macro edit_source_bloc}
  EditSourceBloc({
    required DataRepository<Source> sourcesRepository,
    required MediaRepository mediaRepository,
    required OptimisticImageCacheService optimisticImageCacheService,
    required String sourceId,
  }) : _sourcesRepository = sourcesRepository,
       _mediaRepository = mediaRepository,
       _optimisticImageCacheService = optimisticImageCacheService,
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
    on<EditSourceImageChanged>(_onImageChanged);
    on<EditSourceImageRemoved>(_onImageRemoved);
    on<EditSourceSavedAsDraft>(_onSavedAsDraft);
    on<EditSourcePublished>(_onPublished);

    add(const EditSourceLoaded());
  }

  final DataRepository<Source> _sourcesRepository;
  final MediaRepository _mediaRepository;
  final OptimisticImageCacheService _optimisticImageCacheService;

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
          logoUrl: ValueWrapper(source.logoUrl),
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

  void _onImageChanged(
    EditSourceImageChanged event,
    Emitter<EditSourceState> emit,
  ) {
    emit(
      state.copyWith(
        imageFileBytes: ValueWrapper(event.imageFileBytes),
        imageFileName: ValueWrapper(event.imageFileName),
        status: EditSourceStatus.initial,
      ),
    );
  }

  void _onImageRemoved(
    EditSourceImageRemoved event,
    Emitter<EditSourceState> emit,
  ) {
    emit(
      state.copyWith(
        imageFileBytes: const ValueWrapper(null),
        imageFileName: const ValueWrapper(null),
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
      final newMediaAssetId = await _uploadImage();

      final originalSource = await _sourcesRepository.read(id: state.sourceId);
      final updatedSource = originalSource.copyWith(
        name: state.name,
        logoUrl: newMediaAssetId != null
            ? const ValueWrapper(null)
            : ValueWrapper(originalSource.logoUrl),
        mediaAssetId: newMediaAssetId != null
            ? ValueWrapper(newMediaAssetId)
            : ValueWrapper(originalSource.mediaAssetId),
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
      final newMediaAssetId = await _uploadImage();

      final originalSource = await _sourcesRepository.read(id: state.sourceId);
      final updatedSource = originalSource.copyWith(
        name: state.name,
        logoUrl: newMediaAssetId != null
            ? const ValueWrapper(null)
            : ValueWrapper(originalSource.logoUrl),
        mediaAssetId: newMediaAssetId != null
            ? ValueWrapper(newMediaAssetId)
            : ValueWrapper(originalSource.mediaAssetId),
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

  Future<String?> _uploadImage() async {
    if (state.imageFileBytes != null && state.imageFileName != null) {
      final mediaAssetId = await _mediaRepository.uploadFile(
        fileBytes: state.imageFileBytes!,
        fileName: state.imageFileName!,
        purpose: MediaAssetPurpose.sourceImage,
      );

      // Cache the new image optimistically.
      _optimisticImageCacheService.cacheImage(
        state.sourceId,
        state.imageFileBytes!,
      );

      return mediaAssetId;
    }
    return null;
  }
}
