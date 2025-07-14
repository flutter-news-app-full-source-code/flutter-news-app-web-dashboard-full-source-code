part of 'app_configuration_bloc.dart';

/// Abstract base class for all events in the AppConfigurationBloc.
abstract class AppConfigurationEvent extends Equatable {
  /// {@macro app_configuration_event}
  const AppConfigurationEvent();

  @override
  List<Object?> get props => [];
}

/// {@template app_configuration_loaded}
/// Event to request the loading of the application configuration.
/// {@endtemplate}
class AppConfigurationLoaded extends AppConfigurationEvent {
  /// {@macro app_configuration_loaded}
  const AppConfigurationLoaded();
}

/// {@template app_configuration_updated}
/// Event to request the update of the application configuration.
///
/// Carries the new "appConfig" object to be saved.
/// {@endtemplate}
class AppConfigurationUpdated extends AppConfigurationEvent {
  /// {@macro app_configuration_updated}
  const AppConfigurationUpdated(this.remoteConfig);

  /// The updated application configuration.
  final RemoteConfig remoteConfig;

  @override
  List<Object?> get props => [remoteConfig];
}

/// {@template app_configuration_discarded}
/// Event to discard any unsaved changes to the application configuration.
/// {@endtemplate}
class AppConfigurationDiscarded extends AppConfigurationEvent {
  /// {@macro app_configuration_discarded}
  const AppConfigurationDiscarded();
}

/// {@template app_configuration_field_changed}
/// Event to notify that a field in the application configuration has changed.
///
/// This event is used to update the local state and mark it as dirty,
/// without immediately triggering a backend save.
/// {@endtemplate}
class AppConfigurationFieldChanged extends AppConfigurationEvent {
  /// {@macro app_configuration_field_changed}
  const AppConfigurationFieldChanged({
    this.remoteConfig,
  });

  /// The partially or fully updated RemoteConfig object.
  final RemoteConfig? remoteConfig;

  @override
  List<Object?> get props => [remoteConfig];
}
