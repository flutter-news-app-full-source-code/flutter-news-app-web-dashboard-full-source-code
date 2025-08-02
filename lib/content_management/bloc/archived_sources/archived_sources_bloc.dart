import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'archived_sources_event.dart';
part 'archived_sources_state.dart';

class ArchivedSourcesBloc
    extends Bloc<ArchivedSourcesEvent, ArchivedSourcesState> {
  ArchivedSourcesBloc({
    required DataRepository<Source> sourcesRepository,
  }) : _sourcesRepository = sourcesRepository,
       super(const ArchivedSourcesState()) {
    on<LoadArchivedSourcesRequested>(_onLoadArchivedSourcesRequested);
    on<RestoreSourceRequested>(_onRestoreSourceRequested);
  }

  final DataRepository<Source> _sourcesRepository;

  Future<void> _onLoadArchivedSourcesRequested(
    LoadArchivedSourcesRequested event,
    Emitter<ArchivedSourcesState> emit,
  ) async {
    emit(state.copyWith(status: ArchivedSourcesStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousSources = isPaginating ? state.sources : <Source>[];

      final paginatedSources = await _sourcesRepository.readAll(
        filter: {'status': ContentStatus.archived.name},
        sort: [const SortOption('updatedAt', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          status: ArchivedSourcesStatus.success,
          sources: [...previousSources, ...paginatedSources.items],
          cursor: paginatedSources.cursor,
          hasMore: paginatedSources.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: ArchivedSourcesStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ArchivedSourcesStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onRestoreSourceRequested(
    RestoreSourceRequested event,
    Emitter<ArchivedSourcesState> emit,
  ) async {
    final originalSources = List<Source>.from(state.sources);
    final sourceIndex = originalSources.indexWhere((s) => s.id == event.id);
    if (sourceIndex == -1) return;

    final sourceToRestore = originalSources[sourceIndex];
    final updatedSources = originalSources..removeAt(sourceIndex);

    emit(state.copyWith(sources: updatedSources));

    try {
      final restoredSource = await _sourcesRepository.update(
        id: event.id,
        item: sourceToRestore.copyWith(status: ContentStatus.active),
      );
      emit(state.copyWith(restoredSource: restoredSource));
    } on HttpException catch (e) {
      emit(state.copyWith(sources: originalSources, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          sources: originalSources,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
