import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'edit_sync_event.dart';
part 'edit_sync_state.dart';

class EditSyncBloc extends Bloc<EditSyncEvent, EditSyncState> {
  EditSyncBloc({
    required DataRepository<NewsAutomationTask> automationRepository,
    required DataRepository<Source> sourcesRepository,
  }) : _automationRepository = automationRepository,
       _sourcesRepository = sourcesRepository,
       super(const EditSyncState()) {
    on<EditSyncStarted>(_onStarted);
    on<EditSyncFrequencyChanged>(_onFrequencyChanged);
    on<EditSyncStatusChanged>(_onStatusChanged);
    on<EditSyncSubmitted>(_onSubmitted);
  }

  final DataRepository<NewsAutomationTask> _automationRepository;
  final DataRepository<Source> _sourcesRepository;

  Future<void> _onStarted(
    EditSyncStarted event,
    Emitter<EditSyncState> emit,
  ) async {
    emit(state.copyWith(status: EditSyncStatus.loading));
    try {
      final task = await _automationRepository.read(id: event.id);
      final source = await _sourcesRepository.read(id: task.sourceId);
      emit(
        state.copyWith(
          status: EditSyncStatus.initial,
          task: task,
          source: source,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditSyncStatus.failure, exception: e));
    }
  }

  void _onFrequencyChanged(
    EditSyncFrequencyChanged event,
    Emitter<EditSyncState> emit,
  ) {
    if (state.task == null) return;
    emit(
      state.copyWith(
        task: state.task!.copyWith(fetchInterval: event.frequency),
      ),
    );
  }

  void _onStatusChanged(
    EditSyncStatusChanged event,
    Emitter<EditSyncState> emit,
  ) {
    if (state.task == null) return;
    emit(
      state.copyWith(
        task: state.task!.copyWith(status: event.status),
      ),
    );
  }

  Future<void> _onSubmitted(
    EditSyncSubmitted event,
    Emitter<EditSyncState> emit,
  ) async {
    if (state.task == null) return;
    emit(state.copyWith(status: EditSyncStatus.submitting));
    try {
      await _automationRepository.update(
        id: state.task!.id,
        item: state.task!.copyWith(updatedAt: DateTime.now()),
      );
      emit(state.copyWith(status: EditSyncStatus.success));
    } on HttpException catch (e) {
      emit(state.copyWith(status: EditSyncStatus.failure, exception: e));
    }
  }
}
