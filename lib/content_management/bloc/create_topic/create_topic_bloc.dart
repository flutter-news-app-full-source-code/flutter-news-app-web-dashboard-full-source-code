import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'create_topic_event.dart';
part 'create_topic_state.dart';

/// A BLoC to manage the state of creating a new topic.
class CreateTopicBloc extends Bloc<CreateTopicEvent, CreateTopicState> {
  /// {@macro create_topic_bloc}
  CreateTopicBloc({required DataRepository<Topic> topicsRepository})
    : _topicsRepository = topicsRepository,
      super(const CreateTopicState()) {
    on<CreateTopicNameChanged>(_onNameChanged);
    on<CreateTopicDescriptionChanged>(_onDescriptionChanged);
    on<CreateTopicIconUrlChanged>(_onIconUrlChanged);
    on<CreateTopicSavedAsDraft>(_onSavedAsDraft);
    on<CreateTopicPublished>(_onPublished);
  }

  final DataRepository<Topic> _topicsRepository;
  final _uuid = const Uuid();

  void _onNameChanged(
    CreateTopicNameChanged event,
    Emitter<CreateTopicState> emit,
  ) {
    emit(state.copyWith(name: event.name, status: CreateTopicStatus.initial));
  }

  void _onDescriptionChanged(
    CreateTopicDescriptionChanged event,
    Emitter<CreateTopicState> emit,
  ) {
    emit(
      state.copyWith(
        description: event.description,
        status: CreateTopicStatus.initial,
      ),
    );
  }

  void _onIconUrlChanged(
    CreateTopicIconUrlChanged event,
    Emitter<CreateTopicState> emit,
  ) {
    emit(
      state.copyWith(iconUrl: event.iconUrl, status: CreateTopicStatus.initial),
    );
  }

  /// Handles saving the topic as a draft.
  Future<void> _onSavedAsDraft(
    CreateTopicSavedAsDraft event,
    Emitter<CreateTopicState> emit,
  ) async {
    emit(state.copyWith(status: CreateTopicStatus.submitting));
    try {
      final now = DateTime.now();
      final newTopic = Topic(
        id: _uuid.v4(),
        name: state.name,
        description: state.description,
        iconUrl: state.iconUrl,
        status: ContentStatus.draft,
        createdAt: now,
        updatedAt: now,
      );

      await _topicsRepository.create(item: newTopic);
      emit(
        state.copyWith(
          status: CreateTopicStatus.success,
          createdTopic: newTopic,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: CreateTopicStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateTopicStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles publishing the topic.
  Future<void> _onPublished(
    CreateTopicPublished event,
    Emitter<CreateTopicState> emit,
  ) async {
    emit(state.copyWith(status: CreateTopicStatus.submitting));
    try {
      final now = DateTime.now();
      final newTopic = Topic(
        id: _uuid.v4(),
        name: state.name,
        description: state.description,
        iconUrl: state.iconUrl,
        status: ContentStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      await _topicsRepository.create(item: newTopic);
      emit(
        state.copyWith(
          status: CreateTopicStatus.success,
          createdTopic: newTopic,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: CreateTopicStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateTopicStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
