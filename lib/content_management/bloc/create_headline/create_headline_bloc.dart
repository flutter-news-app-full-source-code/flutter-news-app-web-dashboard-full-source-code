import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' hide Topic;
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:uuid/uuid.dart';

part 'create_headline_event.dart';
part 'create_headline_state.dart';

/// A BLoC to manage the state of creating a new headline.
class CreateHeadlineBloc
    extends Bloc<CreateHeadlineEvent, CreateHeadlineState> {
  /// {@macro create_headline_bloc}
  CreateHeadlineBloc({
    required HtDataRepository<Headline> headlinesRepository,
    required HtDataRepository<Source> sourcesRepository,
    required HtDataRepository<Topic> topicsRepository,
    required HtDataRepository<Country> countriesRepository,
  })  : _headlinesRepository = headlinesRepository,
        _sourcesRepository = sourcesRepository,
        _topicsRepository = topicsRepository,
        _countriesRepository = countriesRepository,
        super(const CreateHeadlineState()) {
    on<CreateHeadlineDataLoaded>(_onDataLoaded);
    on<CreateHeadlineTitleChanged>(_onTitleChanged);
    on<CreateHeadlineDescriptionChanged>(_onDescriptionChanged);
    on<CreateHeadlineUrlChanged>(_onUrlChanged);
    on<CreateHeadlineImageUrlChanged>(_onImageUrlChanged);
    on<CreateHeadlineSourceChanged>(_onSourceChanged);
    on<CreateHeadlineTopicChanged>(_onTopicChanged);
    on<CreateHeadlineCountryChanged>(_onCountryChanged);
    on<CreateHeadlineStatusChanged>(_onStatusChanged);
    on<CreateHeadlineSubmitted>(_onSubmitted);
  }

  final HtDataRepository<Headline> _headlinesRepository;
  final HtDataRepository<Source> _sourcesRepository;
  final HtDataRepository<Topic> _topicsRepository;
  final HtDataRepository<Country> _countriesRepository;
  final _uuid = const Uuid();

  Future<void> _onDataLoaded(
    CreateHeadlineDataLoaded event,
    Emitter<CreateHeadlineState> emit,
  ) async {
    emit(state.copyWith(status: CreateHeadlineStatus.loading));
    try {
      final [sourcesResponse, topicsResponse, countriesResponse] =
          await Future.wait([
        _sourcesRepository.readAll(),
        _topicsRepository.readAll(),
        _countriesRepository.readAll(),
      ]);

      final sources = sourcesResponse.items;
      final topics = topicsResponse.items;
      final countries = countriesResponse.items;

      emit(
        state.copyWith(
          status: CreateHeadlineStatus.initial,
          sources: sources,
          topics: topics,
          countries: countries,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onTitleChanged(
    CreateHeadlineTitleChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
    CreateHeadlineDescriptionChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onUrlChanged(
    CreateHeadlineUrlChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(url: event.url));
  }

  void _onImageUrlChanged(
    CreateHeadlineImageUrlChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(imageUrl: event.imageUrl));
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

  void _onStatusChanged(
    CreateHeadlineStatusChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: CreateHeadlineStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    CreateHeadlineSubmitted event,
    Emitter<CreateHeadlineState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: CreateHeadlineStatus.submitting));
    try {
      final now = DateTime.now();
      final newHeadline = Headline(
        id: _uuid.v4(),
        title: state.title,
        excerpt: state.description,
        url: state.url,
        imageUrl: state.imageUrl,
        source: state.source!,
        eventCountry: state.eventCountry!,
        topic: state.topic!,
        createdAt: now,
        updatedAt: now,
        status: state.contentStatus,
      );

      await _headlinesRepository.create(item: newHeadline);
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.success,
          createdHeadline: newHeadline,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
