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
  String get headlines => 'Headlines';

  @override
  String get categories => 'Categories';

  @override
  String get sources => 'Sources';

  @override
  String get appConfiguration => 'App Configuration';

  @override
  String get settings => 'Settings';
}
