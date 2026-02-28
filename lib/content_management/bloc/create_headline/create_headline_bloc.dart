import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

part 'create_headline_event.dart';
part 'create_headline_state.dart';

/// {@template create_headline_bloc}
/// A BLoC to manage the state of creating a new headline.
///
/// This BLoC handles form input changes and orchestrates the two-stage
/// submission process: first uploading the image to media services, and then
/// creating the headline entity with the returned media asset ID.
/// {@endtemplate}
class CreateHeadlineBloc
    extends Bloc<CreateHeadlineEvent, CreateHeadlineState> {
  /// {@macro create_headline_bloc}
  CreateHeadlineBloc({
    required DataRepository<Headline> headlinesRepository,
    required MediaRepository mediaRepository,
    required Logger logger,
  }) : _headlinesRepository = headlinesRepository,
       _mediaRepository = mediaRepository,
       _logger = logger,
       super(const CreateHeadlineState()) {
    on<CreateHeadlineInitialized>(_onInitialized);
    on<CreateHeadlineTitleChanged>(_onTitleChanged);
    on<CreateHeadlineUrlChanged>(_onUrlChanged);
    on<CreateHeadlineImageChanged>(_onImageChanged);
    on<CreateHeadlineImageRemoved>(_onImageRemoved);
    on<CreateHeadlineSourceChanged>(_onSourceChanged);
    on<CreateHeadlineTopicChanged>(_onTopicChanged);
    on<CreateHeadlineCountryChanged>(_onCountryChanged);
    on<CreateHeadlineIsBreakingChanged>(_onIsBreakingChanged);
    on<CreateHeadlineLanguageTabChanged>(_onLanguageTabChanged);
    on<CreateHeadlineSavedAsDraft>(_onSavedAsDraft);
    on<CreateHeadlinePublished>(_onPublished);
  }

  final DataRepository<Headline> _headlinesRepository;
  final MediaRepository _mediaRepository;
  final Logger _logger;

  final _uuid = const Uuid();

  void _onInitialized(
    CreateHeadlineInitialized event,
    Emitter<CreateHeadlineState> emit,
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

  void _onTitleChanged(
    CreateHeadlineTitleChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    _logger.fine('Title changed: ${event.title}');
    emit(state.copyWith(title: event.title));
  }

  void _onUrlChanged(
    CreateHeadlineUrlChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    _logger.fine('URL changed: ${event.url}');
    emit(state.copyWith(url: event.url));
  }

  void _onImageChanged(
    CreateHeadlineImageChanged event,
    Emitter<CreateHeadlineState> emit,
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
    CreateHeadlineImageRemoved event,
    Emitter<CreateHeadlineState> emit,
  ) {
    _logger.fine('Image removed.');
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
    _logger.fine('Source changed: ${event.source?.name}');
    emit(state.copyWith(source: () => event.source));
  }

  void _onTopicChanged(
    CreateHeadlineTopicChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    _logger.fine('Topic changed: ${event.topic?.name}');
    emit(state.copyWith(topic: () => event.topic));
  }

  void _onCountryChanged(
    CreateHeadlineCountryChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    _logger.fine('Country changed: ${event.country?.name}');
    emit(state.copyWith(eventCountry: () => event.country));
  }

  void _onIsBreakingChanged(
    CreateHeadlineIsBreakingChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    _logger.fine('Is Breaking changed: ${event.isBreaking}');
    emit(state.copyWith(isBreaking: event.isBreaking));
  }

  void _onLanguageTabChanged(
    CreateHeadlineLanguageTabChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(selectedLanguage: event.language));
  }

  /// Handles saving the headline as a draft.
  Future<void> _onSavedAsDraft(
    CreateHeadlineSavedAsDraft event,
    Emitter<CreateHeadlineState> emit,
  ) async {
    _logger.info('Saving headline as draft...');
    await _submitHeadline(emit, status: ContentStatus.draft);
  }

  /// Handles publishing the headline.
  Future<void> _onPublished(
    CreateHeadlinePublished event,
    Emitter<CreateHeadlineState> emit,
  ) async {
    _logger.info('Publishing headline...');
    await _submitHeadline(emit, status: ContentStatus.active);
  }

  /// Orchestrates the two-stage process of creating a headline.
  ///
  /// First, it uploads the image file if one is present. If the upload is
  /// successful, it proceeds to create the headline entity in the database.
  Future<void> _submitHeadline(
    Emitter<CreateHeadlineState> emit, {
    required ContentStatus status,
  }) async {
    final newHeadlineId = _uuid.v4();
    String? newMediaAssetId;

    // --- Stage 1: Image Upload ---
    if (state.imageFileBytes != null && state.imageFileName != null) {
      emit(state.copyWith(status: CreateHeadlineStatus.imageUploading));
      _logger.fine(
        'Starting image upload for new headline ID: $newHeadlineId...',
      );
      try {
        newMediaAssetId = await _mediaRepository.uploadFile(
          fileBytes: state.imageFileBytes!,
          fileName: state.imageFileName!,
          purpose: MediaAssetPurpose.headlineImage,
        );
        _logger.info(
          'Image upload successful. MediaAssetId: $newMediaAssetId',
        );
      } on HttpException catch (e) {
        _logger.severe('Image upload failed.', e);
        // Provide a more user-friendly message for bad requests, which are
        // likely due to file size limits.
        final exception = e is BadRequestException
            ? const BadRequestException('File is too large.')
            : e;
        emit(
          state.copyWith(
            status: CreateHeadlineStatus.imageUploadFailure,
            exception: ValueWrapper(exception),
          ),
        );
        return;
      }
    }

    // --- Stage 2: Entity Submission ---
    emit(state.copyWith(status: CreateHeadlineStatus.entitySubmitting));
    _logger.fine('Starting entity submission for headline ID: $newHeadlineId');
    try {
      final now = DateTime.now();
      final newHeadline = Headline(
        id: newHeadlineId,
        title: state.title,
        url: state.url,
        imageUrl: null,
        mediaAssetId: newMediaAssetId,
        source: state.source!,
        eventCountry: state.eventCountry!,
        topic: state.topic!,
        createdAt: now,
        updatedAt: now,
        status: status,
        isBreaking: state.isBreaking,
      );

      _logger.finer('Submitting new headline data: ${newHeadline.toJson()}');
      await _headlinesRepository.create(item: newHeadline);
      _logger.info('Headline entity created successfully.');
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.success,
          createdHeadline: newHeadline,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('Headline entity submission failed.', e);
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.entitySubmitFailure,
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
          status: CreateHeadlineStatus.entitySubmitFailure,
          exception: ValueWrapper(
            UnknownException('An unexpected error occurred: $e'),
          ),
        ),
      );
    }
  }
}
