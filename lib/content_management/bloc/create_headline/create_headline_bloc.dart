import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

part 'create_headline_event.dart';
part 'create_headline_state.dart';

/// A BLoC to manage the state of creating a new headline.
class CreateHeadlineBloc
    extends Bloc<CreateHeadlineEvent, CreateHeadlineState> {
  /// {@macro create_headline_bloc}
  CreateHeadlineBloc({
    required HtDataRepository<Headline> headlinesRepository,
    required HtDataRepository<Source> sourcesRepository,
    required HtDataRepository<Category> categoriesRepository,
  }) : _headlinesRepository = headlinesRepository,
       _sourcesRepository = sourcesRepository,
       _categoriesRepository = categoriesRepository,
       super(const CreateHeadlineState()) {
    on<CreateHeadlineDataLoaded>(_onDataLoaded);
    on<CreateHeadlineTitleChanged>(_onTitleChanged);
    on<CreateHeadlineDescriptionChanged>(_onDescriptionChanged);
    on<CreateHeadlineUrlChanged>(_onUrlChanged);
    on<CreateHeadlineImageUrlChanged>(_onImageUrlChanged);
    on<CreateHeadlineSourceChanged>(_onSourceChanged);
    on<CreateHeadlineCategoryChanged>(_onCategoryChanged);
    on<CreateHeadlineStatusChanged>(_onStatusChanged);
    on<CreateHeadlineSubmitted>(_onSubmitted);
  }

  final HtDataRepository<Headline> _headlinesRepository;
  final HtDataRepository<Source> _sourcesRepository;
  final HtDataRepository<Category> _categoriesRepository;

  Future<void> _onDataLoaded(
    CreateHeadlineDataLoaded event,
    Emitter<CreateHeadlineState> emit,
  ) async {
    emit(state.copyWith(status: CreateHeadlineStatus.loading));
    try {
      final [sourcesResponse, categoriesResponse] = await Future.wait([
        _sourcesRepository.readAll(),
        _categoriesRepository.readAll(),
      ]);

      final sources = (sourcesResponse as PaginatedResponse<Source>).items;
      final categories =
          (categoriesResponse as PaginatedResponse<Category>).items;

      emit(
        state.copyWith(
          status: CreateHeadlineStatus.initial,
          sources: sources,
          categories: categories,
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

  void _onCategoryChanged(
    CreateHeadlineCategoryChanged event,
    Emitter<CreateHeadlineState> emit,
  ) {
    emit(state.copyWith(category: () => event.category));
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
      final newHeadline = Headline(
        title: state.title,
        description: state.description.isNotEmpty ? state.description : null,
        url: state.url.isNotEmpty ? state.url : null,
        imageUrl: state.imageUrl.isNotEmpty ? state.imageUrl : null,
        source: state.source,
        category: state.category,
        status: state.contentStatus,
      );

      await _headlinesRepository.create(item: newHeadline);
      emit(state.copyWith(status: CreateHeadlineStatus.success));
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
