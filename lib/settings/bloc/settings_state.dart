part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState({this.appSettings});

  /// The current user application settings. Null if not loaded or unauthenticated.
  final AppSettings? appSettings;

  @override
  List<Object?> get props => [appSettings];
}

/// {@template settings_initial}
/// The initial settings state.
/// {@endtemplate}
final class SettingsInitial extends SettingsState {
  /// {@macro settings_initial}
  const SettingsInitial({super.appSettings});
}

/// {@template settings_load_in_progress}
/// State indicating that user settings are being loaded.
/// {@endtemplate}
final class SettingsLoadInProgress extends SettingsState {
  /// {@macro settings_load_in_progress}
  const SettingsLoadInProgress({super.appSettings});
}

/// {@template settings_load_success}
/// State indicating that user settings have been successfully loaded.
/// {@endtemplate}
final class SettingsLoadSuccess extends SettingsState {
  /// {@macro settings_load_success}
  const SettingsLoadSuccess({required super.appSettings});
}

/// {@template settings_load_failure}
/// State indicating that loading user settings failed.
/// {@endtemplate}
final class SettingsLoadFailure extends SettingsState {
  /// {@macro settings_load_failure}
  const SettingsLoadFailure(this.exception, {super.appSettings});

  /// The error exception describing the failure.
  final HttpException exception;

  @override
  List<Object?> get props => [exception, appSettings];
}

/// {@template settings_update_in_progress}
/// State indicating that user settings are being updated.
/// {@endtemplate}
final class SettingsUpdateInProgress extends SettingsState {
  /// {@macro settings_update_in_progress}
  const SettingsUpdateInProgress({required super.appSettings});
}

/// {@template settings_update_success}
/// State indicating that user settings have been successfully updated.
/// {@endtemplate}
final class SettingsUpdateSuccess extends SettingsState {
  /// {@macro settings_update_success}
  const SettingsUpdateSuccess({required super.appSettings});
}

/// {@template settings_update_failure}
/// State indicating that updating user settings failed.
/// {@endtemplate}
final class SettingsUpdateFailure extends SettingsState {
  /// {@macro settings_update_failure}
  const SettingsUpdateFailure(this.exception, {super.appSettings});

  /// The error exception describing the failure.
  final HttpException exception;

  @override
  List<Object?> get props => [exception, appSettings];
}
