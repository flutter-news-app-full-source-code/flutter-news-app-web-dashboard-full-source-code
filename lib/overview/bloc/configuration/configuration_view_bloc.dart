import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/bloc/app_configuration_bloc.dart';

part 'configuration_view_event.dart';
part 'configuration_view_state.dart';

class ConfigurationViewBloc
    extends Bloc<ConfigurationViewEvent, ConfigurationViewState> {
  ConfigurationViewBloc({
    required AppConfigurationBloc appConfigurationBloc,
  }) : _appConfigurationBloc = appConfigurationBloc,
       super(const ConfigurationViewState()) {
    on<ConfigurationViewSubscriptionRequested>(_onSubscriptionRequested);

    _appConfigSubscription = _appConfigurationBloc.stream.listen((appState) {
      if (appState.status == AppConfigurationStatus.success) {
        add(ConfigurationViewSubscriptionRequested(appState.remoteConfig));
      }
    });
  }

  final AppConfigurationBloc _appConfigurationBloc;
  late final StreamSubscription<AppConfigurationState> _appConfigSubscription;

  void _onSubscriptionRequested(
    ConfigurationViewSubscriptionRequested event,
    Emitter<ConfigurationViewState> emit,
  ) {
    emit(
      state.copyWith(
        status: ConfigurationViewStatus.success,
        remoteConfig: event.remoteConfig,
      ),
    );
  }

  @override
  Future<void> close() {
    _appConfigSubscription.cancel();
    return super.close();
  }
}
