part of 'app_configuration_bloc.dart';

/// Represents the status of the AppConfigurationBloc.
enum AppConfigurationStatus {
  /// The configuration is in its initial state.
  initial,

  /// The configuration is currently being loaded.
  loading,

  /// The configuration has been successfully loaded or updated.
  success,

  /// An error occurred during loading or updating the configuration.
  failure,
}

/// {@template app_configuration_state}
/// State for the AppConfigurationBloc.
/// {@endtemplate}
class AppConfigurationState extends Equatable {
  /// {@macro app_configuration_state}
  const AppConfigurationState({
    this.status = AppConfigurationStatus.initial,
    this.remoteConfig,
    this.originalRemoteConfig,
    this.exception,
    this.isDirty = false,
    this.showSaveSuccess = false,
  });

  /// The current status of the application configuration.
  final AppConfigurationStatus status;

  /// The loaded or updated application configuration.
  final RemoteConfig? remoteConfig;

  /// The original application configuration loaded from the backend.
  final RemoteConfig? originalRemoteConfig;

  /// An error exception if an operation failed.
  final HtHttpException? exception;

  /// Indicates if there are unsaved changes to the configuration.
  final bool isDirty;

  /// Indicates if a save operation was successful and a snackbar should be shown.
  final bool showSaveSuccess;

  /// Creates a copy of the current state with updated values.
  AppConfigurationState copyWith({
    AppConfigurationStatus? status,
    RemoteConfig? remoteConfig,
    RemoteConfig? originalRemoteConfig,
    HtHttpException? exception,
    bool? isDirty,
    bool clearException = false,
    bool? showSaveSuccess,
    bool clearShowSaveSuccess = false,
  }) {
    return AppConfigurationState(
      status: status ?? this.status,
      remoteConfig: remoteConfig ?? this.remoteConfig,
      originalRemoteConfig: originalRemoteConfig ?? this.originalRemoteConfig,
      exception: clearException ? null : exception ?? this.exception,
      isDirty: isDirty ?? this.isDirty,
      showSaveSuccess: clearShowSaveSuccess
          ? false
          : showSaveSuccess ?? this.showSaveSuccess,
    );
  }

  @override
  List<Object?> get props => [
    status,
    remoteConfig,
    originalRemoteConfig,
    exception,
    isDirty,
    showSaveSuccess,
  ];
}
