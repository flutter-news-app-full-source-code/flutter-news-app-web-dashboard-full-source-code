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
       super(EditTopicState(topicId: topicId, status: EditTopicStatus.loading)) {
    on<EditTopicLoaded>(_onEditTopicLoaded);
    on<EditTopicNameChanged>(_onNameChanged);
    on<EditTopicDescriptionChanged>(_onDescriptionChanged);
    on<EditTopicIconUrlChanged>(_onIconUrlChanged);
    on<EditTopicStatusChanged>(_onStatusChanged);
    on<EditTopicSubmitted>(_onSubmitted);

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
          contentStatus: topic.status,
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

  void _onStatusChanged(
    EditTopicStatusChanged event,
    Emitter<EditTopicState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: EditTopicStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditTopicSubmitted event,
    Emitter<EditTopicState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: EditTopicStatus.submitting));
    try {
      final updatedTopic = Topic(
        id: state.topicId,
        name: state.name,
        description: state.description,
        iconUrl: state.iconUrl,
        status: state.contentStatus,
        createdAt: DateTime.now(), // This should ideally be the original createdAt
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
