part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

final class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User? user;

  @override
  List<Object?> get props => [user];
}

final class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

/// Event for when the user's app settings are changed.
final class AppUserAppSettingsChanged extends AppEvent {
  const AppUserAppSettingsChanged(this.appSettings);

  /// The new user app settings.
  final AppSettings appSettings;

  @override
  List<Object?> get props => [appSettings];
}
