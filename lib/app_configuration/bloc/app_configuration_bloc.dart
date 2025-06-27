import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_configuration_event.dart';
part 'app_configuration_state.dart';

class AppConfigurationBloc extends Bloc<AppConfigurationEvent, AppConfigurationState> {
  AppConfigurationBloc() : super(AppConfigurationInitial()) {
    on<AppConfigurationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
