// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get authenticationEmailSignInButton => 'Sign in with Email';

  @override
  String get emailSignInPageTitle => 'Email Sign In';

  @override
  String get requestCodePageHeadline => 'Sign in or create an account';

  @override
  String get requestCodePageSubheadline =>
      'Enter your email to receive a verification code. No password needed!';

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
  String get dashboard => 'Dashboard';

  @override
  String get contentManagement => 'Content Management';

  @override
  String get contentManagementPageDescription =>
      'Manage news headlines, categories, and sources for the Dashboard.';

  @override
  String get headlines => 'Headlines';

  @override
  String get categories => 'Categories';

  @override
  String get sources => 'Sources';

  @override
  String get appConfiguration => 'App Configuration';

  @override
  String get appConfigurationPageDescription =>
      'Configure global settings for the mobile application, including user content limits, ad display rules, in-app prompts, operational status, and force update parameters.';

  @override
  String get settings => 'Settings';

  @override
  String get appConfigurationPageTitle => 'App Configuration';

  @override
  String get userContentLimitsTab => 'User Content Limits';

  @override
  String get adSettingsTab => 'Ad Settings';

  @override
  String get inAppPromptsTab => 'In-App Prompts';

  @override
  String get appOperationalStatusTab => 'App Operational Status';

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
  String get userContentLimitsDescription =>
      'These settings define the maximum number of countries, news sources, categories, and saved headlines a user can follow or save. Limits vary by user type (Guest, Standard, Premium) and directly impact what content users can curate.';

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
      'Maximum number of countries, news sources, or categories a Guest user can follow (each type has its own limit).';

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
      'Maximum number of countries, news sources, or categories a Standard user can follow (each type has its own limit).';

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
      'Maximum number of countries, news sources, or categories a Premium user can follow (each type has its own limit).';

  @override
  String get premiumSavedHeadlinesLimitLabel => 'Premium Saved Headlines Limit';

  @override
  String get premiumSavedHeadlinesLimitDescription =>
      'Maximum number of headlines a Premium user can save.';

  @override
  String get adSettingsDescription =>
      'These settings control how advertisements are displayed within the app\'s news feed, with different rules for Guest, Standard, and Premium users. \"Ad Frequency\" determines how often an ad can appear, while \"Ad Placement Interval\" sets how many news items must be shown before the very first ad appears.';

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
  String get inAppPromptsDescription =>
      'These settings control how often special in-app messages or \"prompts\" are shown to users in their news feed. These prompts encourage actions like linking an account (for guests) or upgrading to a premium subscription (for authenticated users). The frequency varies by user type.';

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
  String get forceUpdateDescription =>
      'These settings control app version enforcement. Users on versions below the minimum allowed will be forced to update.';

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
  String get androidStoreUrlDescription =>
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
  String get publishedAt => 'Published At';

  @override
  String get actions => 'Actions';

  @override
  String get unknown => 'Unknown';

  @override
  String get loadingCategories => 'Loading Categories';

  @override
  String get noCategoriesFound => 'No categories found.';

  @override
  String get categoryName => 'Name';

  @override
  String get description => 'Description';

  @override
  String get notAvailable => 'N/A';

  @override
  String get loadingSources => 'Loading Sources';

  @override
  String get noSourcesFound => 'No sources found.';

  @override
  String get sourceName => 'Name';

  @override
  String get sourceType => 'Type';

  @override
  String get language => 'Language';
}
