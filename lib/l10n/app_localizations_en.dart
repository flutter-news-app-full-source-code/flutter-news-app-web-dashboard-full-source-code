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
  String get headline => 'Headline';

  @override
  String get topics => 'Topics';

  @override
  String get topic => 'Topic';

  @override
  String get sources => 'Sources';

  @override
  String get source => 'Source';

  @override
  String get appConfiguration => 'Remote Config';

  @override
  String get appConfigurationPageDescription =>
      'Manage global settings for the mobile app, from content limits to operational status.';

  @override
  String get settings => 'Settings';

  @override
  String get appConfigurationPageTitle => 'Remote Configuration';

  @override
  String get feedTab => 'Feed';

  @override
  String get advertisementsTab => 'Advertisements';

  @override
  String get systemTab => 'System';

  @override
  String get userContentLimitsTitle => 'User Content Limits';

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
      'Remote configuration saved successfully. Mobile clients will update on their next launch.';

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
  String get edit => 'Edit';

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
      'Toggle to put the mobile app in maintenance mode, preventing user access.';

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
  String get savedFeedFiltersLimitLabel => 'Saved Filters Limits';

  @override
  String get savedFeedFiltersLimitDescription =>
      'Maximum number of feed filters this user role can save.';

  @override
  String get adFrequencyLabel => 'Ad Frequency';

  @override
  String get adFrequencyDescription =>
      'How often an ad can appear for this user role (e.g., a value of 5 means an ad could be placed after every 5 news items).';

  @override
  String get savedFeedFilterLimitsTitle => 'Saved Filter Limits';

  @override
  String get savedFeedFilterLimitsDescription =>
      'Set limits on the number of saved feed filters for each user tier.';

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
  String get apply => 'Apply';

  @override
  String visibleToRoleLabel(String roleName) {
    return 'Visible to $roleName';
  }

  @override
  String get adPlatformConfigurationTitle => 'Ad Platform Configuration';

  @override
  String get primaryAdPlatformTitle => 'Primary Ad Platform';

  @override
  String get primaryAdPlatformDescription =>
      'Choose the primary ad platform to be used across the application.';

  @override
  String get adUnitIdentifiersTitle => 'Ad Unit Identifiers';

  @override
  String get adUnitIdentifiersDescription =>
      'Configure the ad unit IDs for the selected ad platform.';

  @override
  String get feedAdSettingsTitle => 'Feed Ad Settings';

  @override
  String get enableFeedAdsLabel => 'Enable Feed Ads';

  @override
  String get feedAdTypeSelectionTitle => 'Feed Ad Type Selection';

  @override
  String get feedAdTypeSelectionDescription =>
      'Choose the type of ads to display in the main feed (Native or Banner).';

  @override
  String get userRoleFrequencySettingsTitle => 'User Role Frequency Settings';

  @override
  String get userRoleFrequencySettingsDescription =>
      'Configure ad frequency and placement intervals based on user roles.';

  @override
  String get articleAdSettingsTitle => 'Article Ad Settings';

  @override
  String get enableArticleAdsLabel => 'Enable Article Ads';

  @override
  String get defaultInArticleAdTypeSelectionTitle =>
      'Default In-Article Ad Type Selection';

  @override
  String get defaultInArticleAdTypeSelectionDescription =>
      'Choose the default type of ads to display within articles (Native or Banner).';

  @override
  String get inArticleAdSlotPlacementsTitle => 'In-Article Ad Slot Placements';

  @override
  String get inArticleAdSlotPlacementsDescription =>
      'Enable or disable specific ad slots within article content.';

  @override
  String get feedNativeAdIdLabel => 'Feed Native Ad ID';

  @override
  String get feedNativeAdIdDescription =>
      'The unit ID for native ads in the feed.';

  @override
  String get feedBannerAdIdLabel => 'Feed Banner Ad ID';

  @override
  String get feedBannerAdIdDescription =>
      'The unit ID for banner ads in the feed.';

  @override
  String get articleInterstitialAdIdLabel => 'Article Interstitial Ad ID';

  @override
  String get articleInterstitialAdIdDescription =>
      'The unit ID for interstitial ads in articles.';

  @override
  String get inArticleNativeAdIdLabel => 'In-Article Native Ad ID';

  @override
  String get inArticleNativeAdIdDescription =>
      'The unit ID for native ads within articles.';

  @override
  String get inArticleBannerAdIdLabel => 'In-Article Banner Ad ID';

  @override
  String get inArticleBannerAdIdDescription =>
      'The unit ID for banner ads within articles.';

  @override
  String get inArticleAdSlotTypeAboveArticleContinueReadingButton =>
      'Above the \'Continue Reading\' button';

  @override
  String get inArticleAdSlotTypeBelowArticleContinueReadingButton =>
      'Below the \'Continue Reading\' button';

  @override
  String idCopiedToClipboard(String id) {
    return 'ID \'$id\' copied to clipboard.';
  }

  @override
  String get copyId => 'Copy ID';

  @override
  String get enableGlobalAdsLabel => 'Enable Ads';

  @override
  String get feedToArticleInterstitialAdIdLabel =>
      'Feed to Article Interstitial Ad ID';

  @override
  String get feedToArticleInterstitialAdIdDescription =>
      'The ad unit ID for interstitial ads displayed when a user navigates from a feed to an article.';

  @override
  String get interstitialAdSettingsTitle => 'Interstitial Ad Settings';

  @override
  String get enableInterstitialAdsLabel => 'Enable Interstitial Ads';

  @override
  String get userRoleInterstitialFrequencyTitle =>
      'Interstitial Ad Frequency by User Role';

  @override
  String get userRoleInterstitialFrequencyDescription =>
      'Configure how many transitions a user must make before an interstitial ad is shown, based on their role.';

  @override
  String get transitionsBeforeInterstitialAdsLabel =>
      'Transitions Before Interstitial Ads';

  @override
  String get transitionsBeforeInterstitialAdsDescription =>
      'The number of transitions (e.g., opening articles) a user must make before an interstitial ad is displayed.';

  @override
  String get adPlatformTypeAdmob => 'AdMob';

  @override
  String get nativeAdsTab => 'Native Ads';

  @override
  String get bannerAdsTab => 'Banner Ads';

  @override
  String get interstitialAdsTab => 'Interstitial Ads';

  @override
  String get videoAdsTab => 'Video Ads';

  @override
  String get bannerAdType => 'Banner';

  @override
  String get nativeAdType => 'Native';

  @override
  String get interstitialAdType => 'Interstitial';

  @override
  String get videoAdType => 'Video';

  @override
  String get bannerAdShapeSelectionTitle => 'Banner Ad Shape';

  @override
  String get bannerAdShapeSelectionDescription =>
      'Select the preferred visual shape for banner ads displayed in articles.';

  @override
  String get bannerAdShapeSquare => 'Square';

  @override
  String get bannerAdShapeRectangle => 'Rectangle';

  @override
  String get loadingDraftHeadlines => 'Loading Draft Headlines';

  @override
  String get noDraftHeadlinesFound => 'No Draft Headlines Found';

  @override
  String get publish => 'Publish';

  @override
  String get saveAsDraft => 'Save as Draft';

  @override
  String get invalidFormTitle => 'Invalid Form';

  @override
  String get invalidFormMessage =>
      'Please complete all required fields before publishing. You can save as a draft or discard your changes.';

  @override
  String get completeForm => 'Complete Form';

  @override
  String get discard => 'Discard';

  @override
  String get drafts => 'Drafts';

  @override
  String get draftsIconTooltip => 'Drafts';

  @override
  String get draftHeadlines => 'Draft Headlines';

  @override
  String get draftTopics => 'Draft Topics';

  @override
  String get draftSources => 'Draft Sources';

  @override
  String get saveHeadlineTitle => 'Save Headline';

  @override
  String get saveHeadlineMessage =>
      'Do you want to publish this headline or save it as a draft?';

  @override
  String get saveTopicTitle => 'Save Topic';

  @override
  String get saveTopicMessage =>
      'Do you want to publish this topic or save it as a draft?';

  @override
  String get saveSourceTitle => 'Save Source';

  @override
  String get saveSourceMessage =>
      'Do you want to publish this source or save it as a draft?';

  @override
  String get loadingDraftTopics => 'Loading Draft Topics...';

  @override
  String get noDraftTopicsFound => 'No draft topics found.';

  @override
  String topicDeleted(String topicTitle) {
    return 'Topic \"$topicTitle\" deleted.';
  }

  @override
  String get loadingDraftSources => 'Loading Draft Sources...';

  @override
  String get noDraftSourcesFound => 'No draft sources found.';

  @override
  String sourceDeleted(String sourceName) {
    return 'Source \"$sourceName\" deleted.';
  }

  @override
  String get publishTopic => 'Publish Topic';

  @override
  String get publishSource => 'Publish Source';

  @override
  String enableInArticleAdsForRoleLabel(String role) {
    return 'Enable In-Article Ads for $role';
  }

  @override
  String get moreActions => 'More Actions';

  @override
  String get filter => 'Filter';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get filterHeadlines => 'Filter Headlines';

  @override
  String get filterTopics => 'Filter Topics';

  @override
  String get filterSources => 'Filter Sources';

  @override
  String get searchByHeadlineTitle => 'Search by headline title...';

  @override
  String get searchByTopicName => 'Search by Name or ID...';

  @override
  String get searchBySourceName => 'Search by Name or ID...';

  @override
  String get selectSources => 'Select Sources';

  @override
  String get selectTopics => 'Select Topics';

  @override
  String get countries => 'Countries';

  @override
  String get selectCountries => 'Select Countries';

  @override
  String get selectSourceTypes => 'Select Source Types';

  @override
  String get selectLanguages => 'Select Languages';

  @override
  String get selectHeadquarters => 'Select Headquarters';

  @override
  String get resetFiltersButtonText => 'Reset Filters';

  @override
  String get noResultsWithCurrentFilters =>
      'No results found with current filters. Try resetting them.';

  @override
  String get aboutIconTooltip => 'About this page';

  @override
  String get closeButtonText => 'Close';

  @override
  String get logoUrl => 'Logo URL';

  @override
  String get userManagement => 'User Management';

  @override
  String get userManagementPageDescription =>
      'Manage system users, including their roles and permissions.';

  @override
  String get loadingUsers => 'Loading Users';

  @override
  String get noUsersFound => 'No users found.';

  @override
  String get email => 'Email';

  @override
  String get appRole => 'App Role';

  @override
  String get dashboardRole => 'Dashboard Role';

  @override
  String get createdAt => 'Created At';

  @override
  String get promoteToPublisher => 'Promote to Publisher';

  @override
  String get demoteToUser => 'Demote to User';

  @override
  String get adminRole => 'Admin';

  @override
  String get publisherRole => 'Publisher';

  @override
  String get filterUsers => 'Filter Users';

  @override
  String get searchByUserEmail => 'Search by Email or ID...';

  @override
  String get selectAppRoles => 'Select App Roles';

  @override
  String get selectDashboardRoles => 'Select Dashboard Roles';

  @override
  String get authentication => 'Authentication';

  @override
  String get subscription => 'Subscription';

  @override
  String get authenticationAnonymous => 'Anonymous';

  @override
  String get authenticationAuthenticated => 'Authenticated';

  @override
  String get subscriptionFree => 'Free';

  @override
  String get subscriptionPremium => 'Premium';

  @override
  String get savedHeadlineFilterLimitsTitle => 'Saved Headline Filter Limits';

  @override
  String get savedHeadlineFilterLimitsDescription =>
      'Set limits on the number of saved headline filters for each user tier, including total, pinned, and notification subscriptions.';

  @override
  String get savedSourceFilterLimitsTitle => 'Saved Source Filter Limits';

  @override
  String get savedSourceFilterLimitsDescription =>
      'Set limits on the number of saved source filters for each user tier, including total and pinned.';

  @override
  String get totalLimitLabel => 'Total Limit';

  @override
  String get totalLimitDescription =>
      'The total number of filters of this type a user can create.';

  @override
  String get pinnedLimitLabel => 'Pinned Limit';

  @override
  String get pinnedLimitDescription =>
      'The maximum number of filters of this type that can be pinned.';

  @override
  String get notificationSubscriptionLimitLabel =>
      'Notification Subscription Limit';

  @override
  String get notificationSubscriptionLimitDescription =>
      'The maximum number of filters a user can subscribe to for this notification type.';

  @override
  String get pushNotificationSubscriptionDeliveryTypeBreakingOnly =>
      'Breaking News';

  @override
  String get pushNotificationSubscriptionDeliveryTypeDailyDigest =>
      'Daily Digest';

  @override
  String get pushNotificationSubscriptionDeliveryTypeWeeklyRoundup =>
      'Weekly Roundup';

  @override
  String get isBreakingNewsLabel => 'Mark as Breaking News';

  @override
  String get isBreakingNewsDescription =>
      'Enabling this will send an immediate push notification to all subscribed users upon publication.';

  @override
  String get isBreakingNewsDescriptionEdit =>
      'Changing this status during an edit will NOT trigger a new push notification, as notifications are only sent on initial creation.';

  @override
  String get confirmBreakingNewsTitle => 'Confirm Breaking News Publication';

  @override
  String get confirmBreakingNewsMessage =>
      'Are you sure you want to publish this as breaking news? This action will send an immediate push notification to all subscribed users.';

  @override
  String get confirmPublishButton => 'Confirm & Publish';

  @override
  String get cannotDraftBreakingNews =>
      'Breaking news cannot be saved as a draft. Please publish it or disable the \'Breaking News\' toggle.';

  @override
  String get ok => 'OK';

  @override
  String get breakingNewsFilterTitle => 'Breaking News';

  @override
  String get breakingNewsFilterAll => 'All';

  @override
  String get breakingNewsFilterBreakingOnly => 'Breaking Only';

  @override
  String get breakingNewsFilterNonBreakingOnly => 'Non-Breaking Only';

  @override
  String get notificationsTab => 'Notifications';

  @override
  String get pushNotificationSettingsTitle => 'Push Notification Settings';

  @override
  String get pushNotificationSettingsDescription =>
      'Manage global settings for the push notification system, including the primary provider and which notification types are active.';

  @override
  String get pushNotificationSystemStatusTitle => 'Enable Notifications';

  @override
  String get pushNotificationSystemStatusDescription =>
      'A global switch to enable or disable all push notifications.';

  @override
  String get pushNotificationPrimaryProviderTitle => 'Primary Provider';

  @override
  String get pushNotificationPrimaryProviderDescription =>
      'Select the primary service provider. Ensure the chosen provider is correctly configured in your backend\'s .env file as per the documentation.';

  @override
  String get pushNotificationDeliveryTypesTitle => 'Delivery Types';

  @override
  String get pushNotificationDeliveryTypesDescription =>
      'Globally enable or disable specific types of push notifications.';

  @override
  String get pushNotificationProviderFirebase => 'Firebase';

  @override
  String get pushNotificationProviderOneSignal => 'OneSignal';

  @override
  String get appTab => 'General';

  @override
  String get featuresTab => 'Features';

  @override
  String get userTab => 'User';

  @override
  String get maintenanceConfigTitle => 'Maintenance Mode';

  @override
  String get maintenanceConfigDescription =>
      'Enable to put the app into maintenance mode, preventing user access.';

  @override
  String get updateConfigTitle => 'Update Settings';

  @override
  String get updateConfigDescription =>
      'Configure mandatory app updates for users.';

  @override
  String get generalAppConfigTitle => 'General App Settings';

  @override
  String get generalAppConfigDescription =>
      'Manage general application settings like Terms of Service and Privacy Policy URLs.';

  @override
  String get termsOfServiceUrlLabel => 'Terms of Service URL';

  @override
  String get termsOfServiceUrlDescription =>
      'The URL for the application\'s Terms of Service page.';

  @override
  String get privacyPolicyUrlLabel => 'Privacy Policy URL';

  @override
  String get privacyPolicyUrlDescription =>
      'The URL for the application\'s Privacy Policy page.';

  @override
  String get navigationAdConfigTitle => 'Navigation Ad Settings';

  @override
  String get enableNavigationAdsLabel => 'Enable Navigation Ads';

  @override
  String get navigationAdFrequencyTitle => 'Navigation Ad Frequency';

  @override
  String get navigationAdFrequencyDescription =>
      'Configure how many transitions a user must make before an interstitial ad is shown, based on their role.';

  @override
  String get internalNavigationsBeforeAdLabel =>
      'Internal Navigations Before Ad';

  @override
  String get internalNavigationsBeforeAdDescription =>
      'The number of internal page-to-page navigations a user must make before an interstitial ad is displayed.';

  @override
  String get externalNavigationsBeforeAdLabel =>
      'External Navigations Before Ad';

  @override
  String get externalNavigationsBeforeAdDescription =>
      'The number of external navigations a user must make before an interstitial ad is displayed.';

  @override
  String get nativeAdIdLabel => 'Native Ad ID';

  @override
  String get nativeAdIdDescription => 'The unit ID for native ads.';

  @override
  String get bannerAdIdLabel => 'Banner Ad ID';

  @override
  String get bannerAdIdDescription => 'The unit ID for banner ads.';

  @override
  String get interstitialAdIdLabel => 'Interstitial Ad ID';

  @override
  String get interstitialAdIdDescription => 'The unit ID for interstitial ads.';

  @override
  String get savedHeadlinesLimitLabel => 'Saved Headlines Limit';

  @override
  String get savedHeadlinesLimitDescription =>
      'Maximum number of headlines this user role can save.';

  @override
  String get appUpdateManagementTitle => 'Application Update Management';

  @override
  String get feedItemClickBehaviorTitle => 'Feed Item Click Behavior';

  @override
  String get feedItemClickBehaviorDescription =>
      'Set the default browser for opening headlines. This can be overridden by users in their app\'s feed settings.';

  @override
  String get feedItemClickBehaviorInternalNavigation => 'In-App Browser';

  @override
  String get feedItemClickBehaviorExternalNavigation => 'System Browser';

  @override
  String get userLimitsTitle => 'User Limits';

  @override
  String get userLimitsDescription =>
      'Define limits for user-specific features and content.';

  @override
  String get appStatusAndUpdatesDescription =>
      'Control the application\'s operational status and manage update requirements.';

  @override
  String get advertisementsDescription =>
      'Manage all advertisement settings, including global controls, platforms, and placements.';

  @override
  String get notificationsDescription =>
      'Configure the push notification system, including providers and delivery types.';

  @override
  String get feedDescription =>
      'Control the behavior and appearance of the user\'s content feed.';

  @override
  String get notificationSubscriptionBreakingOnlyDescription =>
      'Limit for subscriptions that send immediate alerts for matching headlines.';

  @override
  String get notificationSubscriptionDailyDigestDescription =>
      'Limit for subscriptions that send a daily summary of matching headlines.';

  @override
  String get notificationSubscriptionWeeklyRoundupDescription =>
      'Limit for subscriptions that send a weekly summary of matching headlines.';

  @override
  String get appStatusAndUpdatesTitle => 'App Status & Updates';

  @override
  String get enableForcedUpdatesLabel => 'Enable Forced Updates';

  @override
  String get enableForcedUpdatesDescription =>
      'When enabled, you can specify a minimum required version for the mobile app.';

  @override
  String get appUrlsTitle => 'Application URLs';

  @override
  String get appUrlsDescription =>
      'Manage external and internal URLs used within the application.';

  @override
  String get communityAndEngagementTitle => 'Community & Engagement';

  @override
  String get communityAndEngagementDescription =>
      'Configure user engagement and reporting tools. To ensure accountability, these features are unavailable for guest users within the mobile app, irrespective of the settings configured here.';

  @override
  String get userEngagementTitle => 'User Engagement';

  @override
  String get userEngagementDescription => 'Configure reactions and comments.';

  @override
  String get contentReportingTitle => 'Content Reporting';

  @override
  String get contentReportingDescription =>
      'Set rules for what users can report.';

  @override
  String get appReviewFunnelTitle => 'App Reviews';

  @override
  String get appReviewFunnelDescription =>
      'Manage the process for capturing user satisfaction and optionally requesting reviews.';

  @override
  String get enableEngagementFeaturesLabel => 'Enable Engagement Features';

  @override
  String get enableEngagementFeaturesDescription =>
      'Globally activates or deactivates all reaction and comment functionality.';

  @override
  String get engagementModeLabel => 'Engagement Mode';

  @override
  String get engagementModeDescription =>
      'Determines if users can only react or also add comments to content.';

  @override
  String get engagementModeReactionsOnly => 'Reactions Only';

  @override
  String get engagementModeReactionsAndComments => 'Reactions & Comments';

  @override
  String get enableReportingSystemLabel => 'Enable Reporting System';

  @override
  String get enableReportingSystemDescription =>
      'Globally activates or deactivates all user-facing reporting options.';

  @override
  String get enableHeadlineReportingLabel => 'Enable Headline Reporting';

  @override
  String get enableSourceReportingLabel => 'Enable Source Reporting';

  @override
  String get enableCommentReportingLabel => 'Enable Comment Reporting';

  @override
  String get enableAppFeedbackSystemLabel => 'Enable App Feedback System';

  @override
  String get enableAppFeedbackSystemDescription =>
      'Activates the internal system that periodically asks users if they are enjoying the app.';

  @override
  String get interactionCycleThresholdLabel => 'Interaction Cycle Threshold';

  @override
  String get interactionCycleThresholdDescription =>
      'Defines the number of positive actions (e.g., save, like) required to trigger the enjoyment prompt. The prompt is shown each time the user\'s total positive actions is a multiple of this number.';

  @override
  String get initialPromptCooldownLabel => 'Initial Prompt Cooldown (Days)';

  @override
  String get initialPromptCooldownDescription =>
      'The number of days to wait before showing the enjoyment prompt for the first time, This cooldown ensures users are not asked until they used the app enough.';

  @override
  String get requestStoreReviewLabel => 'Request Store Review After \'Yes\'';

  @override
  String get requestStoreReviewDescription =>
      'If enabled, users who respond \'Yes\' to the enjoyment prompt will be shown the official OS store review dialog.';

  @override
  String get requestWrittenFeedbackLabel =>
      'Request Written Feedback After \'No\'';

  @override
  String get requestWrittenFeedbackDescription =>
      'If enabled, users who respond \'No\' will be prompted to provide written feedback directly to the team.';

  @override
  String get internalPromptLogicTitle => 'Internal Prompt Logic';

  @override
  String get eligiblePositiveInteractionsTitle =>
      'Eligible Positive Interactions';

  @override
  String get positiveInteractionTypeSaveItem => 'Save a content item';

  @override
  String get positiveInteractionTypeFollowItem => 'Follow an entity';

  @override
  String get positiveInteractionTypeShareContent => 'Share a content item';

  @override
  String get positiveInteractionTypeSaveFilter => 'Create a saved filter';

  @override
  String get followUpActionsTitle => 'Follow-up Actions';

  @override
  String get enableCommunityFeaturesLabel => 'Enable Community Features';

  @override
  String get enableCommunityFeaturesDescription =>
      'Globally activates or deactivates all community-related functionality, including engagement and reporting.';

  @override
  String get communityManagementPageDescription =>
      'Manage user-generated content including engagements (reactions and comments), content reports, and app reviews.';

  @override
  String get engagements => 'Engagements';

  @override
  String get reports => 'Reports';

  @override
  String get appReviews => 'App Reviews';

  @override
  String get user => 'User';

  @override
  String get engagedContent => 'Engaged Content';

  @override
  String get reaction => 'Reaction';

  @override
  String get comment => 'Comment';

  @override
  String get commentStatus => 'Comment Status';

  @override
  String get hasCommentFilterLabel => 'Contains Comment';

  @override
  String get hasCommentFilterDescription =>
      'Show only engagements that include a text comment.';

  @override
  String get date => 'Date';

  @override
  String get approveComment => 'Approve Comment';

  @override
  String get rejectComment => 'Reject Comment';

  @override
  String get viewEngagedContent => 'View Content';

  @override
  String get copyUserId => 'Copy User ID';

  @override
  String get reporter => 'Reporter';

  @override
  String get reportedItem => 'Reported Item';

  @override
  String get reason => 'Reason';

  @override
  String get reportStatus => 'Report Status';

  @override
  String get viewReportedItem => 'View Item';

  @override
  String get markAsInReview => 'Mark as In Review';

  @override
  String get resolveReport => 'Resolve Report';

  @override
  String get initialFeedback => 'Initial Feedback';

  @override
  String get osPromptRequested => 'OS Prompt?';

  @override
  String get feedbackHistory => 'Feedback History';

  @override
  String get lastInteraction => 'Last Interaction';

  @override
  String get viewFeedbackHistory => 'View History';

  @override
  String get reactionTypeLike => 'Like';

  @override
  String get reactionTypeInsightful => 'Insightful';

  @override
  String get reactionTypeAmusing => 'Amusing';

  @override
  String get reactionTypeSad => 'Sad';

  @override
  String get reactionTypeAngry => 'Angry';

  @override
  String get reactionTypeSkeptical => 'Skeptical';

  @override
  String get initialAppReviewFeedbackPositive => 'Positive';

  @override
  String get initialAppReviewFeedbackNegative => 'Negative';

  @override
  String get filterCommunity => 'Filter Community Content';

  @override
  String get searchByEngagementUser => 'Search by user email...';

  @override
  String get searchByReportReporter => 'Search by reporter email...';

  @override
  String get searchByAppReviewUser => 'Search by user email...';

  @override
  String get selectCommentStatus => 'Select Comment Status';

  @override
  String get selectReportStatus => 'Select Report Status';

  @override
  String get selectInitialFeedback => 'Select Initial Feedback';

  @override
  String get selectReportableEntity => 'Select Reported Item Type';

  @override
  String get reportableEntityHeadline => 'Headline';

  @override
  String get reportableEntitySource => 'Source';

  @override
  String get reportableEntityComment => 'Comment';

  @override
  String get noEngagementsFound => 'No engagements found.';

  @override
  String get noReportsFound => 'No reports found.';

  @override
  String get noAppReviewsFound => 'No app reviews found.';

  @override
  String get loadingEngagements => 'Loading Engagements';

  @override
  String get loadingReports => 'Loading Reports';

  @override
  String get loadingAppReviews => 'Loading App Reviews';

  @override
  String get userIdCopied => 'User ID copied to clipboard.';

  @override
  String get reportStatusUpdated => 'Report status updated.';

  @override
  String feedbackHistoryForUser(String email) {
    return 'Feedback History for $email';
  }

  @override
  String get noFeedbackHistory =>
      'No feedback history available for this user.';

  @override
  String feedbackProvidedAt(String date) {
    return 'Feedback provided at: $date';
  }

  @override
  String feedbackReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get noReasonProvided => 'No reason provided.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get reportReasonMisinformationOrFakeNews =>
      'Misinformation / Fake News';

  @override
  String get reportReasonClickbaitTitle => 'Clickbait Title';

  @override
  String get reportReasonOffensiveOrHateSpeech => 'Offensive / Hate Speech';

  @override
  String get reportReasonSpamOrScam => 'Spam / Scam';

  @override
  String get reportReasonBrokenLink => 'Broken Link';

  @override
  String get reportReasonPaywalled => 'Paywalled';

  @override
  String get reportReasonLowQualityJournalism => 'Low Quality Journalism';

  @override
  String get reportReasonHighAdDensity => 'High Ad Density';

  @override
  String get reportReasonBlog => 'Blog';

  @override
  String get reportReasonGovernmentSource => 'Government Source';

  @override
  String get reportReasonAggregator => 'Aggregator';

  @override
  String get reportReasonOther => 'Other';

  @override
  String get reportReasonFrequentPaywalls => 'Frequent Paywalls';

  @override
  String get reportReasonImpersonation => 'Impersonation';

  @override
  String get noNegativeFeedbackHistory =>
      'No negative feedback history found for this user.';

  @override
  String get reject => 'Reject';

  @override
  String get commentStatusFlaggedByAi => 'Flagged by AI';

  @override
  String get cancel => 'Cancel';

  @override
  String get rejectCommentConfirmation =>
      'Are you sure you want to reject and permanently delete this comment? This action cannot be undone.';

  @override
  String get searchByUserId => 'Search by User ID...';

  @override
  String get viewReportedHeadline => 'View Headline';

  @override
  String get viewReportedSource => 'View Source';

  @override
  String get viewReportedComment => 'View Comment';

  @override
  String get entityType => 'Entity Type';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackDetails => 'Feedback Details';

  @override
  String get moderationStatusPendingReview => 'Pending Review';

  @override
  String get moderationStatusResolved => 'Resolved';

  @override
  String get hasComment => 'Has Comment';

  @override
  String get any => 'Any';

  @override
  String get withComment => 'With Comment';

  @override
  String get withoutComment => 'Without Comment';

  @override
  String get reportResolved => 'Report resolved.';

  @override
  String get commentApproved => 'Comment approved.';

  @override
  String get commentRejected => 'Comment rejected.';

  @override
  String get copyHeadlineId => 'Copy Headline ID';

  @override
  String get copyReportedItemId => 'Copy Reported Item ID';

  @override
  String get viewFeedbackDetails => 'View Feedback Details';

  @override
  String get reportDetails => 'Report Details';

  @override
  String get commentDetails => 'Comment Details';

  @override
  String get communityManagement => 'Community Management';

  @override
  String get navContent => 'Content';

  @override
  String get navUsers => 'Users';

  @override
  String get navCommunity => 'Community';

  @override
  String get confirmPromotionTitle => 'Confirm Promotion';

  @override
  String confirmPromotionMessage(String email) {
    return 'Are you sure you want to promote $email to a Publisher?';
  }

  @override
  String get confirmDemotionTitle => 'Confirm Demotion';

  @override
  String confirmDemotionMessage(String email) {
    return 'Are you sure you want to demote $email to a standard user?';
  }

  @override
  String get premiumUserTooltip => 'Premium';

  @override
  String get adminUserTooltip => 'Admin';

  @override
  String get publisherUserTooltip => 'Publisher';

  @override
  String get breakingNewsHint => 'This is a breaking news headline';

  @override
  String get breakingNewsFilterDescription =>
      'Show only breaking news headlines';

  @override
  String publishItemTitle(String itemType) {
    return 'Publish $itemType?';
  }

  @override
  String publishItemContent(String itemType) {
    return 'Are you sure you want to publish this $itemType? It will become publicly visible.';
  }

  @override
  String archiveItemTitle(String itemType) {
    return 'Archive $itemType?';
  }

  @override
  String archiveItemContent(String itemType) {
    return 'Are you sure you want to archive this $itemType? It will be hidden from public view.';
  }

  @override
  String restoreItemTitle(String itemType) {
    return 'Restore $itemType?';
  }

  @override
  String restoreItemContent(String itemType) {
    return 'Are you sure you want to restore this $itemType? It will become active and publicly visible again.';
  }

  @override
  String deleteItemTitle(String itemType) {
    return 'Delete $itemType?';
  }

  @override
  String deleteItemContent(String itemType) {
    return 'Are you sure you want to delete this $itemType? ';
  }

  @override
  String itemDeletedSnackbar(String itemType, String itemName) {
    return '$itemType \"$itemName\" deleted.';
  }

  @override
  String get adPlatformConfigurationDescription =>
      'Select the primary ad provider and configure their respective ad unit IDs.';

  @override
  String get feedAdSettingsDescription =>
      'Control ad visibility, type, and frequency within the user\'s content feed.';

  @override
  String get navigationAdConfigDescription =>
      'Configure interstitial ads that appear during user navigation.';

  @override
  String get feedDecoratorLinkAccountDescription =>
      'Prompts guest users to create a full account.';

  @override
  String get feedDecoratorUpgradeDescription =>
      'Prompts standard users to upgrade to a premium subscription.';

  @override
  String get feedDecoratorRateAppDescription =>
      'Prompts users to rate the application in the app store.';

  @override
  String get feedDecoratorEnableNotificationsDescription =>
      'Prompts users to enable push notifications.';

  @override
  String get feedDecoratorSuggestedTopicsDescription =>
      'Shows a collection of topics the user might be interested in following.';

  @override
  String get feedDecoratorSuggestedSourcesDescription =>
      'Shows a collection of sources the user might be interested in following.';

  @override
  String get enableGlobalAdsDescription =>
      'Globally activates or deactivates all advertisements within the application.';

  @override
  String get enableFeedAdsDescription =>
      'Controls the visibility of all ads within content feeds.';

  @override
  String visibleToRoleDescription(String roleName) {
    return 'When enabled, this feature will be active for users with the \'$roleName\' role.';
  }

  @override
  String get enableDecoratorDescription =>
      'Globally activates or deactivates this decorator for all eligible users.';

  @override
  String get enableNavigationAdsDescription =>
      'Controls the visibility of interstitial ads that appear during user navigation.';

  @override
  String get enableHeadlineReportingDescription =>
      'Allows users to report individual headlines for issues like misinformation or clickbait.';

  @override
  String get enableSourceReportingDescription =>
      'Allows users to report entire news sources for issues like low quality or bias.';

  @override
  String get enableCommentReportingDescription =>
      'Allows users to report individual comments for moderation.';

  @override
  String get pushNotificationDeliveryTypeBreakingOnlyDescription =>
      'Enable to allow users to subscribe to immediate alerts for breaking news.';

  @override
  String get pushNotificationDeliveryTypeDailyDigestDescription =>
      'Enable to allow users to subscribe to a daily summary of relevant news.';

  @override
  String get pushNotificationDeliveryTypeWeeklyRoundupDescription =>
      'Enable to allow users to subscribe to a weekly roundup of relevant news.';

  @override
  String get positiveInteractionTypeSaveItemDescription =>
      'Counts when a user bookmark a headline.';

  @override
  String get positiveInteractionTypeFollowItemDescription =>
      'Counts when a user follows a headline topic, source, or country.';

  @override
  String get positiveInteractionTypeShareContentDescription =>
      'Counts when a user shares a headline.';

  @override
  String get positiveInteractionTypeSaveFilterDescription =>
      'Counts when a user creates a saved filter.';

  @override
  String get internalPromptLogicDescription =>
      'Define the conditions that trigger the enjoyment prompt, such as the number of user actions and cooldown periods.';

  @override
  String get eligiblePositiveInteractionsDescription =>
      'Select which user actions are counted as \'positive interactions\' to trigger the enjoyment prompt.';

  @override
  String get followUpActionsDescription =>
      'Configure what happens after a user responds to the enjoyment prompt, such as requesting a store review.';

  @override
  String get analyticsTab => 'Analytics';

  @override
  String get analyticsDescription =>
      'Configure analytics provider, event logging, and sampling rates.';

  @override
  String get analyticsSystemStatusTitle => 'Enable Analytics System';

  @override
  String get analyticsSystemStatusDescription =>
      'Master switch to enable or disable all analytics tracking.';

  @override
  String get analyticsProviderTitle => 'Active Provider';

  @override
  String get analyticsProviderDescription =>
      'Select the primary analytics service provider.';

  @override
  String get analyticsEventsTitle => 'Event Configuration';

  @override
  String get analyticsEventsDescription =>
      'Fine-tune logging for specific events. Disable noisy events or adjust sampling rates.';

  @override
  String samplingRateLabel(int rate) {
    return 'Sampling Rate: $rate%';
  }

  @override
  String get analyticsProviderFirebase => 'Firebase';

  @override
  String get analyticsProviderMixpanel => 'Mixpanel';

  @override
  String get analyticsEventUserRegisteredLabel => 'User Registration';

  @override
  String get analyticsEventUserRegisteredDescription =>
      'Track when a new user successfully creates an account.';

  @override
  String get analyticsEventUserLoginLabel => 'User Login';

  @override
  String get analyticsEventUserLoginDescription =>
      'Track when a user logs in to the application.';

  @override
  String get analyticsEventAccountLinkedLabel => 'Account Linking';

  @override
  String get analyticsEventAccountLinkedDescription =>
      'Track when a guest user links their account to a permanent credential.';

  @override
  String get analyticsEventUserRoleChangedLabel => 'User Role Change';

  @override
  String get analyticsEventUserRoleChangedDescription =>
      'Track when a user\'s role is updated (e.g., upgraded to Premium).';

  @override
  String get analyticsEventContentViewedLabel => 'Content View';

  @override
  String get analyticsEventContentViewedDescription =>
      'Track when a user views a headline or article.';

  @override
  String get analyticsEventContentSharedLabel => 'Content Share';

  @override
  String get analyticsEventContentSharedDescription =>
      'Track when a user shares content via external platforms.';

  @override
  String get analyticsEventContentSavedLabel => 'Content Save';

  @override
  String get analyticsEventContentSavedDescription =>
      'Track when a user bookmarks a headline.';

  @override
  String get analyticsEventContentUnsavedLabel => 'Content Unsave';

  @override
  String get analyticsEventContentUnsavedDescription =>
      'Track when a user removes a bookmark.';

  @override
  String get analyticsEventContentReadingTimeLabel => 'Content Reading Time';

  @override
  String get analyticsEventContentReadingTimeDescription =>
      'Track the duration a user spends reading an article.';

  @override
  String get analyticsEventReactionCreatedLabel => 'Reaction Added';

  @override
  String get analyticsEventReactionCreatedDescription =>
      'Track when a user reacts to content.';

  @override
  String get analyticsEventReactionDeletedLabel => 'Reaction Removed';

  @override
  String get analyticsEventReactionDeletedDescription =>
      'Track when a user removes their reaction.';

  @override
  String get analyticsEventCommentCreatedLabel => 'Comment Posted';

  @override
  String get analyticsEventCommentCreatedDescription =>
      'Track when a user submits a new comment.';

  @override
  String get analyticsEventCommentDeletedLabel => 'Comment Deleted';

  @override
  String get analyticsEventCommentDeletedDescription =>
      'Track when a user deletes their own comment.';

  @override
  String get analyticsEventReportSubmittedLabel => 'Report Submitted';

  @override
  String get analyticsEventReportSubmittedDescription =>
      'Track when a user reports content or other users.';

  @override
  String get analyticsEventHeadlineFilterCreatedLabel =>
      'Headline Filter Creation';

  @override
  String get analyticsEventHeadlineFilterCreatedDescription =>
      'Track when a user creates a new custom headline filter.';

  @override
  String get analyticsEventHeadlineFilterUpdatedLabel =>
      'Headline Filter Update';

  @override
  String get analyticsEventHeadlineFilterUpdatedDescription =>
      'Track when a user modifies an existing headline filter.';

  @override
  String get analyticsEventHeadlineFilterUsedLabel => 'Headline Filter Usage';

  @override
  String get analyticsEventHeadlineFilterUsedDescription =>
      'Track when a user applies a saved headline filter.';

  @override
  String get analyticsEventSourceFilterCreatedLabel => 'Source Filter Creation';

  @override
  String get analyticsEventSourceFilterCreatedDescription =>
      'Track when a user creates a new source filter.';

  @override
  String get analyticsEventSourceFilterUpdatedLabel => 'Source Filter Update';

  @override
  String get analyticsEventSourceFilterUpdatedDescription =>
      'Track when a user modifies an existing source filter.';

  @override
  String get analyticsEventSearchPerformedLabel => 'Search Performed';

  @override
  String get analyticsEventSearchPerformedDescription =>
      'Track when a user performs a search query.';

  @override
  String get analyticsEventAppReviewPromptRespondedLabel =>
      'Review Prompt Response';

  @override
  String get analyticsEventAppReviewPromptRespondedDescription =>
      'Track user responses to the internal \'Enjoying the app?\' prompt.';

  @override
  String get analyticsEventAppReviewStoreRequestedLabel =>
      'Store Review Request';

  @override
  String get analyticsEventAppReviewStoreRequestedDescription =>
      'Track when the native OS store review dialog is requested.';

  @override
  String get analyticsEventLimitExceededLabel => 'Limit Exceeded';

  @override
  String get analyticsEventLimitExceededDescription =>
      'Track when a user hits a usage limit (e.g., saved items limit).';

  @override
  String get analyticsEventLimitExceededCtaClickedLabel => 'Limit CTA Click';

  @override
  String get analyticsEventLimitExceededCtaClickedDescription =>
      'Track clicks on \'Upgrade\' or \'Link Account\' buttons in limit dialogs.';

  @override
  String get analyticsEventPaywallPresentedLabel => 'Paywall Impression';

  @override
  String get analyticsEventPaywallPresentedDescription =>
      'Track when the paywall screen is shown to a user.';

  @override
  String get analyticsEventSubscriptionStartedLabel => 'Subscription Start';

  @override
  String get analyticsEventSubscriptionStartedDescription =>
      'Track when a user successfully starts a new subscription.';

  @override
  String get analyticsEventSubscriptionRenewedLabel => 'Subscription Renewal';

  @override
  String get analyticsEventSubscriptionRenewedDescription =>
      'Track when a subscription is automatically or manually renewed.';

  @override
  String get analyticsEventSubscriptionCancelledLabel =>
      'Subscription Cancellation';

  @override
  String get analyticsEventSubscriptionCancelledDescription =>
      'Track when a user cancels their subscription.';

  @override
  String get analyticsEventSubscriptionEndedLabel => 'Subscription End';

  @override
  String get analyticsEventSubscriptionEndedDescription =>
      'Track when a subscription expires or is terminated.';

  @override
  String get analyticsEventAdImpressionLabel => 'Ad Impression';

  @override
  String get analyticsEventAdImpressionDescription =>
      'Track when an advertisement is displayed to the user.';

  @override
  String get analyticsEventAdClickedLabel => 'Ad Click';

  @override
  String get analyticsEventAdClickedDescription =>
      'Track when a user clicks on an advertisement.';

  @override
  String get analyticsEventAdLoadFailedLabel => 'Ad Load Failure';

  @override
  String get analyticsEventAdLoadFailedDescription =>
      'Track errors when attempting to load advertisements.';

  @override
  String get analyticsEventAdRewardEarnedLabel => 'Ad Reward Earned';

  @override
  String get analyticsEventAdRewardEarnedDescription =>
      'Track when a user completes a rewarded ad action.';

  @override
  String get analyticsEventThemeChangedLabel => 'Theme Change';

  @override
  String get analyticsEventThemeChangedDescription =>
      'Track when a user changes the application theme.';

  @override
  String get analyticsEventLanguageChangedLabel => 'Language Change';

  @override
  String get analyticsEventLanguageChangedDescription =>
      'Track when a user changes the application language.';

  @override
  String get analyticsEventFeedDensityChangedLabel => 'Feed Density Change';

  @override
  String get analyticsEventFeedDensityChangedDescription =>
      'Track when a user adjusts the information density of the feed.';

  @override
  String get analyticsEventBrowserChoiceChangedLabel =>
      'Browser Preference Change';

  @override
  String get analyticsEventBrowserChoiceChangedDescription =>
      'Track when a user changes their preferred browser for opening links.';

  @override
  String get analyticsEventSourceFilterUsedLabel => 'Source Filter Usage';

  @override
  String get analyticsEventSourceFilterUsedDescription =>
      'Track when a user applies a saved source filter.';

  @override
  String get timeFrameDay => '24H';

  @override
  String get timeFrameWeek => '7D';

  @override
  String get timeFrameMonth => '30D';

  @override
  String get timeFrameYear => '1Y';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get vsPreviousPeriod => 'vs previous period';

  @override
  String get vsPreviousDay => 'vs previous 24h';

  @override
  String get vsPreviousWeek => 'vs previous 7 days';

  @override
  String get vsPreviousMonth => 'vs previous 30 days';

  @override
  String get vsPreviousYear => 'vs previous year';

  @override
  String get kpiUsersTotalRegistered => 'Total Registered Users';

  @override
  String get kpiUsersNewRegistrations => 'New Registrations';

  @override
  String get kpiUsersActiveUsers => 'Active Users';

  @override
  String get kpiContentHeadlinesTotalPublished => 'Total Headlines Published';

  @override
  String get kpiContentHeadlinesTotalViews => 'Total Headline Views';

  @override
  String get kpiContentHeadlinesTotalLikes => 'Total Headline Likes';

  @override
  String get kpiContentSourcesTotalSources => 'Total Sources';

  @override
  String get kpiContentSourcesNewSources => 'New Sources';

  @override
  String get kpiContentSourcesTotalFollowers => 'Total Source Followers';

  @override
  String get kpiContentTopicsTotalTopics => 'Total Topics';

  @override
  String get kpiContentTopicsNewTopics => 'New Topics';

  @override
  String get kpiContentTopicsTotalFollowers => 'Total Topic Followers';

  @override
  String get kpiEngagementsTotalReactions => 'Total Reactions';

  @override
  String get kpiEngagementsTotalComments => 'Total Comments';

  @override
  String get kpiEngagementsAverageEngagementRate => 'Avg. Engagement Rate';

  @override
  String get kpiEngagementsReportsPending => 'Pending Reports';

  @override
  String get kpiEngagementsReportsResolved => 'Resolved Reports';

  @override
  String get kpiEngagementsReportsAverageResolutionTime =>
      'Avg. Resolution Time';

  @override
  String get kpiEngagementsAppReviewsTotalFeedback => 'Total Feedback';

  @override
  String get kpiEngagementsAppReviewsPositiveFeedback => 'Positive Feedback';

  @override
  String get kpiEngagementsAppReviewsStoreRequests => 'Store Review Requests';

  @override
  String get chartUsersRegistrationsOverTime => 'Registrations Over Time';

  @override
  String get chartUsersActiveUsersOverTime => 'Active Users Trend';

  @override
  String get chartUsersRoleDistribution => 'User Role Distribution';

  @override
  String get chartContentHeadlinesViewsOverTime => 'Headline Views Trend';

  @override
  String get chartContentHeadlinesLikesOverTime => 'Headline Likes Trend';

  @override
  String get chartContentHeadlinesViewsByTopic => 'Views by Topic';

  @override
  String get chartContentSourcesHeadlinesPublishedOverTime => 'Source Activity';

  @override
  String get chartContentSourcesFollowersOverTime => 'Source Follower Growth';

  @override
  String get chartContentSourcesEngagementByType => 'Engagement by Source Type';

  @override
  String get chartContentTopicsFollowersOverTime => 'Topic Follower Growth';

  @override
  String get chartContentTopicsHeadlinesPublishedOverTime => 'Topic Activity';

  @override
  String get chartContentTopicsEngagementByTopic => 'Engagement by Topic';

  @override
  String get chartEngagementsReactionsOverTime => 'Reactions Trend';

  @override
  String get chartEngagementsCommentsOverTime => 'Comments Trend';

  @override
  String get chartEngagementsReactionsByType => 'Reactions Distribution';

  @override
  String get chartEngagementsReportsSubmittedOverTime => 'Reports Submitted';

  @override
  String get chartEngagementsReportsResolutionTimeOverTime =>
      'Resolution Time Trend';

  @override
  String get chartEngagementsReportsByReason => 'Reports by Reason';

  @override
  String get chartEngagementsAppReviewsFeedbackOverTime => 'Feedback Trend';

  @override
  String get chartEngagementsAppReviewsPositiveVsNegative =>
      'Sentiment Analysis';

  @override
  String get chartEngagementsAppReviewsStoreRequestsOverTime =>
      'Store Requests Trend';

  @override
  String get chartContentSourcesStatusDistribution =>
      'Source Status Distribution';

  @override
  String get chartContentHeadlinesBreakingNewsDistribution =>
      'Breaking News Distribution';

  @override
  String get rankedListOverviewHeadlinesMostViewed => 'Top Viewed Headlines';

  @override
  String get rankedListOverviewHeadlinesMostLiked => 'Top Liked Headlines';

  @override
  String get rankedListOverviewSourcesMostFollowed => 'Top Followed Sources';

  @override
  String get rankedListOverviewTopicsMostFollowed => 'Top Followed Topics';

  @override
  String get subscriptionTab => 'Subscriptions';

  @override
  String get subscriptionDescription =>
      'Configure the subscription plans (e.g., monthly, annual) offered to users. When enabled, users who reach their feature limits will be prompted to upgrade to a premium tier.';

  @override
  String get enableSubscriptionLabel => 'Enable Subscription Feature';

  @override
  String get enableSubscriptionDescription =>
      'Master switch for the subscription system. When enabled, users can purchase plans to upgrade their access tier (e.g., from Standard to Premium).';

  @override
  String get monthlyPlanTitle => 'Monthly Plan';

  @override
  String get annualPlanTitle => 'Annual Plan';

  @override
  String get planEnabledLabel => 'Enable Plan';

  @override
  String get planRecommendedLabel => 'Recommended Plan';

  @override
  String get planRecommendedDescription =>
      'Highlights this plan as the best value option.';

  @override
  String get appleProductIdLabel => 'Apple App Store Product ID';

  @override
  String get googleProductIdLabel => 'Google Play Store Product ID';

  @override
  String get subscriptionPlanEnablementError =>
      'Please enter at least one Product ID to enable this plan.';

  @override
  String get subscriptionPlanDisabledNotification =>
      'Plan disabled because no Product IDs are provided.';

  @override
  String get subscriptionFeatureDisabledNotification =>
      'Subscription feature disabled because no plans are active.';

  @override
  String get pushNotificationFeatureDisabledNotification =>
      'Push notification system disabled because no delivery types are active.';

  @override
  String get analyticsFeatureDisabledNotification =>
      'Analytics system disabled because all events are disabled.';

  @override
  String get reportingFeatureDisabledNotification =>
      'Reporting system disabled because no reporting options are active.';

  @override
  String get appReviewFeatureDisabledNotification =>
      'App review system disabled because no positive interactions are selected.';

  @override
  String get subscriptionsName => 'Subscriptions';

  @override
  String get subscriptionProvider => 'Store Provider';

  @override
  String get accessTier => 'Access Tier';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get willAutoRenew => 'Auto Renew';

  @override
  String get allAccessTiers => 'All Tiers';

  @override
  String get subscriptionActionCopyUserId => 'Copy User ID';

  @override
  String get subscriptionActionCopySubscriptionId => 'Copy Subscription ID';

  @override
  String get filterSubscriptions => 'Filter Subscriptions';

  @override
  String get selectStatus => 'Select Status';

  @override
  String get selectProvider => 'Select Provider';

  @override
  String get selectTier => 'Select Tier';

  @override
  String get noSubscriptionsFound => 'No subscriptions found.';

  @override
  String get loadingSubscriptions => 'Loading Subscriptions';

  @override
  String get searchByUserIdOrSubscriptionId =>
      'Search by User ID or Subscription ID...';

  @override
  String get subscriptionsPageDescription =>
      'Provides a read-only interface for monitoring user subscription statuses. All lifecycle events, such as purchases, renewals, and cancellations, are processed automatically by the backend through webhook synchronization with the Apple App Store and Google Play. This dashboard does not initiate or manage financial transactions.';

  @override
  String get subscriptionStatusActive => 'Active';

  @override
  String get subscriptionStatusGracePeriod => 'Grace Period';

  @override
  String get subscriptionStatusBillingIssue => 'Billing Issue';

  @override
  String get subscriptionStatusCanceled => 'Canceled';

  @override
  String get subscriptionStatusExpired => 'Expired';

  @override
  String get storeProviderApple => 'Apple';

  @override
  String get storeProviderGoogle => 'Google';

  @override
  String get chartSubscriptionsActiveOverTime =>
      'Active Subscriptions Over Time';

  @override
  String get chartSubscriptionsStatusDistribution =>
      'Subscription Status Distribution';

  @override
  String get chartSubscriptionsByStoreProvider => 'Subscriptions by Store';

  @override
  String get kpiRewardsAdsWatchedTotal => 'Total Ads Watched';

  @override
  String get kpiRewardsActiveUsersCount => 'Active Reward Users';

  @override
  String get rewardsTab => 'Rewards';

  @override
  String get rewardsDescription =>
      'Configure time-based rewards for user engagement.';

  @override
  String get enableRewardsLabel => 'Enable Rewards System';

  @override
  String get enableRewardsDescription =>
      'Allow users to earn rewards by watching ads.';

  @override
  String get rewardTypeAdFree => 'Ad-Free Experience';

  @override
  String get rewardTypeDailyDigest => 'Daily Digest';

  @override
  String get rewardDurationDaysLabel => 'Duration (Days)';

  @override
  String get rewardEnabledLabel => 'Enabled';

  @override
  String get chartRewardsAdsWatchedOverTime => 'Ads Watched Trend';

  @override
  String get chartRewardsActiveByType => 'Active Rewards by Type';

  @override
  String get feedDecoratorUnlockRewardsDescription =>
      'Prompts users to watch an ad to unlock premium features temporarily.';

  @override
  String get rewardDurationDaysDescription =>
      'The number of days the reward remains active.';

  @override
  String get rewardsManagement => 'Rewards Management';

  @override
  String get rewardsManagementPageDescription =>
      'Manage user rewards and entitlements.';

  @override
  String get loadingRewards => 'Loading Rewards';

  @override
  String get noRewardsFound => 'No rewards found.';

  @override
  String get userId => 'User ID';

  @override
  String get activeRewards => 'Active Rewards';

  @override
  String get expiry => 'Expiry';

  @override
  String get filterRewards => 'Filter Rewards';

  @override
  String get rewardType => 'Reward Type';

  @override
  String get selectRewardTypes => 'Select Reward Types';

  @override
  String get loadingAnalytics => 'Loading Analytics';

  @override
  String get noAnalyticsDataHeadline => 'No Analytics Data';

  @override
  String get noAnalyticsDataSubheadline =>
      'There is no data to display yet. Check back later.';
}
