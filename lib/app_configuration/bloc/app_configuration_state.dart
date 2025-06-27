part of 'app_configuration_bloc.dart';

sealed class AppConfigurationState extends Equatable {
  const AppConfigurationState();
  
  @override
  List<Object> get props => [];
}

final class AppConfigurationInitial extends AppConfigurationState {}
