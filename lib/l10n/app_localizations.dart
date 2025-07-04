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

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// Button label for signing in with email
  ///
  /// In en, this message translates to:
  /// **'Sign in with Email'**
  String get authenticationEmailSignInButton;

  /// Title for the email sign-in page
  ///
  /// In en, this message translates to:
  /// **'Email Sign In'**
  String get emailSignInPageTitle;

  /// Headline for the request code page
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account'**
  String get requestCodePageHeadline;

  /// Subheadline for the request code page
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a verification code. No password needed!'**
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

  /// Label for the dashboard navigation item
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Label for the content management navigation item
  ///
  /// In en, this message translates to:
  /// **'Content Management'**
  String get contentManagement;

  /// Description for the Content Management page
  ///
  /// In en, this message translates to:
  /// **'Manage news headlines, categories, and sources for the Dashboard.'**
  String get contentManagementPageDescription;

  /// Label for the headlines subpage
  ///
  /// In en, this message translates to:
  /// **'Headlines'**
  String get headlines;

  /// Label for the categories subpage
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

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
  /// **'Configure global settings for the mobile application, including user content limits, ad display rules, in-app prompts, operational status, and force update parameters.'**
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

  /// Tab title for User Content Limits
  ///
  /// In en, this message translates to:
  /// **'User Content Limits'**
  String get userContentLimitsTab;

  /// Tab title for Ad Settings
  ///
  /// In en, this message translates to:
  /// **'Ad Settings'**
  String get adSettingsTab;

  /// Tab title for In-App Prompts
  ///
  /// In en, this message translates to:
  /// **'In-App Prompts'**
  String get inAppPromptsTab;

  /// Tab title for App Operational Status
  ///
  /// In en, this message translates to:
  /// **'App Operational Status'**
  String get appOperationalStatusTab;

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

  /// Description for User Content Limits section
  ///
  /// In en, this message translates to:
  /// **'These settings define the maximum number of countries, news sources, categories, and saved headlines a user can follow or save. Limits vary by user type (Guest, Standard, Premium) and directly impact what content users can curate.'**
  String get userContentLimitsDescription;

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
  /// **'Maximum number of countries, news sources, or categories a Guest user can follow (each type has its own limit).'**
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
  /// **'Maximum number of countries, news sources, or categories a Standard user can follow (each type has its own limit).'**
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
  /// **'Maximum number of countries, news sources, or categories a Premium user can follow (each type has its own limit).'**
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

  /// Description for Ad Settings section
  ///
  /// In en, this message translates to:
  /// **'These settings control how advertisements are displayed within the app\'s news feed, with different rules for Guest, Standard, and Premium users. \"Ad Frequency\" determines how often an ad can appear, while \"Ad Placement Interval\" sets how many news items must be shown before the very first ad appears.'**
  String get adSettingsDescription;

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

  /// Description for In-App Prompts section
  ///
  /// In en, this message translates to:
  /// **'These settings control how often special in-app messages or \"prompts\" are shown to users in their news feed. These prompts encourage actions like linking an account (for guests) or upgrading to a premium subscription (for authenticated users). The frequency varies by user type.'**
  String get inAppPromptsDescription;

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

  /// Description for Force Update Configuration section
  ///
  /// In en, this message translates to:
  /// **'These settings control app version enforcement. Users on versions below the minimum allowed will be forced to update.'**
  String get forceUpdateDescription;

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

  /// Description for Android Store URL
  ///
  /// In en, this message translates to:
  /// **'URL to the app on the Google Play Store.'**
  String get androidStoreUrlDescription;

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

  /// Headline for loading state of categories
  ///
  /// In en, this message translates to:
  /// **'Loading Categories'**
  String get loadingCategories;

  /// Message when no categories are found
  ///
  /// In en, this message translates to:
  /// **'No categories found.'**
  String get noCategoriesFound;

  /// Label for the category name field in forms and tables.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

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
  /// **'Name'**
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

  /// Title for the Edit Category page
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// Tooltip for the save changes button
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Message displayed while loading category data
  ///
  /// In en, this message translates to:
  /// **'Loading Category'**
  String get loadingCategory;

  /// Label for the icon URL input field
  ///
  /// In en, this message translates to:
  /// **'Icon URL'**
  String get iconUrl;

  /// Message displayed when a category is updated successfully
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully.'**
  String get categoryUpdatedSuccessfully;

  /// Error message when updating a category fails because the original data wasn't loaded
  ///
  /// In en, this message translates to:
  /// **'Cannot update: Original category data not loaded.'**
  String get cannotUpdateCategoryError;

  /// Title for the Create Category page
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get createCategory;

  /// Message displayed when a category is created successfully
  ///
  /// In en, this message translates to:
  /// **'Category created successfully.'**
  String get categoryCreatedSuccessfully;

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

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @contentStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get contentStatusActive;

  /// No description provided for @contentStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get contentStatusArchived;

  /// No description provided for @contentStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get contentStatusDraft;

  /// Label for the total headlines summary card on the dashboard
  ///
  /// In en, this message translates to:
  /// **'Total Headlines'**
  String get totalHeadlines;

  /// Label for the total categories summary card on the dashboard
  ///
  /// In en, this message translates to:
  /// **'Total Categories'**
  String get totalCategories;

  /// Label for the total sources summary card on the dashboard
  ///
  /// In en, this message translates to:
  /// **'Total Sources'**
  String get totalSources;

  /// Headline for the dashboard loading state
  ///
  /// In en, this message translates to:
  /// **'Loading Dashboard'**
  String get loadingDashboard;

  /// Subheadline for the dashboard loading state
  ///
  /// In en, this message translates to:
  /// **'Fetching latest statistics...'**
  String get loadingDashboardSubheadline;

  /// Error message when dashboard data fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load dashboard data.'**
  String get dashboardLoadFailure;
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
