import 'package:flutter_news_app_web_dashboard_full_source_code/app/config/app_environment.dart';

class AppConfig {
  const AppConfig({required this.environment, required this.baseUrl});

  factory AppConfig.production() => const AppConfig(
    environment: AppEnvironment.production,
    baseUrl: 'http://api.yourproductiondomain.com',
  );

  factory AppConfig.demo() =>
      const AppConfig(environment: AppEnvironment.demo, baseUrl: '');

  factory AppConfig.development() => const AppConfig(
    environment: AppEnvironment.development,
    baseUrl: 'http://localhost:8080',
  );

  final AppEnvironment environment;
  final String baseUrl;
}
