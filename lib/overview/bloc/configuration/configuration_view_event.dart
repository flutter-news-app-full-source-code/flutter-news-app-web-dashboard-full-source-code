part of 'configuration_view_bloc.dart';

sealed class ConfigurationViewEvent extends Equatable {
  const ConfigurationViewEvent();

  @override
  List<Object?> get props => [];
}

final class ConfigurationViewSubscriptionRequested
    extends ConfigurationViewEvent {
  const ConfigurationViewSubscriptionRequested(this.remoteConfig);
  final RemoteConfig? remoteConfig;
}
