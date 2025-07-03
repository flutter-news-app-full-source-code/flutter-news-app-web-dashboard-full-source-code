import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ht_dashboard/l10n/app_localizations.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_http_client/ht_http_client.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:ht_dashboard/l10n/l10n.dart';

part 'edit_source_event.dart';
part 'edit_source_state.dart';

/// A BLoC to manage the state of editing a single source.
class EditSourceBloc extends Bloc<EditSourceEvent, EditSourceState> {
  /// {@macro edit_source_bloc}
  EditSourceBloc({
    required HtDataRepository<Source> sourcesRepository,
    required HtDataRepository<Country> countriesRepository,
    required String sourceId,
  }) : _sourcesRepository = sourcesRepository,
       _countriesRepository = countriesRepository,
       _sourceId = sourceId,
       super(const EditSourceState()) {
    on<EditSourceLoaded>(_onLoaded);
    on<EditSourceNameChanged>(_onNameChanged);
    on<EditSourceDescriptionChanged>(_onDescriptionChanged);
    on<EditSourceUrlChanged>(_onUrlChanged);
    on<EditSourceTypeChanged>(_onSourceTypeChanged);
    on<EditSourceLanguageChanged>(_onLanguageChanged);
    on<EditSourceHeadquartersChanged>(_onHeadquartersChanged);
    on<EditSourceStatusChanged>(_onStatusChanged);
    on<EditSourceSubmitted>(_onSubmitted);
  }

  final HtDataRepository<Source> _sourcesRepository;
  final HtDataRepository<Country> _countriesRepository;
  final String _sourceId;

  Future<void> _onLoaded(
    EditSourceLoaded event,
    Emitter<EditSourceState> emit,
  ) async {
    emit(state.copyWith(status: EditSourceStatus.loading));
    try {
      final [sourceResponse, countriesResponse] = await Future.wait([
        _sourcesRepository.read(id: _sourceId),
        _countriesRepository.readAll(),
      ]);
      final source = sourceResponse as Source;
      final countries = (countriesResponse as PaginatedResponse<Country>).items;
      emit(
        state.copyWith(
          status: EditSourceStatus.initial,
          initialSource: source,
          name: source.name,
          description: source.description ?? '',
          url: source.url ?? '',
          sourceType: () => source.sourceType,
          language: source.language ?? '',
          headquarters: () => source.headquarters,
          contentStatus: source.status,
          countries: countries,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onNameChanged(
    EditSourceNameChanged event,
    Emitter<EditSourceState> emit,
  ) {
    emit(state.copyWith(name: event.name, status: EditSourceStatus.initial));
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
        language: event.language,
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

  void _onStatusChanged(
    EditSourceStatusChanged event,
    Emitter<EditSourceState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: EditSourceStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditSourceSubmitted event,
    Emitter<EditSourceState> emit,
  ) async {
    if (!state.isFormValid) return;

    final initialSource = state.initialSource;
    if (initialSource == null) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          errorMessage: 'Cannot update: Original source data not loaded.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: EditSourceStatus.submitting));
    try {
      final updatedSource = initialSource.copyWith(
        name: state.name,
        description: state.description.isNotEmpty ? state.description : null,
        url: state.url.isNotEmpty ? state.url : null,
        sourceType: state.sourceType,
        language: state.language.isNotEmpty ? state.language : null,
        headquarters: state.headquarters,
        status: state.contentStatus,
        updatedAt: DateTime.now(),
      );

      await _sourcesRepository.update(id: _sourceId, item: updatedSource);
      emit(
        state.copyWith(
          status: EditSourceStatus.success,
          updatedSource: updatedSource,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditSourceStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

/// Adds localization support to the [SourceType] enum.
extension SourceTypeL10n on SourceType {
  /// Returns the localized name for the source type.
  ///
  /// This requires an [AppLocalizations] instance, which is typically
  /// retrieved from the build context.
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case SourceType.newsAgency:
        return l10n.sourceTypeNewsAgency;
      case SourceType.localNewsOutlet:
        return l10n.sourceTypeLocalNewsOutlet;
      case SourceType.nationalNewsOutlet:
        return l10n.sourceTypeNationalNewsOutlet;
      case SourceType.internationalNewsOutlet:
        return l10n.sourceTypeInternationalNewsOutlet;
      case SourceType.specializedPublisher:
        return l10n.sourceTypeSpecializedPublisher;
      case SourceType.blog:
        return l10n.sourceTypeBlog;
      case SourceType.governmentSource:
        return l10n.sourceTypeGovernmentSource;
      case SourceType.aggregator:
        return l10n.sourceTypeAggregator;
      case SourceType.other:
        return l10n.sourceTypeOther;
    }
  }
}
