import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

part 'edit_source_event.dart';
part 'edit_source_state.dart';

/// {@template edit_source_bloc}
/// A BLoC to manage the state of editing a single source.
///
/// This BLoC handles loading the existing source, managing form input
/// changes, and orchestrating the two-stage update process.
/// {@endtemplate}
class EditSourceBloc extends Bloc<EditSourceEvent, EditSourceState> {
  /// {@macro edit_source_bloc}
  EditSourceBloc({
    required DataRepository<Source> sourcesRepository,
    required MediaRepository mediaRepository,
    required String sourceId,
    Logger? logger,
  }) : _sourcesRepository = sourcesRepository,
       _mediaRepository = mediaRepository,
       _logger = logger ?? Logger('EditSourceBloc'),
       super(EditSourceState(sourceId: sourceId)) {
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
  }

  final DataRepository<Source> _sourcesRepository;
  final MediaRepository _mediaRepository;
  final Logger _logger;

  Future<void> _onEditSourceLoaded(
    EditSourceLoaded event,
    Emitter<EditSourceState> emit,
  ) async {
    _logger.fine(
      'Loading source for editing with ID: ${state.sourceId}...',
    );
    emit(state.copyWith(status: EditSourceStatus.loading));
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
          initialSource: source,
        ),
      );
      _logger.info('Successfully loaded source: ${source.id}');
    } on HttpException catch (e) {
      _logger.severe('Failed to load source: ${state.sourceId}', e);
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          exception: ValueWrapper(e),
        ),
      );
    } catch (e) {
      _logger.severe(
        'An unexpected error occurred while loading source: ${state.sourceId}',
      );
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          exception: ValueWrapper(
            UnknownException('An unexpected error occurred: $e'),
          ),
        ),
      );
    }
  }

  void _onNameChanged(
    EditSourceNameChanged event,
    Emitter<EditSourceState> emit,
  ) {
    _logger.finer('Name changed: ${event.name}');
    emit(
      state.copyWith(name: event.name, status: EditSourceStatus.initial),
    );
  }

  void _onDescriptionChanged(
    EditSourceDescriptionChanged event,
    Emitter<EditSourceState> emit,
  ) {
    _logger.finer('Description changed: ${event.description}');
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
    _logger.finer('URL changed: ${event.url}');
    emit(state.copyWith(url: event.url, status: EditSourceStatus.initial));
  }

  void _onSourceTypeChanged(
    EditSourceTypeChanged event,
    Emitter<EditSourceState> emit,
  ) {
    _logger.finer('Source type changed: ${event.sourceType?.name}');
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
    _logger.finer('Language changed: ${event.language?.name}');
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
    _logger.finer('Headquarters changed: ${event.headquarters?.name}');
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
    _logger.finer('Image changed: ${event.imageFileName}');
    emit(
      state.copyWith(
        imageFileBytes: ValueWrapper(event.imageFileBytes),
        imageFileName: ValueWrapper(event.imageFileName),
        imageRemoved: false,
        status: EditSourceStatus.initial,
      ),
    );
  }

  void _onImageRemoved(
    EditSourceImageRemoved event,
    Emitter<EditSourceState> emit,
  ) {
    _logger.finer('Image removed.');
    emit(
      state.copyWith(
        logoUrl: const ValueWrapper(null),
        imageFileBytes: const ValueWrapper(null),
        imageFileName: const ValueWrapper(null),
        imageRemoved: true,
        status: EditSourceStatus.initial,
      ),
    );
  }

  /// Handles saving the source as a draft.
  Future<void> _onSavedAsDraft(
    EditSourceSavedAsDraft event,
    Emitter<EditSourceState> emit,
  ) async {
    _logger.info('Saving source as draft...');
    await _submitSource(emit, status: ContentStatus.draft);
  }

  /// Handles publishing the source.
  Future<void> _onPublished(
    EditSourcePublished event,
    Emitter<EditSourceState> emit,
  ) async {
    _logger.info('Publishing source...');
    await _submitSource(emit, status: ContentStatus.active);
  }

  /// Orchestrates the two-stage process of updating a source.
  ///
  /// First, it uploads a new logo file if one has been provided. If the
  /// upload is successful (or if no new logo was provided), it proceeds to
  /// update the source entity in the database.
  ///
  /// This method includes a critical fix to prevent a race condition by using
  /// an `initialSource` from the state rather than re-fetching from the repository.
  Future<void> _submitSource(
    Emitter<EditSourceState> emit, {
    required ContentStatus status,
  }) async {
    String? newMediaAssetId;

    if (state.imageFileBytes != null && state.imageFileName != null) {
      emit(state.copyWith(status: EditSourceStatus.imageUploading));
      _logger.fine('Starting image upload for source: ${state.sourceId}');
      try {
        newMediaAssetId = await _mediaRepository.uploadFile(
          fileBytes: state.imageFileBytes!,
          fileName: state.imageFileName!,
          purpose: MediaAssetPurpose.sourceImage,
        );
        _logger.info(
          'Image upload successful for source ${state.sourceId}. New MediaAssetId: $newMediaAssetId',
        );
      } on HttpException catch (e) {
        _logger.severe('Image upload failed for source: ${state.sourceId}', e);
        final exception = e is BadRequestException
            ? const BadRequestException('File is too large.')
            : e;
        emit(
          state.copyWith(
            status: EditSourceStatus.imageUploadFailure,
            exception: ValueWrapper(exception),
          ),
        );
        return;
      }
    }

    emit(state.copyWith(status: EditSourceStatus.entitySubmitting));
    _logger.fine('Starting entity update for source: ${state.sourceId}');
    try {
      // CRITICAL: Use `state.initialSource` as the base for the update.
      // This prevents a race condition where another user's edits could be
      // overwritten. By using the source state as it was when the page
      // was loaded, we ensure that we are only applying the changes made
      // in *this* editing session.
      if (state.initialSource == null) {
        throw const OperationFailedException(
          'Cannot update source: initial state is missing.',
        );
      }
      final updatedSource = state.initialSource!.copyWith(
        name: state.name,
        description: state.description,
        url: state.url,
        sourceType: state.sourceType,
        language: state.language,
        headquarters: state.headquarters,
        status: status,
        updatedAt: DateTime.now(),
        logoUrl: (newMediaAssetId != null || state.imageRemoved)
            ? const ValueWrapper(null)
            : ValueWrapper(state.initialSource!.logoUrl),
        mediaAssetId: newMediaAssetId != null
            ? ValueWrapper(newMediaAssetId)
            : state.imageRemoved
            ? const ValueWrapper(null)
            : ValueWrapper(state.initialSource!.mediaAssetId),
      );

      _logger.finer(
        'Submitting updated source data: ${updatedSource.toJson()}',
      );
      await _sourcesRepository.update(id: state.sourceId, item: updatedSource);
      _logger.info('Source entity updated successfully: ${state.sourceId}');
      emit(
        state.copyWith(
          status: EditSourceStatus.success,
          updatedSource: updatedSource,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('Source entity update failed: ${state.sourceId}', e);
      emit(
        state.copyWith(
          status: EditSourceStatus.entitySubmitFailure,
          exception: ValueWrapper(e),
        ),
      );
    } catch (e) {
      _logger.severe(
        'An unexpected error occurred during entity update: ${state.sourceId}',
      );
      emit(
        state.copyWith(
          status: EditSourceStatus.entitySubmitFailure,
          exception: ValueWrapper(
            UnknownException('An unexpected error occurred: $e'),
          ),
        ),
      );
    }
  }
}
