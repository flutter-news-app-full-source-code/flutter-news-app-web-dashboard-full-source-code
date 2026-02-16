import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';
import 'package:uuid/uuid.dart';

part 'create_headline_event.dart';
part 'create_headline_state.dart';

/// A BLoC to manage the state of creating a new headline.
class CreateHeadlineBloc
    extends Bloc<CreateHeadlineEvent, CreateHeadlineState> {
  /// {@macro create_headline_bloc}
  CreateHeadlineBloc({
    required DataRepository<Headline> headlinesRepository,
    required MediaRepository mediaRepository,
    required OptimisticImageCacheService optimisticImageCacheService,
  }) : _headlinesRepository = headlinesRepository,
       _mediaRepository = mediaRepository,
       _optimisticImageCacheService = optimisticImageCacheService,
       super(const CreateHeadlineState()) {
    on<CreateHeadlineTitleChanged>(_onTitleChanged);
    on<CreateHeadlineUrlChanged>(_onUrlChanged);
    on<CreateHeadlineImageChanged>(_onImageChanged);
    on<CreateHeadlineImageRemoved>(_onImageRemoved);
    on<CreateHeadlineSourceChanged>(_onSourceChanged);
    on<CreateHeadlineTopicChanged>(_onTopicChanged);
    on<CreateHeadlineCountryChanged>(_onCountryChanged);
    on<CreateHeadlineIsBreakingChanged>(_onIsBreakingChanged);
    on<CreateHeadlineSavedAsDraft>(_onSavedAsDraft);
    on<CreateHeadlinePublished>(_onPublished);
  }

  final DataRepository<Headline> _headlinesRepository;
  final MediaRepository _mediaRepository;
  final OptimisticImageCacheService _optimisticImageCacheService;

  final _uuid = const Uuid();

  void _onTitleChanged(
    CreateHeadlineTitleChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onUrlChanged(
    CreateHeadlineUrlChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(url: event.url));
  }

  void _onImageChanged(
    CreateHeadlineImageChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        imageFileBytes: ValueWrapper(event.imageFileBytes),
        imageFileName: ValueWrapper(event.imageFileName),
      ),
    );
  }

  void _onImageRemoved(
    CreateHeadlineImageRemoved event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        imageFileBytes: const ValueWrapper(null),
        imageFileName: const ValueWrapper(null),
      ),
    );
  }

  void _onSourceChanged(
    CreateHeadlineSourceChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(source: () => event.source));
  }

  void _onTopicChanged(
    CreateHeadlineTopicChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(topic: () => event.topic));
  }

  void _onCountryChanged(
    CreateHeadlineCountryChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(eventCountry: () => event.country));
  }

  void _onIsBreakingChanged(
    CreateHeadlineIsBreakingChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(isBreaking: event.isBreaking));
  }

  /// Handles saving the headline as a draft.
  Future<void> _onSavedAsDraft(
    CreateHeadlineSavedAsDraft event,
    Emitter<CreateHeadlineState> emit,
  ) async {
    emit(state.copyWith(status: CreateHeadlineStatus.submitting));
    try {
      final mediaAssetId = await _mediaRepository.uploadFile(
        fileBytes: state.imageFileBytes!,
        fileName: state.imageFileName!,
        purpose: MediaAssetPurpose.headlineImage,
      );

      final now = DateTime.now();
      final newHeadline = Headline(
        id: _uuid.v4(),
        title: state.title,
        url: state.url,
        // The imageUrl is intentionally null. The backend will populate it
        // via a webhook after the media asset is processed.
        imageUrl: null,
        mediaAssetId: mediaAssetId,
        source: state.source!,
        eventCountry: state.eventCountry!,
        topic: state.topic!,
        createdAt: now,
        updatedAt: now,
        status: ContentStatus.draft,
        isBreaking: state.isBreaking,
      );

      // Cache the image optimistically
      _optimisticImageCacheService.cacheImage(
        newHeadline.id,
        state.imageFileBytes!,
      );

      await _headlinesRepository.create(item: newHeadline);
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.success,
          createdHeadline: newHeadline,
        ),
      );
    } on HttpException catch (e) {
      final exception = e is BadRequestException
          ? const BadRequestException('File is too large.')
          : e;
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          exception: exception,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles publishing the headline.
  Future<void> _onPublished(
    CreateHeadlinePublished event,
    Emitter<CreateHeadlineState> emit,
  ) async {
    emit(state.copyWith(status: CreateHeadlineStatus.submitting));
    try {
      final mediaAssetId = await _mediaRepository.uploadFile(
        fileBytes: state.imageFileBytes!,
        fileName: state.imageFileName!,
        purpose: MediaAssetPurpose.headlineImage,
      );

      final now = DateTime.now();
      final newHeadline = Headline(
        id: _uuid.v4(),
        title: state.title,
        url: state.url,
        // The imageUrl is intentionally null. The backend will populate it
        // via a webhook after the media asset is processed.
        imageUrl: null,
        mediaAssetId: mediaAssetId,
        source: state.source!,
        eventCountry: state.eventCountry!,
        topic: state.topic!,
        createdAt: now,
        updatedAt: now,
        status: ContentStatus.active,
        isBreaking: state.isBreaking,
      );

      // Cache the image optimistically
      _optimisticImageCacheService.cacheImage(
        newHeadline.id,
        state.imageFileBytes!,
      );

      await _headlinesRepository.create(item: newHeadline);
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.success,
          createdHeadline: newHeadline,
        ),
      );
    } on HttpException catch (e) {
      final exception = e is BadRequestException
          ? const BadRequestException('File is too large.')
          : e;
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          exception: exception,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
