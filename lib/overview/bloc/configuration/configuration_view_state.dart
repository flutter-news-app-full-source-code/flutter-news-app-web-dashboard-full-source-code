part of 'configuration_view_bloc.dart';

enum ConfigurationViewStatus { initial, loading, success, failure }

final class ConfigurationViewState extends Equatable {
  const ConfigurationViewState({
    this.status = ConfigurationViewStatus.initial,
    this.remoteConfig,
    this.error,
  });

  final ConfigurationViewStatus status;
  final RemoteConfig? remoteConfig;
  final Object? error;

  ConfigurationViewState copyWith({
    ConfigurationViewStatus? status,
    RemoteConfig? remoteConfig,
    Object? error,
  }) {
    return ConfigurationViewState(
      status: status ?? this.status,
      remoteConfig: remoteConfig ?? this.remoteConfig,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, remoteConfig, error];
}
