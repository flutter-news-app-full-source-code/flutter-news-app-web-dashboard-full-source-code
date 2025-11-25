part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User? user;

  @override
  List<Object?> get props => [user];
}

/// {@template app_logout_requested}
/// Event to request user logout.
/// {@endtemplate}
class AppLogoutRequested extends AppEvent {
  /// {@macro app_logout_requested}
  const AppLogoutRequested();
}

/// {@template app_user_app_settings_changed}
/// Event to notify that user application settings have changed.
/// {@endtemplate}
final class AppUserAppSettingsChanged extends AppEvent {
  /// {@macro app_user_app_settings_changed}
  const AppUserAppSettingsChanged(this.appSettings);

  /// The updated user application settings.
  final AppSettings appSettings;

  @override
  List<Object?> get props => [appSettings];
}
