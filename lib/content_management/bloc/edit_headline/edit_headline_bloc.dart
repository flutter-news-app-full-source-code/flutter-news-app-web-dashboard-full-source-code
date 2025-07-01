import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' hide Category;
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
    required HtDataRepository<Category> categoriesRepository,
    required String headlineId,
  }) : _headlinesRepository = headlinesRepository,
       _sourcesRepository = sourcesRepository,
       _categoriesRepository = categoriesRepository,
       _headlineId = headlineId,
       super(const EditHeadlineState()) {
    on<EditHeadlineLoaded>(_onLoaded);
    on<EditHeadlineTitleChanged>(_onTitleChanged);
    on<EditHeadlineDescriptionChanged>(_onDescriptionChanged);
    on<EditHeadlineUrlChanged>(_onUrlChanged);
    on<EditHeadlineImageUrlChanged>(_onImageUrlChanged);
    on<EditHeadlineSourceChanged>(_onSourceChanged);
    on<EditHeadlineCategoryChanged>(_onCategoryChanged);
    on<EditHeadlineSubmitted>(_onSubmitted);
  }

  final HtDataRepository<Headline> _headlinesRepository;
  final HtDataRepository<Source> _sourcesRepository;
  final HtDataRepository<Category> _categoriesRepository;
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
        categoriesResponse,
      ] = await Future.wait([
        _headlinesRepository.read(id: _headlineId),
        _sourcesRepository.readAll(),
        _categoriesRepository.readAll(),
      ]);

      final headline = headlineResponse as Headline;
      final sources = (sourcesResponse as PaginatedResponse<Source>).items;
      final categories =
          (categoriesResponse as PaginatedResponse<Category>).items;

      emit(
        state.copyWith(
          status: EditHeadlineStatus.initial,
          initialHeadline: headline,
          title: headline.title,
          description: headline.description ?? '',
          url: headline.url ?? '',
          imageUrl: headline.imageUrl ?? '',
          source: () => headline.source,
          category: () => headline.category,
          sources: sources,
          categories: categories,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          errorMessage: e.toString(),
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

  void _onDescriptionChanged(
    EditHeadlineDescriptionChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        description: event.description,
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

  void _onCategoryChanged(
    EditHeadlineCategoryChanged event,
    Emitter<EditHeadlineState> emit,
  ) {
    emit(
      state.copyWith(
        category: () => event.category,
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
          errorMessage: 'Cannot update: Original headline data not loaded.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: EditHeadlineStatus.submitting));
    try {
      final updatedHeadline = initialHeadline.copyWith(
        title: state.title,
        description: state.description.isNotEmpty ? state.description : null,
        url: state.url.isNotEmpty ? state.url : null,
        imageUrl: state.imageUrl.isNotEmpty ? state.imageUrl : null,
        source: state.source,
        category: state.category,
      );

      await _headlinesRepository.update(id: _headlineId, item: updatedHeadline);
      emit(state.copyWith(status: EditHeadlineStatus.success));
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditHeadlineStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
