import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required DataRepository<AppSettings> appSettingsRepository,
    required AuthRepository authRepository,
  }) : _appSettingsRepository = appSettingsRepository,
       _authRepository = authRepository,
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
  final AuthRepository _authRepository;

  Future<void> _onSettingsLoaded(
    SettingsLoaded event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoadInProgress(appSettings: state.appSettings));
    try {
      final appSettings = await _appSettingsRepository.read(
        id: event.userId!,
      );
      emit(SettingsLoadSuccess(appSettings: appSettings));
    } on NotFoundException {
      // If settings are not found, create default settings for the user.
      // This ensures that a user always has a valid settings object.
      final defaultSettings = AppSettings(
        id: event.userId!,
        displaySettings: const DisplaySettings(
          baseTheme: AppBaseTheme.system,
          accentTheme: AppAccentTheme.defaultBlue,
          fontFamily: 'SystemDefault',
          textScaleFactor: AppTextScaleFactor.medium,
          fontWeight: AppFontWeight.regular,
        ),
        language: SupportedLanguage.en,
        feedSettings: const FeedSettings(
          feedItemDensity: FeedItemDensity.standard,
          feedItemImageStyle: FeedItemImageStyle.largeThumbnail,
          feedItemClickBehavior: FeedItemClickBehavior.defaultBehavior,
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
          appSettings: state.appSettings,
        ),
      );
    }
  }

  Future<void> _updateSettings(
    AppSettings updatedSettings,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsUpdateInProgress(appSettings: updatedSettings));
    try {
      final result = await _appSettingsRepository.update(
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
          appSettings: state.appSettings,
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
        language: SupportedLanguage.values.byName(event.language.code),
      );
      await _updateSettings(updatedSettings, emit);

      // Trigger token refresh to update the 'lang' claim in the JWT.
      // This ensures subsequent 'readAll' requests return the new language.
      if (state is SettingsUpdateSuccess) {
        try {
          await _authRepository.refreshToken();
        } catch (e) {
          // Log failure but don't revert settings update.
        }
      }
    }
  }
}
