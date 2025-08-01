import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

part 'create_headline_event.dart';
part 'create_headline_state.dart';

final class _FetchNextCountryPage extends CreateHeadlineEvent {
  const _FetchNextCountryPage();
}

/// A BLoC to manage the state of creating a new headline.
class CreateHeadlineBloc
    extends Bloc<CreateHeadlineEvent, CreateHeadlineState> {
  /// {@macro create_headline_bloc}
  CreateHeadlineBloc({
    required DataRepository<Headline> headlinesRepository,
    required DataRepository<Source> sourcesRepository,
    required DataRepository<Topic> topicsRepository,
    required DataRepository<Country> countriesRepository,
  }) : _headlinesRepository = headlinesRepository,
       _sourcesRepository = sourcesRepository,
       _topicsRepository = topicsRepository,
       _countriesRepository = countriesRepository,
       super(const CreateHeadlineState()) {
    on<CreateHeadlineDataLoaded>(_onDataLoaded);
    on<CreateHeadlineTitleChanged>(_onTitleChanged);
    on<CreateHeadlineExcerptChanged>(_onExcerptChanged);
    on<CreateHeadlineUrlChanged>(_onUrlChanged);
    on<CreateHeadlineImageUrlChanged>(_onImageUrlChanged);
    on<CreateHeadlineSourceChanged>(_onSourceChanged);
    on<CreateHeadlineTopicChanged>(_onTopicChanged);
    on<CreateHeadlineCountryChanged>(_onCountryChanged);
    on<CreateHeadlineStatusChanged>(_onStatusChanged);
    on<CreateHeadlineSubmitted>(_onSubmitted);
    on<_FetchNextCountryPage>(_onFetchNextCountryPage);
  }

  final DataRepository<Headline> _headlinesRepository;
  final DataRepository<Source> _sourcesRepository;
  final DataRepository<Topic> _topicsRepository;
  final DataRepository<Country> _countriesRepository;
  final _uuid = const Uuid();

  Future<void> _onDataLoaded(
    CreateHeadlineDataLoaded event,
    Emitter<CreateHeadlineState> emit,
  ) async {
    emit(state.copyWith(status: CreateHeadlineStatus.loading));
    try {
      final [sourcesResponse, topicsResponse] = await Future.wait([
        _sourcesRepository.readAll(
          sort: [const SortOption('updatedAt', SortOrder.desc)],
        ),
        _topicsRepository.readAll(
          sort: [const SortOption('updatedAt', SortOrder.desc)],
        ),
      ]);

      final sources = (sourcesResponse as PaginatedResponse<Source>).items;
      final topics = (topicsResponse as PaginatedResponse<Topic>).items;

      final countriesResponse = await _countriesRepository.readAll(
        sort: [const SortOption('name', SortOrder.asc)],
      );

      emit(
        state.copyWith(
          status: CreateHeadlineStatus.initial,
          sources: sources,
          topics: topics,
          countries: countriesResponse.items,
          countriesCursor: countriesResponse.cursor,
          countriesHasMore: countriesResponse.hasMore,
        ),
      );

      // After the initial page of countries is loaded, start a background
      // process to fetch all remaining pages.
      if (state.countriesHasMore) {
        add(const _FetchNextCountryPage());
      }
    } on HttpException catch (e) {
      emit(state.copyWith(status: CreateHeadlineStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateHeadlineStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
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

  void _onExcerptChanged(
    CreateHeadlineExcerptChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(excerpt: event.excerpt));
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

  // --- Background Data Fetching for Dropdown ---
  // The DropdownButtonFormField widget does not natively support on-scroll
  // pagination. To preserve UI consistency across the application, this BLoC
  // employs an event-driven background fetching mechanism.
  //
  // After the first page of items is loaded, a chain of events is initiated
  // to progressively fetch all remaining pages. This process is throttled
  // and runs in the background, ensuring the UI remains responsive while the
  // full list of dropdown options is populated over time.
  Future<void> _onFetchNextCountryPage(
    _FetchNextCountryPage event,
    Emitter<CreateHeadlineState> emit,
  ) async {
    if (!state.countriesHasMore || state.countriesIsLoadingMore) return;

    try {
      emit(state.copyWith(countriesIsLoadingMore: true));

      // ignore: inference_failure_on_instance_creation
      await Future.delayed(const Duration(milliseconds: 400));

      final nextCountries = await _countriesRepository.readAll(
        pagination: PaginationOptions(cursor: state.countriesCursor),
        sort: [const SortOption('name', SortOrder.asc)],
      );

      emit(
        state.copyWith(
          countries: List.of(state.countries)..addAll(nextCountries.items),
          countriesCursor: nextCountries.cursor,
          countriesHasMore: nextCountries.hasMore,
          countriesIsLoadingMore: false,
        ),
      );

      if (nextCountries.hasMore) {
        add(const _FetchNextCountryPage());
      }
    } catch (e) {
      emit(state.copyWith(countriesIsLoadingMore: false));
      // Optionally log the error without disrupting the user
    }
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
        excerpt: state.excerpt,
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
    } on HttpException catch (e) {
      emit(state.copyWith(status: CreateHeadlineStatus.failure, exception: e));
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
