// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get helloWorld => 'مرحبا بالعالم!';

  @override
  String get authenticationEmailSignInButton =>
      'تسجيل الدخول بالبريد الإلكتروني';

  @override
  String get emailSignInPageTitle => 'تسجيل الدخول بالبريد الإلكتروني';

  @override
  String get requestCodePageHeadline => 'سجل الدخول أو أنشئ حسابًا';

  @override
  String get requestCodePageSubheadline =>
      'أدخل بريدك الإلكتروني لتلقي رمز التحقق. لا حاجة لكلمة مرور!';

  @override
  String get requestCodeEmailLabel => 'البريد الإلكتروني';

  @override
  String get requestCodeEmailHint => 'بريدك.الإلكتروني@مثال.كوم';

  @override
  String get accountLinkingEmailValidationError =>
      'الرجاء إدخال عنوان بريد إلكتروني صالح.';

  @override
  String get requestCodeSendCodeButton => 'إرسال الرمز';

  @override
  String get emailCodeSentPageTitle => 'التحقق من الرمز';

  @override
  String emailCodeSentConfirmation(String email) {
    return 'لقد أرسلنا رمزًا مكونًا من 6 أرقام إلى $email';
  }

  @override
  String get emailCodeSentInstructions =>
      'الرجاء التحقق من بريدك الوارد وإدخال الرمز أدناه للمتابعة.';

  @override
  String demoVerificationCodeMessage(String code) {
    return 'في الوضع التجريبي، استخدم الرمز: $code';
  }

  @override
  String get emailCodeVerificationHint => 'رمز مكون من 6 أرقام';

  @override
  String get emailCodeValidationEmptyError => 'لا يمكن أن يكون الرمز فارغًا.';

  @override
  String get emailCodeValidationLengthError => 'يجب أن يتكون الرمز من 6 أرقام.';

  @override
  String get emailCodeVerificationButtonLabel => 'التحقق من الرمز';

  @override
  String get dashboard => 'لوحة القيادة';

  @override
  String get contentManagement => 'إدارة المحتوى';

  @override
  String get headlines => 'العناوين الرئيسية';

  @override
  String get categories => 'الفئات';

  @override
  String get sources => 'المصادر';

  @override
  String get appConfiguration => 'إعدادات التطبيق';

  @override
  String get settings => 'الإعدادات';
}
