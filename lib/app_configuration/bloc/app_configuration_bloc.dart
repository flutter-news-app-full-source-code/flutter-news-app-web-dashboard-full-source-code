import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart'; // Use AppConfig from ht_shared

part 'app_configuration_event.dart';
part 'app_configuration_state.dart';

class AppConfigurationBloc
    extends Bloc<AppConfigurationEvent, AppConfigurationState> {
  AppConfigurationBloc({
    required HtDataRepository<AppConfig> appConfigRepository,
  }) : _appConfigRepository = appConfigRepository,
       super(
         const AppConfigurationState(),
       ) {
    on<AppConfigurationLoaded>(_onAppConfigurationLoaded);
    on<AppConfigurationUpdated>(_onAppConfigurationUpdated);
    on<AppConfigurationFieldChanged>(_onAppConfigurationFieldChanged);
    on<AppConfigurationDiscarded>(_onAppConfigurationDiscarded);
  }

  final HtDataRepository<AppConfig> _appConfigRepository;

  Future<void> _onAppConfigurationLoaded(
    AppConfigurationLoaded event,
    Emitter<AppConfigurationState> emit,
  ) async {
    emit(state.copyWith(status: AppConfigurationStatus.loading));
    try {
      final appConfig = await _appConfigRepository.read(id: 'app_config');
      emit(
        state.copyWith(
          status: AppConfigurationStatus.success,
          appConfig: appConfig,
          originalAppConfig: appConfig, // Store the original config
          isDirty: false,
          clearShowSaveSuccess:
              true, // Clear any previous success snackbar flag
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: AppConfigurationStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppConfigurationStatus.failure,
          errorMessage: 'An unknown error occurred: $e',
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
      final updatedConfig = await _appConfigRepository.update(
        id: event.appConfig.id,
        item: event.appConfig,
      );
      emit(
        state.copyWith(
          status: AppConfigurationStatus.success,
          appConfig: updatedConfig,
          originalAppConfig: updatedConfig, // Update original config on save
          isDirty: false,
          showSaveSuccess: true, // Set flag to show success snackbar
        ),
      );
    } on HtHttpException catch (e) {
      emit(
        state.copyWith(
          status: AppConfigurationStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppConfigurationStatus.failure,
          errorMessage: 'An unknown error occurred: $e',
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
        appConfig: event.appConfig,
        isDirty: true,
        clearErrorMessage: true, // Clear any previous error messages
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
        appConfig: state.originalAppConfig, // Revert to original config
        isDirty: false,
        clearErrorMessage: true, // Clear any previous error messages
        clearShowSaveSuccess: true, // Clear success snackbar
      ),
    );
  }
}
