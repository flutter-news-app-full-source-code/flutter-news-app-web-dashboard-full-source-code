part of 'app_bloc.dart';

/// Represents the application's authentication status.
enum AppStatus {
  /// The application is initializing and the status is unknown.
  initial,

  /// The user is authenticated.
  authenticated,

  /// The user is unauthenticated.
  unauthenticated,

  /// The user is anonymous (signed in using an anonymous provider).
  anonymous,
}

class AppState extends Equatable {
  /// {@macro app_state}
  const AppState({
    this.status = AppStatus.initial,
    this.user,
    this.environment,
  });

  /// The current authentication status of the application.
  final AppStatus status;

  /// The current user details. Null if unauthenticated.
  final User? user;

  /// The current application environment (e.g., production, development, demo).
  final local_config.AppEnvironment? environment;

  /// Creates a copy of the current state with updated values.
  AppState copyWith({
    AppStatus? status,
    User? user,
    local_config.AppEnvironment? environment,
    bool clearEnvironment = false,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      environment: clearEnvironment ? null : environment ?? this.environment,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        environment,
      ];
}
