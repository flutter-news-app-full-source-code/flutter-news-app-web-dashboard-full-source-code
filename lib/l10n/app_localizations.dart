import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Headline for the main authentication page
  ///
  /// In en, this message translates to:
  /// **'Dashboard Access'**
  String get authenticationPageHeadline;

  /// Subheadline for the main authentication page
  ///
  /// In en, this message translates to:
  /// **'Secure sign-in for administrators and publishers.'**
  String get authenticationPageSubheadline;

  /// Button label for signing in with email
  ///
  /// In en, this message translates to:
  /// **'Sign in with Email'**
  String get authenticationEmailSignInButton;

  /// Title for the email sign-in page
  ///
  /// In en, this message translates to:
  /// **'Secure Email Sign-In'**
  String get emailSignInPageTitle;

  /// Headline for the request code page
  ///
  /// In en, this message translates to:
  /// **'Secure Email Sign-In'**
  String get requestCodePageHeadline;

  /// Subheadline for the request code page
  ///
  /// In en, this message translates to:
  /// **'Enter your authorized email to receive a secure sign-in code.'**
  String get requestCodePageSubheadline;

  /// Label for the email input field on the request code page
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get requestCodeEmailLabel;

  /// Hint text for the email input field on the request code page
  ///
  /// In en, this message translates to:
  /// **'your.email@example.com'**
  String get requestCodeEmailHint;

  /// Validation error message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get accountLinkingEmailValidationError;

  /// Button label for sending the verification code
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get requestCodeSendCodeButton;

  /// Button label for resending the verification code after a cooldown
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String requestCodeResendButtonCooldown(int seconds);

  /// Title for the email code verification page
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get emailCodeSentPageTitle;

  /// Confirmation message that a code has been sent to the email
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}'**
  String emailCodeSentConfirmation(String email);

  /// Instructions for the user to verify the code
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox and enter the code below to continue.'**
  String get emailCodeSentInstructions;

  /// Message displaying the demo verification code
  ///
  /// In en, this message translates to:
  /// **'In demo mode, use code: {code}'**
  String demoVerificationCodeMessage(String code);

  /// Hint text for the code input field on the verification page
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get emailCodeVerificationHint;

  /// Validation error message when the code field is empty
  ///
  /// In en, this message translates to:
  /// **'Code cannot be empty.'**
  String get emailCodeValidationEmptyError;

  /// Validation error message when the code length is incorrect
  ///
  /// In en, this message translates to:
  /// **'Code must be 6 digits.'**
  String get emailCodeValidationLengthError;

  /// Button label for verifying the code
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get emailCodeVerificationButtonLabel;

  /// Label for the dashboard overview navigation item
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// Label for the content management navigation item
  ///
  /// In en, this message translates to:
  /// **'Content Management'**
  String get contentManagement;

  /// Description for the Content Management page
  ///
  /// In en, this message translates to:
  /// **'Manage news headlines, topics, and sources for the mobile application.'**
  String get contentManagementPageDescription;

  /// Label for the headlines subpage
  ///
  /// In en, this message translates to:
  /// **'Headlines'**
  String get headlines;

  /// Label for the topics subpage
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topics;

  /// Label for the sources subpage
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sources;

  /// Label for the app configuration navigation item
  ///
  /// In en, this message translates to:
  /// **'App Configuration'**
  String get appConfiguration;

  /// Description for the App Configuration page
  ///
  /// In en, this message translates to:
  /// **'Manage global settings for the mobile app, from content limits to operational status.'**
  String get appConfigurationPageDescription;

  /// Label for the settings navigation item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Title for the App Configuration page
  ///
  /// In en, this message translates to:
  /// **'App Configuration'**
  String get appConfigurationPageTitle;

  /// Tab title for Feed settings
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feedTab;

  /// Tab title for Advertisements settings
  ///
  /// In en, this message translates to:
  /// **'Advertisements'**
  String get advertisementsTab;

  /// Tab title for system settings
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTab;

  /// Title for the User Content Limits section
  ///
  /// In en, this message translates to:
  /// **'User Content Limits'**
  String get userContentLimitsTitle;

  /// Description for the User Content Limits section
  ///
  /// In en, this message translates to:
  /// **'Set limits on followed items and saved headlines for each user tier.'**
  String get userContentLimitsDescription;

  /// Title for the Feed Actions section
  ///
  /// In en, this message translates to:
  /// **'Feed Actions'**
  String get feedActionsTitle;

  /// Description for the Feed Actions section
  ///
  /// In en, this message translates to:
  /// **'Configure how often to inject action widgets (e.g., \'Rate App\') into the feed.'**
  String get feedActionsDescription;

  /// Title for the Feed Decorators section
  ///
  /// In en, this message translates to:
  /// **'Feed Decorators'**
  String get feedDecoratorsTitle;

  /// Description for the Feed Decorators section
  ///
  /// In en, this message translates to:
  /// **'Configure how content is decorated and presented in the feed for different user roles.'**
  String get feedDecoratorsDescription;

  /// Title for the Advertisement Settings section
  ///
  /// In en, this message translates to:
  /// **'Advertisement Settings'**
  String get adSettingsTitle;

  /// Description for the Ad Settings section
  ///
  /// In en, this message translates to:
  /// **'Manage ad frequency and placement for different user roles.'**
  String get adSettingsDescription;

  /// Title for the Maintenance Mode section
  ///
  /// In en, this message translates to:
  /// **'Maintenance Mode'**
  String get maintenanceModeTitle;

  /// Description for the Maintenance Mode section
  ///
  /// In en, this message translates to:
  /// **'Enable to show a maintenance screen to all users.'**
  String get maintenanceModeDescription;

  /// Title for the Force App Update section
  ///
  /// In en, this message translates to:
  /// **'Force App Update'**
  String get forceUpdateTitle;

  /// Description for the Force App Update section
  ///
  /// In en, this message translates to:
  /// **'Configure mandatory app updates for users.'**
  String get forceUpdateDescription;

  /// Tab title for Force Update
  ///
  /// In en, this message translates to:
  /// **'Force Update'**
  String get forceUpdateTab;

  /// Snackbar message for successful app configuration save
  ///
  /// In en, this message translates to:
  /// **'App configuration saved successfully!'**
  String get appConfigSaveSuccessMessage;

  /// Snackbar message for app configuration save error
  ///
  /// In en, this message translates to:
  /// **'Error: {errorMessage}'**
  String appConfigSaveErrorMessage(String errorMessage);

  /// Fallback message for unknown errors
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// Headline for loading state of app configuration
  ///
  /// In en, this message translates to:
  /// **'Loading Configuration'**
  String get loadingConfigurationHeadline;

  /// Subheadline for loading state of app configuration
  ///
  /// In en, this message translates to:
  /// **'Please wait while settings are loaded...'**
  String get loadingConfigurationSubheadline;

  /// Message for failure state of app configuration loading
  ///
  /// In en, this message translates to:
  /// **'Failed to load configuration.'**
  String get failedToLoadConfigurationMessage;

  /// Subheadline for initial state of app configuration
  ///
  /// In en, this message translates to:
  /// **'Load application settings from the backend.'**
  String get loadAppSettingsSubheadline;

  /// Button to discard changes in app configuration
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get discardChangesButton;

  /// Button to save changes in app configuration
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesButton;

  /// Title for the confirmation dialog before saving app config
  ///
  /// In en, this message translates to:
  /// **'Confirm Configuration Update'**
  String get confirmConfigUpdateDialogTitle;

  /// Content for the confirmation dialog before saving app config
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to apply these changes to the live application configuration? This is a critical operation.'**
  String get confirmConfigUpdateDialogContent;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Confirm save button label in dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Save'**
  String get confirmSaveButton;

  /// Tab title for Guest user role
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestUserTab;

  /// Tab title for Authenticated user role
  ///
  /// In en, this message translates to:
  /// **'Authenticated'**
  String get authenticatedUserTab;

  /// Tab title for Premium user role
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumUserTab;

  /// Label for Guest Followed Items Limit
  ///
  /// In en, this message translates to:
  /// **'Guest Followed Items Limit'**
  String get guestFollowedItemsLimitLabel;

  /// Description for Guest Followed Items Limit
  ///
  /// In en, this message translates to:
  /// **'Maximum number of countries, news sources, or topics a Guest user can follow (each type has its own limit).'**
  String get guestFollowedItemsLimitDescription;

  /// Label for Guest Saved Headlines Limit
  ///
  /// In en, this message translates to:
  /// **'Guest Saved Headlines Limit'**
  String get guestSavedHeadlinesLimitLabel;

  /// Description for Guest Saved Headlines Limit
  ///
  /// In en, this message translates to:
  /// **'Maximum number of headlines a Guest user can save.'**
  String get guestSavedHeadlinesLimitDescription;

  /// Label for Standard User Followed Items Limit
  ///
  /// In en, this message translates to:
  /// **'Standard User Followed Items Limit'**
  String get standardUserFollowedItemsLimitLabel;

  /// Description for Standard User Followed Items Limit
  ///
  /// In en, this message translates to:
  /// **'Maximum number of countries, news sources, or topics a Standard user can follow (each type has its own limit).'**
  String get standardUserFollowedItemsLimitDescription;

  /// Label for Standard User Saved Headlines Limit
  ///
  /// In en, this message translates to:
  /// **'Standard User Saved Headlines Limit'**
  String get standardUserSavedHeadlinesLimitLabel;

  /// Description for Standard User Saved Headlines Limit
  ///
  /// In en, this message translates to:
  /// **'Maximum number of headlines a Standard user can save.'**
  String get standardUserSavedHeadlinesLimitDescription;

  /// Label for Premium Followed Items Limit
  ///
  /// In en, this message translates to:
  /// **'Premium Followed Items Limit'**
  String get premiumFollowedItemsLimitLabel;

  /// Description for Premium Followed Items Limit
  ///
  /// In en, this message translates to:
  /// **'Maximum number of countries, news sources, or topics a Premium user can follow (each type has its own limit).'**
  String get premiumFollowedItemsLimitDescription;

  /// Label for Premium Saved Headlines Limit
  ///
  /// In en, this message translates to:
  /// **'Premium Saved Headlines Limit'**
  String get premiumSavedHeadlinesLimitLabel;

  /// Description for Premium Saved Headlines Limit
  ///
  /// In en, this message translates to:
  /// **'Maximum number of headlines a Premium user can save.'**
  String get premiumSavedHeadlinesLimitDescription;

  /// Tab title for Standard User in Ad Settings
  ///
  /// In en, this message translates to:
  /// **'Standard User'**
  String get standardUserAdTab;

  /// Label for Guest Ad Frequency
  ///
  /// In en, this message translates to:
  /// **'Guest Ad Frequency'**
  String get guestAdFrequencyLabel;

  /// Description for Guest Ad Frequency
  ///
  /// In en, this message translates to:
  /// **'How often an ad can appear for Guest users (e.g., a value of 5 means an ad could be placed after every 5 news items).'**
  String get guestAdFrequencyDescription;

  /// Label for Guest Ad Placement Interval
  ///
  /// In en, this message translates to:
  /// **'Guest Ad Placement Interval'**
  String get guestAdPlacementIntervalLabel;

  /// Description for Guest Ad Placement Interval
  ///
  /// In en, this message translates to:
  /// **'Minimum number of news items that must be shown before the very first ad appears for Guest users.'**
  String get guestAdPlacementIntervalDescription;

  /// Label for Guest Articles Before Interstitial Ads
  ///
  /// In en, this message translates to:
  /// **'Guest Articles Before Interstitial Ads'**
  String get guestArticlesBeforeInterstitialAdsLabel;

  /// Description for Guest Articles Before Interstitial Ads
  ///
  /// In en, this message translates to:
  /// **'Number of articles a Guest user needs to read before a full-screen interstitial ad is shown.'**
  String get guestArticlesBeforeInterstitialAdsDescription;

  /// Label for Standard User Ad Frequency
  ///
  /// In en, this message translates to:
  /// **'Standard User Ad Frequency'**
  String get standardUserAdFrequencyLabel;

  /// Description for Standard User Ad Frequency
  ///
  /// In en, this message translates to:
  /// **'How often an ad can appear for Standard users (e.g., a value of 10 means an ad could be placed after every 10 news items).'**
  String get standardUserAdFrequencyDescription;

  /// Label for Standard User Ad Placement Interval
  ///
  /// In en, this message translates to:
  /// **'Standard User Ad Placement Interval'**
  String get standardUserAdPlacementIntervalLabel;

  /// Description for Standard User Ad Placement Interval
  ///
  /// In en, this message translates to:
  /// **'Minimum number of news items that must be shown before the very first ad appears for Standard users.'**
  String get standardUserAdPlacementIntervalDescription;

  /// Label for Standard User Articles Before Interstitial Ads
  ///
  /// In en, this message translates to:
  /// **'Standard User Articles Before Interstitial Ads'**
  String get standardUserArticlesBeforeInterstitialAdsLabel;

  /// Description for Standard User Articles Before Interstitial Ads
  ///
  /// In en, this message translates to:
  /// **'Number of articles a Standard user needs to read before a full-screen interstitial ad is shown.'**
  String get standardUserArticlesBeforeInterstitialAdsDescription;

  /// Label for Premium Ad Frequency
  ///
  /// In en, this message translates to:
  /// **'Premium Ad Frequency'**
  String get premiumAdFrequencyLabel;

  /// Description for Premium Ad Frequency
  ///
  /// In en, this message translates to:
  /// **'How often an ad can appear for Premium users (0 for no ads).'**
  String get premiumAdFrequencyDescription;

  /// Label for Premium Ad Placement Interval
  ///
  /// In en, this message translates to:
  /// **'Premium Ad Placement Interval'**
  String get premiumAdPlacementIntervalLabel;

  /// Description for Premium Ad Placement Interval
  ///
  /// In en, this message translates to:
  /// **'Minimum number of news items that must be shown before the very first ad appears for Premium users.'**
  String get premiumAdPlacementIntervalDescription;

  /// Label for Premium User Articles Before Interstitial Ads
  ///
  /// In en, this message translates to:
  /// **'Premium User Articles Before Interstitial Ads'**
  String get premiumUserArticlesBeforeInterstitialAdsLabel;

  /// Description for Premium User Articles Before Interstitial Ads
  ///
  /// In en, this message translates to:
  /// **'Number of articles a Premium user needs to read before a full-screen interstitial ad is shown.'**
  String get premiumUserArticlesBeforeInterstitialAdsDescription;

  /// Warning message for changing app operational status
  ///
  /// In en, this message translates to:
  /// **'WARNING: Changing the app\'s operational status can affect all users. Use with extreme caution.'**
  String get appOperationalStatusWarning;

  /// Label for App Operational Status
  ///
  /// In en, this message translates to:
  /// **'App Operational Status'**
  String get appOperationalStatusLabel;

  /// Description for App Operational Status
  ///
  /// In en, this message translates to:
  /// **'The current operational status of the app (e.g., active, maintenance, disabled).'**
  String get appOperationalStatusDescription;

  /// Label for Maintenance Message
  ///
  /// In en, this message translates to:
  /// **'Maintenance Message'**
  String get maintenanceMessageLabel;

  /// Description for Maintenance Message
  ///
  /// In en, this message translates to:
  /// **'Message displayed when the app is in maintenance mode.'**
  String get maintenanceMessageDescription;

  /// Label for Disabled Message
  ///
  /// In en, this message translates to:
  /// **'Disabled Message'**
  String get disabledMessageLabel;

  /// Description for Disabled Message
  ///
  /// In en, this message translates to:
  /// **'Message displayed when the app is permanently disabled.'**
  String get disabledMessageDescription;

  /// Title for Force Update Configuration section
  ///
  /// In en, this message translates to:
  /// **'Force Update Configuration'**
  String get forceUpdateConfigurationTitle;

  /// Label for Minimum Allowed App Version
  ///
  /// In en, this message translates to:
  /// **'Minimum Allowed App Version'**
  String get minAllowedAppVersionLabel;

  /// Description for Minimum Allowed App Version
  ///
  /// In en, this message translates to:
  /// **'The lowest app version allowed to run (e.g., \"1.2.0\").'**
  String get minAllowedAppVersionDescription;

  /// Label for Latest App Version
  ///
  /// In en, this message translates to:
  /// **'Latest App Version'**
  String get latestAppVersionLabel;

  /// Description for Latest App Version
  ///
  /// In en, this message translates to:
  /// **'The latest available app version (e.g., \"1.5.0\").'**
  String get latestAppVersionDescription;

  /// Label for Update Required Message
  ///
  /// In en, this message translates to:
  /// **'Update Required Message'**
  String get updateRequiredMessageLabel;

  /// Description for Update Required Message
  ///
  /// In en, this message translates to:
  /// **'Message displayed when a force update is required.'**
  String get updateRequiredMessageDescription;

  /// Label for Update Optional Message
  ///
  /// In en, this message translates to:
  /// **'Update Optional Message'**
  String get updateOptionalMessageLabel;

  /// Description for Update Optional Message
  ///
  /// In en, this message translates to:
  /// **'Message displayed for an optional update.'**
  String get updateOptionalMessageDescription;

  /// Label for iOS Store URL
  ///
  /// In en, this message translates to:
  /// **'iOS Store URL'**
  String get iosStoreUrlLabel;

  /// Description for iOS Store URL
  ///
  /// In en, this message translates to:
  /// **'URL to the app on the Apple App Store.'**
  String get iosStoreUrlDescription;

  /// Label for Android Store URL
  ///
  /// In en, this message translates to:
  /// **'Android Store URL'**
  String get androidStoreUrlLabel;

  /// Description for Android Update URL
  ///
  /// In en, this message translates to:
  /// **'URL to the app on the Google Play Store.'**
  String get androidUpdateUrlDescription;

  /// Label for Guest Days Between In-App Prompts
  ///
  /// In en, this message translates to:
  /// **'Guest Days Between In-App Prompts'**
  String get guestDaysBetweenInAppPromptsLabel;

  /// Description for Guest Days Between In-App Prompts
  ///
  /// In en, this message translates to:
  /// **'Minimum number of days that must pass before a Guest user sees another in-app prompt.'**
  String get guestDaysBetweenInAppPromptsDescription;

  /// Label for Standard User Days Between In-App Prompts
  ///
  /// In en, this message translates to:
  /// **'Standard User Days Between In-App Prompts'**
  String get standardUserDaysBetweenInAppPromptsLabel;

  /// Description for Standard User Days Between In-App Prompts
  ///
  /// In en, this message translates to:
  /// **'Minimum number of days that must pass before a Standard user sees another in-app prompt.'**
  String get standardUserDaysBetweenInAppPromptsDescription;

  /// Text for the Sign Out menu item
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Snackbar message for successful settings save
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully!'**
  String get settingsSavedSuccessfully;

  /// Snackbar message for settings save error
  ///
  /// In en, this message translates to:
  /// **'Error saving settings: {errorMessage}'**
  String settingsSaveErrorMessage(String errorMessage);

  /// Headline for loading state of settings
  ///
  /// In en, this message translates to:
  /// **'Loading Settings'**
  String get loadingSettingsHeadline;

  /// Subheadline for loading state of settings
  ///
  /// In en, this message translates to:
  /// **'Please wait while your settings are loaded...'**
  String get loadingSettingsSubheadline;

  /// Message for failure state of settings loading
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings: {errorMessage}'**
  String failedToLoadSettingsMessage(String errorMessage);

  /// Label for base theme setting
  ///
  /// In en, this message translates to:
  /// **'Base Theme'**
  String get baseThemeLabel;

  /// Description for base theme setting
  ///
  /// In en, this message translates to:
  /// **'Choose the overall light or dark appearance of the app.'**
  String get baseThemeDescription;

  /// Option for light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Option for dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// Option for system default theme
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemTheme;

  /// Label for accent theme setting
  ///
  /// In en, this message translates to:
  /// **'Accent Theme'**
  String get accentThemeLabel;

  /// Description for accent theme setting
  ///
  /// In en, this message translates to:
  /// **'Select a primary accent color for interactive elements.'**
  String get accentThemeDescription;

  /// Option for default blue accent theme
  ///
  /// In en, this message translates to:
  /// **'Default Blue'**
  String get defaultBlueTheme;

  /// Option for news red accent theme
  ///
  /// In en, this message translates to:
  /// **'News Red'**
  String get newsRedTheme;

  /// Option for graphite gray accent theme
  ///
  /// In en, this message translates to:
  /// **'Graphite Gray'**
  String get graphiteGrayTheme;

  /// Label for font family setting
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get fontFamilyLabel;

  /// Description for font family setting
  ///
  /// In en, this message translates to:
  /// **'Choose the font used throughout the application.'**
  String get fontFamilyDescription;

  /// Option for system default font
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefaultFont;

  /// Label for text scale factor setting
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textScaleFactorLabel;

  /// Description for text scale factor setting
  ///
  /// In en, this message translates to:
  /// **'Adjust the overall size of text in the app.'**
  String get textScaleFactorDescription;

  /// Option for small text size
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get smallText;

  /// Option for medium text size
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get mediumText;

  /// Option for large text size
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get largeText;

  /// Option for extra large text size
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get extraLargeText;

  /// Label for font weight setting
  ///
  /// In en, this message translates to:
  /// **'Font Weight'**
  String get fontWeightLabel;

  /// Description for font weight setting
  ///
  /// In en, this message translates to:
  /// **'Choose the thickness of the text.'**
  String get fontWeightDescription;

  /// Option for light font weight
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightFontWeight;

  /// Option for regular font weight
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regularFontWeight;

  /// Option for bold font weight
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get boldFontWeight;

  /// Label for language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// Description for language setting
  ///
  /// In en, this message translates to:
  /// **'Select the application language.'**
  String get languageDescription;

  /// Tooltip for the edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Option for English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// Option for Arabic language
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicLanguage;

  /// Label for the Appearance settings tab
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSettingsLabel;

  /// Label for the Language settings tab
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingsLabel;

  /// Label for the Theme Settings sub-tab
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettingsLabel;

  /// Label for the Font Settings sub-tab
  ///
  /// In en, this message translates to:
  /// **'Font Settings'**
  String get fontSettingsLabel;

  /// Description for the main settings page
  ///
  /// In en, this message translates to:
  /// **'Configure your personal preferences for the Dashboard interface, encompassing visual presentation and language selection.'**
  String get settingsPageDescription;

  /// Description for the Appearance settings tab
  ///
  /// In en, this message translates to:
  /// **'Adjust the visual characteristics of the Dashboard, including theme, accent colors, and typographic styles.'**
  String get appearanceSettingsDescription;

  /// Headline for loading state of headlines
  ///
  /// In en, this message translates to:
  /// **'Loading Headlines'**
  String get loadingHeadlines;

  /// Subheadline for loading state
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// Message when no headlines are found
  ///
  /// In en, this message translates to:
  /// **'No headlines found.'**
  String get noHeadlinesFound;

  /// Column header for headline title
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get headlineTitle;

  /// Label for the excerpt input field
  ///
  /// In en, this message translates to:
  /// **'Excerpt'**
  String get excerpt;

  /// Label for the country name dropdown field
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryName;

  /// Column header for published date
  ///
  /// In en, this message translates to:
  /// **'Published At'**
  String get publishedAt;

  /// Column header for actions
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// Fallback text for unknown values
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Headline for loading state of topics
  ///
  /// In en, this message translates to:
  /// **'Loading Topics'**
  String get loadingTopics;

  /// Message when no topics are found
  ///
  /// In en, this message translates to:
  /// **'No topics found.'**
  String get noTopicsFound;

  /// Label for the topic name field in forms and tables.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get topicName;

  /// Column header for description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Short text for 'not available'
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// Headline for loading state of sources
  ///
  /// In en, this message translates to:
  /// **'Loading Sources'**
  String get loadingSources;

  /// Message when no sources are found
  ///
  /// In en, this message translates to:
  /// **'No sources found.'**
  String get noSourcesFound;

  /// Column header for source name
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sourceName;

  /// Column header for source type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get sourceType;

  /// Column header for language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Title for the Edit Topic page
  ///
  /// In en, this message translates to:
  /// **'Edit Topic'**
  String get editTopic;

  /// Tooltip for the save changes button
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Message displayed while loading topic data
  ///
  /// In en, this message translates to:
  /// **'Loading Topic'**
  String get loadingTopic;

  /// Label for the icon URL input field
  ///
  /// In en, this message translates to:
  /// **'Icon URL'**
  String get iconUrl;

  /// Message displayed when a topic is updated successfully
  ///
  /// In en, this message translates to:
  /// **'Topic updated successfully.'**
  String get topicUpdatedSuccessfully;

  /// Error message when updating a topic fails because the original data wasn't loaded
  ///
  /// In en, this message translates to:
  /// **'Cannot update: Original topic data not loaded.'**
  String get cannotUpdateTopicError;

  /// Title for the Create Topic page
  ///
  /// In en, this message translates to:
  /// **'Create Topic'**
  String get createTopic;

  /// Message displayed when a topic is created successfully
  ///
  /// In en, this message translates to:
  /// **'Topic created successfully.'**
  String get topicCreatedSuccessfully;

  /// Title for the Edit Source page
  ///
  /// In en, this message translates to:
  /// **'Edit Source'**
  String get editSource;

  /// Message displayed when a source is updated successfully
  ///
  /// In en, this message translates to:
  /// **'Source updated successfully.'**
  String get sourceUpdatedSuccessfully;

  /// Message displayed while loading source data
  ///
  /// In en, this message translates to:
  /// **'Loading Source...'**
  String get loadingSource;

  /// Label for the source URL input field
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get sourceUrl;

  /// Label for the headquarters dropdown field
  ///
  /// In en, this message translates to:
  /// **'Headquarters'**
  String get headquarters;

  /// Default null option for dropdowns
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Error message when updating a source fails because the original data wasn't loaded
  ///
  /// In en, this message translates to:
  /// **'Cannot update: Original source data not loaded.'**
  String get cannotUpdateSourceError;

  /// A global news agency (e.g., Reuters, Associated Press).
  ///
  /// In en, this message translates to:
  /// **'News Agency'**
  String get sourceTypeNewsAgency;

  /// A news outlet focused on a specific local area.
  ///
  /// In en, this message translates to:
  /// **'Local News Outlet'**
  String get sourceTypeLocalNewsOutlet;

  /// A news outlet focused on a specific country.
  ///
  /// In en, this message translates to:
  /// **'National News Outlet'**
  String get sourceTypeNationalNewsOutlet;

  /// A news outlet with a broad international focus.
  ///
  /// In en, this message translates to:
  /// **'International News Outlet'**
  String get sourceTypeInternationalNewsOutlet;

  /// A publisher focused on a specific topic (e.g., technology, sports).
  ///
  /// In en, this message translates to:
  /// **'Specialized Publisher'**
  String get sourceTypeSpecializedPublisher;

  /// A blog or personal publication.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get sourceTypeBlog;

  /// An official government source.
  ///
  /// In en, this message translates to:
  /// **'Government Source'**
  String get sourceTypeGovernmentSource;

  /// A service that aggregates news from other sources.
  ///
  /// In en, this message translates to:
  /// **'Aggregator'**
  String get sourceTypeAggregator;

  /// Any other type of source not covered above.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sourceTypeOther;

  /// Title for the Edit Headline page
  ///
  /// In en, this message translates to:
  /// **'Edit Headline'**
  String get editHeadline;

  /// Message displayed when a headline is updated successfully
  ///
  /// In en, this message translates to:
  /// **'Headline updated successfully.'**
  String get headlineUpdatedSuccessfully;

  /// Message displayed while loading headline data
  ///
  /// In en, this message translates to:
  /// **'Loading Headline...'**
  String get loadingHeadline;

  /// Label for an image URL input field
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// Error message when updating a headline fails because the original data wasn't loaded
  ///
  /// In en, this message translates to:
  /// **'Cannot update: Original headline data not loaded.'**
  String get cannotUpdateHeadlineError;

  /// Title for the Create Headline page
  ///
  /// In en, this message translates to:
  /// **'Create Headline'**
  String get createHeadline;

  /// Message displayed when a headline is created successfully
  ///
  /// In en, this message translates to:
  /// **'Headline created successfully.'**
  String get headlineCreatedSuccessfully;

  /// Generic message displayed while loading data for a form
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loadingData;

  /// Message displayed in a dropdown when its full list of items is being loaded in the background.
  ///
  /// In en, this message translates to:
  /// **'Loading full list...'**
  String get loadingFullList;

  /// Title for the Create Source page
  ///
  /// In en, this message translates to:
  /// **'Create Source'**
  String get createSource;

  /// Message displayed when a source is created successfully
  ///
  /// In en, this message translates to:
  /// **'Source created successfully.'**
  String get sourceCreatedSuccessfully;

  /// Label for content status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Column header for last updated date
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// Content status: Active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get contentStatusActive;

  /// Content status: Archived
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get contentStatusArchived;

  /// Content status: Draft
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get contentStatusDraft;

  /// Label for the total headlines summary card on the dashboard overview
  ///
  /// In en, this message translates to:
  /// **'Total Headlines'**
  String get totalHeadlines;

  /// Label for the total topics summary card on the dashboard overview
  ///
  /// In en, this message translates to:
  /// **'Total Topics'**
  String get totalTopics;

  /// Label for the total sources summary card on the dashboard overview
  ///
  /// In en, this message translates to:
  /// **'Total Sources'**
  String get totalSources;

  /// Headline for the dashboard overview loading state
  ///
  /// In en, this message translates to:
  /// **'Loading Dashboard Overview...'**
  String get loadingOverview;

  /// Subheadline for the dashboard overview loading state
  ///
  /// In en, this message translates to:
  /// **'Fetching latest statistics...'**
  String get loadingOverviewSubheadline;

  /// Error message when dashboard overview data fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load dashboard overview data.'**
  String get overviewLoadFailure;

  /// Title for the recent headlines card on the dashboard overview
  ///
  /// In en, this message translates to:
  /// **'Recent Headlines'**
  String get recentHeadlines;

  /// Button text to view all items in a list
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Message shown when there are no recent headlines
  ///
  /// In en, this message translates to:
  /// **'No recent headlines to display.'**
  String get noRecentHeadlines;

  /// Title for the system status card on the dashboard overview
  ///
  /// In en, this message translates to:
  /// **'System Status'**
  String get systemStatus;

  /// Title for the quick actions card on the dashboard overview
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Button text for the create headline quick action
  ///
  /// In en, this message translates to:
  /// **'Create Headline'**
  String get createHeadlineAction;

  /// Button text for the manage content quick action
  ///
  /// In en, this message translates to:
  /// **'Manage Content'**
  String get manageContentAction;

  /// Button text for the app configuration quick action
  ///
  /// In en, this message translates to:
  /// **'App Configuration'**
  String get appConfigAction;

  /// Text for the 'Active' app status
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get appStatusActive;

  /// Text for the 'Disabled' app status
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get appStatusDisabled;

  /// Hint text shown in demo environment for the login email.
  ///
  /// In en, this message translates to:
  /// **'For demo, use email: {email}'**
  String demoEmailHint(String email);

  /// Hint text shown in demo environment for the verification code.
  ///
  /// In en, this message translates to:
  /// **'For demo, use code: {code}'**
  String demoCodeHint(String code);

  /// Text for the 'Maintenance' app status
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get appStatusMaintenance;

  /// Text for the 'Operational' app status
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get appStatusOperational;

  /// Label for the 'is under maintenance' switch
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance'**
  String get isUnderMaintenanceLabel;

  /// Description for the 'is under maintenance' switch
  ///
  /// In en, this message translates to:
  /// **'Toggle to put the mobile app in maintenance mode, preventing user access.'**
  String get isUnderMaintenanceDescription;

  /// Label for the 'is latest version only' switch
  ///
  /// In en, this message translates to:
  /// **'Force Latest Version Only'**
  String get isLatestVersionOnlyLabel;

  /// Description for the 'is latest version only' switch
  ///
  /// In en, this message translates to:
  /// **'If enabled, users must update to the latest app version to continue using the app.'**
  String get isLatestVersionOnlyDescription;

  /// Label for iOS Update URL
  ///
  /// In en, this message translates to:
  /// **'iOS Update URL'**
  String get iosUpdateUrlLabel;

  /// Description for iOS Update URL
  ///
  /// In en, this message translates to:
  /// **'URL for iOS app updates.'**
  String get iosUpdateUrlDescription;

  /// Label for Android Update URL
  ///
  /// In en, this message translates to:
  /// **'Android Update URL'**
  String get androidUpdateUrlLabel;

  /// Label for Followed Items Limit
  ///
  /// In en, this message translates to:
  /// **'Followed Items Limit'**
  String get followedItemsLimitLabel;

  /// Description for Followed Items Limit
  ///
  /// In en, this message translates to:
  /// **'Maximum number of countries, news sources, or categories this user role can follow (each type has its own limit).'**
  String get followedItemsLimitDescription;

  /// Label for Saved filters Limits
  ///
  /// In en, this message translates to:
  /// **'Saved Filters Limits'**
  String get savedFeedFiltersLimitLabel;

  /// Description for Saved Headlines Limit
  ///
  /// In en, this message translates to:
  /// **'Maximum number of feed filters this user role can save.'**
  String get savedFeedFiltersLimitDescription;

  /// Label for Ad Frequency
  ///
  /// In en, this message translates to:
  /// **'Ad Frequency'**
  String get adFrequencyLabel;

  /// Description for Ad Frequency
  ///
  /// In en, this message translates to:
  /// **'How often an ad can appear for this user role (e.g., a value of 5 means an ad could be placed after every 5 news items).'**
  String get adFrequencyDescription;

  /// Title for the Saved Feed Filter Limits section
  ///
  /// In en, this message translates to:
  /// **'Saved Filter Limits'**
  String get savedFeedFilterLimitsTitle;

  /// Description for the Saved Headlines Filter Limits section
  ///
  /// In en, this message translates to:
  /// **'Set limits on the number of saved feed filters for each user tier.'**
  String get savedFeedFilterLimitsDescription;

  /// Label for Ad Placement Interval
  ///
  /// In en, this message translates to:
  /// **'Ad Placement Interval'**
  String get adPlacementIntervalLabel;

  /// Description for Ad Placement Interval
  ///
  /// In en, this message translates to:
  /// **'Minimum number of news items that must be shown before the very first ad appears for this user role.'**
  String get adPlacementIntervalDescription;

  /// Label for Articles Before Interstitial Ads
  ///
  /// In en, this message translates to:
  /// **'Articles Before Interstitial Ads'**
  String get articlesBeforeInterstitialAdsLabel;

  /// Description for Articles Before Interstitial Ads
  ///
  /// In en, this message translates to:
  /// **'Number of articles this user role needs to read before a full-screen interstitial ad is shown.'**
  String get articlesBeforeInterstitialAdsDescription;

  /// Suffix for number of days in prompt descriptions
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get daysSuffix;

  /// Description for days between in-app prompts
  ///
  /// In en, this message translates to:
  /// **'Minimum number of days before showing the {actionType} prompt.'**
  String daysBetweenPromptDescription(String actionType);

  /// Text for the retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButtonText;

  /// Feed action type for linking an account
  ///
  /// In en, this message translates to:
  /// **'Link Account'**
  String get feedActionTypeLinkAccount;

  /// Feed action type for rating the app
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get feedActionTypeRateApp;

  /// Feed action type for following topics
  ///
  /// In en, this message translates to:
  /// **'Follow Topics'**
  String get feedActionTypeFollowTopics;

  /// Feed action type for following sources
  ///
  /// In en, this message translates to:
  /// **'Follow Sources'**
  String get feedActionTypeFollowSources;

  /// Feed action type for upgrading
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get feedActionTypeUpgrade;

  /// Feed action type for enabling notifications
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get feedActionTypeEnableNotifications;

  /// Label for the search input in the country picker
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get countryPickerSearchLabel;

  /// Hint text for the search input in the country picker
  ///
  /// In en, this message translates to:
  /// **'Start typing to search...'**
  String get countryPickerSearchHint;

  /// Label displayed when no country is selected in the picker form field
  ///
  /// In en, this message translates to:
  /// **'Select a country'**
  String get countryPickerSelectCountryLabel;

  /// Title for the Archived Headlines page
  ///
  /// In en, this message translates to:
  /// **'Archived Headlines'**
  String get archivedHeadlines;

  /// Headline for loading state of archived headlines
  ///
  /// In en, this message translates to:
  /// **'Loading Archived Headlines'**
  String get loadingArchivedHeadlines;

  /// Message when no archived headlines are found
  ///
  /// In en, this message translates to:
  /// **'No archived headlines found.'**
  String get noArchivedHeadlinesFound;

  /// Tooltip for the restore button
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// Tooltip for the delete forever button
  ///
  /// In en, this message translates to:
  /// **'Delete Forever'**
  String get deleteForever;

  /// Title for the Archived Topics page
  ///
  /// In en, this message translates to:
  /// **'Archived Topics'**
  String get archivedTopics;

  /// Headline for loading state of archived topics
  ///
  /// In en, this message translates to:
  /// **'Loading Archived Topics'**
  String get loadingArchivedTopics;

  /// Message when no archived topics are found
  ///
  /// In en, this message translates to:
  /// **'No archived topics found.'**
  String get noArchivedTopicsFound;

  /// Title for the Archived Sources page
  ///
  /// In en, this message translates to:
  /// **'Archived Sources'**
  String get archivedSources;

  /// Headline for loading state of archived sources
  ///
  /// In en, this message translates to:
  /// **'Loading Archived Sources'**
  String get loadingArchivedSources;

  /// Message when no archived sources are found
  ///
  /// In en, this message translates to:
  /// **'No archived sources found.'**
  String get noArchivedSourcesFound;

  /// Tooltip for the archived items button
  ///
  /// In en, this message translates to:
  /// **'Archived Items'**
  String get archivedItems;

  /// Tooltip for the add new item button
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get addNewItem;

  /// Tooltip for the archive button
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// Snackbar message when a headline is deleted
  ///
  /// In en, this message translates to:
  /// **'Deleted \'\'{title}\'\'.'**
  String headlineDeleted(String title);

  /// Label for undo button
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Label for enabled switch
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabledLabel;

  /// Label for items to display input
  ///
  /// In en, this message translates to:
  /// **'Items to Display'**
  String get itemsToDisplayLabel;

  /// Description for items to display input
  ///
  /// In en, this message translates to:
  /// **'Number of items to display in this decorator.'**
  String get itemsToDisplayDescription;

  /// Title for role specific settings section
  ///
  /// In en, this message translates to:
  /// **'Role Specific Settings'**
  String get roleSpecificSettingsTitle;

  /// Label for days between views input
  ///
  /// In en, this message translates to:
  /// **'Days Between Views'**
  String get daysBetweenViewsLabel;

  /// Description for days between views input for feed decorators
  ///
  /// In en, this message translates to:
  /// **'This setting determines the minimum number of days that must pass before a decorator can be shown again to a user, provided the associated task has not yet been completed.'**
  String get daysBetweenViewsDescription;

  /// Localized name for FeedDecoratorType.linkAccount
  ///
  /// In en, this message translates to:
  /// **'Link Account'**
  String get feedDecoratorTypeLinkAccount;

  /// Localized name for FeedDecoratorType.upgrade
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get feedDecoratorTypeUpgrade;

  /// Localized name for FeedDecoratorType.rateApp
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get feedDecoratorTypeRateApp;

  /// Localized name for FeedDecoratorType.enableNotifications
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get feedDecoratorTypeEnableNotifications;

  /// Localized name for FeedDecoratorType.suggestedTopics
  ///
  /// In en, this message translates to:
  /// **'Suggested Topics'**
  String get feedDecoratorTypeSuggestedTopics;

  /// Localized name for FeedDecoratorType.suggestedSources
  ///
  /// In en, this message translates to:
  /// **'Suggested Sources'**
  String get feedDecoratorTypeSuggestedSources;

  /// Localized name for AppUserRole.guestUser
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUserRole;

  /// Localized name for AppUserRole.standardUser
  ///
  /// In en, this message translates to:
  /// **'Standard User'**
  String get standardUserRole;

  /// Localized name for AppUserRole.premiumUser
  ///
  /// In en, this message translates to:
  /// **'Premium User'**
  String get premiumUserRole;

  /// Title for the main dashboard app bar
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// Tooltip for the clear selection button in a dropdown
  ///
  /// In en, this message translates to:
  /// **'Clear Selection'**
  String get clearSelection;

  /// Label for the search input field
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Message when no search results are found
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResultsFound;

  /// Button text to close a modal or overlay
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Button text to apply changes or selections
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Label for checkbox to control visibility of a decorator for a specific role
  ///
  /// In en, this message translates to:
  /// **'Visible to {roleName}'**
  String visibleToRoleLabel(String roleName);

  /// Title for the Ad Platform Configuration section
  ///
  /// In en, this message translates to:
  /// **'Ad Platform Configuration'**
  String get adPlatformConfigurationTitle;

  /// Title for the Primary Ad Platform Selection section
  ///
  /// In en, this message translates to:
  /// **'Primary Ad Platform'**
  String get primaryAdPlatformTitle;

  /// Description for the Primary Ad Platform Selection section
  ///
  /// In en, this message translates to:
  /// **'Choose the primary ad platform to be used across the application.'**
  String get primaryAdPlatformDescription;

  /// Title for the Ad Unit Identifiers section
  ///
  /// In en, this message translates to:
  /// **'Ad Unit Identifiers'**
  String get adUnitIdentifiersTitle;

  /// Description for the Ad Unit Identifiers section
  ///
  /// In en, this message translates to:
  /// **'Configure the ad unit IDs for the selected ad platform.'**
  String get adUnitIdentifiersDescription;

  /// Title for the Feed Ad Settings section
  ///
  /// In en, this message translates to:
  /// **'Feed Ad Settings'**
  String get feedAdSettingsTitle;

  /// Label for the enable feed ads switch
  ///
  /// In en, this message translates to:
  /// **'Enable Feed Ads'**
  String get enableFeedAdsLabel;

  /// Title for the Feed Ad Type Selection section
  ///
  /// In en, this message translates to:
  /// **'Feed Ad Type Selection'**
  String get feedAdTypeSelectionTitle;

  /// Description for the Feed Ad Type Selection section
  ///
  /// In en, this message translates to:
  /// **'Choose the type of ads to display in the main feed (Native or Banner).'**
  String get feedAdTypeSelectionDescription;

  /// Title for the User Role Frequency Settings section
  ///
  /// In en, this message translates to:
  /// **'User Role Frequency Settings'**
  String get userRoleFrequencySettingsTitle;

  /// Description for the User Role Frequency Settings section
  ///
  /// In en, this message translates to:
  /// **'Configure ad frequency and placement intervals based on user roles.'**
  String get userRoleFrequencySettingsDescription;

  /// Title for the Article Ad Settings section
  ///
  /// In en, this message translates to:
  /// **'Article Ad Settings'**
  String get articleAdSettingsTitle;

  /// Label for the enable article ads switch
  ///
  /// In en, this message translates to:
  /// **'Enable Article Ads'**
  String get enableArticleAdsLabel;

  /// Title for the Default In-Article Ad Type Selection section
  ///
  /// In en, this message translates to:
  /// **'Default In-Article Ad Type Selection'**
  String get defaultInArticleAdTypeSelectionTitle;

  /// Description for the Default In-Article Ad Type Selection section
  ///
  /// In en, this message translates to:
  /// **'Choose the default type of ads to display within articles (Native or Banner).'**
  String get defaultInArticleAdTypeSelectionDescription;

  /// Title for the In-Article Ad Slot Placements section
  ///
  /// In en, this message translates to:
  /// **'In-Article Ad Slot Placements'**
  String get inArticleAdSlotPlacementsTitle;

  /// Description for the In-Article Ad Slot Placements section
  ///
  /// In en, this message translates to:
  /// **'Enable or disable specific ad slots within article content.'**
  String get inArticleAdSlotPlacementsDescription;

  /// Label for the Feed Native Ad ID input field
  ///
  /// In en, this message translates to:
  /// **'Feed Native Ad ID'**
  String get feedNativeAdIdLabel;

  /// Description for the Feed Native Ad ID input field
  ///
  /// In en, this message translates to:
  /// **'The unit ID for native ads in the feed.'**
  String get feedNativeAdIdDescription;

  /// Label for the Feed Banner Ad ID input field
  ///
  /// In en, this message translates to:
  /// **'Feed Banner Ad ID'**
  String get feedBannerAdIdLabel;

  /// Description for the Feed Banner Ad ID input field
  ///
  /// In en, this message translates to:
  /// **'The unit ID for banner ads in the feed.'**
  String get feedBannerAdIdDescription;

  /// Label for the Article Interstitial Ad ID input field
  ///
  /// In en, this message translates to:
  /// **'Article Interstitial Ad ID'**
  String get articleInterstitialAdIdLabel;

  /// Description for the Article Interstitial Ad ID input field
  ///
  /// In en, this message translates to:
  /// **'The unit ID for interstitial ads in articles.'**
  String get articleInterstitialAdIdDescription;

  /// Label for the In-Article Native Ad ID input field
  ///
  /// In en, this message translates to:
  /// **'In-Article Native Ad ID'**
  String get inArticleNativeAdIdLabel;

  /// Description for the In-Article Native Ad ID input field
  ///
  /// In en, this message translates to:
  /// **'The unit ID for native ads within articles.'**
  String get inArticleNativeAdIdDescription;

  /// Label for the In-Article Banner Ad ID input field
  ///
  /// In en, this message translates to:
  /// **'In-Article Banner Ad ID'**
  String get inArticleBannerAdIdLabel;

  /// Description for the In-Article Banner Ad ID input field
  ///
  /// In en, this message translates to:
  /// **'The unit ID for banner ads within articles.'**
  String get inArticleBannerAdIdDescription;

  /// Localized name for InArticleAdSlotType.aboveArticleContinueReadingButton
  ///
  /// In en, this message translates to:
  /// **'Above the \'Continue Reading\' button'**
  String get inArticleAdSlotTypeAboveArticleContinueReadingButton;

  /// Localized name for InArticleAdSlotType.belowArticleContinueReadingButton
  ///
  /// In en, this message translates to:
  /// **'Below the \'Continue Reading\' button'**
  String get inArticleAdSlotTypeBelowArticleContinueReadingButton;

  /// Snackbar message when an ID is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'ID \'{id}\' copied to clipboard.'**
  String idCopiedToClipboard(String id);

  /// Tooltip for the copy ID button.
  ///
  /// In en, this message translates to:
  /// **'Copy ID'**
  String get copyId;

  /// Label for the switch to enable or disable all ads globally.
  ///
  /// In en, this message translates to:
  /// **'Enable Ads'**
  String get enableGlobalAdsLabel;

  /// Label for the ad unit ID for interstitial ads shown when transitioning from feed to article.
  ///
  /// In en, this message translates to:
  /// **'Feed to Article Interstitial Ad ID'**
  String get feedToArticleInterstitialAdIdLabel;

  /// Description for the ad unit ID for interstitial ads shown when transitioning from feed to article.
  ///
  /// In en, this message translates to:
  /// **'The ad unit ID for interstitial ads displayed when a user navigates from a feed to an article.'**
  String get feedToArticleInterstitialAdIdDescription;

  /// Title for the section configuring global interstitial ad settings.
  ///
  /// In en, this message translates to:
  /// **'Interstitial Ad Settings'**
  String get interstitialAdSettingsTitle;

  /// Label for the switch to enable or disable interstitial ads.
  ///
  /// In en, this message translates to:
  /// **'Enable Interstitial Ads'**
  String get enableInterstitialAdsLabel;

  /// Title for the section configuring interstitial ad frequency based on user roles.
  ///
  /// In en, this message translates to:
  /// **'Interstitial Ad Frequency by User Role'**
  String get userRoleInterstitialFrequencyTitle;

  /// Description for the interstitial ad frequency settings by user role.
  ///
  /// In en, this message translates to:
  /// **'Configure how many transitions a user must make before an interstitial ad is shown, based on their role.'**
  String get userRoleInterstitialFrequencyDescription;

  /// Label for the number of transitions a user must make before an interstitial ad is shown.
  ///
  /// In en, this message translates to:
  /// **'Transitions Before Interstitial Ads'**
  String get transitionsBeforeInterstitialAdsLabel;

  /// Description for the number of transitions a user must make before an interstitial ad is shown.
  ///
  /// In en, this message translates to:
  /// **'The number of transitions (e.g., opening articles) a user must make before an interstitial ad is displayed.'**
  String get transitionsBeforeInterstitialAdsDescription;

  /// The name of the AdMob ad platform.
  ///
  /// In en, this message translates to:
  /// **'AdMob'**
  String get adPlatformTypeAdmob;

  /// Tab title for Native Ads in local ads management.
  ///
  /// In en, this message translates to:
  /// **'Native Ads'**
  String get nativeAdsTab;

  /// Tab title for Banner Ads in local ads management.
  ///
  /// In en, this message translates to:
  /// **'Banner Ads'**
  String get bannerAdsTab;

  /// Tab title for Interstitial Ads in local ads management.
  ///
  /// In en, this message translates to:
  /// **'Interstitial Ads'**
  String get interstitialAdsTab;

  /// Tab title for Video Ads in local ads management.
  ///
  /// In en, this message translates to:
  /// **'Video Ads'**
  String get videoAdsTab;

  /// Label for Banner Ad Type.
  ///
  /// In en, this message translates to:
  /// **'Banner'**
  String get bannerAdType;

  /// Label for Native Ad Type.
  ///
  /// In en, this message translates to:
  /// **'Native'**
  String get nativeAdType;

  /// Label for Interstitial Ad Type.
  ///
  /// In en, this message translates to:
  /// **'Interstitial'**
  String get interstitialAdType;

  /// Label for Video Ad Type.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get videoAdType;

  /// Title for the Banner Ad Shape Selection section
  ///
  /// In en, this message translates to:
  /// **'Banner Ad Shape'**
  String get bannerAdShapeSelectionTitle;

  /// Description for the Banner Ad Shape Selection section
  ///
  /// In en, this message translates to:
  /// **'Select the preferred visual shape for banner ads displayed in articles.'**
  String get bannerAdShapeSelectionDescription;

  /// Label for the Square banner ad shape option
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get bannerAdShapeSquare;

  /// Label for the Rectangle banner ad shape option
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get bannerAdShapeRectangle;

  /// Text displayed when draft headlines are being loaded.
  ///
  /// In en, this message translates to:
  /// **'Loading Draft Headlines'**
  String get loadingDraftHeadlines;

  /// Text displayed when no draft headlines are available.
  ///
  /// In en, this message translates to:
  /// **'No Draft Headlines Found'**
  String get noDraftHeadlinesFound;

  /// Button text to publish a headline (either new, edited, or from drafts).
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// Button text to save a headline as a draft.
  ///
  /// In en, this message translates to:
  /// **'Save as Draft'**
  String get saveAsDraft;

  /// Title for the dialog shown when a form is invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid Form'**
  String get invalidFormTitle;

  /// Message for the dialog shown when a form is invalid.
  ///
  /// In en, this message translates to:
  /// **'Please complete all required fields before publishing. You can save as a draft or discard your changes.'**
  String get invalidFormMessage;

  /// Button text in the invalid form dialog to return to the form.
  ///
  /// In en, this message translates to:
  /// **'Complete Form'**
  String get completeForm;

  /// Button text in the invalid form dialog to discard changes.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// Label for the 'Drafts' tab in content management.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get drafts;

  /// Tooltip for the drafts icon button in the AppBar
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get draftsIconTooltip;

  /// Title for the Draft Headlines page
  ///
  /// In en, this message translates to:
  /// **'Draft Headlines'**
  String get draftHeadlines;

  /// Title for the Draft Topics page
  ///
  /// In en, this message translates to:
  /// **'Draft Topics'**
  String get draftTopics;

  /// Title for the Draft Sources page
  ///
  /// In en, this message translates to:
  /// **'Draft Sources'**
  String get draftSources;

  /// Title for the dialog asking how to save a headline.
  ///
  /// In en, this message translates to:
  /// **'Save Headline'**
  String get saveHeadlineTitle;

  /// Message for the dialog asking how to save a headline.
  ///
  /// In en, this message translates to:
  /// **'Do you want to publish this headline or save it as a draft?'**
  String get saveHeadlineMessage;

  /// Title for the dialog asking how to save a topic.
  ///
  /// In en, this message translates to:
  /// **'Save Topic'**
  String get saveTopicTitle;

  /// Message for the dialog asking how to save a topic.
  ///
  /// In en, this message translates to:
  /// **'Do you want to publish this topic or save it as a draft?'**
  String get saveTopicMessage;

  /// Title for the dialog asking how to save a source.
  ///
  /// In en, this message translates to:
  /// **'Save Source'**
  String get saveSourceTitle;

  /// Message for the dialog asking how to save a source.
  ///
  /// In en, this message translates to:
  /// **'Do you want to publish this source or save it as a draft?'**
  String get saveSourceMessage;

  /// Message displayed when draft topics are being loaded.
  ///
  /// In en, this message translates to:
  /// **'Loading Draft Topics...'**
  String get loadingDraftTopics;

  /// Message displayed when no draft topics are available.
  ///
  /// In en, this message translates to:
  /// **'No draft topics found.'**
  String get noDraftTopicsFound;

  /// Snackbar message when a topic is deleted.
  ///
  /// In en, this message translates to:
  /// **'Topic \"{topicTitle}\" deleted.'**
  String topicDeleted(String topicTitle);

  /// Message displayed when draft sources are being loaded.
  ///
  /// In en, this message translates to:
  /// **'Loading Draft Sources...'**
  String get loadingDraftSources;

  /// Message displayed when no draft sources are available.
  ///
  /// In en, this message translates to:
  /// **'No draft sources found.'**
  String get noDraftSourcesFound;

  /// Snackbar message when a source is deleted.
  ///
  /// In en, this message translates to:
  /// **'Source \"{sourceName}\" deleted.'**
  String sourceDeleted(String sourceName);

  /// Tooltip for the publish topic button.
  ///
  /// In en, this message translates to:
  /// **'Publish Topic'**
  String get publishTopic;

  /// Tooltip for the publish source button.
  ///
  /// In en, this message translates to:
  /// **'Publish Source'**
  String get publishSource;

  /// Label for a checkbox to enable/disable in-article ads for a specific user role.
  ///
  /// In en, this message translates to:
  /// **'Enable In-Article Ads for {role}'**
  String enableInArticleAdsForRoleLabel(String role);

  /// Tooltip for the button that opens a menu with more actions for a table row.
  ///
  /// In en, this message translates to:
  /// **'More Actions'**
  String get moreActions;

  /// Tooltip for the filter icon button.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Text for the button to apply filters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// Title for the filter dialog when filtering headlines.
  ///
  /// In en, this message translates to:
  /// **'Filter Headlines'**
  String get filterHeadlines;

  /// Title for the filter dialog when filtering topics.
  ///
  /// In en, this message translates to:
  /// **'Filter Topics'**
  String get filterTopics;

  /// Title for the filter dialog when filtering sources.
  ///
  /// In en, this message translates to:
  /// **'Filter Sources'**
  String get filterSources;

  /// Hint text for the headline search field.
  ///
  /// In en, this message translates to:
  /// **'Search by headline title...'**
  String get searchByHeadlineTitle;

  /// Hint text for the topic search field.
  ///
  /// In en, this message translates to:
  /// **'Search by Name or ID...'**
  String get searchByTopicName;

  /// Hint text for the source search field.
  ///
  /// In en, this message translates to:
  /// **'Search by Name or ID...'**
  String get searchBySourceName;

  /// Hint text for selecting sources in a filter dialog.
  ///
  /// In en, this message translates to:
  /// **'Select Sources'**
  String get selectSources;

  /// Hint text for selecting topics in a filter dialog.
  ///
  /// In en, this message translates to:
  /// **'Select Topics'**
  String get selectTopics;

  /// Label for countries filter.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get countries;

  /// Hint text for selecting countries in a filter dialog.
  ///
  /// In en, this message translates to:
  /// **'Select Countries'**
  String get selectCountries;

  /// Hint text for selecting source types in a filter dialog.
  ///
  /// In en, this message translates to:
  /// **'Select Source Types'**
  String get selectSourceTypes;

  /// Hint text for selecting languages in a filter dialog.
  ///
  /// In en, this message translates to:
  /// **'Select Languages'**
  String get selectLanguages;

  /// Hint text for selecting headquarters in a filter dialog.
  ///
  /// In en, this message translates to:
  /// **'Select Headquarters'**
  String get selectHeadquarters;

  /// Text for the button to reset filters to their default state.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get resetFiltersButtonText;

  /// Message displayed when no results are found due to active filters, prompting the user to reset them.
  ///
  /// In en, this message translates to:
  /// **'No results found with current filters. Try resetting them.'**
  String get noResultsWithCurrentFilters;

  /// Tooltip for the information icon that shows page description.
  ///
  /// In en, this message translates to:
  /// **'About this page'**
  String get aboutIconTooltip;

  /// Text for the close button in a dialog.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButtonText;

  /// Label for the source logo URL input field
  ///
  /// In en, this message translates to:
  /// **'Logo URL'**
  String get logoUrl;

  /// Label for the user management navigation item
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// Description for the User Management page
  ///
  /// In en, this message translates to:
  /// **'Manage system users, including their roles and permissions.'**
  String get userManagementPageDescription;

  /// Headline for loading state of users
  ///
  /// In en, this message translates to:
  /// **'Loading Users'**
  String get loadingUsers;

  /// Message when no users are found
  ///
  /// In en, this message translates to:
  /// **'No users found.'**
  String get noUsersFound;

  /// Column header for user email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Column header for user app role
  ///
  /// In en, this message translates to:
  /// **'App Role'**
  String get appRole;

  /// Column header for user dashboard role
  ///
  /// In en, this message translates to:
  /// **'Dashboard Role'**
  String get dashboardRole;

  /// Column header for creation date
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// Action to promote a user to a publisher role.
  ///
  /// In en, this message translates to:
  /// **'Promote to Publisher'**
  String get promoteToPublisher;

  /// Action to demote a publisher back to a standard user role.
  ///
  /// In en, this message translates to:
  /// **'Demote to User'**
  String get demoteToUser;

  /// Localized name for DashboardUserRole.admin
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminRole;

  /// Localized name for DashboardUserRole.publisher
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get publisherRole;

  /// Title for the filter dialog when filtering users.
  ///
  /// In en, this message translates to:
  /// **'Filter Users'**
  String get filterUsers;

  /// Hint text for the user search field.
  ///
  /// In en, this message translates to:
  /// **'Search by Email or ID...'**
  String get searchByUserEmail;

  /// Hint text for selecting app roles in a filter dialog.
  ///
  /// In en, this message translates to:
  /// **'Select App Roles'**
  String get selectAppRoles;

  /// Hint text for selecting dashboard roles in a filter dialog.
  ///
  /// In en, this message translates to:
  /// **'Select Dashboard Roles'**
  String get selectDashboardRoles;

  /// Column header for authentication status
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// Column header for subscription status
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// Authentication status for a guest user
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get authenticationAnonymous;

  /// Authentication status for a signed-in user
  ///
  /// In en, this message translates to:
  /// **'Authenticated'**
  String get authenticationAuthenticated;

  /// Subscription status for a free user
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get subscriptionFree;

  /// Subscription status for a premium user
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get subscriptionPremium;

  /// Title for the Saved Headline Filter Limits section
  ///
  /// In en, this message translates to:
  /// **'Saved Headline Filter Limits'**
  String get savedHeadlineFilterLimitsTitle;

  /// Description for the Saved Headline Filter Limits section
  ///
  /// In en, this message translates to:
  /// **'Set limits on the number of saved headline filters for each user tier, including total, pinned, and notification subscriptions.'**
  String get savedHeadlineFilterLimitsDescription;

  /// Title for the Saved Source Filter Limits section
  ///
  /// In en, this message translates to:
  /// **'Saved Source Filter Limits'**
  String get savedSourceFilterLimitsTitle;

  /// Description for the Saved Source Filter Limits section
  ///
  /// In en, this message translates to:
  /// **'Set limits on the number of saved source filters for each user tier, including total and pinned.'**
  String get savedSourceFilterLimitsDescription;

  /// Label for the total limit of a filter type
  ///
  /// In en, this message translates to:
  /// **'Total Limit'**
  String get totalLimitLabel;

  /// Description for the total limit of a filter type
  ///
  /// In en, this message translates to:
  /// **'The total number of filters of this type a user can create.'**
  String get totalLimitDescription;

  /// Label for the pinned limit of a filter type
  ///
  /// In en, this message translates to:
  /// **'Pinned Limit'**
  String get pinnedLimitLabel;

  /// Description for the pinned limit of a filter type
  ///
  /// In en, this message translates to:
  /// **'The maximum number of filters of this type that can be pinned.'**
  String get pinnedLimitDescription;

  /// Label for the notification subscription limit of a filter type
  ///
  /// In en, this message translates to:
  /// **'Notification Subscription Limit'**
  String get notificationSubscriptionLimitLabel;

  /// Description for the notification subscription limit of a filter type
  ///
  /// In en, this message translates to:
  /// **'The maximum number of filters a user can subscribe to for this notification type.'**
  String get notificationSubscriptionLimitDescription;

  /// Label for the 'breaking only' push notification delivery type
  ///
  /// In en, this message translates to:
  /// **'Breaking News'**
  String get pushNotificationSubscriptionDeliveryTypeBreakingOnly;

  /// Label for the 'daily digest' push notification delivery type
  ///
  /// In en, this message translates to:
  /// **'Daily Digest'**
  String get pushNotificationSubscriptionDeliveryTypeDailyDigest;

  /// Label for the 'weekly roundup' push notification delivery type
  ///
  /// In en, this message translates to:
  /// **'Weekly Roundup'**
  String get pushNotificationSubscriptionDeliveryTypeWeeklyRoundup;

  /// Label for the switch to mark a headline as breaking news
  ///
  /// In en, this message translates to:
  /// **'Mark as Breaking News'**
  String get isBreakingNewsLabel;

  /// Description for the breaking news switch on the create page
  ///
  /// In en, this message translates to:
  /// **'Enabling this will send an immediate push notification to all subscribed users upon publication.'**
  String get isBreakingNewsDescription;

  /// Description for the breaking news switch on the edit page
  ///
  /// In en, this message translates to:
  /// **'Changing this status during an edit will NOT trigger a new push notification, as notifications are only sent on initial creation.'**
  String get isBreakingNewsDescriptionEdit;

  /// Title for the confirmation dialog when publishing breaking news
  ///
  /// In en, this message translates to:
  /// **'Confirm Breaking News Publication'**
  String get confirmBreakingNewsTitle;

  /// Message for the confirmation dialog when publishing breaking news
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to publish this as breaking news? This action will send an immediate push notification to all subscribed users.'**
  String get confirmBreakingNewsMessage;

  /// Text for the button to confirm publishing breaking news
  ///
  /// In en, this message translates to:
  /// **'Confirm & Publish'**
  String get confirmPublishButton;

  /// Error message shown when a user tries to save a breaking news article as a draft.
  ///
  /// In en, this message translates to:
  /// **'Breaking news cannot be saved as a draft. Please publish it or disable the \'Breaking News\' toggle.'**
  String get cannotDraftBreakingNews;

  /// A common 'OK' button text.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Title for the breaking news filter section in the filter dialog.
  ///
  /// In en, this message translates to:
  /// **'Breaking News'**
  String get breakingNewsFilterTitle;

  /// Label for the 'All' choice chip in the breaking news filter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get breakingNewsFilterAll;

  /// Label for the 'Breaking Only' choice chip in the breaking news filter.
  ///
  /// In en, this message translates to:
  /// **'Breaking Only'**
  String get breakingNewsFilterBreakingOnly;

  /// Label for the 'Non-Breaking Only' choice chip in the breaking news filter.
  ///
  /// In en, this message translates to:
  /// **'Non-Breaking Only'**
  String get breakingNewsFilterNonBreakingOnly;

  /// Tab title for Notifications settings
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTab;

  /// Title for the Push Notification Settings section
  ///
  /// In en, this message translates to:
  /// **'Push Notification Settings'**
  String get pushNotificationSettingsTitle;

  /// Description for the Push Notification Settings section
  ///
  /// In en, this message translates to:
  /// **'Manage global settings for the push notification system, including the primary provider and which notification types are active.'**
  String get pushNotificationSettingsDescription;

  /// Title for the Push Notification System status section
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get pushNotificationSystemStatusTitle;

  /// Description for the Push Notification System status section
  ///
  /// In en, this message translates to:
  /// **'A global switch to enable or disable all push notifications.'**
  String get pushNotificationSystemStatusDescription;

  /// Title for the Push Notification Primary Provider section
  ///
  /// In en, this message translates to:
  /// **'Primary Provider'**
  String get pushNotificationPrimaryProviderTitle;

  /// Description for the Push Notification Primary Provider section
  ///
  /// In en, this message translates to:
  /// **'Select the primary service provider. Ensure the chosen provider is correctly configured in your backend\'s .env file as per the documentation.'**
  String get pushNotificationPrimaryProviderDescription;

  /// Title for the Push Notification Delivery Types section
  ///
  /// In en, this message translates to:
  /// **'Delivery Types'**
  String get pushNotificationDeliveryTypesTitle;

  /// Description for the Push Notification Delivery Types section
  ///
  /// In en, this message translates to:
  /// **'Globally enable or disable specific types of push notifications.'**
  String get pushNotificationDeliveryTypesDescription;

  /// Label for the Firebase push notification provider
  ///
  /// In en, this message translates to:
  /// **'Firebase'**
  String get pushNotificationProviderFirebase;

  /// Label for the OneSignal push notification provider
  ///
  /// In en, this message translates to:
  /// **'OneSignal'**
  String get pushNotificationProviderOneSignal;

  /// Tab title for global App settings.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get appTab;

  /// Tab title for Features settings (Ads, Notifications, etc.).
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get featuresTab;

  /// Tab title for User-specific settings and limits.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userTab;

  /// Title for the Maintenance Mode configuration section.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Mode'**
  String get maintenanceConfigTitle;

  /// Description for the Maintenance Mode configuration section.
  ///
  /// In en, this message translates to:
  /// **'Enable to put the app into maintenance mode, preventing user access.'**
  String get maintenanceConfigDescription;

  /// Title for the App Update configuration section.
  ///
  /// In en, this message translates to:
  /// **'Update Settings'**
  String get updateConfigTitle;

  /// Description for the App Update configuration section.
  ///
  /// In en, this message translates to:
  /// **'Configure mandatory app updates for users.'**
  String get updateConfigDescription;

  /// Title for the General App Settings configuration section.
  ///
  /// In en, this message translates to:
  /// **'General App Settings'**
  String get generalAppConfigTitle;

  /// Description for the General App Settings configuration section.
  ///
  /// In en, this message translates to:
  /// **'Manage general application settings like Terms of Service and Privacy Policy URLs.'**
  String get generalAppConfigDescription;

  /// Label for the Terms of Service URL input field.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service URL'**
  String get termsOfServiceUrlLabel;

  /// Description for the Terms of Service URL input field.
  ///
  /// In en, this message translates to:
  /// **'The URL for the application\'s Terms of Service page.'**
  String get termsOfServiceUrlDescription;

  /// Label for the Privacy Policy URL input field.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy URL'**
  String get privacyPolicyUrlLabel;

  /// Description for the Privacy Policy URL input field.
  ///
  /// In en, this message translates to:
  /// **'The URL for the application\'s Privacy Policy page.'**
  String get privacyPolicyUrlDescription;

  /// Title for the Navigation (Interstitial) Ad Settings section.
  ///
  /// In en, this message translates to:
  /// **'Navigation Ad Settings'**
  String get navigationAdConfigTitle;

  /// Label for the switch to enable navigation ads.
  ///
  /// In en, this message translates to:
  /// **'Enable Navigation Ads'**
  String get enableNavigationAdsLabel;

  /// Title for the Navigation Ad Frequency settings section.
  ///
  /// In en, this message translates to:
  /// **'Navigation Ad Frequency'**
  String get navigationAdFrequencyTitle;

  /// Description for the Navigation Ad Frequency settings section.
  ///
  /// In en, this message translates to:
  /// **'Configure how many transitions a user must make before an interstitial ad is shown, based on their role.'**
  String get navigationAdFrequencyDescription;

  /// Label for the number of internal navigations before showing an ad.
  ///
  /// In en, this message translates to:
  /// **'Internal Navigations Before Ad'**
  String get internalNavigationsBeforeAdLabel;

  /// Description for the internal navigations before ad setting.
  ///
  /// In en, this message translates to:
  /// **'The number of internal page-to-page navigations a user must make before an interstitial ad is displayed.'**
  String get internalNavigationsBeforeAdDescription;

  /// Label for the number of external navigations before showing an ad.
  ///
  /// In en, this message translates to:
  /// **'External Navigations Before Ad'**
  String get externalNavigationsBeforeAdLabel;

  /// Description for the external navigations before ad setting.
  ///
  /// In en, this message translates to:
  /// **'The number of external navigations a user must make before an interstitial ad is displayed.'**
  String get externalNavigationsBeforeAdDescription;

  /// Label for the Native Ad ID input field.
  ///
  /// In en, this message translates to:
  /// **'Native Ad ID'**
  String get nativeAdIdLabel;

  /// Description for the Native Ad ID input field.
  ///
  /// In en, this message translates to:
  /// **'The unit ID for native ads.'**
  String get nativeAdIdDescription;

  /// Label for the Banner Ad ID input field.
  ///
  /// In en, this message translates to:
  /// **'Banner Ad ID'**
  String get bannerAdIdLabel;

  /// Description for the Banner Ad ID input field.
  ///
  /// In en, this message translates to:
  /// **'The unit ID for banner ads.'**
  String get bannerAdIdDescription;

  /// Label for the Interstitial Ad ID input field.
  ///
  /// In en, this message translates to:
  /// **'Interstitial Ad ID'**
  String get interstitialAdIdLabel;

  /// Description for the Interstitial Ad ID input field.
  ///
  /// In en, this message translates to:
  /// **'The unit ID for interstitial ads.'**
  String get interstitialAdIdDescription;

  /// Label for Saved Headlines Limit
  ///
  /// In en, this message translates to:
  /// **'Saved Headlines Limit'**
  String get savedHeadlinesLimitLabel;

  /// Description for Saved Headlines Limit
  ///
  /// In en, this message translates to:
  /// **'Maximum number of headlines this user role can save.'**
  String get savedHeadlinesLimitDescription;

  /// Title for the Application Update Management expansion tile.
  ///
  /// In en, this message translates to:
  /// **'Application Update Management'**
  String get appUpdateManagementTitle;

  /// Title for the feed item click behavior setting.
  ///
  /// In en, this message translates to:
  /// **'Feed Item Click Behavior'**
  String get feedItemClickBehaviorTitle;

  /// Description for the feed item click behavior setting.
  ///
  /// In en, this message translates to:
  /// **'Select which browser opens when a user taps on a headline in the feed.'**
  String get feedItemClickBehaviorDescription;

  /// Option for opening links in the app's internal browser.
  ///
  /// In en, this message translates to:
  /// **'In-App Browser'**
  String get feedItemClickBehaviorInternalNavigation;

  /// Option for opening links in the device's default system browser.
  ///
  /// In en, this message translates to:
  /// **'System Browser'**
  String get feedItemClickBehaviorExternalNavigation;

  /// Title for the User Limits expansion tile.
  ///
  /// In en, this message translates to:
  /// **'User Limits'**
  String get userLimitsTitle;

  /// Description for the breaking news notification subscription limit.
  ///
  /// In en, this message translates to:
  /// **'Limit for subscriptions that send immediate alerts for matching headlines.'**
  String get notificationSubscriptionBreakingOnlyDescription;

  /// Description for the daily digest notification subscription limit.
  ///
  /// In en, this message translates to:
  /// **'Limit for subscriptions that send a daily summary of matching headlines.'**
  String get notificationSubscriptionDailyDigestDescription;

  /// Description for the weekly roundup notification subscription limit.
  ///
  /// In en, this message translates to:
  /// **'Limit for subscriptions that send a weekly summary of matching headlines.'**
  String get notificationSubscriptionWeeklyRoundupDescription;

  /// Title for the App Status & Updates expansion tile.
  ///
  /// In en, this message translates to:
  /// **'App Status & Updates'**
  String get appStatusAndUpdatesTitle;

  /// Label for the switch to enable forced updates.
  ///
  /// In en, this message translates to:
  /// **'Enable Forced Updates'**
  String get enableForcedUpdatesLabel;

  /// Description for the switch to enable forced updates.
  ///
  /// In en, this message translates to:
  /// **'When enabled, you can specify a minimum required version for the mobile app.'**
  String get enableForcedUpdatesDescription;

  /// Title for the Application URLs expansion tile.
  ///
  /// In en, this message translates to:
  /// **'Application URLs'**
  String get appUrlsTitle;

  /// Description for the Application URLs expansion tile.
  ///
  /// In en, this message translates to:
  /// **'Manage external and internal URLs used within the application.'**
  String get appUrlsDescription;

  /// Title for the Community & Engagement expansion tile.
  ///
  /// In en, this message translates to:
  /// **'Community & Engagement'**
  String get communityAndEngagementTitle;

  /// Description for the Community & Engagement expansion tile.
  ///
  /// In en, this message translates to:
  /// **'Manage user interactions, content reporting, and the internal app reporting system.'**
  String get communityAndEngagementDescription;

  /// Title for the User Engagement expansion tile.
  ///
  /// In en, this message translates to:
  /// **'User Engagement'**
  String get userEngagementTitle;

  /// Description for the User Engagement expansion tile.
  ///
  /// In en, this message translates to:
  /// **'Configure reactions and comments.'**
  String get userEngagementDescription;

  /// Title for the Content Reporting expansion tile.
  ///
  /// In en, this message translates to:
  /// **'Content Reporting'**
  String get contentReportingTitle;

  /// Description for the Content Reporting expansion tile.
  ///
  /// In en, this message translates to:
  /// **'Set rules for what users can report.'**
  String get contentReportingDescription;

  /// Title for the App Review Funnel expansion tile.
  ///
  /// In en, this message translates to:
  /// **'App Reviews'**
  String get appReviewFunnelTitle;

  /// Description for the App Feedback Funnel expansion tile.
  ///
  /// In en, this message translates to:
  /// **'Manage the process for capturing user satisfaction and optionally requesting reviews.'**
  String get appReviewFunnelDescription;

  /// Label for the master switch to enable all engagement features.
  ///
  /// In en, this message translates to:
  /// **'Enable Engagement Features'**
  String get enableEngagementFeaturesLabel;

  /// Description for the master switch to enable all engagement features.
  ///
  /// In en, this message translates to:
  /// **'Globally activates or deactivates all reaction and comment functionality.'**
  String get enableEngagementFeaturesDescription;

  /// Label for the engagement mode segmented button.
  ///
  /// In en, this message translates to:
  /// **'Engagement Mode'**
  String get engagementModeLabel;

  /// Description for the engagement mode segmented button.
  ///
  /// In en, this message translates to:
  /// **'Determines if users can only react or also add comments to content.'**
  String get engagementModeDescription;

  /// Label for the 'Reactions Only' engagement mode.
  ///
  /// In en, this message translates to:
  /// **'Reactions Only'**
  String get engagementModeReactionsOnly;

  /// Label for the 'Reactions & Comments' engagement mode.
  ///
  /// In en, this message translates to:
  /// **'Reactions & Comments'**
  String get engagementModeReactionsAndComments;

  /// Label for the master switch to enable the reporting system.
  ///
  /// In en, this message translates to:
  /// **'Enable Reporting System'**
  String get enableReportingSystemLabel;

  /// Description for the master switch to enable the reporting system.
  ///
  /// In en, this message translates to:
  /// **'Globally activates or deactivates all user-facing reporting options.'**
  String get enableReportingSystemDescription;

  /// Label for the switch to enable headline reporting.
  ///
  /// In en, this message translates to:
  /// **'Enable Headline Reporting'**
  String get enableHeadlineReportingLabel;

  /// Label for the switch to enable source reporting.
  ///
  /// In en, this message translates to:
  /// **'Enable Source Reporting'**
  String get enableSourceReportingLabel;

  /// Label for the switch to enable comment reporting.
  ///
  /// In en, this message translates to:
  /// **'Enable Comment Reporting'**
  String get enableCommentReportingLabel;

  /// Label for the master switch to enable the app feedback system.
  ///
  /// In en, this message translates to:
  /// **'Enable App Feedback System'**
  String get enableAppFeedbackSystemLabel;

  /// Description for the master switch to enable the app feedback system.
  ///
  /// In en, this message translates to:
  /// **'Activates the internal system that periodically asks users if they are enjoying the app.'**
  String get enableAppFeedbackSystemDescription;

  /// Label for the interaction cycle threshold input field.
  ///
  /// In en, this message translates to:
  /// **'Interaction Cycle Threshold'**
  String get interactionCycleThresholdLabel;

  /// Description for the interaction cycle threshold input field.
  ///
  /// In en, this message translates to:
  /// **'Defines the number of positive actions (e.g., save, like) required to trigger the enjoyment prompt. The prompt is shown each time the user\'s total positive actions is a multiple of this number.'**
  String get interactionCycleThresholdDescription;

  /// Label for the initial prompt cooldown input field.
  ///
  /// In en, this message translates to:
  /// **'Initial Prompt Cooldown (Days)'**
  String get initialPromptCooldownLabel;

  /// Description for the initial prompt cooldown input field.
  ///
  /// In en, this message translates to:
  /// **'The number of days to wait before showing the enjoyment prompt for the first time, This cooldown ensures users are not asked until they used the app enough.'**
  String get initialPromptCooldownDescription;

  /// Label for the switch to request a store review after positive feedback.
  ///
  /// In en, this message translates to:
  /// **'Request Store Review After \'Yes\''**
  String get requestStoreReviewLabel;

  /// Description for the switch to request a store review after positive feedback.
  ///
  /// In en, this message translates to:
  /// **'If enabled, users who respond \'Yes\' to the enjoyment prompt will be shown the official OS store review dialog.'**
  String get requestStoreReviewDescription;

  /// Label for the switch to request written feedback after a negative response.
  ///
  /// In en, this message translates to:
  /// **'Request Written Feedback After \'No\''**
  String get requestWrittenFeedbackLabel;

  /// Description for the switch to request written feedback after a negative response.
  ///
  /// In en, this message translates to:
  /// **'If enabled, users who respond \'No\' will be prompted to provide written feedback directly to the team.'**
  String get requestWrittenFeedbackDescription;

  /// Title for the nested expansion tile for internal app review prompt settings.
  ///
  /// In en, this message translates to:
  /// **'Internal Prompt Logic'**
  String get internalPromptLogicTitle;

  /// Title for the expansion tile for eligible positive interactions.
  ///
  /// In en, this message translates to:
  /// **'Eligible Positive Interactions'**
  String get eligiblePositiveInteractionsTitle;

  /// Label for the 'save item' positive interaction type.
  ///
  /// In en, this message translates to:
  /// **'Save a content item (e.g., a headline)'**
  String get positiveInteractionTypeSaveItem;

  /// Label for the 'follow item' positive interaction type.
  ///
  /// In en, this message translates to:
  /// **'Follow an entity (e.g., a topic, source, or country)'**
  String get positiveInteractionTypeFollowItem;

  /// Label for the 'share content' positive interaction type.
  ///
  /// In en, this message translates to:
  /// **'Share a content item (e.g., a headline)'**
  String get positiveInteractionTypeShareContent;

  /// Label for the 'save filter' positive interaction type.
  ///
  /// In en, this message translates to:
  /// **'Create a saved filter'**
  String get positiveInteractionTypeSaveFilter;

  /// Title for the nested expansion tile for app review follow-up actions.
  ///
  /// In en, this message translates to:
  /// **'Follow-up Actions'**
  String get followUpActionsTitle;

  /// Label for the master switch to enable all community features.
  ///
  /// In en, this message translates to:
  /// **'Enable Community Features'**
  String get enableCommunityFeaturesLabel;

  /// Description for the master switch to enable all community features.
  ///
  /// In en, this message translates to:
  /// **'Globally activates or deactivates all community-related functionality, including engagement and reporting.'**
  String get enableCommunityFeaturesDescription;

  /// Description for the Community Management page
  ///
  /// In en, this message translates to:
  /// **'Manage user-generated content including engagements (reactions and comments), content reports, and app reviews.'**
  String get communityManagementPageDescription;

  /// Label for the engagements subpage
  ///
  /// In en, this message translates to:
  /// **'Engagements'**
  String get engagements;

  /// Label for the reports subpage
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// Label for the app reviews subpage
  ///
  /// In en, this message translates to:
  /// **'App Reviews'**
  String get appReviews;

  /// Column header for user
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Column header for engaged content
  ///
  /// In en, this message translates to:
  /// **'Engaged Content'**
  String get engagedContent;

  /// Column header for reaction
  ///
  /// In en, this message translates to:
  /// **'Reaction'**
  String get reaction;

  /// Column header for comment
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// Column header for comment status
  ///
  /// In en, this message translates to:
  /// **'Comment Status'**
  String get commentStatus;

  /// Column header for date
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Action to approve a comment
  ///
  /// In en, this message translates to:
  /// **'Approve Comment'**
  String get approveComment;

  /// Action to reject a comment
  ///
  /// In en, this message translates to:
  /// **'Reject Comment'**
  String get rejectComment;

  /// Action to view the engaged content
  ///
  /// In en, this message translates to:
  /// **'View Content'**
  String get viewEngagedContent;

  /// Action to copy the user ID
  ///
  /// In en, this message translates to:
  /// **'Copy User ID'**
  String get copyUserId;

  /// Column header for reporter
  ///
  /// In en, this message translates to:
  /// **'Reporter'**
  String get reporter;

  /// Column header for reported item
  ///
  /// In en, this message translates to:
  /// **'Reported Item'**
  String get reportedItem;

  /// Column header for reason
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// Column header for report status
  ///
  /// In en, this message translates to:
  /// **'Report Status'**
  String get reportStatus;

  /// Action to view the reported item
  ///
  /// In en, this message translates to:
  /// **'View Item'**
  String get viewReportedItem;

  /// Action to mark a report as in review
  ///
  /// In en, this message translates to:
  /// **'Mark as In Review'**
  String get markAsInReview;

  /// Action to resolve a report
  ///
  /// In en, this message translates to:
  /// **'Resolve Report'**
  String get resolveReport;

  /// Column header for initial feedback
  ///
  /// In en, this message translates to:
  /// **'Initial Feedback'**
  String get initialFeedback;

  /// Column header for OS prompt requested
  ///
  /// In en, this message translates to:
  /// **'OS Prompt?'**
  String get osPromptRequested;

  /// Column header for feedback history
  ///
  /// In en, this message translates to:
  /// **'Feedback History'**
  String get feedbackHistory;

  /// Column header for last interaction
  ///
  /// In en, this message translates to:
  /// **'Last Interaction'**
  String get lastInteraction;

  /// Action to view feedback history
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewFeedbackHistory;

  /// Reaction type: Like
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get reactionTypeLike;

  /// Reaction type: Insightful
  ///
  /// In en, this message translates to:
  /// **'Insightful'**
  String get reactionTypeInsightful;

  /// Reaction type: Amusing
  ///
  /// In en, this message translates to:
  /// **'Amusing'**
  String get reactionTypeAmusing;

  /// Reaction type: Sad
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get reactionTypeSad;

  /// Reaction type: Angry
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get reactionTypeAngry;

  /// Reaction type: Skeptical
  ///
  /// In en, this message translates to:
  /// **'Skeptical'**
  String get reactionTypeSkeptical;

  /// Initial app review feedback: Positive
  ///
  /// In en, this message translates to:
  /// **'Positive'**
  String get initialAppReviewFeedbackPositive;

  /// Initial app review feedback: Negative
  ///
  /// In en, this message translates to:
  /// **'Negative'**
  String get initialAppReviewFeedbackNegative;

  /// Action to filter community content
  ///
  /// In en, this message translates to:
  /// **'Filter Community Content'**
  String get filterCommunity;

  /// Hint text for searching by engagement user
  ///
  /// In en, this message translates to:
  /// **'Search by user email...'**
  String get searchByEngagementUser;

  /// Hint text for searching by report reporter
  ///
  /// In en, this message translates to:
  /// **'Search by reporter email...'**
  String get searchByReportReporter;

  /// Hint text for searching by app review user
  ///
  /// In en, this message translates to:
  /// **'Search by user email...'**
  String get searchByAppReviewUser;

  /// Action to select comment status
  ///
  /// In en, this message translates to:
  /// **'Select Comment Status'**
  String get selectCommentStatus;

  /// Action to select report status
  ///
  /// In en, this message translates to:
  /// **'Select Report Status'**
  String get selectReportStatus;

  /// Action to select initial feedback
  ///
  /// In en, this message translates to:
  /// **'Select Initial Feedback'**
  String get selectInitialFeedback;

  /// Action to select reportable entity
  ///
  /// In en, this message translates to:
  /// **'Select Reported Item Type'**
  String get selectReportableEntity;

  /// Reportable entity: Headline
  ///
  /// In en, this message translates to:
  /// **'Headline'**
  String get reportableEntityHeadline;

  /// Reportable entity: Source
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get reportableEntitySource;

  /// Reportable entity: Comment
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get reportableEntityComment;

  /// Message when no engagements are found
  ///
  /// In en, this message translates to:
  /// **'No engagements found.'**
  String get noEngagementsFound;

  /// Message when no reports are found
  ///
  /// In en, this message translates to:
  /// **'No reports found.'**
  String get noReportsFound;

  /// Message when no app reviews are found
  ///
  /// In en, this message translates to:
  /// **'No app reviews found.'**
  String get noAppReviewsFound;

  /// Message when engagements are loading
  ///
  /// In en, this message translates to:
  /// **'Loading Engagements'**
  String get loadingEngagements;

  /// Message when reports are loading
  ///
  /// In en, this message translates to:
  /// **'Loading Reports'**
  String get loadingReports;

  /// Message when app reviews are loading
  ///
  /// In en, this message translates to:
  /// **'Loading App Reviews'**
  String get loadingAppReviews;

  /// Message when user ID is copied
  ///
  /// In en, this message translates to:
  /// **'User ID copied to clipboard.'**
  String get userIdCopied;

  /// Message when a report status is updated
  ///
  /// In en, this message translates to:
  /// **'Report status updated.'**
  String get reportStatusUpdated;

  /// Message displaying feedback history for a user
  ///
  /// In en, this message translates to:
  /// **'Feedback History for {email}'**
  String feedbackHistoryForUser(String email);

  /// Message when no feedback history is available
  ///
  /// In en, this message translates to:
  /// **'No feedback history available for this user.'**
  String get noFeedbackHistory;

  /// Message displaying the date feedback was provided
  ///
  /// In en, this message translates to:
  /// **'Feedback provided at: {date}'**
  String feedbackProvidedAt(String date);

  /// Message displaying the reason for feedback
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String feedbackReason(String reason);

  /// Message when no reason for feedback is provided
  ///
  /// In en, this message translates to:
  /// **'No reason provided.'**
  String get noReasonProvided;

  /// A generic 'Yes' response.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// A generic 'No' response.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Report reason: The content is misinformation or fake news.
  ///
  /// In en, this message translates to:
  /// **'Misinformation / Fake News'**
  String get reportReasonMisinformationOrFakeNews;

  /// Report reason: The headline is clickbait.
  ///
  /// In en, this message translates to:
  /// **'Clickbait Title'**
  String get reportReasonClickbaitTitle;

  /// Report reason: The content is offensive or hate speech.
  ///
  /// In en, this message translates to:
  /// **'Offensive / Hate Speech'**
  String get reportReasonOffensiveOrHateSpeech;

  /// Report reason: The content is spam or a scam.
  ///
  /// In en, this message translates to:
  /// **'Spam / Scam'**
  String get reportReasonSpamOrScam;

  /// Report reason: The link in the content is broken.
  ///
  /// In en, this message translates to:
  /// **'Broken Link'**
  String get reportReasonBrokenLink;

  /// Report reason: The content is behind a paywall.
  ///
  /// In en, this message translates to:
  /// **'Paywalled'**
  String get reportReasonPaywalled;

  /// Report reason: The source exhibits low-quality journalism.
  ///
  /// In en, this message translates to:
  /// **'Low Quality Journalism'**
  String get reportReasonLowQualityJournalism;

  /// Report reason: The source has a high density of ads.
  ///
  /// In en, this message translates to:
  /// **'High Ad Density'**
  String get reportReasonHighAdDensity;

  /// Report reason: The source is a blog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get reportReasonBlog;

  /// Report reason: The source is a government entity.
  ///
  /// In en, this message translates to:
  /// **'Government Source'**
  String get reportReasonGovernmentSource;

  /// Report reason: The source is a news aggregator.
  ///
  /// In en, this message translates to:
  /// **'Aggregator'**
  String get reportReasonAggregator;

  /// Report reason: Other, not specified.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reportReasonOther;

  /// Report reason: The source frequently uses paywalls.
  ///
  /// In en, this message translates to:
  /// **'Frequent Paywalls'**
  String get reportReasonFrequentPaywalls;

  /// Report reason: The source is impersonating another entity.
  ///
  /// In en, this message translates to:
  /// **'Impersonation'**
  String get reportReasonImpersonation;

  /// Message displayed in the feedback history dialog when there is no history.
  ///
  /// In en, this message translates to:
  /// **'No negative feedback history found for this user.'**
  String get noNegativeFeedbackHistory;

  /// Confirmation button text for a reject action.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Admin-centric status for a comment automatically flagged by AI.
  ///
  /// In en, this message translates to:
  /// **'Flagged by AI'**
  String get commentStatusFlaggedByAi;

  /// A generic 'Cancel' button text.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// A simplified confirmation message shown to an admin before they reject and delete a user's comment.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject and permanently delete this comment? This action cannot be undone.'**
  String get rejectCommentConfirmation;

  /// Hint text for the search input field in filter dialogs, specifying to search by User ID.
  ///
  /// In en, this message translates to:
  /// **'Search by User ID...'**
  String get searchByUserId;

  /// Action to view the reported headline
  ///
  /// In en, this message translates to:
  /// **'View Headline'**
  String get viewReportedHeadline;

  /// Action to view the reported source
  ///
  /// In en, this message translates to:
  /// **'View Source'**
  String get viewReportedSource;

  /// Action to view the reported comment
  ///
  /// In en, this message translates to:
  /// **'View Comment'**
  String get viewReportedComment;

  /// Column header for the type of entity being reported
  ///
  /// In en, this message translates to:
  /// **'Entity Type'**
  String get entityType;

  /// Column header for user feedback on app reviews.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// Title for the dialog showing detailed user feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback Details'**
  String get feedbackDetails;

  /// Moderation status: The item is awaiting review.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get moderationStatusPendingReview;

  /// Moderation status: A decision has been made on the item.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get moderationStatusResolved;

  /// Label for a filter option to show items that have a comment.
  ///
  /// In en, this message translates to:
  /// **'Has Comment'**
  String get hasComment;

  /// Filter option to show items regardless of a certain property (e.g., show items with or without comments).
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// Filter option to show only items that have a comment.
  ///
  /// In en, this message translates to:
  /// **'With Comment'**
  String get withComment;

  /// Filter option to show only items that do not have a comment.
  ///
  /// In en, this message translates to:
  /// **'Without Comment'**
  String get withoutComment;

  /// No description provided for @reportResolved.
  ///
  /// In en, this message translates to:
  /// **'Report resolved.'**
  String get reportResolved;

  /// Message when a comment is approved
  ///
  /// In en, this message translates to:
  /// **'Comment approved.'**
  String get commentApproved;

  /// Message when a comment is rejected
  ///
  /// In en, this message translates to:
  /// **'Comment rejected.'**
  String get commentRejected;

  /// Menu item text to copy the ID of a headline.
  ///
  /// In en, this message translates to:
  /// **'Copy Headline ID'**
  String get copyHeadlineId;

  /// Menu item text to copy the ID of a reported item.
  ///
  /// In en, this message translates to:
  /// **'Copy Reported Item ID'**
  String get copyReportedItemId;

  /// Tooltip for the button to view feedback details.
  ///
  /// In en, this message translates to:
  /// **'View Feedback Details'**
  String get viewFeedbackDetails;

  /// Title for the dialog showing the details of a user-submitted report.
  ///
  /// In en, this message translates to:
  /// **'Report Details'**
  String get reportDetails;

  /// Title for the dialog showing the details of a user-submitted comment.
  ///
  /// In en, this message translates to:
  /// **'Comment Details'**
  String get commentDetails;

  /// Label for the Community Management page title and navigation.
  ///
  /// In en, this message translates to:
  /// **'Community Management'**
  String get communityManagement;

  /// Short navigation label for Content Management.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get navContent;

  /// Short navigation label for User Management.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get navUsers;

  /// Short navigation label for Community Management.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunity;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
