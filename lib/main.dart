import 'package:flutter/material.dart';
import 'package:ht_dashboard/app/config/config.dart';
import 'package:ht_dashboard/bootstrap.dart';

// Define the current application environment (production/development/demo).
const AppEnvironment appEnvironment = AppEnvironment.demo;

void main() async {
  final appConfig = switch (appEnvironment) {
    AppEnvironment.production => AppConfig.production(),
    AppEnvironment.development => AppConfig.development(),
    AppEnvironment.demo => AppConfig.demo(),
  };

  final appWidget = await bootstrap(appConfig, appEnvironment);

  runApp(appWidget);
}
