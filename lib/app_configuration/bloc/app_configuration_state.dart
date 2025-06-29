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
    this.appConfig,
    this.originalAppConfig,
    this.errorMessage,
    this.isDirty = false,
    this.showSaveSuccess = false,
  });

  /// The current status of the application configuration.
  final AppConfigurationStatus status;

  /// The loaded or updated application configuration.
  final AppConfig? appConfig;

  /// The original application configuration loaded from the backend.
  final AppConfig? originalAppConfig;

  /// An error message if an operation failed.
  final String? errorMessage;

  /// Indicates if there are unsaved changes to the configuration.
  final bool isDirty;

  /// Indicates if a save operation was successful and a snackbar should be shown.
  final bool showSaveSuccess;

  /// Creates a copy of the current state with updated values.
  AppConfigurationState copyWith({
    AppConfigurationStatus? status,
    AppConfig? appConfig,
    AppConfig? originalAppConfig,
    String? errorMessage,
    bool? isDirty,
    bool clearErrorMessage = false,
    bool? showSaveSuccess,
    bool clearShowSaveSuccess = false,
  }) {
    return AppConfigurationState(
      status: status ?? this.status,
      appConfig: appConfig ?? this.appConfig,
      originalAppConfig: originalAppConfig ?? this.originalAppConfig,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      isDirty: isDirty ?? this.isDirty,
      showSaveSuccess: clearShowSaveSuccess
          ? false
          : showSaveSuccess ?? this.showSaveSuccess,
    );
  }

  @override
  List<Object?> get props => [
    status,
    appConfig,
    originalAppConfig,
    errorMessage,
    isDirty,
    showSaveSuccess,
  ];
}
