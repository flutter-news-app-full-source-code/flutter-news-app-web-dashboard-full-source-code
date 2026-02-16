import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'edit_topic_event.dart';
part 'edit_topic_state.dart';

/// A BLoC to manage the state of editing a single topic.
class EditTopicBloc extends Bloc<EditTopicEvent, EditTopicState> {
  /// {@macro edit_topic_bloc}
  EditTopicBloc({
    required DataRepository<Topic> topicsRepository,
    required String topicId,
  }) : _topicsRepository = topicsRepository,
       super(
         EditTopicState(topicId: topicId, status: EditTopicStatus.loading),
       ) {
    on<EditTopicLoaded>(_onEditTopicLoaded);
    on<EditTopicNameChanged>(_onNameChanged);
    on<EditTopicDescriptionChanged>(_onDescriptionChanged);
    on<EditTopicIconUrlChanged>(_onIconUrlChanged);
    on<EditTopicSavedAsDraft>(_onSavedAsDraft);
    on<EditTopicPublished>(_onPublished);

    add(const EditTopicLoaded());
  }

  final DataRepository<Topic> _topicsRepository;

  Future<void> _onEditTopicLoaded(
    EditTopicLoaded event,
    Emitter<EditTopicState> emit,
  ) async {
    try {
      final topic = await _topicsRepository.read(id: state.topicId);
      emit(
        state.copyWith(
          status: EditTopicStatus.initial,
          name: topic.name,
          description: topic.description,
          iconUrl: topic.iconUrl,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditTopicStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditTopicStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onNameChanged(
    EditTopicNameChanged event,
    Emitter<EditTopicState> emit,
  ) {
    emit(
      state.copyWith(name: event.name, status: EditTopicStatus.initial),
    );
  }

  void _onDescriptionChanged(
    EditTopicDescriptionChanged event,
    Emitter<EditTopicState> emit,
  ) {
    emit(
      state.copyWith(
        description: event.description,
        status: EditTopicStatus.initial,
      ),
    );
  }

  void _onIconUrlChanged(
    EditTopicIconUrlChanged event,
    Emitter<EditTopicState> emit,
  ) {
    emit(
      state.copyWith(iconUrl: event.iconUrl, status: EditTopicStatus.initial),
    );
  }

  /// Handles saving the topic as a draft.
  Future<void> _onSavedAsDraft(
    EditTopicSavedAsDraft event,
    Emitter<EditTopicState> emit,
  ) async {
    emit(state.copyWith(status: EditTopicStatus.submitting));
    try {
      final originalTopic = await _topicsRepository.read(id: state.topicId);
      final updatedTopic = originalTopic.copyWith(
        name: state.name,
        description: state.description,
        iconUrl: ValueWrapper(state.iconUrl),
        status: ContentStatus.draft,
        updatedAt: DateTime.now(),
      );

      await _topicsRepository.update(id: state.topicId, item: updatedTopic);
      emit(
        state.copyWith(
          status: EditTopicStatus.success,
          updatedTopic: updatedTopic,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditTopicStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditTopicStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles publishing the topic.
  Future<void> _onPublished(
    EditTopicPublished event,
    Emitter<EditTopicState> emit,
  ) async {
    emit(state.copyWith(status: EditTopicStatus.submitting));
    try {
      final originalTopic = await _topicsRepository.read(id: state.topicId);
      final updatedTopic = originalTopic.copyWith(
        name: state.name,
        description: state.description,
        iconUrl: ValueWrapper(state.iconUrl),
        status: ContentStatus.active,
        updatedAt: DateTime.now(),
      );

      await _topicsRepository.update(id: state.topicId, item: updatedTopic);
      emit(
        state.copyWith(
          status: EditTopicStatus.success,
          updatedTopic: updatedTopic,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditTopicStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: EditTopicStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
