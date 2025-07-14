import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart'; 

part 'app_configuration_event.dart';
part 'app_configuration_state.dart';

class AppConfigurationBloc
    extends Bloc<AppConfigurationEvent, AppConfigurationState> {
  AppConfigurationBloc({
    required HtDataRepository<RemoteConfig> remoteConfigRepository,
  }) : _remoteConfigRepository = remoteConfigRepository,
       super(
         const AppConfigurationState(),
       ) {
    on<AppConfigurationLoaded>(_onAppConfigurationLoaded);
    on<AppConfigurationUpdated>(_onAppConfigurationUpdated);
    on<AppConfigurationFieldChanged>(_onAppConfigurationFieldChanged);
    on<AppConfigurationDiscarded>(_onAppConfigurationDiscarded);
  }

  final HtDataRepository<RemoteConfig> _remoteConfigRepository;

  Future<void> _onAppConfigurationLoaded(
    AppConfigurationLoaded event,
    Emitter<AppConfigurationState> emit,
  ) async {
    emit(state.copyWith(status: AppConfigurationStatus.loading));
    try {
      final remoteConfig = await _remoteConfigRepository.read(id: kRemoteConfigId);
      emit(
        state.copyWith(
          status: AppConfigurationStatus.success,
          remoteConfig: remoteConfig,
          originalRemoteConfig: remoteConfig, // Store the original config
          isDirty: false,
          clearShowSaveSuccess:
              true, // Clear any previous success snackbar flag
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: AppConfigurationStatus.failure,
          exception: e,
        ),
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
    emit(state.copyWith(status: AppConfigurationStatus.loading));
    try {
      final updatedConfig = await _remoteConfigRepository.update(
        id: event.remoteConfig.id,
        item: event.remoteConfig,
      );
      emit(
        state.copyWith(
          status: AppConfigurationStatus.success,
          remoteConfig: updatedConfig,
          originalRemoteConfig: updatedConfig, // Update original config on save
          isDirty: false,
          showSaveSuccess: true, // Set flag to show success snackbar
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: AppConfigurationStatus.failure,
          exception: e,
        ),
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
    emit(
      state.copyWith(
        remoteConfig: event.remoteConfig,
        isDirty: true,
        clearException: true, // Clear any previous error messages
        clearShowSaveSuccess: true, // Clear success snackbar on field change
      ),
    );
  }

  void _onAppConfigurationDiscarded(
    AppConfigurationDiscarded event,
    Emitter<AppConfigurationState> emit,
  ) {
    emit(
      state.copyWith(
        remoteConfig: state.originalRemoteConfig, // Revert to original config
        isDirty: false,
        clearException: true, // Clear any previous error messages
        clearShowSaveSuccess: true, // Clear success snackbar
      ),
    );
  }
}
