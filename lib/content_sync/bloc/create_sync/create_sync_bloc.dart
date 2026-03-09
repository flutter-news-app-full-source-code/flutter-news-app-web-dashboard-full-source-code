import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

part 'create_sync_event.dart';
part 'create_sync_state.dart';

class CreateSyncBloc extends Bloc<CreateSyncEvent, CreateSyncState> {
  CreateSyncBloc({
    required DataRepository<NewsAutomationTask> automationRepository,
  }) : _automationRepository = automationRepository,
       super(const CreateSyncState()) {
    on<CreateSyncStarted>(_onStarted);
    on<CreateSyncSourceChanged>(_onSourceChanged);
    on<CreateSyncFrequencyChanged>(_onFrequencyChanged);
    on<CreateSyncSubmitted>(_onSubmitted);
  }

  final DataRepository<NewsAutomationTask> _automationRepository;
  final _uuid = const Uuid();

  void _onStarted(CreateSyncStarted event, Emitter<CreateSyncState> emit) {
    emit(state.copyWith(status: CreateSyncStatus.initial));
  }

  void _onSourceChanged(
    CreateSyncSourceChanged event,
    Emitter<CreateSyncState> emit,
  ) {
    emit(state.copyWith(source: event.source));
  }

  void _onFrequencyChanged(
    CreateSyncFrequencyChanged event,
    Emitter<CreateSyncState> emit,
  ) {
    emit(state.copyWith(frequency: event.frequency));
  }

  Future<void> _onSubmitted(
    CreateSyncSubmitted event,
    Emitter<CreateSyncState> emit,
  ) async {
    if (state.source == null) return;
    emit(state.copyWith(status: CreateSyncStatus.submitting));
    try {
      final now = DateTime.now();
      final task = NewsAutomationTask(
        id: _uuid.v4(),
        sourceId: state.source!.id,
        fetchInterval: state.frequency,
        status: IngestionStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      await _automationRepository.create(item: task);
      emit(state.copyWith(status: CreateSyncStatus.success));
    } on HttpException catch (e) {
      emit(state.copyWith(status: CreateSyncStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateSyncStatus.failure,
          exception: UnknownException(e.toString()),
        ),
      );
    }
  }
}
