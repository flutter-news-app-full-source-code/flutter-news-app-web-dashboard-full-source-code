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

  /// Label for the settings navigation item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;
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
