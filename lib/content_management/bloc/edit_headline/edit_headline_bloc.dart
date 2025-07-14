import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

part 'edit_headline_event.dart';
part 'edit_headline_state.dart';

/// A BLoC to manage the state of editing a single headline.
class EditHeadlineBloc extends Bloc<EditHeadlineEvent, EditHeadlineState> {
  /// {@macro edit_headline_bloc}
  EditHeadlineBloc({
    required HtDataRepository<Headline> headlinesRepository,
    required HtDataRepository<Source> sourcesRepository,
    required HtDataRepository<Topic> topicsRepository,
    required HtDataRepository<Country> countriesRepository,
    required String headlineId,
  }) : _headlinesRepository = headlinesRepository,
       _sourcesRepository = sourcesRepository,
       _topicsRepository = topicsRepository,
       _countriesRepository = countriesRepository,
       _headlineId = headlineId,
       super(const EditHeadlineState()) {
    on<EditHeadlineLoaded>(_onLoaded);
    on<EditHeadlineTitleChanged>(_onTitleChanged);
    on<EditHeadlineExcerptChanged>(_onExcerptChanged);
    on<EditHeadlineUrlChanged>(_onUrlChanged);
    on<EditHeadlineImageUrlChanged>(_onImageUrlChanged);
    on<EditHeadlineSourceChanged>(_onSourceChanged);
    on<EditHeadlineTopicChanged>(_onTopicChanged);
    on<EditHeadlineCountryChanged>(_onCountryChanged);
    on<EditHeadlineStatusChanged>(_onStatusChanged);
    on<EditHeadlineSubmitted>(_onSubmitted);
  }

  final HtDataRepository<Headline> _headlinesRepository;
  final HtDataRepository<Source> _sourcesRepository;
  final HtDataRepository<Topic> _topicsRepository;
  final HtDataRepository<Country> _countriesRepository;
  final String _headlineId;

  Future<void> _onLoaded(
    EditHeadlineLoaded event,
    Emitter<EditHeadlineState> emit,
  ) async {
    emit(state.copyWith(status: EditHeadlineStatus.loading));
    try {
      final [
        headlineResponse,
        sourcesResponse,
        topicsResponse,
        countriesResponse,
      ] = await Future.wait([
        _headlinesRepository.read(id: _headlineId),
        _sourcesRepository.readAll(),
        _topicsRepository.readAll(),
        _countriesRepository.readAll(),
      ]);

      final headline = headlineResponse as Headline;
      final sources = (sourcesResponse as PaginatedResponse<Source>).items;
      final topics = (topicsResponse as PaginatedResponse<Topic>).items;
      final countries = (countriesResponse as PaginatedResponse<Country>).items;

      emit(
        state.copyWith(
          status: EditHeadlineStatus.initial,
          initialHeadline: headline,
          title: headline.title,
          excerpt: headline.excerpt,
          url: headline.url,
          imageUrl: headline.imageUrl,
          source: () => headline.source,
          topic: () => headline.topic,
          eventCountry: () => headline.eventCountry,
          sources: sources,
          topics: topics,
          countries: countries,
          contentStatus: headline.status,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: e,
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

  void _onTitleChanged(
    EditHeadlineTitleChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(title: event.title, status: EditHeadlineStatus.initial),
    );
  }

  void _onExcerptChanged(
    EditHeadlineExcerptChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        excerpt: event.excerpt,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  void _onUrlChanged(
    EditHeadlineUrlChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(state.copyWith(url: event.url, status: EditHeadlineStatus.initial));
  }

  void _onImageUrlChanged(
    EditHeadlineImageUrlChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        imageUrl: event.imageUrl,
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

  void _onStatusChanged(
    EditHeadlineStatusChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: EditHeadlineStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditHeadlineSubmitted event,
    Emitter<EditHeadlineState> emit,
  ) async {
    if (!state.isFormValid) return;

    final initialHeadline = state.initialHeadline;
    if (initialHeadline == null) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: UnknownException('Cannot update: Original headline data not loaded.'),
        ),
      );
      return;
    }

    emit(state.copyWith(status: EditHeadlineStatus.submitting));
    try {
      final updatedHeadline = initialHeadline.copyWith(
        title: state.title,
        excerpt: state.excerpt,
        url: state.url,
        imageUrl: state.imageUrl,
        source: state.source,
        topic: state.topic,
        eventCountry: state.eventCountry,
        status: state.contentStatus,
        updatedAt: DateTime.now(),
      );

      await _headlinesRepository.update(id: _headlineId, item: updatedHeadline);
      emit(
        state.copyWith(
          status: EditHeadlineStatus.success,
          updatedHeadline: updatedHeadline,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          exception: e,
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
