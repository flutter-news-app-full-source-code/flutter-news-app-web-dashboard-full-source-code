/// Defines named constants for route paths and names used throughout the application.
///
/// Using constants helps prevent typos and makes route management easier.
abstract final class Routes {
  /// The path for the authentication page.
  static const String authentication = '/authentication';

  /// The name for the authentication page route.
  static const String authenticationName = 'authentication';

  /// The path for the request code page.
  static const String requestCode = 'request-code';

  /// The name for the request code page route.
  static const String requestCodeName = 'requestCode';

  /// The path for the verify code page.
  static const String verifyCode = 'verify-code';

  /// The name for the verify code page route.
  static const String verifyCodeName = 'verifyCode';

  /// The path for the account linking flow.
  static const String accountLinking = 'linking';

  /// The name for the account linking flow route.
  static const String accountLinkingName = 'accountLinking';

  /// The name for the request code page route within the linking flow.
  static const String linkingRequestCodeName = 'linkingRequestCode';

  /// The name for the verify code page route within the linking flow.
  static const String linkingVerifyCodeName = 'linkingVerifyCode';

  /// The path for the dashboard page.
  static const String dashboard = '/dashboard';

  /// The name for the dashboard page route.
  static const String dashboardName = 'dashboard';

  /// The path for the content management section.
  static const String contentManagement = '/content-management';

  /// The name for the content management section route.
  static const String contentManagementName = 'contentManagement';

  /// The path for the headlines page within content management.
  static const String headlines = 'headlines';

  /// The name for the headlines page route.
  static const String headlinesName = 'headlines';

  /// The path for the categories page within content management.
  static const String categories = 'categories';

  /// The name for the categories page route.
  static const String categoriesName = 'categories';

  /// The path for the sources page within content management.
  static const String sources = 'sources';

  /// The name for the sources page route.
  static const String sourcesName = 'sources';

  /// The path for the app configuration page.
  static const String appConfiguration = '/app-configuration';

  /// The name for the app configuration page route.
  static const String appConfigurationName = 'appConfiguration';

  /// The path for the settings page.
  static const String settings = '/settings';

  /// The name for the settings page route.
  static const String settingsName = 'settings';
}
