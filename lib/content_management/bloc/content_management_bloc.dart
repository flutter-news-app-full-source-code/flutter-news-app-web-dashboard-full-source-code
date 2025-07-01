import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

part 'content_management_event.dart';
part 'content_management_state.dart';

/// Defines the tabs available in the content management section.
enum ContentManagementTab {
  /// Represents the Headlines tab.
  headlines,

  /// Represents the Categories tab.
  categories,

  /// Represents the Sources tab.
  sources,
}

class ContentManagementBloc
    extends Bloc<ContentManagementEvent, ContentManagementState> {
  ContentManagementBloc({
    required HtDataRepository<Headline> headlinesRepository,
    required HtDataRepository<Category> categoriesRepository,
    required HtDataRepository<Source> sourcesRepository,
  }) : _headlinesRepository = headlinesRepository,
       _categoriesRepository = categoriesRepository,
       _sourcesRepository = sourcesRepository,
       super(const ContentManagementState()) {
    on<ContentManagementTabChanged>(_onContentManagementTabChanged);
    on<LoadHeadlinesRequested>(_onLoadHeadlinesRequested);
    on<CreateHeadlineRequested>(_onCreateHeadlineRequested);
    on<UpdateHeadlineRequested>(_onUpdateHeadlineRequested);
    on<DeleteHeadlineRequested>(_onDeleteHeadlineRequested);
    on<LoadCategoriesRequested>(_onLoadCategoriesRequested);
    on<CreateCategoryRequested>(_onCreateCategoryRequested);
    on<UpdateCategoryRequested>(_onUpdateCategoryRequested);
    on<DeleteCategoryRequested>(_onDeleteCategoryRequested);
    on<LoadSourcesRequested>(_onLoadSourcesRequested);
    on<CreateSourceRequested>(_onCreateSourceRequested);
    on<UpdateSourceRequested>(_onUpdateSourceRequested);
    on<DeleteSourceRequested>(_onOnDeleteSourceRequested);
  }

  final HtDataRepository<Headline> _headlinesRepository;
  final HtDataRepository<Category> _categoriesRepository;
  final HtDataRepository<Source> _sourcesRepository;

  void _onContentManagementTabChanged(
    ContentManagementTabChanged event,
    Emitter<ContentManagementState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
  }

  Future<void> _onLoadHeadlinesRequested(
    LoadHeadlinesRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(headlinesStatus: ContentManagementStatus.loading));
    try {
      final paginatedHeadlines = await _headlinesRepository.readAll(
        startAfterId: event.startAfterId,
        limit: event.limit,
      );
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.success,
          headlines: paginatedHeadlines.items,
          headlinesCursor: paginatedHeadlines.cursor,
          headlinesHasMore: paginatedHeadlines.hasMore,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateHeadlineRequested(
    CreateHeadlineRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(headlinesStatus: ContentManagementStatus.loading));
    try {
      await _headlinesRepository.create(item: event.headline);
      // Reload headlines after creation
      add(const LoadHeadlinesRequested());
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateHeadlineRequested(
    UpdateHeadlineRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(headlinesStatus: ContentManagementStatus.loading));
    try {
      await _headlinesRepository.update(id: event.id, item: event.headline);
      // Reload headlines after update
      add(const LoadHeadlinesRequested());
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteHeadlineRequested(
    DeleteHeadlineRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(headlinesStatus: ContentManagementStatus.loading));
    try {
      await _headlinesRepository.delete(id: event.id);
      // Reload headlines after deletion
      add(const LoadHeadlinesRequested());
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadCategoriesRequested(
    LoadCategoriesRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(categoriesStatus: ContentManagementStatus.loading));
    try {
      final paginatedCategories = await _categoriesRepository.readAll(
        startAfterId: event.startAfterId,
        limit: event.limit,
      );
      emit(
        state.copyWith(
          categoriesStatus: ContentManagementStatus.success,
          categories: paginatedCategories.items,
          categoriesCursor: paginatedCategories.cursor,
          categoriesHasMore: paginatedCategories.hasMore,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          categoriesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          categoriesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateCategoryRequested(
    CreateCategoryRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(categoriesStatus: ContentManagementStatus.loading));
    try {
      await _categoriesRepository.create(item: event.category);
      // Reload categories after creation
      add(const LoadCategoriesRequested());
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          categoriesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          categoriesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateCategoryRequested(
    UpdateCategoryRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(categoriesStatus: ContentManagementStatus.loading));
    try {
      await _categoriesRepository.update(id: event.id, item: event.category);
      // Reload categories after update
      add(const LoadCategoriesRequested());
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          categoriesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          categoriesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteCategoryRequested(
    DeleteCategoryRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(categoriesStatus: ContentManagementStatus.loading));
    try {
      await _categoriesRepository.delete(id: event.id);
      // Reload categories after deletion
      add(const LoadCategoriesRequested());
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          categoriesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          categoriesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadSourcesRequested(
    LoadSourcesRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(sourcesStatus: ContentManagementStatus.loading));
    try {
      final paginatedSources = await _sourcesRepository.readAll(
        startAfterId: event.startAfterId,
        limit: event.limit,
      );
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.success,
          sources: paginatedSources.items,
          sourcesCursor: paginatedSources.cursor,
          sourcesHasMore: paginatedSources.hasMore,
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateSourceRequested(
    CreateSourceRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(sourcesStatus: ContentManagementStatus.loading));
    try {
      await _sourcesRepository.create(item: event.source);
      // Reload sources after creation
      add(const LoadSourcesRequested());
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateSourceRequested(
    UpdateSourceRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(sourcesStatus: ContentManagementStatus.loading));
    try {
      await _sourcesRepository.update(id: event.id, item: event.source);
      // Reload sources after update
      add(const LoadSourcesRequested());
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onOnDeleteSourceRequested(
    DeleteSourceRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    emit(state.copyWith(sourcesStatus: ContentManagementStatus.loading));
    try {
      await _sourcesRepository.delete(id: event.id);
      // Reload sources after deletion
      add(const LoadSourcesRequested());
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
