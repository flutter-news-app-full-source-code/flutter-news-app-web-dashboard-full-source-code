import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required DataRepository<AppSettings>
    appSettingsRepository, // Changed from UserAppSettings
  }) : _appSettingsRepository =
           appSettingsRepository, // Changed from UserAppSettings
       super(const SettingsInitial()) {
    on<SettingsLoaded>(_onSettingsLoaded);
    on<SettingsBaseThemeChanged>(_onSettingsBaseThemeChanged);
    on<SettingsAccentThemeChanged>(_onSettingsAccentThemeChanged);
    on<SettingsFontFamilyChanged>(_onSettingsFontFamilyChanged);
    on<SettingsTextScaleFactorChanged>(_onSettingsTextScaleFactorChanged);
    on<SettingsFontWeightChanged>(_onSettingsFontWeightChanged);
    on<SettingsLanguageChanged>(_onSettingsLanguageChanged);
  }

  final DataRepository<AppSettings> _appSettingsRepository;

  Future<void> _onSettingsLoaded(
    SettingsLoaded event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadInProgress(appSettings: state.appSettings));
    try {
      final appSettings = await _appSettingsRepository.read(
        // Changed from userAppSettingsRepository
        id: event.userId!,
      );
      emit(SettingsLoadSuccess(appSettings: appSettings));
    } on NotFoundException {
      // If settings are not found, create default settings for the user.
      // This ensures that a user always has a valid settings object.
      final defaultSettings = AppSettings(
        // Changed from UserAppSettings
        id: event.userId!,
        displaySettings: const DisplaySettings(
          baseTheme: AppBaseTheme.system,
          accentTheme: AppAccentTheme.defaultBlue,
          fontFamily: 'SystemDefault',
          textScaleFactor: AppTextScaleFactor.medium,
          fontWeight: AppFontWeight.regular,
        ),
        language: languagesFixturesData.firstWhere(
          (l) => l.code == 'en',
          orElse: () => throw StateError(
            'Default language "en" not found in language fixtures.',
          ),
        ),
        feedSettings: const FeedSettings(
          // Changed from FeedDisplayPreferences
          feedItemDensity:
              FeedItemDensity.standard, // Changed from headlineDensity
          feedItemImageStyle: FeedItemImageStyle
              .largeThumbnail, // Changed from headlineImageStyle
          feedItemClickBehavior:
              FeedItemClickBehavior.defaultBehavior, // Added new field
        ),
      );
      await _appSettingsRepository.create(item: defaultSettings);
      emit(SettingsLoadSuccess(appSettings: defaultSettings));
    } on HttpException catch (e) {
      emit(SettingsLoadFailure(e, appSettings: state.appSettings));
    } catch (e) {
      emit(
        SettingsLoadFailure(
          UnknownException('An unexpected error occurred: $e'),
          appSettings: state.appSettings, // Changed from userAppSettings
        ),
      );
    }
  }

  Future<void> _updateSettings(
    AppSettings updatedSettings, // Changed from UserAppSettings
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsUpdateInProgress(appSettings: updatedSettings));
    try {
      final result = await _appSettingsRepository.update(
        // Changed from userAppSettingsRepository
        id: updatedSettings.id,
        item: updatedSettings,
      );
      emit(SettingsUpdateSuccess(appSettings: result));
    } on HttpException catch (e) {
      emit(SettingsUpdateFailure(e, appSettings: state.appSettings));
    } catch (e) {
      emit(
        SettingsUpdateFailure(
          UnknownException('An unexpected error occurred: $e'),
          appSettings: state.appSettings, // Changed from userAppSettings
        ),
      );
    }
  }

  Future<void> _onSettingsBaseThemeChanged(
    SettingsBaseThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final currentSettings = state.appSettings;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(
        displaySettings: currentSettings.displaySettings.copyWith(
          baseTheme: event.baseTheme,
        ),
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onSettingsAccentThemeChanged(
    SettingsAccentThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final currentSettings = state.appSettings;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(
        displaySettings: currentSettings.displaySettings.copyWith(
          accentTheme: event.accentTheme,
        ),
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onSettingsFontFamilyChanged(
    SettingsFontFamilyChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final currentSettings = state.appSettings;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(
        displaySettings: currentSettings.displaySettings.copyWith(
          fontFamily: event.fontFamily,
        ),
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onSettingsTextScaleFactorChanged(
    SettingsTextScaleFactorChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final currentSettings = state.appSettings;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(
        displaySettings: currentSettings.displaySettings.copyWith(
          textScaleFactor: event.textScaleFactor,
        ),
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onSettingsFontWeightChanged(
    SettingsFontWeightChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final currentSettings = state.appSettings;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(
        displaySettings: currentSettings.displaySettings.copyWith(
          fontWeight: event.fontWeight,
        ),
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onSettingsLanguageChanged(
    SettingsLanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final currentSettings = state.appSettings;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(
        language: event.language,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }
}
