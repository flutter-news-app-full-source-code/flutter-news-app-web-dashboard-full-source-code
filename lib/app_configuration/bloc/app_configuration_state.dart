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
    this.errorMessage,
    this.isDirty = false,
  });

  /// The current status of the application configuration.
  final AppConfigurationStatus status;

  /// The loaded or updated application configuration.
  final AppConfig? appConfig;

  /// An error message if an operation failed.
  final String? errorMessage;

  /// Indicates if there are unsaved changes to the configuration.
  final bool isDirty;

  /// Creates a copy of the current state with updated values.
  AppConfigurationState copyWith({
    AppConfigurationStatus? status,
    AppConfig? appConfig,
    String? errorMessage,
    bool? isDirty,
    bool clearErrorMessage = false,
  }) {
    return AppConfigurationState(
      status: status ?? this.status,
      appConfig: appConfig ?? this.appConfig,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  @override
  List<Object?> get props => [
    status,
    appConfig,
    errorMessage,
    isDirty,
  ];
}
