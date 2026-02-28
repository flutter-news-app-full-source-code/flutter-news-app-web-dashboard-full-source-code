part of 'app_bloc.dart';

enum AppStatus {
  /// The app is in its initial state, typically before any authentication
  /// checks have been performed.
  initial,

  /// The user is authenticated and has a valid session.
  authenticated,

  /// The user is unauthenticated, meaning they are not logged in.
  unauthenticated,
}

final class AppState extends Equatable {
  const AppState({
    required this.environment,
    this.status = AppStatus.initial,
    this.user,
    this.appSettings,
    this.remoteConfig,
  });

  final AppStatus status;
  final User? user;
  final AppSettings? appSettings;
  final RemoteConfig? remoteConfig;
  final local_config.AppEnvironment environment;

  AppState copyWith({
    AppStatus? status,
    User? user,
    AppSettings? appSettings,
    RemoteConfig? remoteConfig,
    bool clearAppSettings = false,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      appSettings: clearAppSettings ? null : appSettings ?? this.appSettings,
      remoteConfig: remoteConfig ?? this.remoteConfig,
      environment: environment,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    appSettings,
    remoteConfig,
    environment,
  ];
}
