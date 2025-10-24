import 'package:flutter_news_app_web_dashboard_full_source_code/app/config/app_environment.dart';

/// A class to hold all environment-specific configurations.
///
/// This class is instantiated in `main.dart` based on the compile-time
/// environment variable. It provides a type-safe way to access
/// environment-specific values like API base URLs.
class AppConfig {
  /// Creates a new [AppConfig].
  AppConfig({
    required this.environment,
    required this.baseUrl,
    // Add other environment-specific configs here (e.g., analytics keys)
  });

  /// A factory constructor for the production environment.
  ///
  /// Reads the `BASE_URL` from a compile-time variable. Throws an exception
  /// if the URL is not provided, ensuring a production build cannot proceed
  /// with a missing configuration. This is a critical safety check.
  factory AppConfig.production() {
    const baseUrl = String.fromEnvironment('BASE_URL');
    if (baseUrl.isEmpty) {
      // This check is crucial for production builds.
      throw StateError(
        'FATAL: The BASE_URL compile-time variable was not provided for this '
        'production build. Ensure the build command includes '
        '--dart-define=BASE_URL=https://your.api.com',
      );
    }
    return AppConfig(environment: AppEnvironment.production, baseUrl: baseUrl);
  }

  /// A factory constructor for the demo environment.
  factory AppConfig.demo() => AppConfig(
    environment: AppEnvironment.demo,
    baseUrl: '', // No API access needed for in-memory demo
  );

  /// A factory constructor for the development environment.
  factory AppConfig.development() => AppConfig(
    environment: AppEnvironment.development,
    baseUrl: const String.fromEnvironment(
      'BASE_URL',
      defaultValue: 'http://localhost:8080',
    ),
  );

  final AppEnvironment environment;
  final String baseUrl;
}
