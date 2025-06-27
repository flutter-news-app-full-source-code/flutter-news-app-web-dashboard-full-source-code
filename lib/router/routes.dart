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
}
