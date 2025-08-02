import 'dart:async';

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
    on<UndoDeleteHeadlineRequested>(_onUndoDeleteHeadlineRequested);
    on<_ConfirmDeleteHeadlineRequested>(_onConfirmDeleteHeadlineRequested);
  }

  final DataRepository<Headline> _headlinesRepository;
  Timer? _deleteTimer;

  @override
  Future<void> close() {
    _deleteTimer?.cancel();
    return super.close();
  }

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
      final restoredHeadline = await _headlinesRepository.update(
        id: event.id,
        item: headlineToRestore.copyWith(status: ContentStatus.active),
      );
      emit(state.copyWith(restoredHeadline: restoredHeadline));
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
    _deleteTimer?.cancel();

    final headlineIndex = state.headlines.indexWhere((h) => h.id == event.id);
    if (headlineIndex == -1) return;

    final headlineToDelete = state.headlines[headlineIndex];
    final updatedHeadlines = List<Headline>.from(state.headlines)
      ..removeAt(headlineIndex);

    emit(
      state.copyWith(
        headlines: updatedHeadlines,
        lastDeletedHeadline: headlineToDelete,
      ),
    );

    _deleteTimer = Timer(
      const Duration(seconds: 5),
      () => add(_ConfirmDeleteHeadlineRequested(event.id)),
    );
  }

  Future<void> _onConfirmDeleteHeadlineRequested(
    _ConfirmDeleteHeadlineRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) async {
    try {
      await _headlinesRepository.delete(id: event.id);
      emit(state.copyWith(lastDeletedHeadline: null));
    } on HttpException catch (e) {
      // If deletion fails, restore the headline to the list
      final originalHeadlines = List<Headline>.from(state.headlines)
        ..add(state.lastDeletedHeadline!);
      emit(
        state.copyWith(
          headlines: originalHeadlines,
          exception: e,
          lastDeletedHeadline: null,
        ),
      );
    } catch (e) {
      final originalHeadlines = List<Headline>.from(state.headlines)
        ..add(state.lastDeletedHeadline!);
      emit(
        state.copyWith(
          headlines: originalHeadlines,
          exception: UnknownException('An unexpected error occurred: $e'),
          lastDeletedHeadline: null,
        ),
      );
    }
  }

  void _onUndoDeleteHeadlineRequested(
    UndoDeleteHeadlineRequested event,
    Emitter<ArchivedHeadlinesState> emit,
  ) {
    _deleteTimer?.cancel();
    if (state.lastDeletedHeadline != null) {
      final updatedHeadlines = List<Headline>.from(state.headlines)
        ..insert(
          state.headlines.indexWhere(
                (h) =>
                    h.updatedAt.isBefore(state.lastDeletedHeadline!.updatedAt),
              ) !=
              -1
              ? state.headlines.indexWhere(
                  (h) =>
                      h.updatedAt.isBefore(state.lastDeletedHeadline!.updatedAt),
                )
              : state.headlines.length,
          state.lastDeletedHeadline!,
        );
      emit(
        state.copyWith(
          headlines: updatedHeadlines,
          lastDeletedHeadline: null,
        ),
      );
    }
  }
}
