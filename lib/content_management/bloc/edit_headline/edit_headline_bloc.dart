import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show ValueGetter;
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';

part 'edit_headline_event.dart';
part 'edit_headline_state.dart';

/// A BLoC to manage the state of editing a single headline.
class EditHeadlineBloc extends Bloc<EditHeadlineEvent, EditHeadlineState> {
  /// {@macro edit_headline_bloc}
  EditHeadlineBloc({
    required DataRepository<Headline> headlinesRepository,
    required MediaRepository mediaRepository,
    required OptimisticImageCacheService optimisticImageCacheService,
    required String headlineId,
  }) : _headlinesRepository = headlinesRepository,
       _mediaRepository = mediaRepository,
       _optimisticImageCacheService = optimisticImageCacheService,
       super(
         EditHeadlineState(
           headlineId: headlineId,
           status: EditHeadlineStatus.loading,
         ),
       ) {
    on<EditHeadlineLoaded>(_onEditHeadlineLoaded);
    on<EditHeadlineTitleChanged>(_onTitleChanged);
    on<EditHeadlineUrlChanged>(_onUrlChanged);
    on<EditHeadlineImageChanged>(_onImageChanged);
    on<EditHeadlineImageRemoved>(_onImageRemoved);
    on<EditHeadlineSourceChanged>(_onSourceChanged);
    on<EditHeadlineTopicChanged>(_onTopicChanged);
    on<EditHeadlineCountryChanged>(_onCountryChanged);
    on<EditHeadlineIsBreakingChanged>(_onIsBreakingChanged);
    on<EditHeadlineSavedAsDraft>(_onSavedAsDraft);
    on<EditHeadlinePublished>(_onPublished);

    add(const EditHeadlineLoaded());
  }

  final DataRepository<Headline> _headlinesRepository;
  final MediaRepository _mediaRepository;
  final OptimisticImageCacheService _optimisticImageCacheService;

  Future<void> _onEditHeadlineLoaded(
    EditHeadlineLoaded event,
    Emitter<EditHeadlineState> emit,
  ) async {
    try {
      final headline = await _headlinesRepository.read(id: state.headlineId);
      emit(
        state.copyWith(
          status: EditHeadlineStatus.initial,
          title: headline.title,
          url: headline.url,
          imageUrl: ValueWrapper(headline.imageUrl),
          source: () => headline.source,
          topic: () => headline.topic,
          eventCountry: () => headline.eventCountry,
          isBreaking: headline.isBreaking,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditHeadlineStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onTitleChanged(
    EditHeadlineTitleChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(title: event.title, status: EditHeadlineStatus.initial),
    );
  }

  void _onUrlChanged(
    EditHeadlineUrlChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(state.copyWith(url: event.url, status: EditHeadlineStatus.initial));
  }

  void _onImageChanged(
    EditHeadlineImageChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        imageFileBytes: ValueWrapper(event.imageFileBytes),
        imageFileName: ValueWrapper(event.imageFileName),
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onImageRemoved(
    EditHeadlineImageRemoved event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        imageFileBytes: const ValueWrapper(null),
        imageFileName: const ValueWrapper(null),
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onSourceChanged(
    EditHeadlineSourceChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        source: () => event.source,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onTopicChanged(
    EditHeadlineTopicChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        topic: () => event.topic,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onCountryChanged(
    EditHeadlineCountryChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        eventCountry: () => event.country,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onIsBreakingChanged(
    EditHeadlineIsBreakingChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        isBreaking: event.isBreaking,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  /// Handles saving the headline as a draft.
  Future<void> _onSavedAsDraft(
    EditHeadlineSavedAsDraft event,
    Emitter<EditHeadlineState> emit,
  ) async {
    emit(state.copyWith(status: EditHeadlineStatus.submitting));
    try {
      String? newMediaAssetId;
      // If a new image file is present, upload it first.
      if (state.imageFileBytes != null && state.imageFileName != null) {
        newMediaAssetId = await _mediaRepository.uploadFile(
          fileBytes: state.imageFileBytes!,
          fileName: state.imageFileName!,
          purpose: MediaAssetPurpose.headlineImage,
        );
        // Cache the new image optimistically.
        _optimisticImageCacheService.cacheImage(
          state.headlineId,
          state.imageFileBytes!,
        );
      }

      final originalHeadline = await _headlinesRepository.read(
        id: state.headlineId,
      );
      final updatedHeadline = originalHeadline.copyWith(
        title: state.title,
        url: state.url,
        imageUrl: newMediaAssetId != null
            ? const ValueWrapper(null)
            : ValueWrapper(state.imageUrl),
        mediaAssetId: newMediaAssetId != null
            ? ValueWrapper(newMediaAssetId)
            : ValueWrapper(originalHeadline.mediaAssetId),
        source: state.source,
        topic: state.topic,
        eventCountry: state.eventCountry,
        isBreaking: state.isBreaking,
        status: ContentStatus.draft,
        updatedAt: DateTime.now(),
      );

      await _headlinesRepository.update(
        id: state.headlineId,
        item: updatedHeadline,
      );
      emit(
        state.copyWith(
          status: EditHeadlineStatus.success,
          updatedHeadline: updatedHeadline,
        ),
      );
    } on HttpException catch (e) {
      final exception = e is BadRequestException
          ? const BadRequestException('File is too large.')
          : e;
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: exception,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles publishing the headline.
  Future<void> _onPublished(
    EditHeadlinePublished event,
    Emitter<EditHeadlineState> emit,
  ) async {
    emit(state.copyWith(status: EditHeadlineStatus.submitting));
    try {
      String? newMediaAssetId;
      // If a new image file is present, upload it first.
      if (state.imageFileBytes != null && state.imageFileName != null) {
        newMediaAssetId = await _mediaRepository.uploadFile(
          fileBytes: state.imageFileBytes!,
          fileName: state.imageFileName!,
          purpose: MediaAssetPurpose.headlineImage,
        );
        // Cache the new image optimistically.
        _optimisticImageCacheService.cacheImage(
          state.headlineId,
          state.imageFileBytes!,
        );
      }

      final originalHeadline = await _headlinesRepository.read(
        id: state.headlineId,
      );
      final updatedHeadline = originalHeadline.copyWith(
        title: state.title,
        url: state.url,
        imageUrl: newMediaAssetId != null
            ? const ValueWrapper(null)
            : ValueWrapper(state.imageUrl),
        mediaAssetId: newMediaAssetId != null
            ? ValueWrapper(newMediaAssetId)
            : ValueWrapper(originalHeadline.mediaAssetId),
        source: state.source,
        topic: state.topic,
        eventCountry: state.eventCountry,
        isBreaking: state.isBreaking,
        status: ContentStatus.active,
        updatedAt: DateTime.now(),
      );

      await _headlinesRepository.update(
        id: state.headlineId,
        item: updatedHeadline,
      );
      emit(
        state.copyWith(
          status: EditHeadlineStatus.success,
          updatedHeadline: updatedHeadline,
        ),
      );
    } on HttpException catch (e) {
      final exception = e is BadRequestException
          ? const BadRequestException('File is too large.')
          : e;
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: exception,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
