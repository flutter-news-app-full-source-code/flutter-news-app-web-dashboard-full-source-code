import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_dashboard/shared/constants/pagination_constants.dart';
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
    on<HeadlineAdded>(_onHeadlineAdded);
    on<HeadlineUpdated>(_onHeadlineUpdated);
    on<DeleteHeadlineRequested>(_onDeleteHeadlineRequested);
    on<LoadCategoriesRequested>(_onLoadCategoriesRequested);
    on<CategoryAdded>(_onCategoryAdded);
    on<CategoryUpdated>(_onCategoryUpdated);
    on<DeleteCategoryRequested>(_onDeleteCategoryRequested);
    on<LoadSourcesRequested>(_onLoadSourcesRequested);
    on<SourceAdded>(_onSourceAdded);
    on<SourceUpdated>(_onSourceUpdated);
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
      final isPaginating = event.startAfterId != null;
      final previousHeadlines = isPaginating ? state.headlines : <Headline>[];

      final paginatedHeadlines = await _headlinesRepository.readAll(
        startAfterId: event.startAfterId,
        limit: event.limit,
      );
      emit(
        state.copyWith(
          headlinesStatus: ContentManagementStatus.success,
          headlines: [...previousHeadlines, ...paginatedHeadlines.items],
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

  void _onHeadlineAdded(HeadlineAdded event, Emitter<ContentManagementState> emit) {
    final updatedHeadlines = [event.headline, ...state.headlines];
    emit(
      state.copyWith(
        headlines: updatedHeadlines,
        headlinesStatus: ContentManagementStatus.success,
      ),
    );
  }

  void _onHeadlineUpdated(
    HeadlineUpdated event,
    Emitter<ContentManagementState> emit,
  ) {
    final updatedHeadlines = List<Headline>.from(state.headlines);
    final index = updatedHeadlines.indexWhere((h) => h.id == event.headline.id);
    if (index != -1) {
      updatedHeadlines[index] = event.headline;
      emit(state.copyWith(headlines: updatedHeadlines));
    }
  }

  Future<void> _onDeleteHeadlineRequested(
    DeleteHeadlineRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      await _headlinesRepository.delete(id: event.id);
      final updatedHeadlines =
          state.headlines.where((h) => h.id != event.id).toList();
      emit(state.copyWith(headlines: updatedHeadlines));
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
      final isPaginating = event.startAfterId != null;
      final previousCategories = isPaginating ? state.categories : <Category>[];

      final paginatedCategories = await _categoriesRepository.readAll(
        startAfterId: event.startAfterId,
        limit: event.limit,
      );
      emit(
        state.copyWith(
          categoriesStatus: ContentManagementStatus.success,
          categories: [...previousCategories, ...paginatedCategories.items],
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

  void _onCategoryAdded(
    CategoryAdded event,
    Emitter<ContentManagementState> emit,
  ) {
    final updatedCategories = [event.category, ...state.categories];
    emit(
      state.copyWith(
        categories: updatedCategories,
        categoriesStatus: ContentManagementStatus.success,
      ),
    );
  }

  void _onCategoryUpdated(
    CategoryUpdated event,
    Emitter<ContentManagementState> emit,
  ) {
    final updatedCategories = List<Category>.from(state.categories);
    final index = updatedCategories.indexWhere((c) => c.id == event.category.id);
    if (index != -1) {
      updatedCategories[index] = event.category;
      emit(state.copyWith(categories: updatedCategories));
    }
  }

  Future<void> _onDeleteCategoryRequested(
    DeleteCategoryRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      await _categoriesRepository.delete(id: event.id);
      final updatedCategories =
          state.categories.where((c) => c.id != event.id).toList();
      emit(state.copyWith(categories: updatedCategories));
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
      final isPaginating = event.startAfterId != null;
      final previousSources = isPaginating ? state.sources : <Source>[];

      final paginatedSources = await _sourcesRepository.readAll(
        startAfterId: event.startAfterId,
        limit: event.limit,
      );
      emit(
        state.copyWith(
          sourcesStatus: ContentManagementStatus.success,
          sources: [...previousSources, ...paginatedSources.items],
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

  void _onSourceAdded(SourceAdded event, Emitter<ContentManagementState> emit) {
    final updatedSources = [event.source, ...state.sources];
    emit(
      state.copyWith(
        sources: updatedSources,
        sourcesStatus: ContentManagementStatus.success,
      ),
    );
  }

  void _onSourceUpdated(
    SourceUpdated event,
    Emitter<ContentManagementState> emit,
  ) {
    final updatedSources = List<Source>.from(state.sources);
    final index = updatedSources.indexWhere((s) => s.id == event.source.id);
    if (index != -1) {
      updatedSources[index] = event.source;
      emit(state.copyWith(sources: updatedSources));
    }
  }

  Future<void> _onOnDeleteSourceRequested(
    DeleteSourceRequested event,
    Emitter<ContentManagementState> emit,
  ) async {
    try {
      await _sourcesRepository.delete(id: event.id);
      final updatedSources =
          state.sources.where((s) => s.id != event.id).toList();
      emit(state.copyWith(sources: updatedSources));
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
