import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart'; // Use AppConfig from ht_shared

part 'app_configuration_event.dart';
part 'app_configuration_state.dart';

class AppConfigurationBloc extends Bloc<AppConfigurationEvent, AppConfigurationState> {
  AppConfigurationBloc({
    required HtDataRepository<AppConfig> appConfigRepository,
  })  : _appConfigRepository = appConfigRepository,
        super(const AppConfigurationState()) {
    on<AppConfigurationLoaded>(_onAppConfigurationLoaded);
    on<AppConfigurationUpdated>(_onAppConfigurationUpdated);
    on<AppConfigurationFieldChanged>(_onAppConfigurationFieldChanged);
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
          isDirty: false,
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
          isDirty: false,
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
      ),
    );
  }
}
