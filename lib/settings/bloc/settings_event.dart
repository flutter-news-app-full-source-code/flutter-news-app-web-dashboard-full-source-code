part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// {@template settings_loaded}
/// Event to request loading of user settings.
/// {@endtemplate}
final class SettingsLoaded extends SettingsEvent {
  /// {@macro settings_loaded}
  const SettingsLoaded({this.userId});

  final String? userId;

  @override
  List<Object?> get props => [userId];
}

/// {@template settings_base_theme_changed}
/// Event to change the base theme.
/// {@endtemplate}
final class SettingsBaseThemeChanged extends SettingsEvent {
  /// {@macro settings_base_theme_changed}
  const SettingsBaseThemeChanged(this.baseTheme);

  /// The new base theme.
  final AppBaseTheme baseTheme;

  @override
  List<Object?> get props => [baseTheme];
}

/// {@template settings_accent_theme_changed}
/// Event to change the accent theme.
/// {@endtemplate}
final class SettingsAccentThemeChanged extends SettingsEvent {
  /// {@macro settings_accent_theme_changed}
  const SettingsAccentThemeChanged(this.accentTheme);

  /// The new accent theme.
  final AppAccentTheme accentTheme;

  @override
  List<Object?> get props => [accentTheme];
}

/// {@template settings_font_family_changed}
/// Event to change the font family.
/// {@endtemplate}
final class SettingsFontFamilyChanged extends SettingsEvent {
  /// {@macro settings_font_family_changed}
  const SettingsFontFamilyChanged(this.fontFamily);

  /// The new font family.
  final String fontFamily;

  @override
  List<Object?> get props => [fontFamily];
}

/// {@template settings_text_scale_factor_changed}
/// Event to change the text scale factor.
/// {@endtemplate}
final class SettingsTextScaleFactorChanged extends SettingsEvent {
  /// {@macro settings_text_scale_factor_changed}
  const SettingsTextScaleFactorChanged(this.textScaleFactor);

  /// The new text scale factor.
  final AppTextScaleFactor textScaleFactor;

  @override
  List<Object?> get props => [textScaleFactor];
}

/// {@template settings_font_weight_changed}
/// Event to change the font weight.
/// {@endtemplate}
final class SettingsFontWeightChanged extends SettingsEvent {
  /// {@macro settings_font_weight_changed}
  const SettingsFontWeightChanged(this.fontWeight);

  /// The new font weight.
  final AppFontWeight fontWeight;

  @override
  List<Object?> get props => [fontWeight];
}

/// {@template settings_language_changed}
/// Event to change the application language.
/// {@endtemplate}
final class SettingsLanguageChanged extends SettingsEvent {
  /// {@macro settings_language_changed}
  const SettingsLanguageChanged(this.language);

  /// The new language.
  final AppLanguage language;

  @override
  List<Object?> get props => [language];
}
