import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/config/config.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/bootstrap.dart';

// Determine the current application environment from compile-time variables.
// Defaults to 'development' if no environment is specified.
const AppEnvironment appEnvironment =
    String.fromEnvironment('APP_ENVIRONMENT') == 'production'
    ? AppEnvironment.production
    : AppEnvironment.development;

@JS('removeSplashFromWeb')
external void removeSplashFromWeb();

void main() async {
  final appConfig = switch (appEnvironment) {
    AppEnvironment.production => AppConfig.production(),
    AppEnvironment.development => AppConfig.development(),
  };

  final appWidget = await bootstrap(appConfig, appEnvironment);

  // Only remove the splash screen on web after the app is ready.
  if (kIsWeb) {
    removeSplashFromWeb();
  }
  runApp(appWidget);
}
