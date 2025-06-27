import 'dart:js_interop';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ht_dashboard/app/config/config.dart';
import 'package:ht_dashboard/bootstrap.dart';

// Define the current application environment (production/development/demo).
const AppEnvironment appEnvironment = AppEnvironment.demo;

@JS('removeSplashFromWeb')
external void removeSplashFromWeb();

void main() async {
  final appConfig = switch (appEnvironment) {
    AppEnvironment.production => AppConfig.production(),
    AppEnvironment.development => AppConfig.development(),
    AppEnvironment.demo => AppConfig.demo(),
  };

  final appWidget = await bootstrap(appConfig, appEnvironment);

  // Only remove the splash screen on web after the app is ready.
  if (kIsWeb) {
    removeSplashFromWeb();
  }

  if (appConfig.environment == AppEnvironment.demo) {
    runApp(
      DevicePreview(
        builder: (context) => appWidget,
        tools: const [DeviceSection()],
        backgroundColor: Colors.black87,
      ),
    );
  } else {
    runApp(appWidget);
  }
}
