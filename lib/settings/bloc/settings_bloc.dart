import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required HtDataRepository<UserAppSettings> userAppSettingsRepository,
  })  : _userAppSettingsRepository = userAppSettingsRepository,
        super(SettingsInitial()) {
    on<SettingsLoaded>(_onSettingsLoaded);
    on<SettingsBaseThemeChanged>(_onSettingsBaseThemeChanged);
    on<SettingsAccentThemeChanged>(_onSettingsAccentThemeChanged);
    on<SettingsFontFamilyChanged>(_onSettingsFontFamilyChanged);
    on<SettingsTextScaleFactorChanged>(_onSettingsTextScaleFactorChanged);
    on<SettingsFontWeightChanged>(_onSettingsFontWeightChanged);
    on<SettingsLanguageChanged>(_onSettingsLanguageChanged);
  }

  final HtDataRepository<UserAppSettings> _userAppSettingsRepository;

  Future<void> _onSettingsLoaded(
    SettingsLoaded event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadInProgress());
    try {
      // Assuming a fixed ID for user settings, or fetching based on current user
      final userAppSettings =
          await _userAppSettingsRepository.read(id: event.userId!);
      emit(SettingsLoadSuccess(userAppSettings: userAppSettings));
    } on NotFoundException {
      final defaultSettings = UserAppSettings(id: event.userId!);
      await _userAppSettingsRepository.create(item: defaultSettings);
      emit(SettingsLoadSuccess(userAppSettings: defaultSettings));
    } on HtHttpException catch (e) {
      emit(SettingsLoadFailure(e.message));
    } catch (e) {
      emit(SettingsLoadFailure('An unexpected error occurred: $e'));
    }
  }

  Future<void> _updateSettings(
    UserAppSettings updatedSettings,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsUpdateInProgress(userAppSettings: updatedSettings));
    try {
      final result = await _userAppSettingsRepository.update(
        id: updatedSettings.id,
        item: updatedSettings,
      );
      emit(SettingsUpdateSuccess(userAppSettings: result));
    } on HtHttpException catch (e) {
      emit(SettingsUpdateFailure(e.message));
    } catch (e) {
      emit(SettingsUpdateFailure('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onSettingsBaseThemeChanged(
    SettingsBaseThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadSuccess) {
      final currentSettings = (state as SettingsLoadSuccess).userAppSettings;
      final updatedSettings = currentSettings.copyWith(
        displaySettings:
            currentSettings.displaySettings.copyWith(baseTheme: event.baseTheme),
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onSettingsAccentThemeChanged(
    SettingsAccentThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadSuccess) {
      final currentSettings = (state as SettingsLoadSuccess).userAppSettings;
      final updatedSettings = currentSettings.copyWith(
        displaySettings: currentSettings.displaySettings
            .copyWith(accentTheme: event.accentTheme),
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onSettingsFontFamilyChanged(
    SettingsFontFamilyChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadSuccess) {
      final currentSettings = (state as SettingsLoadSuccess).userAppSettings;
      final updatedSettings = currentSettings.copyWith(
        displaySettings: currentSettings.displaySettings
            .copyWith(fontFamily: event.fontFamily),
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onSettingsTextScaleFactorChanged(
    SettingsTextScaleFactorChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadSuccess) {
      final currentSettings = (state as SettingsLoadSuccess).userAppSettings;
      final updatedSettings = currentSettings.copyWith(
        displaySettings: currentSettings.displaySettings
            .copyWith(textScaleFactor: event.textScaleFactor),
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onSettingsFontWeightChanged(
    SettingsFontWeightChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadSuccess) {
      final currentSettings = (state as SettingsLoadSuccess).userAppSettings;
      final updatedSettings = currentSettings.copyWith(
        displaySettings: currentSettings.displaySettings
            .copyWith(fontWeight: event.fontWeight),
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onSettingsLanguageChanged(
    SettingsLanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadSuccess) {
      final currentSettings = (state as SettingsLoadSuccess).userAppSettings;
      final updatedSettings =
          currentSettings.copyWith(language: event.language);
      await _updateSettings(updatedSettings, emit);
    }
  }
}
