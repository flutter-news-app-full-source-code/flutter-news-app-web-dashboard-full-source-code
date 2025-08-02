import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'archived_topics_event.dart';
part 'archived_topics_state.dart';

class ArchivedTopicsBloc
    extends Bloc<ArchivedTopicsEvent, ArchivedTopicsState> {
  ArchivedTopicsBloc({
    required DataRepository<Topic> topicsRepository,
  })  : _topicsRepository = topicsRepository,
        super(const ArchivedTopicsState()) {
    on<LoadArchivedTopicsRequested>(_onLoadArchivedTopicsRequested);
    on<RestoreTopicRequested>(_onRestoreTopicRequested);
  }

  final DataRepository<Topic> _topicsRepository;

  Future<void> _onLoadArchivedTopicsRequested(
    LoadArchivedTopicsRequested event,
    Emitter<ArchivedTopicsState> emit,
  ) async {
    emit(state.copyWith(status: ArchivedTopicsStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousTopics = isPaginating ? state.topics : <Topic>[];

      final paginatedTopics = await _topicsRepository.readAll(
        filter: {'status': ContentStatus.archived.name},
        sort: [const SortOption('updatedAt', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          status: ArchivedTopicsStatus.success,
          topics: [...previousTopics, ...paginatedTopics.items],
          cursor: paginatedTopics.cursor,
          hasMore: paginatedTopics.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(
          status: ArchivedTopicsStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ArchivedTopicsStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onRestoreTopicRequested(
    RestoreTopicRequested event,
    Emitter<ArchivedTopicsState> emit,
  ) async {
    final originalTopics = List<Topic>.from(state.topics);
    final topicIndex = originalTopics.indexWhere((t) => t.id == event.id);
    if (topicIndex == -1) return;

    final topicToRestore = originalTopics[topicIndex];
    final updatedTopics = originalTopics..removeAt(topicIndex);

    emit(state.copyWith(topics: updatedTopics));

    try {
      final restoredTopic = await _topicsRepository.update(
        id: event.id,
        item: topicToRestore.copyWith(status: ContentStatus.active),
      );
      emit(state.copyWith(restoredTopic: restoredTopic));
    } on HttpException catch (e) {
      emit(state.copyWith(topics: originalTopics, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          topics: originalTopics,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
