import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'archived_headlines_event.dart';
part 'archived_headlines_state.dart';

class ArchivedHeadlinesBloc
    extends Bloc<ArchivedHeadlinesEvent, ArchivedHeadlinesState> {
  ArchivedHeadlinesBloc({
    required DataRepository<Headline> headlinesRepository,
  })  : _headlinesRepository = headlinesRepository,
        super(const ArchivedHeadlinesState()) {
    on<LoadArchivedHeadlinesRequested>(_onLoadArchivedHeadlinesRequested);
    on<RestoreHeadlineRequested>(_onRestoreHeadlineRequested);
    on<DeleteHeadlineForeverRequested>(_onDeleteHeadlineForeverRequested);
  }

  final DataRepository<Headline> _headlinesRepository;

  Future<void> _onLoadArchivedHeadlinesRequested(
    LoadArchivedHeadlinesRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) async {
    emit(state.copyWith(status: ArchivedHeadlinesStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousHeadlines = isPaginating ? state.headlines : <Headline>[];

      final paginatedHeadlines = await _headlinesRepository.readAll(
        filter: {'status': ContentStatus.archived.name},
        sort: [const SortOption('updatedAt', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          status: ArchivedHeadlinesStatus.success,
          headlines: [...previousHeadlines, ...paginatedHeadlines.items],
          cursor: paginatedHeadlines.cursor,
          hasMore: paginatedHeadlines.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: ArchivedHeadlinesStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ArchivedHeadlinesStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onRestoreHeadlineRequested(
    RestoreHeadlineRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) async {
    final originalHeadlines = List<Headline>.from(state.headlines);
    final headlineIndex = originalHeadlines.indexWhere((h) => h.id == event.id);
    if (headlineIndex == -1) return;

    final headlineToRestore = originalHeadlines[headlineIndex];
    final updatedHeadlines = originalHeadlines..removeAt(headlineIndex);

    emit(state.copyWith(headlines: updatedHeadlines));

    try {
      await _headlinesRepository.update(
        id: event.id,
        item: headlineToRestore.copyWith(status: ContentStatus.active),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(headlines: originalHeadlines, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          headlines: originalHeadlines,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onDeleteHeadlineForeverRequested(
    DeleteHeadlineForeverRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) async {
    final originalHeadlines = List<Headline>.from(state.headlines);
    final headlineIndex = originalHeadlines.indexWhere((h) => h.id == event.id);
    if (headlineIndex == -1) return;

    final updatedHeadlines = originalHeadlines..removeAt(headlineIndex);
    emit(state.copyWith(headlines: updatedHeadlines));

    try {
      await _headlinesRepository.delete(id: event.id);
    } on HttpException catch (e) {
      emit(state.copyWith(headlines: originalHeadlines, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          headlines: originalHeadlines,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
