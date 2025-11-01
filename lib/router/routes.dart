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

  /// The path for the dashboard overview page.
  static const String overview = '/overview';

  /// The name for the dashboard overview page route.
  static const String overviewName = 'overview';

  /// The path for the content management section.
  static const String contentManagement = '/content-management';

  /// The name for the content management section route.
  static const String contentManagementName = 'contentManagement';

  /// The path for creating a new headline.
  static const String createHeadline = 'create-headline';

  /// The name for the create headline page route.
  static const String createHeadlineName = 'createHeadline';

  /// The path for editing an existing headline.
  static const String editHeadline = 'edit-headline/:id';

  /// The name for the edit headline page route.
  static const String editHeadlineName = 'editHeadline';

  /// The path for creating a new topic.
  static const String createTopic = 'create-topic';

  /// The name for the create topic page route.
  static const String createTopicName = 'createTopic';

  /// The path for editing an existing topic.
  static const String editTopic = 'edit-topic/:id';

  /// The name for the edit topic page route.
  static const String editTopicName = 'editTopic';

  /// The path for creating a new source.
  static const String createSource = 'create-source';

  /// The name for the create source page route.
  static const String createSourceName = 'createSource';

  /// The path for editing an existing source.
  static const String editSource = 'edit-source/:id';

  /// The name for the edit source page route.
  static const String editSourceName = 'editSource';

  /// The path for the app configuration page.
  static const String appConfiguration = '/app-configuration';

  /// The name for the app configuration page route.
  static const String appConfigurationName = 'appConfiguration';

  /// The path for the settings page.
  static const String settings = '/settings';

  /// The name for the settings page route.
  static const String settingsName = 'settings';

  /// The path for the generic searchable selection page.
  static const String searchableSelection = 'searchable-selection';

  /// The name for the generic searchable selection page route.
  static const String searchableSelectionName = 'searchableSelection';

  /// The path for the filter dialog.
  static const String filterDialog = 'filter-dialog';

  /// The name for the filter dialog route.
  static const String filterDialogName = 'filterDialog';

  /// The path for the user management section.
  static const String userManagement = '/user-management';

  /// The name for the user management section route.
  static const String userManagementName = 'userManagement';

  /// The path for the user filter dialog.
  static const String userFilterDialog = 'user-filter-dialog';

  /// The name for the user filter dialog route.
  static const String userFilterDialogName = 'userFilterDialog';
}
