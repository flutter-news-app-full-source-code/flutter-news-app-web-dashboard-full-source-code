import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:uuid/uuid.dart';

part 'create_topic_event.dart';
part 'create_topic_state.dart';

/// A BLoC to manage the state of creating a new topic.
class CreateTopicBloc extends Bloc<CreateTopicEvent, CreateTopicState> {
  /// {@macro create_topic_bloc}
  CreateTopicBloc({
    required HtDataRepository<Topic> topicsRepository,
  })  : _topicsRepository = topicsRepository,
        super(const CreateTopicState()) {
    on<CreateTopicNameChanged>(_onNameChanged);
    on<CreateTopicDescriptionChanged>(_onDescriptionChanged);
    on<CreateTopicIconUrlChanged>(_onIconUrlChanged);
    on<CreateTopicStatusChanged>(_onStatusChanged);
    on<CreateTopicSubmitted>(_onSubmitted);
  }

  final HtDataRepository<Topic> _topicsRepository;
  final _uuid = const Uuid();

  void _onNameChanged(
    CreateTopicNameChanged event,
    Emitter<CreateTopicState> emit,
  ) {
    emit(
      state.copyWith(
        name: event.name,
        status: CreateTopicStatus.initial,
      ),
    );
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
      state.copyWith(
        iconUrl: event.iconUrl,
        status: CreateTopicStatus.initial,
      ),
    );
  }

  void _onStatusChanged(
    CreateTopicStatusChanged event,
    Emitter<CreateTopicState> emit,
  ) {
    emit(
      state.copyWith(
        contentStatus: event.status,
        status: CreateTopicStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    CreateTopicSubmitted event,
    Emitter<CreateTopicState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: CreateTopicStatus.submitting));
    try {
      final now = DateTime.now();
      final newTopic = Topic(
        id: _uuid.v4(),
        name: state.name,
        description: state.description,
        iconUrl: state.iconUrl,
        status: state.contentStatus,
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
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: CreateTopicStatus.failure,
          exception: e,
        ),
      );
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
