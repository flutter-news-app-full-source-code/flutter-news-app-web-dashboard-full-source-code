// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authenticationPageHeadline => 'Dashboard Access';

  @override
  String get authenticationPageSubheadline =>
      'Secure sign-in for administrators and publishers.';

  @override
  String get authenticationEmailSignInButton => 'Sign in with Email';

  @override
  String get emailSignInPageTitle => 'Secure Email Sign-In';

  @override
  String get requestCodePageHeadline => 'Secure Email Sign-In';

  @override
  String get requestCodePageSubheadline =>
      'Enter your authorized email to receive a secure sign-in code.';

  @override
  String get requestCodeEmailLabel => 'Email';

  @override
  String get requestCodeEmailHint => 'your.email@example.com';

  @override
  String get accountLinkingEmailValidationError =>
      'Please enter a valid email address.';

  @override
  String get requestCodeSendCodeButton => 'Send Code';

  @override
  String requestCodeResendButtonCooldown(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get emailCodeSentPageTitle => 'Verify Code';

  @override
  String emailCodeSentConfirmation(String email) {
    return 'We sent a 6-digit code to $email';
  }

  @override
  String get emailCodeSentInstructions =>
      'Please check your inbox and enter the code below to continue.';

  @override
  String demoVerificationCodeMessage(String code) {
    return 'In demo mode, use code: $code';
  }

  @override
  String get emailCodeVerificationHint => '6-digit code';

  @override
  String get emailCodeValidationEmptyError => 'Code cannot be empty.';

  @override
  String get emailCodeValidationLengthError => 'Code must be 6 digits.';

  @override
  String get emailCodeVerificationButtonLabel => 'Verify Code';

  @override
  String get overview => 'Overview';

  @override
  String get contentManagement => 'Content Management';

  @override
  String get contentManagementPageDescription =>
      'Manage news headlines, topics, and sources for the mobile application.';

  @override
  String get headlines => 'Headlines';

  @override
  String get topics => 'Topics';

  @override
  String get sources => 'Sources';

  @override
  String get appConfiguration => 'App Configuration';

  @override
  String get appConfigurationPageDescription =>
      'Manage global settings for the mobile app, from content limits to operational status.';

  @override
  String get settings => 'Settings';

  @override
  String get appConfigurationPageTitle => 'App Configuration';

  @override
  String get feedTab => 'Feed';

  @override
  String get advertisementsTab => 'Advertisements';

  @override
  String get generalTab => 'General';

  @override
  String get userContentLimitsTitle => 'User Content & Feed Limits';

  @override
  String get userContentLimitsDescription =>
      'Set limits on followed items and saved headlines for each user tier.';

  @override
  String get feedActionsTitle => 'Feed Actions';

  @override
  String get feedActionsDescription =>
      'Configure how often to inject action widgets (e.g., \'Rate App\') into the feed.';

  @override
  String get feedDecoratorsTitle => 'Feed Decorators';

  @override
  String get feedDecoratorsDescription =>
      'Configure how content is decorated and presented in the feed for different user roles.';

  @override
  String get adSettingsTitle => 'Advertisement Settings';

  @override
  String get adSettingsDescription =>
      'Manage ad frequency and placement for different user roles.';

  @override
  String get maintenanceModeTitle => 'Maintenance Mode';

  @override
  String get maintenanceModeDescription =>
      'Enable to show a maintenance screen to all users.';

  @override
  String get forceUpdateTitle => 'Force App Update';

  @override
  String get forceUpdateDescription =>
      'Configure mandatory app updates for users.';

  @override
  String get forceUpdateTab => 'Force Update';

  @override
  String get appConfigSaveSuccessMessage =>
      'App configuration saved successfully!';

  @override
  String appConfigSaveErrorMessage(String errorMessage) {
    return 'Error: $errorMessage';
  }

  @override
  String get unknownError => 'Unknown error';

  @override
  String get loadingConfigurationHeadline => 'Loading Configuration';

  @override
  String get loadingConfigurationSubheadline =>
      'Please wait while settings are loaded...';

  @override
  String get failedToLoadConfigurationMessage =>
      'Failed to load configuration.';

  @override
  String get loadAppSettingsSubheadline =>
      'Load application settings from the backend.';

  @override
  String get discardChangesButton => 'Discard Changes';

  @override
  String get saveChangesButton => 'Save Changes';

  @override
  String get confirmConfigUpdateDialogTitle => 'Confirm Configuration Update';

  @override
  String get confirmConfigUpdateDialogContent =>
      'Are you sure you want to apply these changes to the live application configuration? This is a critical operation.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get confirmSaveButton => 'Confirm Save';

  @override
  String get guestUserTab => 'Guest';

  @override
  String get authenticatedUserTab => 'Authenticated';

  @override
  String get premiumUserTab => 'Premium';

  @override
  String get guestFollowedItemsLimitLabel => 'Guest Followed Items Limit';

  @override
  String get guestFollowedItemsLimitDescription =>
      'Maximum number of countries, news sources, or topics a Guest user can follow (each type has its own limit).';

  @override
  String get guestSavedHeadlinesLimitLabel => 'Guest Saved Headlines Limit';

  @override
  String get guestSavedHeadlinesLimitDescription =>
      'Maximum number of headlines a Guest user can save.';

  @override
  String get standardUserFollowedItemsLimitLabel =>
      'Standard User Followed Items Limit';

  @override
  String get standardUserFollowedItemsLimitDescription =>
      'Maximum number of countries, news sources, or topics a Standard user can follow (each type has its own limit).';

  @override
  String get standardUserSavedHeadlinesLimitLabel =>
      'Standard User Saved Headlines Limit';

  @override
  String get standardUserSavedHeadlinesLimitDescription =>
      'Maximum number of headlines a Standard user can save.';

  @override
  String get premiumFollowedItemsLimitLabel => 'Premium Followed Items Limit';

  @override
  String get premiumFollowedItemsLimitDescription =>
      'Maximum number of countries, news sources, or topics a Premium user can follow (each type has its own limit).';

  @override
  String get premiumSavedHeadlinesLimitLabel => 'Premium Saved Headlines Limit';

  @override
  String get premiumSavedHeadlinesLimitDescription =>
      'Maximum number of headlines a Premium user can save.';

  @override
  String get standardUserAdTab => 'Standard User';

  @override
  String get guestAdFrequencyLabel => 'Guest Ad Frequency';

  @override
  String get guestAdFrequencyDescription =>
      'How often an ad can appear for Guest users (e.g., a value of 5 means an ad could be placed after every 5 news items).';

  @override
  String get guestAdPlacementIntervalLabel => 'Guest Ad Placement Interval';

  @override
  String get guestAdPlacementIntervalDescription =>
      'Minimum number of news items that must be shown before the very first ad appears for Guest users.';

  @override
  String get guestArticlesBeforeInterstitialAdsLabel =>
      'Guest Articles Before Interstitial Ads';

  @override
  String get guestArticlesBeforeInterstitialAdsDescription =>
      'Number of articles a Guest user needs to read before a full-screen interstitial ad is shown.';

  @override
  String get standardUserAdFrequencyLabel => 'Standard User Ad Frequency';

  @override
  String get standardUserAdFrequencyDescription =>
      'How often an ad can appear for Standard users (e.g., a value of 10 means an ad could be placed after every 10 news items).';

  @override
  String get standardUserAdPlacementIntervalLabel =>
      'Standard User Ad Placement Interval';

  @override
  String get standardUserAdPlacementIntervalDescription =>
      'Minimum number of news items that must be shown before the very first ad appears for Standard users.';

  @override
  String get standardUserArticlesBeforeInterstitialAdsLabel =>
      'Standard User Articles Before Interstitial Ads';

  @override
  String get standardUserArticlesBeforeInterstitialAdsDescription =>
      'Number of articles a Standard user needs to read before a full-screen interstitial ad is shown.';

  @override
  String get premiumAdFrequencyLabel => 'Premium Ad Frequency';

  @override
  String get premiumAdFrequencyDescription =>
      'How often an ad can appear for Premium users (0 for no ads).';

  @override
  String get premiumAdPlacementIntervalLabel => 'Premium Ad Placement Interval';

  @override
  String get premiumAdPlacementIntervalDescription =>
      'Minimum number of news items that must be shown before the very first ad appears for Premium users.';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsLabel =>
      'Premium User Articles Before Interstitial Ads';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsDescription =>
      'Number of articles a Premium user needs to read before a full-screen interstitial ad is shown.';

  @override
  String get appOperationalStatusWarning =>
      'WARNING: Changing the app\'s operational status can affect all users. Use with extreme caution.';

  @override
  String get appOperationalStatusLabel => 'App Operational Status';

  @override
  String get appOperationalStatusDescription =>
      'The current operational status of the app (e.g., active, maintenance, disabled).';

  @override
  String get maintenanceMessageLabel => 'Maintenance Message';

  @override
  String get maintenanceMessageDescription =>
      'Message displayed when the app is in maintenance mode.';

  @override
  String get disabledMessageLabel => 'Disabled Message';

  @override
  String get disabledMessageDescription =>
      'Message displayed when the app is permanently disabled.';

  @override
  String get forceUpdateConfigurationTitle => 'Force Update Configuration';

  @override
  String get minAllowedAppVersionLabel => 'Minimum Allowed App Version';

  @override
  String get minAllowedAppVersionDescription =>
      'The lowest app version allowed to run (e.g., \"1.2.0\").';

  @override
  String get latestAppVersionLabel => 'Latest App Version';

  @override
  String get latestAppVersionDescription =>
      'The latest available app version (e.g., \"1.5.0\").';

  @override
  String get updateRequiredMessageLabel => 'Update Required Message';

  @override
  String get updateRequiredMessageDescription =>
      'Message displayed when a force update is required.';

  @override
  String get updateOptionalMessageLabel => 'Update Optional Message';

  @override
  String get updateOptionalMessageDescription =>
      'Message displayed for an optional update.';

  @override
  String get iosStoreUrlLabel => 'iOS Store URL';

  @override
  String get iosStoreUrlDescription => 'URL to the app on the Apple App Store.';

  @override
  String get androidStoreUrlLabel => 'Android Store URL';

  @override
  String get androidUpdateUrlDescription =>
      'URL to the app on the Google Play Store.';

  @override
  String get guestDaysBetweenInAppPromptsLabel =>
      'Guest Days Between In-App Prompts';

  @override
  String get guestDaysBetweenInAppPromptsDescription =>
      'Minimum number of days that must pass before a Guest user sees another in-app prompt.';

  @override
  String get standardUserDaysBetweenInAppPromptsLabel =>
      'Standard User Days Between In-App Prompts';

  @override
  String get standardUserDaysBetweenInAppPromptsDescription =>
      'Minimum number of days that must pass before a Standard user sees another in-app prompt.';

  @override
  String get signOut => 'Sign Out';

  @override
  String get settingsSavedSuccessfully => 'Settings saved successfully!';

  @override
  String settingsSaveErrorMessage(String errorMessage) {
    return 'Error saving settings: $errorMessage';
  }

  @override
  String get loadingSettingsHeadline => 'Loading Settings';

  @override
  String get loadingSettingsSubheadline =>
      'Please wait while your settings are loaded...';

  @override
  String failedToLoadSettingsMessage(String errorMessage) {
    return 'Failed to load settings: $errorMessage';
  }

  @override
  String get baseThemeLabel => 'Base Theme';

  @override
  String get baseThemeDescription =>
      'Choose the overall light or dark appearance of the app.';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System Default';

  @override
  String get accentThemeLabel => 'Accent Theme';

  @override
  String get accentThemeDescription =>
      'Select a primary accent color for interactive elements.';

  @override
  String get defaultBlueTheme => 'Default Blue';

  @override
  String get newsRedTheme => 'News Red';

  @override
  String get graphiteGrayTheme => 'Graphite Gray';

  @override
  String get fontFamilyLabel => 'Font Family';

  @override
  String get fontFamilyDescription =>
      'Choose the font used throughout the application.';

  @override
  String get systemDefaultFont => 'System Default';

  @override
  String get textScaleFactorLabel => 'Text Size';

  @override
  String get textScaleFactorDescription =>
      'Adjust the overall size of text in the app.';

  @override
  String get smallText => 'Small';

  @override
  String get mediumText => 'Medium';

  @override
  String get largeText => 'Large';

  @override
  String get extraLargeText => 'Extra Large';

  @override
  String get fontWeightLabel => 'Font Weight';

  @override
  String get fontWeightDescription => 'Choose the thickness of the text.';

  @override
  String get lightFontWeight => 'Light';

  @override
  String get regularFontWeight => 'Regular';

  @override
  String get boldFontWeight => 'Bold';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageDescription => 'Select the application language.';

  @override
  String get englishLanguage => 'English';

  @override
  String get arabicLanguage => 'Arabic';

  @override
  String get appearanceSettingsLabel => 'Appearance';

  @override
  String get languageSettingsLabel => 'Language';

  @override
  String get themeSettingsLabel => 'Theme Settings';

  @override
  String get fontSettingsLabel => 'Font Settings';

  @override
  String get settingsPageDescription =>
      'Configure your personal preferences for the Dashboard interface, encompassing visual presentation and language selection.';

  @override
  String get appearanceSettingsDescription =>
      'Adjust the visual characteristics of the Dashboard, including theme, accent colors, and typographic styles.';

  @override
  String get loadingHeadlines => 'Loading Headlines';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get noHeadlinesFound => 'No headlines found.';

  @override
  String get headlineTitle => 'Title';

  @override
  String get excerpt => 'Excerpt';

  @override
  String get countryName => 'Country';

  @override
  String get publishedAt => 'Published At';

  @override
  String get actions => 'Actions';

  @override
  String get unknown => 'Unknown';

  @override
  String get loadingTopics => 'Loading Topics';

  @override
  String get noTopicsFound => 'No topics found.';

  @override
  String get topicName => 'Topic';

  @override
  String get description => 'Description';

  @override
  String get notAvailable => 'N/A';

  @override
  String get loadingSources => 'Loading Sources';

  @override
  String get noSourcesFound => 'No sources found.';

  @override
  String get sourceName => 'Source';

  @override
  String get sourceType => 'Type';

  @override
  String get language => 'Language';

  @override
  String get editTopic => 'Edit Topic';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get loadingTopic => 'Loading Topic';

  @override
  String get iconUrl => 'Icon URL';

  @override
  String get topicUpdatedSuccessfully => 'Topic updated successfully.';

  @override
  String get cannotUpdateTopicError =>
      'Cannot update: Original topic data not loaded.';

  @override
  String get createTopic => 'Create Topic';

  @override
  String get topicCreatedSuccessfully => 'Topic created successfully.';

  @override
  String get editSource => 'Edit Source';

  @override
  String get sourceUpdatedSuccessfully => 'Source updated successfully.';

  @override
  String get loadingSource => 'Loading Source...';

  @override
  String get sourceUrl => 'URL';

  @override
  String get headquarters => 'Headquarters';

  @override
  String get none => 'None';

  @override
  String get cannotUpdateSourceError =>
      'Cannot update: Original source data not loaded.';

  @override
  String get sourceTypeNewsAgency => 'News Agency';

  @override
  String get sourceTypeLocalNewsOutlet => 'Local News Outlet';

  @override
  String get sourceTypeNationalNewsOutlet => 'National News Outlet';

  @override
  String get sourceTypeInternationalNewsOutlet => 'International News Outlet';

  @override
  String get sourceTypeSpecializedPublisher => 'Specialized Publisher';

  @override
  String get sourceTypeBlog => 'Blog';

  @override
  String get sourceTypeGovernmentSource => 'Government Source';

  @override
  String get sourceTypeAggregator => 'Aggregator';

  @override
  String get sourceTypeOther => 'Other';

  @override
  String get editHeadline => 'Edit Headline';

  @override
  String get headlineUpdatedSuccessfully => 'Headline updated successfully.';

  @override
  String get loadingHeadline => 'Loading Headline...';

  @override
  String get imageUrl => 'Image URL';

  @override
  String get cannotUpdateHeadlineError =>
      'Cannot update: Original headline data not loaded.';

  @override
  String get createHeadline => 'Create Headline';

  @override
  String get headlineCreatedSuccessfully => 'Headline created successfully.';

  @override
  String get loadingData => 'Loading data...';

  @override
  String get loadingFullList => 'Loading full list...';

  @override
  String get createSource => 'Create Source';

  @override
  String get sourceCreatedSuccessfully => 'Source created successfully.';

  @override
  String get status => 'Status';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get contentStatusActive => 'Active';

  @override
  String get contentStatusArchived => 'Archived';

  @override
  String get contentStatusDraft => 'Draft';

  @override
  String get totalHeadlines => 'Total Headlines';

  @override
  String get totalTopics => 'Total Topics';

  @override
  String get totalSources => 'Total Sources';

  @override
  String get loadingOverview => 'Loading Dashboard Overview...';

  @override
  String get loadingOverviewSubheadline => 'Fetching latest statistics...';

  @override
  String get overviewLoadFailure => 'Failed to load dashboard overview data.';

  @override
  String get recentHeadlines => 'Recent Headlines';

  @override
  String get viewAll => 'View All';

  @override
  String get noRecentHeadlines => 'No recent headlines to display.';

  @override
  String get systemStatus => 'System Status';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get createHeadlineAction => 'Create Headline';

  @override
  String get manageContentAction => 'Manage Content';

  @override
  String get appConfigAction => 'App Configuration';

  @override
  String get appStatusActive => 'Active';

  @override
  String get appStatusDisabled => 'Disabled';

  @override
  String demoEmailHint(String email) {
    return 'For demo, use email: $email';
  }

  @override
  String demoCodeHint(String code) {
    return 'For demo, use code: $code';
  }

  @override
  String get appStatusMaintenance => 'Maintenance';

  @override
  String get appStatusOperational => 'Operational';

  @override
  String get isUnderMaintenanceLabel => 'Under Maintenance';

  @override
  String get isUnderMaintenanceDescription =>
      'Toggle to put the app in maintenance mode, preventing user access.';

  @override
  String get isLatestVersionOnlyLabel => 'Force Latest Version Only';

  @override
  String get isLatestVersionOnlyDescription =>
      'If enabled, users must update to the latest app version to continue using the app.';

  @override
  String get iosUpdateUrlLabel => 'iOS Update URL';

  @override
  String get iosUpdateUrlDescription => 'URL for iOS app updates.';

  @override
  String get androidUpdateUrlLabel => 'Android Update URL';

  @override
  String get followedItemsLimitLabel => 'Followed Items Limit';

  @override
  String get followedItemsLimitDescription =>
      'Maximum number of countries, news sources, or categories this user role can follow (each type has its own limit).';

  @override
  String get savedHeadlinesLimitLabel => 'Saved Headlines Limit';

  @override
  String get savedHeadlinesLimitDescription =>
      'Maximum number of headlines this user role can save.';

  @override
  String get adFrequencyLabel => 'Ad Frequency';

  @override
  String get adFrequencyDescription =>
      'How often an ad can appear for this user role (e.g., a value of 5 means an ad could be placed after every 5 news items).';

  @override
  String get adPlacementIntervalLabel => 'Ad Placement Interval';

  @override
  String get adPlacementIntervalDescription =>
      'Minimum number of news items that must be shown before the very first ad appears for this user role.';

  @override
  String get articlesBeforeInterstitialAdsLabel =>
      'Articles Before Interstitial Ads';

  @override
  String get articlesBeforeInterstitialAdsDescription =>
      'Number of articles this user role needs to read before a full-screen interstitial ad is shown.';

  @override
  String get daysSuffix => 'Days';

  @override
  String daysBetweenPromptDescription(String actionType) {
    return 'Minimum number of days before showing the $actionType prompt.';
  }

  @override
  String get retryButtonText => 'Retry';

  @override
  String get feedActionTypeLinkAccount => 'Link Account';

  @override
  String get feedActionTypeRateApp => 'Rate App';

  @override
  String get feedActionTypeFollowTopics => 'Follow Topics';

  @override
  String get feedActionTypeFollowSources => 'Follow Sources';

  @override
  String get feedActionTypeUpgrade => 'Upgrade';

  @override
  String get feedActionTypeEnableNotifications => 'Enable Notifications';

  @override
  String get countryPickerSearchLabel => 'Search';

  @override
  String get countryPickerSearchHint => 'Start typing to search...';

  @override
  String get countryPickerSelectCountryLabel => 'Select a country';

  @override
  String get archivedHeadlines => 'Archived Headlines';

  @override
  String get loadingArchivedHeadlines => 'Loading Archived Headlines';

  @override
  String get noArchivedHeadlinesFound => 'No archived headlines found.';

  @override
  String get restore => 'Restore';

  @override
  String get deleteForever => 'Delete Forever';

  @override
  String get archivedTopics => 'Archived Topics';

  @override
  String get loadingArchivedTopics => 'Loading Archived Topics';

  @override
  String get noArchivedTopicsFound => 'No archived topics found.';

  @override
  String get archivedSources => 'Archived Sources';

  @override
  String get loadingArchivedSources => 'Loading Archived Sources';

  @override
  String get noArchivedSourcesFound => 'No archived sources found.';

  @override
  String get archivedItems => 'Archived Items';

  @override
  String get addNewItem => 'Add New Item';

  @override
  String get archive => 'Archive';

  @override
  String headlineDeleted(String title) {
    return 'Deleted \'\'$title\'\'.';
  }

  @override
  String get undo => 'Undo';

  @override
  String get enabledLabel => 'Enabled';

  @override
  String get itemsToDisplayLabel => 'Items to Display';

  @override
  String get itemsToDisplayDescription =>
      'Number of items to display in this decorator.';

  @override
  String get roleSpecificSettingsTitle => 'Role Specific Settings';

  @override
  String get daysBetweenViewsLabel => 'Days Between Views';

  @override
  String get daysBetweenViewsDescription =>
      'This setting determines the minimum number of days that must pass before a decorator can be shown again to a user, provided the associated task has not yet been completed.';

  @override
  String get feedDecoratorTypeLinkAccount => 'Link Account';

  @override
  String get feedDecoratorTypeUpgrade => 'Upgrade to Premium';

  @override
  String get feedDecoratorTypeRateApp => 'Rate App';

  @override
  String get feedDecoratorTypeEnableNotifications => 'Enable Notifications';

  @override
  String get feedDecoratorTypeSuggestedTopics => 'Suggested Topics';

  @override
  String get feedDecoratorTypeSuggestedSources => 'Suggested Sources';

  @override
  String get guestUserRole => 'Guest User';

  @override
  String get standardUserRole => 'Standard User';

  @override
  String get premiumUserRole => 'Premium User';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get clearSelection => 'Clear Selection';

  @override
  String get search => 'Search';

  @override
  String get noResultsFound => 'No results found.';

  @override
  String get close => 'Close';

  @override
  String visibleToRoleLabel(String roleName) {
    return 'Visible to $roleName';
  }
}
