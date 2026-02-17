import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show ValueGetter;
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';
import 'package:logging/logging.dart';

part 'edit_headline_event.dart';
part 'edit_headline_state.dart';

/// {@template edit_headline_bloc}
/// A BLoC to manage the state of editing a single headline.
///
/// This BLoC handles loading the existing headline, managing form input
/// changes, and orchestrating the two-stage update process.
/// {@endtemplate}
class EditHeadlineBloc extends Bloc<EditHeadlineEvent, EditHeadlineState> {
  /// {@macro edit_headline_bloc}
  EditHeadlineBloc({
    required DataRepository<Headline> headlinesRepository,
    required MediaRepository mediaRepository,
    required OptimisticImageCacheService optimisticImageCacheService,
    required String headlineId,
    required Logger logger,
  }) : _headlinesRepository = headlinesRepository,
       _mediaRepository = mediaRepository,
       _optimisticImageCacheService = optimisticImageCacheService,
       _logger = logger,
       super(EditHeadlineState(headlineId: headlineId)) {
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
  }

  final DataRepository<Headline> _headlinesRepository;
  final MediaRepository _mediaRepository;
  final Logger _logger;
  final OptimisticImageCacheService _optimisticImageCacheService;

  Future<void> _onEditHeadlineLoaded(
    EditHeadlineLoaded event,
    Emitter<EditHeadlineState> emit,
  ) async {
    _logger.fine(
      'Loading headline for editing with ID: ${state.headlineId}...',
    );
    emit(state.copyWith(status: EditHeadlineStatus.loading));
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
          initialHeadline: headline,
        ),
      );
      _logger.info('Successfully loaded headline: ${headline.id}');
    } on HttpException catch (e) {
      _logger.severe('Failed to load headline: ${state.headlineId}', e);
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: ValueWrapper(e),
        ),
      );
    } catch (e) {
      _logger.severe(
        'An unexpected error occurred while loading headline: ${state.headlineId}',
      );
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: ValueWrapper(
            UnknownException('An unexpected error occurred: $e'),
          ),
        ),
      );
    }
  }

  void _onTitleChanged(
    EditHeadlineTitleChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    _logger.finer('Title changed: ${event.title}');
    emit(
      state.copyWith(title: event.title, status: EditHeadlineStatus.initial),
    );
  }

  void _onUrlChanged(
    EditHeadlineUrlChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    _logger.finer('URL changed: ${event.url}');
    emit(state.copyWith(url: event.url, status: EditHeadlineStatus.initial));
  }

  void _onImageChanged(
    EditHeadlineImageChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    _logger.finer('Image changed: ${event.imageFileName}');
    emit(
      state.copyWith(
        imageFileBytes: ValueWrapper(event.imageFileBytes),
        imageFileName: ValueWrapper(event.imageFileName),
        imageRemoved: false,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onImageRemoved(
    EditHeadlineImageRemoved event,
    Emitter<EditHeadlineState> emit,
  ) {
    _logger.finer('Image removed.');
    emit(
      state.copyWith(
        imageFileBytes: const ValueWrapper(null),
        imageFileName: const ValueWrapper(null),
        imageRemoved: true,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onSourceChanged(
    EditHeadlineSourceChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    _logger.finer('Source changed: ${event.source?.name}');
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
    _logger.finer('Topic changed: ${event.topic?.name}');
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
    _logger.finer('Country changed: ${event.country?.name}');
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
    _logger.finer('Is Breaking changed: ${event.isBreaking}');
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
    _logger.info('Saving headline as draft...');
    await _submitHeadline(emit, status: ContentStatus.draft);
  }

  /// Handles publishing the headline.
  Future<void> _onPublished(
    EditHeadlinePublished event,
    Emitter<EditHeadlineState> emit,
  ) async {
    _logger.info('Publishing headline...');
    await _submitHeadline(emit, status: ContentStatus.active);
  }

  /// Orchestrates the two-stage process of updating a headline.
  ///
  /// First, it uploads a new image file if one has been provided. If the
  /// upload is successful (or if no new image was provided), it proceeds to
  /// update the headline entity in the database.
  Future<void> _submitHeadline(
    Emitter<EditHeadlineState> emit, {
    required ContentStatus status,
  }) async {
    String? newMediaAssetId;

    // --- Stage 1: Image Upload (if applicable) ---
    if (state.imageFileBytes != null && state.imageFileName != null) {
      emit(state.copyWith(status: EditHeadlineStatus.imageUploading));
      _logger.fine('Starting image upload for headline: ${state.headlineId}');
      try {
        newMediaAssetId = await _mediaRepository.uploadFile(
          fileBytes: state.imageFileBytes!,
          fileName: state.imageFileName!,
          purpose: MediaAssetPurpose.headlineImage,
        );
        _optimisticImageCacheService.cacheImage(
          state.headlineId,
          state.imageFileBytes!,
        );
        _logger.info(
          'Image upload successful for headline ${state.headlineId}. New MediaAssetId: $newMediaAssetId',
        );
      } on HttpException catch (e) {
        _logger.severe(
          'Image upload failed for headline: ${state.headlineId}',
          e,
        );
        // Provide a more user-friendly message for bad requests, which are
        // likely due to file size limits.
        final exception = e is BadRequestException
            ? const BadRequestException('File is too large.')
            : e;
        emit(
          state.copyWith(
            status: EditHeadlineStatus.imageUploadFailure,
            exception: ValueWrapper(exception),
          ),
        );
        return;
      }
    }

    // --- Stage 2: Entity Submission ---
    emit(state.copyWith(status: EditHeadlineStatus.entitySubmitting));
    _logger.fine('Starting entity update for headline: ${state.headlineId}');
    try {
      // CRITICAL: Use `state.initialHeadline` as the base for the update.
      // This prevents a race condition where another user's edits could be
      // overwritten. By using the headline state as it was when the page
      // was loaded, we ensure that we are only applying the changes made
      // in *this* editing session.
      if (state.initialHeadline == null) {
        throw const OperationFailedException(
          'Cannot update headline: initial state is missing.',
        );
      }
      final updatedHeadline = state.initialHeadline!.copyWith(
        title: state.title,
        url: state.url,
        source: state.source,
        topic: state.topic,
        eventCountry: state.eventCountry,
        isBreaking: state.isBreaking,
        status: status,
        updatedAt: DateTime.now(),
        imageUrl: (newMediaAssetId != null || state.imageRemoved)
            ? const ValueWrapper(null)
            : ValueWrapper(state.initialHeadline!.imageUrl),
        mediaAssetId: newMediaAssetId != null
            ? ValueWrapper(newMediaAssetId)
            : state.imageRemoved
            ? const ValueWrapper(null)
            : ValueWrapper(state.initialHeadline!.mediaAssetId),
      );

      _logger.finer(
        'Submitting updated headline data: ${updatedHeadline.toJson()}',
      );
      await _headlinesRepository.update(
        id: state.headlineId,
        item: updatedHeadline,
      );
      _logger.info('Headline entity updated successfully: ${state.headlineId}');
      emit(
        state.copyWith(
          status: EditHeadlineStatus.success,
          updatedHeadline: updatedHeadline,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('Headline entity update failed: ${state.headlineId}', e);
      emit(
        state.copyWith(
          status: EditHeadlineStatus.entitySubmitFailure,
          exception: ValueWrapper(e),
        ),
      );
    } catch (e) {
      _logger.severe(
        'An unexpected error occurred during entity update: ${state.headlineId}',
      );
      emit(
        state.copyWith(
          status: EditHeadlineStatus.entitySubmitFailure,
          exception: ValueWrapper(
            UnknownException('An unexpected error occurred: $e'),
          ),
        ),
      );
    }
  }
}
