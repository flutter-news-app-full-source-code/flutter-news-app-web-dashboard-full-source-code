part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState({this.userAppSettings});

  /// The current user application settings. Null if not loaded or unauthenticated.
  final UserAppSettings? userAppSettings;

  @override
  List<Object?> get props => [userAppSettings];
}

/// {@template settings_initial}
/// The initial settings state.
/// {@endtemplate}
final class SettingsInitial extends SettingsState {
  /// {@macro settings_initial}
  const SettingsInitial({super.userAppSettings});
}

/// {@template settings_load_in_progress}
/// State indicating that user settings are being loaded.
/// {@endtemplate}
final class SettingsLoadInProgress extends SettingsState {
  /// {@macro settings_load_in_progress}
  const SettingsLoadInProgress({super.userAppSettings});
}

/// {@template settings_load_success}
/// State indicating that user settings have been successfully loaded.
/// {@endtemplate}
final class SettingsLoadSuccess extends SettingsState {
  /// {@macro settings_load_success}
  const SettingsLoadSuccess({required super.userAppSettings});
}

/// {@template settings_load_failure}
/// State indicating that loading user settings failed.
/// {@endtemplate}
final class SettingsLoadFailure extends SettingsState {
  /// {@macro settings_load_failure}
  const SettingsLoadFailure(this.exception, {super.userAppSettings});

  /// The error exception describing the failure.
  final HttpException exception;

  @override
  List<Object?> get props => [exception, userAppSettings];
}

/// {@template settings_update_in_progress}
/// State indicating that user settings are being updated.
/// {@endtemplate}
final class SettingsUpdateInProgress extends SettingsState {
  /// {@macro settings_update_in_progress}
  const SettingsUpdateInProgress({required super.userAppSettings});
}

/// {@template settings_update_success}
/// State indicating that user settings have been successfully updated.
/// {@endtemplate}
final class SettingsUpdateSuccess extends SettingsState {
  /// {@macro settings_update_success}
  const SettingsUpdateSuccess({required super.userAppSettings});
}

/// {@template settings_update_failure}
/// State indicating that updating user settings failed.
/// {@endtemplate}
final class SettingsUpdateFailure extends SettingsState {
  /// {@macro settings_update_failure}
  const SettingsUpdateFailure(this.exception, {super.userAppSettings});

  /// The error exception describing the failure.
  final HttpException exception;

  @override
  List<Object?> get props => [exception, userAppSettings];
}
