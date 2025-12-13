import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'app_configuration_event.dart';
part 'app_configuration_state.dart';

class AppConfigurationBloc
    extends Bloc<AppConfigurationEvent, AppConfigurationState> {
  AppConfigurationBloc({
    required DataRepository<RemoteConfig> remoteConfigRepository,
  }) : _remoteConfigRepository = remoteConfigRepository,
       super(const AppConfigurationState()) {
    on<AppConfigurationLoaded>(_onAppConfigurationLoaded);
    on<AppConfigurationUpdated>(_onAppConfigurationUpdated);
    on<AppConfigurationFieldChanged>(_onAppConfigurationFieldChanged);
  }

  final DataRepository<RemoteConfig> _remoteConfigRepository;

  Future<void> _onAppConfigurationLoaded(
    AppConfigurationLoaded event,
    Emitter<AppConfigurationState> emit,
  ) async {
    emit(state.copyWith(status: AppConfigurationStatus.loading));
    try {
      final remoteConfig = await _remoteConfigRepository.read(
        id: kRemoteConfigId,
      );
      emit(
        state.copyWith(
          status: AppConfigurationStatus.success,
          remoteConfig: remoteConfig,
          originalRemoteConfig: remoteConfig,
          isDirty: false,
          clearShowSaveSuccess: true,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(status: AppConfigurationStatus.failure, exception: e),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppConfigurationStatus.failure,
          exception: UnknownException('An unknown error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onAppConfigurationUpdated(
    AppConfigurationUpdated event,
    Emitter<AppConfigurationState> emit,
  ) async {
    if (state.originalRemoteConfig == null) {
      emit(
        state.copyWith(
          status: AppConfigurationStatus.failure,
          exception: const UnknownException(
            'Original remote config is not available.',
          ),
        ),
      );
      return;
    }
    emit(state.copyWith(status: AppConfigurationStatus.loading));
    try {
      final configToUpdate = event.remoteConfig.copyWith(
        createdAt: state.originalRemoteConfig!.createdAt,
        updatedAt: DateTime.now(),
      );
      final updatedConfig = await _remoteConfigRepository.update(
        id: configToUpdate.id,
        item: configToUpdate,
      );
      emit(
        state.copyWith(
          status: AppConfigurationStatus.success,
          remoteConfig: updatedConfig,
          originalRemoteConfig: updatedConfig,
          isDirty: false,
          showSaveSuccess: true,
        ),
      );
    } on HttpException catch (e) {
      emit(
        state.copyWith(status: AppConfigurationStatus.failure, exception: e),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppConfigurationStatus.failure,
          exception: UnknownException('An unknown error occurred: $e'),
        ),
      );
    }
  }

  void _onAppConfigurationFieldChanged(
    AppConfigurationFieldChanged event,
    Emitter<AppConfigurationState> emit,
  ) {
    final isDirty = event.remoteConfig != state.originalRemoteConfig;

    emit(
      state.copyWith(
        remoteConfig: event.remoteConfig,
        // isDirty should be true only if the new config is different from the original.
        isDirty: isDirty,
        clearException: true,
        clearShowSaveSuccess: true,
      ),
    );
  }
}
