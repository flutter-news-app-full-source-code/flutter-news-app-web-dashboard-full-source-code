part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// {@template settings_initial}
/// The initial settings state.
/// {@endtemplate}
final class SettingsInitial extends SettingsState {}

/// {@template settings_load_in_progress}
/// State indicating that user settings are being loaded.
/// {@endtemplate}
final class SettingsLoadInProgress extends SettingsState {}

/// {@template settings_load_success}
/// State indicating that user settings have been successfully loaded.
/// {@endtemplate}
final class SettingsLoadSuccess extends SettingsState {
  /// {@macro settings_load_success}
  const SettingsLoadSuccess({required this.userAppSettings});

  /// The loaded user application settings.
  final UserAppSettings userAppSettings;

  @override
  List<Object?> get props => [userAppSettings];
}

/// {@template settings_load_failure}
/// State indicating that loading user settings failed.
/// {@endtemplate}
final class SettingsLoadFailure extends SettingsState {
  /// {@macro settings_load_failure}
  const SettingsLoadFailure(this.errorMessage);

  /// The error message describing the failure.
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

/// {@template settings_update_in_progress}
/// State indicating that user settings are being updated.
/// {@endtemplate}
final class SettingsUpdateInProgress extends SettingsState {
  /// {@macro settings_update_in_progress}
  const SettingsUpdateInProgress({required this.userAppSettings});

  /// The user application settings being updated.
  final UserAppSettings userAppSettings;

  @override
  List<Object?> get props => [userAppSettings];
}

/// {@template settings_update_success}
/// State indicating that user settings have been successfully updated.
/// {@endtemplate}
final class SettingsUpdateSuccess extends SettingsState {
  /// {@macro settings_update_success}
  const SettingsUpdateSuccess({required this.userAppSettings});

  /// The updated user application settings.
  final UserAppSettings userAppSettings;

  @override
  List<Object?> get props => [userAppSettings];
}

/// {@template settings_update_failure}
/// State indicating that updating user settings failed.
/// {@endtemplate}
final class SettingsUpdateFailure extends SettingsState {
  /// {@macro settings_update_failure}
  const SettingsUpdateFailure(this.errorMessage);

  /// The error message describing the failure.
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
