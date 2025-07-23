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
       _topicId = topicId,
       super(const EditTopicState()) {
    on<EditTopicLoaded>(_onLoaded);
    on<EditTopicNameChanged>(_onNameChanged);
    on<EditTopicDescriptionChanged>(_onDescriptionChanged);
    on<EditTopicIconUrlChanged>(_onIconUrlChanged);
    on<EditTopicStatusChanged>(_onStatusChanged);
    on<EditTopicSubmitted>(_onSubmitted);
  }

  final DataRepository<Topic> _topicsRepository;
  final String _topicId;

  Future<void> _onLoaded(
    EditTopicLoaded event,
    Emitter<EditTopicState> emit,
  ) async {
    emit(state.copyWith(status: EditTopicStatus.loading));
    try {
      final topic = await _topicsRepository.read(id: _topicId);
      emit(
        state.copyWith(
          status: EditTopicStatus.initial,
          initialTopic: topic,
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
      state.copyWith(
        name: event.name,
        // Reset status to allow for re-submission after a failure.
        status: EditTopicStatus.initial,
      ),
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

    // Safely access the initial topic to prevent null errors.
    final initialTopic = state.initialTopic;
    if (initialTopic == null) {
      emit(
        state.copyWith(
          status: EditTopicStatus.failure,
          exception: const UnknownException(
            'Cannot update: Original topic data not loaded.',
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(status: EditTopicStatus.submitting));
    try {
      // Use null for empty optional fields, which is cleaner for APIs.
      final updatedTopic = initialTopic.copyWith(
        name: state.name,
        description: state.description,
        iconUrl: state.iconUrl,
        status: state.contentStatus,
        updatedAt: DateTime.now(),
      );

      await _topicsRepository.update(id: _topicId, item: updatedTopic);
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
