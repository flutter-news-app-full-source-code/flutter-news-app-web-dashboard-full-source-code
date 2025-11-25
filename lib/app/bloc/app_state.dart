part of 'app_bloc.dart';

enum AppStatus {
  /// The app is in its initial state, typically before any authentication
  /// checks have been performed.
  initial,

  /// The user is authenticated and has a valid session.
  authenticated,

  /// The user is unauthenticated, meaning they are not logged in.
  unauthenticated,

  /// The user is authenticated anonymously.
  anonymous,
}

final class AppState extends Equatable {
  const AppState({
    required this.environment,
    this.status = AppStatus.initial,
    this.user,
    this.appSettings,
  });

  final AppStatus status;
  final User? user;
  final AppSettings? appSettings;
  final local_config.AppEnvironment environment;

  AppState copyWith({
    AppStatus? status,
    User? user,
    AppSettings? appSettings,
    bool clearAppSettings = false,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      appSettings: clearAppSettings ? null : appSettings ?? this.appSettings,
      environment: environment,
    );
  }

  @override
  List<Object?> get props => [status, user, appSettings, environment];
}
