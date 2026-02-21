// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get authenticationPageHeadline => 'الوصول إلى لوحة التحكم';

  @override
  String get authenticationPageSubheadline =>
      'تسجيل دخول آمن للمسؤولين والناشرين.';

  @override
  String get authenticationEmailSignInButton =>
      'تسجيل الدخول بالبريد الإلكتروني';

  @override
  String get emailSignInPageTitle => 'تسجيل دخول آمن بالبريد الإلكتروني';

  @override
  String get requestCodePageHeadline => 'تسجيل دخول آمن بالبريد الإلكتروني';

  @override
  String get requestCodePageSubheadline =>
      'أدخل بريدك الإلكتروني المعتمد لتلقي رمز تسجيل دخول آمن.';

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
  String requestCodeResendButtonCooldown(int seconds) {
    return 'إعادة الإرسال في $seconds ثانية';
  }

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
  String get overview => 'نظرة عامة';

  @override
  String get contentManagement => 'إدارة المحتوى';

  @override
  String get contentManagementPageDescription =>
      'إدارة العناوين الإخبارية والمواضيع والمصادر لتطبيق الهاتف';

  @override
  String get headlines => 'العناوين الرئيسية';

  @override
  String get headline => 'العنوان الرئيسي';

  @override
  String get topics => 'المواضيع';

  @override
  String get topic => 'الموضوع';

  @override
  String get sources => 'المصادر';

  @override
  String get source => 'المصدر';

  @override
  String get appConfiguration => 'التحكم المركزي';

  @override
  String get appConfigurationPageDescription =>
      'إدارة الإعدادات العامة لتطبيق الهاتف، من حدود المحتوى إلى الحالة التشغيلية.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appConfigurationPageTitle => 'التحكم المركزي عن بعد';

  @override
  String get feedTab => 'الموجز';

  @override
  String get advertisementsTab => 'الإعلانات';

  @override
  String get systemTab => 'النظام';

  @override
  String get userContentLimitsTitle => 'حدود المحتوى';

  @override
  String get userContentLimitsDescription =>
      'تعيين حدود للعناصر المتابعة والعناوين المحفوظة لكل فئة من فئات المستخدمين.';

  @override
  String get feedActionsTitle => 'إجراءات الموجز';

  @override
  String get feedActionsDescription =>
      'تكوين عدد مرات إدراج ودجات الإجراءات (مثل \'تقييم التطبيق\') في الموجز.';

  @override
  String get feedDecoratorsTitle => 'زينة الموجز';

  @override
  String get feedDecoratorsDescription =>
      'تكوين كيفية تزيين وعرض المحتوى في الموجز لأدوار المستخدمين المختلفة.';

  @override
  String get adSettingsTitle => 'إعدادات الإعلانات';

  @override
  String get adSettingsDescription =>
      'إدارة تكرار وموضع الإعلانات لأدوار المستخدمين المختلفة.';

  @override
  String get maintenanceModeTitle => 'وضع الصيانة';

  @override
  String get maintenanceModeDescription =>
      'تمكين لعرض شاشة صيانة لجميع المستخدمين.';

  @override
  String get forceUpdateTitle => 'فرض تحديث التطبيق';

  @override
  String get forceUpdateDescription =>
      'تكوين تحديثات التطبيق الإلزامية للمستخدمين.';

  @override
  String get forceUpdateTab => 'تحديث إجباري';

  @override
  String get appConfigSaveSuccessMessage =>
      'تم حفظ الإعدادات عن بعد بنجاح. ستعكس تطبيقات الجوال هذه التغييرات عند تشغيلها التالي.';

  @override
  String appConfigSaveErrorMessage(String errorMessage) {
    return 'خطأ: $errorMessage';
  }

  @override
  String get unknownError => 'خطأ غير معروف';

  @override
  String get loadingConfigurationHeadline => 'جاري تحميل الإعدادات';

  @override
  String get loadingConfigurationSubheadline =>
      'الرجاء الانتظار بينما يتم تحميل الإعدادات...';

  @override
  String get failedToLoadConfigurationMessage => 'فشل تحميل الإعدادات.';

  @override
  String get loadAppSettingsSubheadline =>
      'تحميل إعدادات التطبيق من الواجهة الخلفية.';

  @override
  String get discardChangesButton => 'تجاهل التغييرات';

  @override
  String get saveChangesButton => 'حفظ التغييرات';

  @override
  String get confirmConfigUpdateDialogTitle => 'تأكيد تحديث الإعدادات';

  @override
  String get confirmConfigUpdateDialogContent =>
      'هل أنت متأكد أنك تريد تطبيق هذه التغييرات على إعدادات التطبيق المباشرة؟ هذه عملية حساسة.';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get confirmSaveButton => 'تأكيد الحفظ';

  @override
  String get guestUserTab => 'ضيف';

  @override
  String get authenticatedUserTab => 'موثق';

  @override
  String get premiumUserTab => 'مميز';

  @override
  String get guestFollowedItemsLimitLabel => 'حد العناصر المتابعة للضيف';

  @override
  String get guestFollowedItemsLimitDescription =>
      'الحد الأقصى لعدد البلدان أو مصادر الأخبار أو المواضيع التي يمكن للمستخدم الضيف متابعتها (لكل نوع حد خاص به).';

  @override
  String get guestSavedHeadlinesLimitLabel => 'حد العناوين المحفوظة للضيف';

  @override
  String get guestSavedHeadlinesLimitDescription =>
      'الحد الأقصى لعدد العناوين الرئيسية التي يمكن للمستخدم الضيف حفظها.';

  @override
  String get standardUserFollowedItemsLimitLabel =>
      'حد العناصر المتابعة للمستخدم العادي';

  @override
  String get standardUserFollowedItemsLimitDescription =>
      'الحد الأقصى لعدد البلدان أو مصادر الأخبار أو المواضيع التي يمكن للمستخدم العادي متابعتها (لكل نوع حد خاص به).';

  @override
  String get standardUserSavedHeadlinesLimitLabel =>
      'حد العناوين المحفوظة للمستخدم العادي';

  @override
  String get standardUserSavedHeadlinesLimitDescription =>
      'الحد الأقصى لعدد العناوين الرئيسية التي يمكن للمستخدم العادي حفظها.';

  @override
  String get premiumFollowedItemsLimitLabel =>
      'حد العناصر المتابعة للمستخدم المميز';

  @override
  String get premiumFollowedItemsLimitDescription =>
      'الحد الأقصى لعدد البلدان أو مصادر الأخبار أو المواضيع التي يمكن للمستخدم المميز متابعتها (لكل نوع حد خاص به).';

  @override
  String get premiumSavedHeadlinesLimitLabel =>
      'حد العناوين المحفوظة للمستخدم المميز';

  @override
  String get premiumSavedHeadlinesLimitDescription =>
      'الحد الأقصى لعدد العناوين الرئيسية التي يمكن للمستخدم المميز حفظها.';

  @override
  String get standardUserAdTab => 'مستخدم عادي';

  @override
  String get guestAdFrequencyLabel => 'تكرار الإعلان للضيف';

  @override
  String get guestAdFrequencyDescription =>
      'عدد مرات ظهور الإعلان للمستخدمين الضيوف (على سبيل المثال، قيمة 5 تعني أنه يمكن وضع إعلان بعد كل 5 عناصر إخبارية).';

  @override
  String get guestAdPlacementIntervalLabel => 'فترة وضع الإعلان للضيف';

  @override
  String get guestAdPlacementIntervalDescription =>
      'الحد الأدنى لعدد عناصر الأخبار التي يجب عرضها قبل ظهور الإعلان الأول للمستخدمين الضيوف.';

  @override
  String get guestArticlesBeforeInterstitialAdsLabel =>
      'مقالات الضيف قبل الإعلانات البينية';

  @override
  String get guestArticlesBeforeInterstitialAdsDescription =>
      'عدد المقالات التي يحتاج المستخدم الضيف لقراءتها قبل عرض إعلان بيني بملء الشاشة.';

  @override
  String get standardUserAdFrequencyLabel => 'تكرار الإعلان للمستخدم العادي';

  @override
  String get standardUserAdFrequencyDescription =>
      'عدد مرات ظهور الإعلان للمستخدمين العاديين (على سبيل المثال، قيمة 10 تعني أنه يمكن وضع إعلان بعد كل 10 عناصر إخبارية).';

  @override
  String get standardUserAdPlacementIntervalLabel =>
      'فترة وضع الإعلان للمستخدم العادي';

  @override
  String get standardUserAdPlacementIntervalDescription =>
      'الحد الأدنى لعدد عناصر الأخبار التي يجب عرضها قبل ظهور الإعلان الأول للمستخدمين العاديين.';

  @override
  String get standardUserArticlesBeforeInterstitialAdsLabel =>
      'مقالات المستخدم العادي قبل الإعلانات البينية';

  @override
  String get standardUserArticlesBeforeInterstitialAdsDescription =>
      'عدد المقالات التي يحتاج المستخدم العادي لقراءتها قبل عرض إعلان بيني بملء الشاشة.';

  @override
  String get premiumAdFrequencyLabel => 'تكرار الإعلان للمستخدم المميز';

  @override
  String get premiumAdFrequencyDescription =>
      'عدد مرات ظهور الإعلان للمستخدمين المميزين (0 يعني عدم وجود إعلانات).';

  @override
  String get premiumAdPlacementIntervalLabel =>
      'فترة وضع الإعلان للمستخدم المميز';

  @override
  String get premiumAdPlacementIntervalDescription =>
      'الحد الأدنى لعدد عناصر الأخبار التي يجب عرضها قبل ظهور الإعلان الأول للمستخدمين المميزين.';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsLabel =>
      'مقالات المستخدم المميز قبل الإعلانات البينية';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsDescription =>
      'عدد المقالات التي يحتاج المستخدم المميز لقراءتها قبل عرض إعلان بيني بملء الشاشة.';

  @override
  String get appOperationalStatusWarning =>
      'تحذير: قد يؤثر تغيير حالة تشغيل التطبيق على جميع المستخدمين. استخدم بحذر شديد.';

  @override
  String get appOperationalStatusLabel => 'حالة تشغيل التطبيق';

  @override
  String get appOperationalStatusDescription =>
      'الحالة التشغيلية الحالية للتطبيق (على سبيل المثال، نشط، صيانة، معطل).';

  @override
  String get maintenanceMessageLabel => 'رسالة الصيانة';

  @override
  String get maintenanceMessageDescription =>
      'الرسالة المعروضة عندما يكون التطبيق في وضع الصيانة.';

  @override
  String get disabledMessageLabel => 'رسالة التعطيل';

  @override
  String get disabledMessageDescription =>
      'الرسالة المعروضة عندما يكون التطبيق معطلاً بشكل دائم.';

  @override
  String get forceUpdateConfigurationTitle => 'إعدادات التحديث الإجباري';

  @override
  String get minAllowedAppVersionLabel =>
      'الحد الأدنى المسموح به لإصدار التطبيق';

  @override
  String get minAllowedAppVersionDescription =>
      'أدنى إصدار للتطبيق مسموح بتشغيله (على سبيل المثال، \"1.2.0\").';

  @override
  String get latestAppVersionLabel => 'أحدث إصدار للتطبيق';

  @override
  String get latestAppVersionDescription =>
      'أحدث إصدار متاح للتطبيق (على سبيل المثال، \"1.5.0\").';

  @override
  String get updateRequiredMessageLabel => 'رسالة التحديث المطلوب';

  @override
  String get updateRequiredMessageDescription =>
      'الرسالة المعروضة عندما يكون التحديث إجباريًا.';

  @override
  String get updateOptionalMessageLabel => 'رسالة التحديث الاختياري';

  @override
  String get updateOptionalMessageDescription =>
      'الرسالة المعروضة للتحديث الاختياري.';

  @override
  String get iosStoreUrlLabel => 'رابط متجر iOS';

  @override
  String get iosStoreUrlDescription => 'رابط التطبيق على متجر Apple App Store.';

  @override
  String get androidStoreUrlLabel => 'رابط متجر Android';

  @override
  String get androidUpdateUrlDescription => 'رابط تحديثات تطبيق Android.';

  @override
  String get guestDaysBetweenInAppPromptsLabel =>
      'أيام الضيف بين التنبيهات داخل التطبيق';

  @override
  String get guestDaysBetweenInAppPromptsDescription =>
      'الحد الأدنى لعدد الأيام التي يجب أن تمر قبل أن يرى المستخدم الضيف تنبيهًا آخر داخل التطبيق.';

  @override
  String get standardUserDaysBetweenInAppPromptsLabel =>
      'أيام المستخدم العادي بين التنبيهات داخل التطبيق';

  @override
  String get standardUserDaysBetweenInAppPromptsDescription =>
      'الحد الأدنى لعدد الأيام التي يجب أن تمر قبل أن يرى المستخدم العادي تنبيهًا آخر داخل التطبيق.';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get settingsSavedSuccessfully => 'تم حفظ الإعدادات بنجاح!';

  @override
  String settingsSaveErrorMessage(String errorMessage) {
    return 'خطأ في حفظ الإعدادات: $errorMessage';
  }

  @override
  String get loadingSettingsHeadline => 'جاري تحميل الإعدادات';

  @override
  String get loadingSettingsSubheadline =>
      'الرجاء الانتظار بينما يتم تحميل إعداداتك...';

  @override
  String failedToLoadSettingsMessage(String errorMessage) {
    return 'فشل تحميل الإعدادات: $errorMessage';
  }

  @override
  String get baseThemeLabel => 'السمة الأساسية';

  @override
  String get baseThemeDescription =>
      'اختر المظهر العام الفاتح أو الداكن للتطبيق.';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get systemTheme => 'افتراضي النظام';

  @override
  String get accentThemeLabel => 'سمة التمييز';

  @override
  String get accentThemeDescription =>
      'اختر لون تمييز أساسي للعناصر التفاعلية.';

  @override
  String get defaultBlueTheme => 'أزرق افتراضي';

  @override
  String get newsRedTheme => 'أحمر الأخبار';

  @override
  String get graphiteGrayTheme => 'رمادي جرافيت';

  @override
  String get fontFamilyLabel => 'عائلة الخط';

  @override
  String get fontFamilyDescription =>
      'اختر الخط المستخدم في جميع أنحاء التطبيق.';

  @override
  String get systemDefaultFont => 'افتراضي النظام';

  @override
  String get textScaleFactorLabel => 'حجم النص';

  @override
  String get textScaleFactorDescription => 'ضبط الحجم الكلي للنص في التطبيق.';

  @override
  String get smallText => 'صغير';

  @override
  String get mediumText => 'متوسط';

  @override
  String get largeText => 'كبير';

  @override
  String get extraLargeText => 'كبير جداً';

  @override
  String get fontWeightLabel => 'وزن الخط';

  @override
  String get fontWeightDescription => 'اختر سمك النص.';

  @override
  String get lightFontWeight => 'فاتح';

  @override
  String get regularFontWeight => 'عادي';

  @override
  String get boldFontWeight => 'عريض';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get languageDescription => 'اختر لغة التطبيق.';

  @override
  String get edit => 'تعديل';

  @override
  String get englishLanguage => 'الإنجليزية';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String get appearanceSettingsLabel => 'المظهر';

  @override
  String get languageSettingsLabel => 'اللغة';

  @override
  String get themeSettingsLabel => 'إعدادات السمة';

  @override
  String get fontSettingsLabel => 'إعدادات الخط';

  @override
  String get settingsPageDescription =>
      'قم بتكوين تفضيلاتك الشخصية لواجهة لوحة القيادة، بما في ذلك العرض المرئي واختيار اللغة.';

  @override
  String get appearanceSettingsDescription =>
      'اضبط الخصائص المرئية للوحة القيادة، بما في ذلك السمة وألوان التمييز والأنماط الطباعية.';

  @override
  String get loadingHeadlines => 'جاري تحميل العناوين الرئيسية';

  @override
  String get pleaseWait => 'الرجاء الانتظار...';

  @override
  String get noHeadlinesFound => 'لم يتم العثور على عناوين رئيسية.';

  @override
  String get headlineTitle => 'العنوان';

  @override
  String get excerpt => 'المقتطف';

  @override
  String get countryName => 'البلد';

  @override
  String get publishedAt => 'تاريخ النشر';

  @override
  String get actions => 'الإجراءات';

  @override
  String get unknown => 'غير معروف';

  @override
  String get loadingTopics => 'جاري تحميل المواضيع';

  @override
  String get noTopicsFound => 'لم يتم العثور على مواضيع.';

  @override
  String get topicName => 'الموضوع';

  @override
  String get description => 'الوصف';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get loadingSources => 'جاري تحميل المصادر';

  @override
  String get noSourcesFound => 'لم يتم العثور على مصادر.';

  @override
  String get sourceName => 'المصدر';

  @override
  String get sourceType => 'النوع';

  @override
  String get language => 'اللغة';

  @override
  String get editTopic => 'تعديل الموضوع';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get loadingTopic => 'جاري تحميل الموضوع';

  @override
  String get icon => 'أيقونة';

  @override
  String get topicUpdatedSuccessfully => 'تم تحديث الموضوع بنجاح.';

  @override
  String get cannotUpdateTopicError =>
      'لا يمكن التحديث: لم يتم تحميل بيانات الموضوع الأصلية.';

  @override
  String get createTopic => 'إنشاء موضوع';

  @override
  String get topicCreatedSuccessfully => 'تم إنشاء الموضوع بنجاح.';

  @override
  String get editSource => 'تعديل المصدر';

  @override
  String get sourceUpdatedSuccessfully => 'تم تحديث المصدر بنجاح.';

  @override
  String get loadingSource => 'جاري تحميل المصدر...';

  @override
  String get sourceUrl => 'الرابط';

  @override
  String get headquarters => 'المقر الرئيسي';

  @override
  String get none => 'لا شيء';

  @override
  String get cannotUpdateSourceError =>
      'لا يمكن التحديث: لم يتم تحميل بيانات المصدر الأصلية.';

  @override
  String get sourceTypeNewsAgency => 'وكالة أنباء';

  @override
  String get sourceTypeLocalNewsOutlet => 'منفذ إخباري محلي';

  @override
  String get sourceTypeNationalNewsOutlet => 'منفذ إخباري وطني';

  @override
  String get sourceTypeInternationalNewsOutlet => 'منفذ إخباري دولي';

  @override
  String get sourceTypeSpecializedPublisher => 'ناشر متخصص';

  @override
  String get sourceTypeBlog => 'مدونة';

  @override
  String get sourceTypeGovernmentSource => 'مصدر حكومي';

  @override
  String get sourceTypeAggregator => 'مجمع';

  @override
  String get sourceTypeOther => 'أخرى';

  @override
  String get editHeadline => 'تعديل العنوان';

  @override
  String get headlineUpdatedSuccessfully => 'تم تحديث العنوان بنجاح.';

  @override
  String get loadingHeadline => 'جاري تحميل العنوان...';

  @override
  String get image => 'صورة';

  @override
  String get cannotUpdateHeadlineError =>
      'لا يمكن التحديث: لم يتم تحميل بيانات العنوان الأصلية.';

  @override
  String get createHeadline => 'إنشاء عنوان';

  @override
  String get headlineCreatedSuccessfully => 'تم إنشاء العنوان بنجاح.';

  @override
  String get loadingData => 'جاري تحميل البيانات...';

  @override
  String get loadingFullList => 'جاري تحميل القائمة الكاملة...';

  @override
  String get createSource => 'إنشاء مصدر';

  @override
  String get updateSourceTitle => 'تحديث المصدر';

  @override
  String get updateSourceMessage =>
      'هل تريد نشر هذه التغييرات أم حفظ التحديث كمسودة؟';

  @override
  String get sourceCreatedSuccessfully => 'تم إنشاء المصدر بنجاح.';

  @override
  String get updateTopicTitle => 'تحديث الموضوع';

  @override
  String get status => 'الحالة';

  @override
  String get updateTopicMessage =>
      'هل تريد نشر هذه التغييرات أم حفظ التحديث كمسودة؟';

  @override
  String get lastUpdated => 'آخر تحديث';

  @override
  String get contentStatusActive => 'نشط';

  @override
  String get contentStatusArchived => 'مؤرشف';

  @override
  String get contentStatusDraft => 'مسودة';

  @override
  String get totalHeadlines => 'إجمالي العناوين';

  @override
  String get totalTopics => 'إجمالي المواضيع';

  @override
  String get totalSources => 'إجمالي المصادر';

  @override
  String get loadingOverview => 'جاري تحميل نظرة عامة على لوحة القيادة';

  @override
  String get loadingOverviewSubheadline => 'جاري جلب أحدث الإحصائيات...';

  @override
  String get overviewLoadFailure =>
      'فشل تحميل بيانات نظرة عامة على لوحة القيادة.';

  @override
  String get recentHeadlines => 'أحدث العناوين';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get noRecentHeadlines => 'لا توجد عناوين حديثة لعرضها.';

  @override
  String get systemStatus => 'حالة النظام';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get createHeadlineAction => 'إنشاء عنوان';

  @override
  String get manageContentAction => 'إدارة المحتوى';

  @override
  String get appConfigAction => 'إعدادات التطبيق';

  @override
  String get appStatusActive => 'نشط';

  @override
  String get appStatusDisabled => 'معطل';

  @override
  String demoEmailHint(String email) {
    return 'للعرض التجريبي، استخدم البريد الإلكتروني: $email';
  }

  @override
  String demoCodeHint(String code) {
    return 'للعرض التجريبي، استخدم الرمز: $code';
  }

  @override
  String get appStatusMaintenance => 'صيانة';

  @override
  String get appStatusOperational => 'يعاري';

  @override
  String get isUnderMaintenanceLabel => 'تحت الصيانة';

  @override
  String get isUnderMaintenanceDescription =>
      'تبديل لوضع تطبيق الجوال في وضع الصيانة، مما يمنع وصول المستخدمين.';

  @override
  String get isLatestVersionOnlyLabel => 'فرض أحدث إصدار فقط';

  @override
  String get isLatestVersionOnlyDescription =>
      'إذا تم التمكين، يجب على المستخدمين التحديث إلى أحدث إصدار من التطبيق لمواصلة استخدامه.';

  @override
  String get iosUpdateUrlLabel => 'رابط تحديث iOS';

  @override
  String get iosUpdateUrlDescription => 'رابط تحديثات تطبيق iOS.';

  @override
  String get androidUpdateUrlLabel => 'رابط تحديث Android';

  @override
  String get followedItemsLimitLabel => 'حد العناصر المتابعة';

  @override
  String get followedItemsLimitDescription =>
      'الحد الأقصى لعدد البلدان أو مصادر الأخبار أو المواضيع التي يمكن لهذا الدور المستخدم متابعتها (لكل نوع حد خاص به).';

  @override
  String get savedFeedFiltersLimitLabel => 'حدود المرشحات';

  @override
  String get savedFeedFiltersLimitDescription =>
      'الحد الأقصى لعدد مرشحات موجز الأخبار التي يمكن لهذا الدور المستخدم حفظها.';

  @override
  String get adFrequencyLabel => 'تكرار الإعلان';

  @override
  String get adFrequencyDescription =>
      'عدد مرات ظهور الإعلان لهذا الدور المستخدم (على سبيل المثال، قيمة 5 تعني أنه يمكن وضع إعلان بعد كل 5 عناصر إخبارية).';

  @override
  String get savedFeedFilterLimitsTitle => 'حدود المرشحات المحفوظة';

  @override
  String get savedFeedFilterLimitsDescription =>
      'الحد الأقصى لعدد  مرشحات موجز الأخبار المحفوظة التي يمكن لهذا الدور إنشاؤها.';

  @override
  String get adPlacementIntervalLabel => 'فترة وضع الإعلان';

  @override
  String get adPlacementIntervalDescription =>
      'الحد الأدنى لعدد عناصر الأخبار التي يجب عرضها قبل ظهور الإعلان الأول لهذا الدور المستخدم.';

  @override
  String get articlesBeforeInterstitialAdsLabel =>
      'مقالات قبل الإعلانات البينية';

  @override
  String get articlesBeforeInterstitialAdsDescription =>
      'عدد المقالات التي يحتاج هذا الدور المستخدم لقراءتها قبل عرض إعلان بيني بملء الشاشة.';

  @override
  String get daysSuffix => 'أيام';

  @override
  String daysBetweenPromptDescription(String actionType) {
    return 'الحد الأدنى لعدد الأيام قبل عرض تنبيه $actionType.';
  }

  @override
  String get retryButtonText => 'إعادة المحاولة';

  @override
  String get feedActionTypeLinkAccount => 'ربط الحساب';

  @override
  String get feedActionTypeRateApp => 'تقييم التطبيق';

  @override
  String get feedActionTypeFollowTopics => 'متابعة المواضيع';

  @override
  String get feedActionTypeFollowSources => 'متابعة المصادر';

  @override
  String get feedActionTypeUpgrade => 'ترقية';

  @override
  String get feedActionTypeEnableNotifications => 'تفعيل الإشعارات';

  @override
  String get countryPickerSearchLabel => 'بحث';

  @override
  String get countryPickerSearchHint => 'ابدأ الكتابة للبحث...';

  @override
  String get countryPickerSelectCountryLabel => 'اختر دولة';

  @override
  String get archivedHeadlines => 'العناوين المؤرشفة';

  @override
  String get loadingArchivedHeadlines => 'جاري تحميل العناوين المؤرشفة';

  @override
  String get noArchivedHeadlinesFound => 'لم يتم العثور على عناوين مؤرشفة.';

  @override
  String get restore => 'استعادة';

  @override
  String get deleteForever => 'حذف نهائي';

  @override
  String get archivedTopics => 'المواضيع المؤرشفة';

  @override
  String get loadingArchivedTopics => 'جاري تحميل المواضيع المؤرشفة';

  @override
  String get noArchivedTopicsFound => 'لم يتم العثور على مواضيع مؤرشفة.';

  @override
  String get archivedSources => 'المصادر المؤرشفة';

  @override
  String get loadingArchivedSources => 'جاري تحميل المصادر المؤرشفة';

  @override
  String get noArchivedSourcesFound => 'لم يتم العثور على مصادر مؤرشفة.';

  @override
  String get archivedItems => 'العناصر المؤرشفة';

  @override
  String get addNewItem => 'إضافة عنصر جديد';

  @override
  String get archive => 'أرشفة';

  @override
  String headlineDeleted(String title) {
    return 'تم حذف \'\'$title\'\'.';
  }

  @override
  String get undo => 'تراجع';

  @override
  String get enabledLabel => 'مفعل';

  @override
  String get itemsToDisplayLabel => 'العناصر المعروضة';

  @override
  String get itemsToDisplayDescription =>
      'عدد العناصر التي تظهر في هذه الزينة.';

  @override
  String get roleSpecificSettingsTitle => 'إعدادات مخصصة للدور';

  @override
  String get daysBetweenViewsLabel => 'الأيام بين المشاهدات';

  @override
  String get daysBetweenViewsDescription =>
      'يحدد هذا الإعداد الحد الأدنى لعدد الأيام التي يجب أن تمر قبل أن يمكن عرض هذه الزينة مرة أخرى للمستخدم، شريطة ألا يكون قد أكمل المهمة المرتبطة بها بعد.';

  @override
  String get feedDecoratorTypeLinkAccount => 'ربط الحساب';

  @override
  String get feedDecoratorTypeUpgrade => 'الترقية إلى مميز';

  @override
  String get feedDecoratorTypeRateApp => 'تقييم التطبيق';

  @override
  String get feedDecoratorTypeEnableNotifications => 'تفعيل الإشعارات';

  @override
  String get feedDecoratorTypeSuggestedTopics => 'مواضيع مقترحة';

  @override
  String get feedDecoratorTypeSuggestedSources => 'مصادر مقترحة';

  @override
  String get guestUserRole => 'مستخدم ضيف';

  @override
  String get standardUserRole => 'مستخدم عادي';

  @override
  String get premiumUserRole => 'مستخدم مميز';

  @override
  String get dashboardTitle => 'لوحة القيادة';

  @override
  String get clearSelection => 'مسح التحديد';

  @override
  String get search => 'بحث';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج.';

  @override
  String get close => 'إغلاق';

  @override
  String get apply => 'تطبيق';

  @override
  String visibleToRoleLabel(String roleName) {
    return 'مرئي لـ $roleName';
  }

  @override
  String get adPlatformConfigurationTitle => 'إعدادات منصة الإعلان';

  @override
  String get primaryAdPlatformTitle => 'منصة الإعلانات الأساسية';

  @override
  String get primaryAdPlatformDescription =>
      'اختر منصة الإعلانات الأساسية التي ستُستخدم في جميع أنحاء التطبيق.';

  @override
  String get adUnitIdentifiersTitle => 'معرفات الوحدات الإعلانية';

  @override
  String get adUnitIdentifiersDescription =>
      'تكوين معرفات الوحدات الإعلانية لمنصة الإعلانات المختارة.';

  @override
  String get feedAdSettingsTitle => 'إعدادات إعلانات الموجز';

  @override
  String get enableFeedAdsLabel => 'تفعيل إعلانات الموجز';

  @override
  String get feedAdTypeSelectionTitle => 'اختيار نوع إعلان الموجز';

  @override
  String get feedAdTypeSelectionDescription =>
      'اختر نوع الإعلانات التي ستُعرض في الموجز الرئيسي (أصلي أو بانر).';

  @override
  String get userRoleFrequencySettingsTitle => 'إعدادات تكرار دور المستخدم';

  @override
  String get userRoleFrequencySettingsDescription =>
      'تكوين تكرار الإعلانات وفترات وضعها بناءً على أدوار المستخدمين.';

  @override
  String get articleAdSettingsTitle => 'إعدادات إعلانات المقالات';

  @override
  String get enableArticleAdsLabel => 'تفعيل إعلانات المقالات';

  @override
  String get defaultInArticleAdTypeSelectionTitle =>
      'اختيار نوع الإعلان الافتراضي داخل المقال';

  @override
  String get defaultInArticleAdTypeSelectionDescription =>
      'اختر نوع الإعلانات الافتراضي الذي سيُعرض داخل المقالات (أصلي أو بانر).';

  @override
  String get inArticleAdSlotPlacementsTitle => 'مواضع الإعلانات داخل المقال';

  @override
  String get inArticleAdSlotPlacementsDescription =>
      'تفعيل أو تعطيل فتحات إعلانية محددة داخل محتوى المقال.';

  @override
  String get feedNativeAdIdLabel => 'معرف الإعلان الأصلي للموجز';

  @override
  String get feedNativeAdIdDescription =>
      'معرف وحدة الإعلانات الأصلية في الموجز.';

  @override
  String get feedBannerAdIdLabel => 'معرف إعلان البانر للموجز';

  @override
  String get feedBannerAdIdDescription => 'معرف وحدة إعلانات البانر في الموجز.';

  @override
  String get articleInterstitialAdIdLabel => 'معرف الإعلان البيني للمقالات';

  @override
  String get articleInterstitialAdIdDescription =>
      'معرف وحدة الإعلانات البينية في المقالات.';

  @override
  String get inArticleNativeAdIdLabel => 'معرف الإعلان الأصلي داخل المقال';

  @override
  String get inArticleNativeAdIdDescription =>
      'معرف وحدة الإعلانات الأصلية داخل المقالات.';

  @override
  String get inArticleBannerAdIdLabel => 'معرف إعلان البانر داخل المقال';

  @override
  String get inArticleBannerAdIdDescription =>
      'معرف وحدة إعلانات البانر داخل المقالات.';

  @override
  String get inArticleAdSlotTypeAboveArticleContinueReadingButton =>
      'فوق زر \'متابعة القراءة\'';

  @override
  String get inArticleAdSlotTypeBelowArticleContinueReadingButton =>
      'أسفل زر \'متابعة القراءة\'';

  @override
  String idCopiedToClipboard(String id) {
    return 'تم نسخ المعرف \'$id\' إلى الحافظة.';
  }

  @override
  String get copyId => 'نسخ المعرف';

  @override
  String get enableGlobalAdsLabel => 'تفعيل الإعلانات';

  @override
  String get feedToArticleInterstitialAdIdLabel =>
      'معرف الإعلان البيني للانتقال من الموجز إلى المقال';

  @override
  String get feedToArticleInterstitialAdIdDescription =>
      'معرف الوحدة الإعلانية للإعلانات البينية التي تظهر عندما ينتقل المستخدم من الموجز إلى المقال.';

  @override
  String get interstitialAdSettingsTitle => 'إعدادات الإعلانات البينية';

  @override
  String get enableInterstitialAdsLabel => 'تفعيل الإعلانات البينية';

  @override
  String get userRoleInterstitialFrequencyTitle =>
      'تكرار الإعلانات البينية حسب دور المستخدم';

  @override
  String get userRoleInterstitialFrequencyDescription =>
      'تكوين عدد الانتقالات التي يجب أن يقوم بها المستخدم قبل عرض إعلان بيني، بناءً على دوره.';

  @override
  String get transitionsBeforeInterstitialAdsLabel =>
      'الانتقالات قبل الإعلانات البينية';

  @override
  String get transitionsBeforeInterstitialAdsDescription =>
      'عدد الانتقالات (مثل فتح المقالات) التي يجب أن يقوم بها المستخدم قبل عرض إعلان بيني.';

  @override
  String get adPlatformTypeAdmob => 'أدموب';

  @override
  String get nativeAdsTab => 'إعلانات أصلية';

  @override
  String get bannerAdsTab => 'إعلانات بانر';

  @override
  String get interstitialAdsTab => 'إعلانات بينية';

  @override
  String get videoAdsTab => 'إعلانات فيديو';

  @override
  String get bannerAdType => 'بانر';

  @override
  String get nativeAdType => 'أصلي';

  @override
  String get interstitialAdType => 'بيني';

  @override
  String get videoAdType => 'فيديو';

  @override
  String get rewardedAdType => 'إعلان بمكافأة';

  @override
  String get bannerAdShapeSelectionTitle => 'شكل إعلان البانر';

  @override
  String get bannerAdShapeSelectionDescription =>
      'اختر الشكل المرئي المفضل لإعلانات البانر المعروضة في المقالات.';

  @override
  String get bannerAdShapeSquare => 'مربع';

  @override
  String get bannerAdShapeRectangle => 'مستطيل';

  @override
  String get loadingDraftHeadlines => 'جاري تحميل العناوين المسودة';

  @override
  String get noDraftHeadlinesFound => 'لا توجد عناوين مسودة';

  @override
  String get publish => 'نشر';

  @override
  String get saveAsDraft => 'حفظ كمسودة';

  @override
  String get invalidFormTitle => 'نموذج غير صالح';

  @override
  String get invalidFormMessage =>
      'يرجى إكمال جميع الحقول المطلوبة قبل النشر. يمكنك الحفظ كمسودة أو تجاهل التغييرات.';

  @override
  String get completeForm => 'إكمال النموذج';

  @override
  String get discard => 'تجاهل';

  @override
  String get drafts => 'المسودات';

  @override
  String get draftsIconTooltip => 'المسودات';

  @override
  String get draftHeadlines => 'مسودات العناوين';

  @override
  String get draftTopics => 'مسودات المواضيع';

  @override
  String get draftSources => 'مسودات المصادر';

  @override
  String get saveHeadlineTitle => 'حفظ العنوان';

  @override
  String get saveHeadlineMessage => 'هل تريد نشر هذا العنوان أم حفظه كمسودة؟';

  @override
  String get saveTopicTitle => 'حفظ الموضوع';

  @override
  String get saveTopicMessage => 'هل تريد نشر هذا الموضوع أم حفظه كمسودة؟';

  @override
  String get saveSourceTitle => 'حفظ المصدر';

  @override
  String get saveSourceMessage => 'هل تريد نشر هذا المصدر أم حفظه كمسودة؟';

  @override
  String get loadingDraftTopics => 'جاري تحميل مسودات المواضيع...';

  @override
  String get noDraftTopicsFound => 'لم يتم العثور على مسودات مواضيع.';

  @override
  String topicDeleted(String topicTitle) {
    return 'تم حذف الموضوع \"$topicTitle\".';
  }

  @override
  String get loadingDraftSources => 'جاري تحميل مسودات المصادر...';

  @override
  String get noDraftSourcesFound => 'لم يتم العثور على مسودات مصادر.';

  @override
  String sourceDeleted(String sourceName) {
    return 'تم حذف المصدر \"$sourceName\".';
  }

  @override
  String get publishTopic => 'نشر الموضوع';

  @override
  String get publishSource => 'نشر المصدر';

  @override
  String enableInArticleAdsForRoleLabel(String role) {
    return 'تمكين الإعلانات داخل المقال لـ $role';
  }

  @override
  String get moreActions => 'المزيد من الإجراءات';

  @override
  String get filter => 'تصفية';

  @override
  String get applyFilters => 'تطبيق الفلاتر';

  @override
  String get filterHeadlines => 'تصفية العناوين';

  @override
  String get filterTopics => 'تصفية المواضيع';

  @override
  String get filterSources => 'تصفية المصادر';

  @override
  String get searchByHeadlineTitle => 'البحث بعنوان الخبر...';

  @override
  String get searchByTopicName => 'البحث بالاسم أو المعرف...';

  @override
  String get searchBySourceName => 'البحث بالاسم أو المعرف...';

  @override
  String get selectSources => 'اختر المصادر';

  @override
  String get selectTopics => 'اختر المواضيع';

  @override
  String get countries => 'البلدان';

  @override
  String get selectCountries => 'اختر البلدان';

  @override
  String get selectSourceTypes => 'اختر أنواع المصادر';

  @override
  String get selectLanguages => 'اختر اللغات';

  @override
  String get selectHeadquarters => 'اختر المقر الرئيسي';

  @override
  String get resetFiltersButtonText => 'إعادة تعيين الفلاتر';

  @override
  String get noResultsWithCurrentFilters =>
      'لم يتم العثور على نتائج باستخدام الفلاتر الحالية. حاول إعادة تعيينها.';

  @override
  String get aboutIconTooltip => 'حول هذه الصفحة';

  @override
  String get closeButtonText => 'إغلاق';

  @override
  String get logo => 'الشعار';

  @override
  String get userManagement => 'إدارة المستخدمين';

  @override
  String get userManagementPageDescription =>
      'إدارة مستخدمي النظام، بما في ذلك أدوارهم وأذوناتهم.';

  @override
  String get loadingUsers => 'جاري تحميل المستخدمين';

  @override
  String get noUsersFound => 'لم يتم العثور على مستخدمين.';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get appRole => 'دور التطبيق';

  @override
  String get dashboardRole => 'دور لوحة التحكم';

  @override
  String get createdAt => 'تاريخ الإنشاء';

  @override
  String get promoteToPublisher => 'ترقية إلى ناشر';

  @override
  String get demoteToUser => 'تخفيض إلى مستخدم';

  @override
  String get adminRole => 'مسؤول';

  @override
  String get publisherRole => 'ناشر';

  @override
  String get filterUsers => 'تصفية المستخدمين';

  @override
  String get searchByUserEmail => 'البحث بالبريد الإلكتروني أو المعرف...';

  @override
  String get selectAppRoles => 'اختر أدوار التطبيق';

  @override
  String get selectDashboardRoles => 'اختر أدوار لوحة التحكم';

  @override
  String get authentication => 'المصادقة';

  @override
  String get subscription => 'الاشتراك';

  @override
  String get authenticationAnonymous => 'مجهول';

  @override
  String get authenticationAuthenticated => 'موثق';

  @override
  String get subscriptionFree => 'مجاني';

  @override
  String get subscriptionPremium => 'مميز';

  @override
  String get savedHeadlineFilterLimitsTitle => 'حدود مرشحات العناوين المحفوظة';

  @override
  String get savedHeadlineFilterLimitsDescription =>
      'تعيين حدود على عدد مرشحات العناوين المحفوظة لكل فئة من فئات المستخدمين، بما في ذلك الإجمالي والمثبتة واشتراكات الإشعارات.';

  @override
  String get savedSourceFilterLimitsTitle => 'حدود مرشحات المصادر المحفوظة';

  @override
  String get savedSourceFilterLimitsDescription =>
      'تعيين حدود على عدد مرشحات المصادر المحفوظة لكل فئة من فئات المستخدمين، بما في ذلك الإجمالي والمثبتة.';

  @override
  String get totalLimitLabel => 'الحد الإجمالي';

  @override
  String get totalLimitDescription =>
      'العدد الإجمالي للمرشحات من هذا النوع التي يمكن للمستخدم إنشاؤها.';

  @override
  String get pinnedLimitLabel => 'الحد المثبت';

  @override
  String get pinnedLimitDescription =>
      'الحد الأقصى لعدد المرشحات من هذا النوع التي يمكن تثبيتها.';

  @override
  String get notificationSubscriptionLimitLabel => 'حد اشتراك الإشعارات';

  @override
  String get notificationSubscriptionLimitDescription =>
      'الحد الأقصى لعدد المرشحات التي يمكن للمستخدم الاشتراك فيها لهذا النوع من الإشعارات.';

  @override
  String get pushNotificationSubscriptionDeliveryTypeBreakingOnly =>
      'الأخبار العاجلة';

  @override
  String get pushNotificationSubscriptionDeliveryTypeDailyDigest =>
      'الملخص اليومي';

  @override
  String get pushNotificationSubscriptionDeliveryTypeWeeklyRoundup =>
      'حصاد الأسبوع';

  @override
  String get isBreakingNewsLabel => 'وضع علامة \'خبر عاجل\'';

  @override
  String get isBreakingNewsDescription =>
      'سيؤدي تمكين هذا إلى إرسال إشعار فوري لجميع المستخدمين المشتركين عند النشر.';

  @override
  String get isBreakingNewsDescriptionEdit =>
      'تغيير هذه الحالة أثناء التعديل لن يؤدي إلى إرسال إشعار فوري جديد، حيث يتم إرسال الإشعارات فقط عند الإنشاء الأولي.';

  @override
  String get confirmBreakingNewsTitle => 'تأكيد نشر خبر عاجل';

  @override
  String get confirmBreakingNewsMessage =>
      'هل أنت متأكد أنك تريد نشر هذا كخبر عاجل؟ سيؤدي هذا الإجراء إلى إرسال إشعار فوري لجميع المستخدمين المشتركين.';

  @override
  String get confirmPublishButton => 'تأكيد ونشر';

  @override
  String get cannotDraftBreakingNews =>
      'لا يمكن حفظ الأخبار العاجلة كمسودة. يرجى نشرها أو تعطيل مفتاح \'خبر عاجل\'.';

  @override
  String get ok => 'موافق';

  @override
  String get breakingNewsFilterTitle => 'تصفية الأخبار العاجلة';

  @override
  String get breakingNewsFilterAll => 'الكل';

  @override
  String get breakingNewsFilterBreakingOnly => 'العاجلة فقط';

  @override
  String get breakingNewsFilterNonBreakingOnly => 'غير العاجلة فقط';

  @override
  String get notificationsTab => 'الإشعارات';

  @override
  String get pushNotificationSettingsTitle => 'إعدادات الإشعارات الفورية';

  @override
  String get pushNotificationSettingsDescription =>
      'إدارة الإعدادات العامة لنظام الإشعارات الفورية، بما في ذلك المزود الأساسي وأنواع الإشعارات النشطة.';

  @override
  String get pushNotificationSystemStatusTitle => 'تفعيل الإشعارات';

  @override
  String get pushNotificationSystemStatusDescription =>
      'مفتاح عام لتمكين أو تعطيل جميع الإشعارات الفورية.';

  @override
  String get pushNotificationPrimaryProviderTitle => 'المزود الأساسي';

  @override
  String get pushNotificationPrimaryProviderDescription =>
      'اختر مزود الخدمة الأساسي. تأكد من أن المزود المختار قد تم إعداده بشكل صحيح في ملف .env الخاص بالواجهة الخلفية.';

  @override
  String get pushNotificationDeliveryTypesTitle => 'أنواع التسليم';

  @override
  String get pushNotificationDeliveryTypesDescription =>
      'تمكين أو تعطيل أنواع معينة من الإشعارات الفورية.';

  @override
  String get pushNotificationProviderFirebase => 'Firebase';

  @override
  String get pushNotificationProviderOneSignal => 'OneSignal';

  @override
  String get appTab => 'الإعدادات العامة';

  @override
  String get featuresTab => 'الميزات';

  @override
  String get userTab => 'المستخدم';

  @override
  String get maintenanceConfigTitle => 'وضع الصيانة';

  @override
  String get maintenanceConfigDescription =>
      'تفعيل لوضع التطبيق في وضع الصيانة، مما يمنع وصول المستخدمين.';

  @override
  String get updateConfigTitle => 'إعدادات التحديث';

  @override
  String get updateConfigDescription =>
      'تكوين تحديثات التطبيق الإلزامية للمستخدمين.';

  @override
  String get generalAppConfigTitle => 'إعدادات التطبيق العامة';

  @override
  String get generalAppConfigDescription =>
      'إدارة الإعدادات العامة للتطبيق مثل روابط شروط الخدمة وسياسة الخصوصية.';

  @override
  String get termsOfServiceUrlLabel => 'رابط شروط الخدمة';

  @override
  String get termsOfServiceUrlDescription =>
      'الرابط لصفحة شروط الخدمة للتطبيق.';

  @override
  String get privacyPolicyUrlLabel => 'رابط سياسة الخصوصية';

  @override
  String get privacyPolicyUrlDescription =>
      'الرابط لصفحة سياسة الخصوصية للتطبيق.';

  @override
  String get navigationAdConfigTitle => 'إعدادات إعلانات التنقل';

  @override
  String get enableNavigationAdsLabel => 'تفعيل إعلانات التنقل';

  @override
  String get navigationAdFrequencyTitle => 'تكرار إعلانات التنقل';

  @override
  String get navigationAdFrequencyDescription =>
      'تكوين عدد الانتقالات التي يجب أن يقوم بها المستخدم قبل عرض إعلان بيني، بناءً على دوره.';

  @override
  String get internalNavigationsBeforeAdLabel =>
      'الانتقالات الداخلية قبل الإعلان';

  @override
  String get internalNavigationsBeforeAdDescription =>
      'عدد الانتقالات الداخلية بين الصفحات التي يجب أن يقوم بها المستخدم قبل عرض إعلان بيني.';

  @override
  String get externalNavigationsBeforeAdLabel =>
      'الانتقالات الخارجية قبل الإعلان';

  @override
  String get externalNavigationsBeforeAdDescription =>
      'عدد الانتقالات الخارجية التي يجب أن يقوم بها المستخدم قبل عرض إعلان بيني.';

  @override
  String get nativeAdIdLabel => 'معرف الإعلان الأصلي';

  @override
  String get nativeAdIdDescription => 'معرف الوحدة للإعلانات الأصلية.';

  @override
  String get bannerAdIdLabel => 'معرف إعلان البانر';

  @override
  String get bannerAdIdDescription => 'معرف الوحدة لإعلانات البانر.';

  @override
  String get interstitialAdIdLabel => 'معرف الإعلان البيني';

  @override
  String get interstitialAdIdDescription => 'معرف الوحدة للإعلانات البينية.';

  @override
  String get savedHeadlinesLimitLabel => 'حد العناوين المحفوظة';

  @override
  String get savedHeadlinesLimitDescription =>
      'الحد الأقصى لعدد العناوين التي يمكن لهذا الدور المستخدم حفظها.';

  @override
  String get appUpdateManagementTitle => 'إدارة تحديثات التطبيق';

  @override
  String get feedItemClickBehaviorTitle => 'سلوك النقر على عنصر الموجز';

  @override
  String get feedItemClickBehaviorDescription =>
      'قم بتعيين المتصفح الافتراضي لفتح العناوين. يمكن للمستخدمين تجاوز هذا الإعداد في إعدادات الموجز الخاصة بهم في التطبيق.';

  @override
  String get feedItemClickBehaviorInternalNavigation => 'متصفح داخل التطبيق';

  @override
  String get feedItemClickBehaviorExternalNavigation => 'متصفح النظام';

  @override
  String get userLimitsTitle => 'حدود المستخدم';

  @override
  String get userLimitsDescription =>
      'تحديد حدود للميزات والمحتوى الخاص بالمستخدم.';

  @override
  String get appStatusAndUpdatesDescription =>
      'التحكم في الحالة التشغيلية للتطبيق وإدارة متطلبات التحديث.';

  @override
  String get advertisementsDescription =>
      'إدارة جميع إعدادات الإعلانات، بما في ذلك الضوابط العالمية والمنصات والمواضع.';

  @override
  String get notificationsDescription =>
      'تكوين نظام الإشعارات الفورية، بما في ذلك المزودين وأنواع التسليم.';

  @override
  String get feedDescription => 'التحكم في سلوك ومظهر موجز محتوى المستخدم.';

  @override
  String get notificationSubscriptionBreakingOnlyDescription =>
      'حد الاشتراكات التي ترسل تنبيهات فورية للأخبار العاجلة للعناوين المطابقة.';

  @override
  String get notificationSubscriptionDailyDigestDescription =>
      'حد الاشتراكات التي ترسل ملخصًا يوميًا للعناوين المطابقة.';

  @override
  String get notificationSubscriptionWeeklyRoundupDescription =>
      'حد الاشتراكات التي ترسل ملخصًا أسبوعيًا للعناوين المطابقة.';

  @override
  String get appStatusAndUpdatesTitle => 'حالة التطبيق والتحديثات';

  @override
  String get enableForcedUpdatesLabel => 'تفعيل التحديثات الإجبارية';

  @override
  String get enableForcedUpdatesDescription =>
      'عند التفعيل، يمكنك تحديد الحد الأدنى للإصدار المطلوب لتطبيق الجوال.';

  @override
  String get appUrlsTitle => 'روابط التطبيق';

  @override
  String get appUrlsDescription =>
      'إدارة الروابط الخارجية والداخلية المستخدمة داخل التطبيق.';

  @override
  String get communityAndEngagementTitle => 'المجتمع والمشاركة';

  @override
  String get communityAndEngagementDescription =>
      'تكوين أدوات تفاعل المستخدمين والإبلاغ. لضمان المساءلة، هذه الميزات غير متاحة للمستخدمين الضيوف داخل تطبيق الجوال، بغض النظر عن الإعدادات المكونة هنا.';

  @override
  String get userEngagementTitle => 'مشاركة المستخدم';

  @override
  String get userEngagementDescription => 'تكوين التفاعلات والتعليقات.';

  @override
  String get contentReportingTitle => 'الإبلاغ عن المحتوى';

  @override
  String get contentReportingDescription =>
      'ضع قواعد لما يمكن للمستخدمين الإبلاغ عنه.';

  @override
  String get appReviewFunnelTitle => 'مراجعات التطبيق';

  @override
  String get appReviewFunnelDescription =>
      'إدارة عملية جمع رضا المستخدم وطلب المراجعات اختياريًا.';

  @override
  String get enableEngagementFeaturesLabel => 'تفعيل ميزات المشاركة';

  @override
  String get enableEngagementFeaturesDescription =>
      'ينشط أو يعطل عالميًا جميع وظائف التفاعل والتعليق.';

  @override
  String get engagementModeLabel => 'وضع المشاركة';

  @override
  String get engagementModeDescription =>
      'يحدد ما إذا كان يمكن للمستخدمين التفاعل فقط أو إضافة تعليقات أيضًا على المحتوى.';

  @override
  String get engagementModeReactionsOnly => 'التفاعلات فقط';

  @override
  String get engagementModeReactionsAndComments => 'التفاعلات والتعليقات';

  @override
  String get enableReportingSystemLabel => 'تفعيل نظام الإبلاغ';

  @override
  String get enableReportingSystemDescription =>
      'ينشط أو يعطل عالميًا جميع خيارات الإبلاغ الموجهة للمستخدم.';

  @override
  String get enableHeadlineReportingLabel => 'تفعيل الإبلاغ عن العناوين';

  @override
  String get enableSourceReportingLabel => 'تفعيل الإبلاغ عن المصادر';

  @override
  String get enableCommentReportingLabel => 'تفعيل الإبلاغ عن التعليقات';

  @override
  String get enableAppFeedbackSystemLabel => 'تفعيل نظام ملاحظات التطبيق';

  @override
  String get enableAppFeedbackSystemDescription =>
      'ينشط النظام الداخلي الذي يسأل المستخدمين بشكل دوري عما إذا كانوا يستمتعون بالتطبيق.';

  @override
  String get interactionCycleThresholdLabel => 'عتبة دورة التفاعل';

  @override
  String get interactionCycleThresholdDescription =>
      'يحدد عدد الإجراءات الإيجابية (مثل الحفظ، الإعجاب) المطلوبة لتشغيل موجه الاستمتاع. يظهر الموجه في كل مرة يكون فيها إجمالي الإجراءات الإيجابية للمستخدم من مضاعفات هذا الرقم.';

  @override
  String get initialPromptCooldownLabel => 'فترة تهدئة الموجه الأولي (أيام)';

  @override
  String get initialPromptCooldownDescription =>
      'عدد الأيام التي يجب الانتظار فيها قبل إظهار مطالبة الاستمتاع للمرة الأولى. تضمن فترة التهدئة هذه عدم سؤال المستخدمين حتى يستخدموا التطبيق بما فيه الكفاية.';

  @override
  String get requestStoreReviewLabel => 'طلب مراجعة المتجر بعد \'نعم\'';

  @override
  String get requestStoreReviewDescription =>
      'إذا تم التمكين، سيُعرض للمستخدمين الذين يجيبون بـ \'نعم\' على موجه الاستمتاع مربع حوار مراجعة متجر نظام التشغيل الرسمي.';

  @override
  String get requestWrittenFeedbackLabel => 'طلب ملاحظات مكتوبة بعد \'لا\'';

  @override
  String get requestWrittenFeedbackDescription =>
      'إذا تم التمكين، سيُطلب من المستخدمين الذين يجيبون بـ \'لا\' تقديم ملاحظات مكتوبة مباشرة إلى فريق التطوير.';

  @override
  String get internalPromptLogicTitle => 'منطق الموجه الداخلي';

  @override
  String get eligiblePositiveInteractionsTitle => 'التفاعلات الإيجابية المؤهلة';

  @override
  String get positiveInteractionTypeSaveItem => 'حفظ عنصر محتوى';

  @override
  String get positiveInteractionTypeFollowItem => 'متابعة كيان ';

  @override
  String get positiveInteractionTypeShareContent => 'مشاركة عنصر محتوى';

  @override
  String get positiveInteractionTypeSaveFilter => 'إنشاء مرشح محفوظ';

  @override
  String get followUpActionsTitle => 'إجراءات المتابعة';

  @override
  String get enableCommunityFeaturesLabel => 'تفعيل ميزات المجتمع';

  @override
  String get enableCommunityFeaturesDescription =>
      'ينشط أو يعطل عالميًا جميع الوظائف المتعلقة بالمجتمع، بما في ذلك المشاركة والإبلاغ.';

  @override
  String get communityManagementPageDescription =>
      'إدارة المحتوى الذي ينشئه المستخدمون بما في ذلك التفاعلات (ردود الفعل والتعليقات) وتبليغات المحتوى ومراجعات التطبيق.';

  @override
  String get engagements => 'التفاعلات';

  @override
  String get reports => 'التبليغات';

  @override
  String get appReviews => 'مراجعات التطبيق';

  @override
  String get user => 'المستخدم';

  @override
  String get engagedContent => 'المحتوى المتفاعل معه';

  @override
  String get reaction => 'رد الفعل';

  @override
  String get comment => 'التعليق';

  @override
  String get commentStatus => 'حالة التعليق';

  @override
  String get hasCommentFilterLabel => 'تحتوي على تعليقات';

  @override
  String get hasCommentFilterDescription =>
      'إظهار التفاعلات التي تتضمن تعليقًا نصيًا فقط.';

  @override
  String get date => 'التاريخ';

  @override
  String get approveComment => 'الموافقة على التعليق';

  @override
  String get rejectComment => 'رفض التعليق';

  @override
  String get viewEngagedContent => 'عرض المحتوى';

  @override
  String get copyUserId => 'نسخ معرف المستخدم';

  @override
  String get reporter => 'المبلغ';

  @override
  String get reportedItem => 'العنصر المبلغ عنه';

  @override
  String get reason => 'السبب';

  @override
  String get reportStatus => 'حالة البلاغ';

  @override
  String get viewReportedItem => 'عرض العنصر';

  @override
  String get markAsInReview => 'وضع علامة \'قيد المراجعة\'';

  @override
  String get resolveReport => 'حل البلاغ';

  @override
  String get initialFeedback => 'التقييم الأولي';

  @override
  String get osPromptRequested => 'طُلب تقييم النظام؟';

  @override
  String get feedbackHistory => 'سجل التقييمات';

  @override
  String get lastInteraction => 'آخر تفاعل';

  @override
  String get viewFeedbackHistory => 'عرض السجل';

  @override
  String get reactionTypeLike => 'إعجاب';

  @override
  String get reactionTypeInsightful => 'ثاقب';

  @override
  String get reactionTypeAmusing => 'مسلي';

  @override
  String get reactionTypeSad => 'حزين';

  @override
  String get reactionTypeAngry => 'غاضب';

  @override
  String get reactionTypeSkeptical => 'متشكك';

  @override
  String get initialAppReviewFeedbackPositive => 'إيجابي';

  @override
  String get initialAppReviewFeedbackNegative => 'سلبي';

  @override
  String get filterCommunity => 'تصفية محتوى المجتمع';

  @override
  String get searchByEngagementUser => 'البحث بالبريد الإلكتروني للمستخدم...';

  @override
  String get searchByReportReporter => 'البحث بالبريد الإلكتروني للمبلغ...';

  @override
  String get searchByAppReviewUser => 'البحث بالبريد الإلكتروني للمستخدم...';

  @override
  String get selectCommentStatus => 'اختر حالة التعليق';

  @override
  String get selectReportStatus => 'اختر حالة البلاغ';

  @override
  String get selectInitialFeedback => 'اختر التقييم الأولي';

  @override
  String get selectReportableEntity => 'اختر نوع العنصر المبلغ عنه';

  @override
  String get reportableEntityHeadline => 'عنوان';

  @override
  String get reportableEntitySource => 'مصدر';

  @override
  String get reportableEntityComment => 'تعليق';

  @override
  String get noEngagementsFound => 'لم يتم العثور على تفاعلات.';

  @override
  String get noReportsFound => 'لم يتم العثور على بلاغات.';

  @override
  String get noAppReviewsFound => 'لم يتم العثور على مراجعات للتطبيق.';

  @override
  String get loadingEngagements => 'جاري تحميل التفاعلات';

  @override
  String get loadingReports => 'جاري تحميل البلاغات';

  @override
  String get loadingAppReviews => 'جاري تحميل مراجعات التطبيق';

  @override
  String get userIdCopied => 'تم نسخ معرف المستخدم إلى الحافظة.';

  @override
  String get reportStatusUpdated => 'تم تحديث حالة البلاغ.';

  @override
  String feedbackHistoryForUser(String email) {
    return 'سجل التقييمات للمستخدم $email';
  }

  @override
  String get noFeedbackHistory => 'لا يوجد سجل تقييمات متاح لهذا المستخدم.';

  @override
  String feedbackProvidedAt(String date) {
    return 'تم تقديم التقييم في: $date';
  }

  @override
  String feedbackReason(String reason) {
    return 'السبب: $reason';
  }

  @override
  String get noReasonProvided => 'لم يتم تقديم سبب.';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get reportReasonMisinformationOrFakeNews =>
      'معلومات مضللة / أخبار كاذبة';

  @override
  String get reportReasonClickbaitTitle => 'عنوان مضلل';

  @override
  String get reportReasonOffensiveOrHateSpeech => 'محتوى مسيء / خطاب كراهية';

  @override
  String get reportReasonSpamOrScam => 'بريد مزعج / احتيال';

  @override
  String get reportReasonBrokenLink => 'رابط معطل';

  @override
  String get reportReasonPaywalled => 'يتطلب اشتراكًا مدفوعًا';

  @override
  String get reportReasonLowQualityJournalism => 'صحافة منخفضة الجودة';

  @override
  String get reportReasonHighAdDensity => 'كثافة إعلانات عالية';

  @override
  String get reportReasonBlog => 'مدونة';

  @override
  String get reportReasonGovernmentSource => 'مصدر حكومي';

  @override
  String get reportReasonAggregator => 'مجمع أخبار';

  @override
  String get reportReasonOther => 'آخر';

  @override
  String get reportReasonFrequentPaywalls => 'اشتراكات مدفوعة متكررة';

  @override
  String get reportReasonImpersonation => 'انتحال شخصية';

  @override
  String get noNegativeFeedbackHistory =>
      'لم يتم العثور على سجل تقييمات سلبية لهذا المستخدم.';

  @override
  String get reject => 'رفض';

  @override
  String get commentStatusFlaggedByAi => 'تم الإبلاغ بواسطة الذكاء الاصطناعي';

  @override
  String get cancel => 'إلغاء';

  @override
  String get rejectCommentConfirmation =>
      'هل أنت متأكد أنك تريد رفض وحذف هذا التعليق نهائيًا؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get searchByUserId => 'ابحث باستخدام معرّف المستخدم...';

  @override
  String get viewReportedHeadline => 'عرض العنوان';

  @override
  String get viewReportedSource => 'عرض المصدر';

  @override
  String get viewReportedComment => 'عرض التعليق';

  @override
  String get entityType => 'نوع الكيان';

  @override
  String get feedback => 'التقييم';

  @override
  String get feedbackDetails => 'تفاصيل التقييم';

  @override
  String get moderationStatusPendingReview => 'قيد المراجعة';

  @override
  String get moderationStatusResolved => 'تم الحل';

  @override
  String get hasComment => 'يحتوي على تعليق';

  @override
  String get any => 'الكل';

  @override
  String get withComment => 'مع تعليق';

  @override
  String get withoutComment => 'بدون تعليق';

  @override
  String get reportResolved => 'تم حل البلاغ.';

  @override
  String get commentApproved => 'تمت الموافقة على التعليق.';

  @override
  String get commentRejected => 'تم رفض التعليق.';

  @override
  String get copyHeadlineId => 'نسخ معرّف العنوان';

  @override
  String get copyReportedItemId => 'نسخ معرّف العنصر المُبلغ عنه';

  @override
  String get viewFeedbackDetails => 'عرض تفاصيل التقييم';

  @override
  String get reportDetails => 'تفاصيل البلاغ';

  @override
  String get commentDetails => 'تفاصيل التعليق';

  @override
  String get communityManagement => 'إدارة المجتمع';

  @override
  String get navContent => 'المحتوى';

  @override
  String get navUsers => 'المستخدمون';

  @override
  String get navCommunity => 'المجتمع';

  @override
  String get confirmPromotionTitle => 'تأكيد الترقية';

  @override
  String confirmPromotionMessage(String email) {
    return 'هل أنت متأكد أنك تريد ترقية $email إلى ناشر؟';
  }

  @override
  String get confirmDemotionTitle => 'تأكيد التخفيض';

  @override
  String confirmDemotionMessage(String email) {
    return 'هل أنت متأكد أنك تريد تخفيض رتبة $email إلى مستخدم عادي؟';
  }

  @override
  String get premiumUserTooltip => 'مستخدم مميز';

  @override
  String get adminUserTooltip => 'مسؤول';

  @override
  String get publisherUserTooltip => 'ناشر';

  @override
  String get breakingNewsHint => 'هذا عنوان خبر عاجل';

  @override
  String get breakingNewsFilterDescription =>
      'إظهار عناوين الأخبار العاجلة فقط';

  @override
  String publishItemTitle(String itemType) {
    return 'نشر $itemType؟';
  }

  @override
  String publishItemContent(String itemType) {
    return 'هل أنت متأكد أنك تريد نشر هذا الـ $itemType؟ سيصبح مرئيًا للعامة.';
  }

  @override
  String archiveItemTitle(String itemType) {
    return 'أرشفة $itemType؟';
  }

  @override
  String archiveItemContent(String itemType) {
    return 'هل أنت متأكد أنك تريد أرشفة هذا الـ $itemType؟ سيتم إخفاؤه عن العرض العام.';
  }

  @override
  String restoreItemTitle(String itemType) {
    return 'استعادة $itemType؟';
  }

  @override
  String restoreItemContent(String itemType) {
    return 'هل أنت متأكد أنك تريد استعادة هذا الـ $itemType؟ سيصبح نشطًا ومرئيًا للعامة مرة أخرى.';
  }

  @override
  String deleteItemTitle(String itemType) {
    return 'حذف $itemType؟';
  }

  @override
  String deleteItemContent(String itemType) {
    return 'هل أنت متأكد أنك تريد حذف هذا الـ $itemType؟ يمكن التراجع عن هذا الإجراء لفترة قصيرة.';
  }

  @override
  String itemDeletedSnackbar(String itemType, String itemName) {
    return 'تم حذف $itemType \"$itemName\".';
  }

  @override
  String get adPlatformConfigurationDescription =>
      'اختر مزود الإعلانات الأساسي وقم بتكوين معرفات الوحدات الإعلانية الخاصة به.';

  @override
  String get feedAdSettingsDescription =>
      'تحكم في رؤية الإعلانات ونوعها وتكرارها داخل موجز محتوى المستخدم.';

  @override
  String get navigationAdConfigDescription =>
      'تكوين الإعلانات البينية التي تظهر أثناء تنقل المستخدم.';

  @override
  String get feedDecoratorLinkAccountDescription =>
      'يطالب المستخدمين الضيوف بإنشاء حساب كامل.';

  @override
  String get feedDecoratorUpgradeDescription =>
      'يطالب المستخدمين العاديين بالترقية إلى اشتراك مميز.';

  @override
  String get feedDecoratorRateAppDescription =>
      'يطالب المستخدمين بتقييم التطبيق في متجر التطبيقات.';

  @override
  String get feedDecoratorEnableNotificationsDescription =>
      'يطالب المستخدمين بتمكين الإشعارات الفورية.';

  @override
  String get feedDecoratorSuggestedTopicsDescription =>
      'يعرض مجموعة من المواضيع التي قد يهتم المستخدم بمتابعتها.';

  @override
  String get feedDecoratorSuggestedSourcesDescription =>
      'يعرض مجموعة من المصادر التي قد يهتم المستخدم بمتابعتها.';

  @override
  String get enableGlobalAdsDescription =>
      'ينشط أو يعطل عالميًا جميع الإعلانات داخل التطبيق.';

  @override
  String get enableFeedAdsDescription =>
      'يتحكم في رؤية جميع الإعلانات داخل موجزات المحتوى.';

  @override
  String visibleToRoleDescription(String roleName) {
    return 'عند التمكين، ستكون هذه الميزة نشطة للمستخدمين الذين لديهم دور \'$roleName\'.';
  }

  @override
  String get enableDecoratorDescription =>
      'ينشط أو يعطل عالميًا هذه الزينة لجميع المستخدمين المؤهلين.';

  @override
  String get enableNavigationAdsDescription =>
      'يتحكم في رؤية الإعلانات البينية التي تظهر أثناء تنقل المستخدم.';

  @override
  String get enableHeadlineReportingDescription =>
      'يسمح للمستخدمين بالإبلاغ عن العناوين الفردية لمشاكل مثل المعلومات المضللة أو العناوين المضللة.';

  @override
  String get enableSourceReportingDescription =>
      'يسمح للمستخدمين بالإبلاغ عن مصادر الأخبار بأكملها لمشاكل مثل الجودة المنخفضة أو التحيز.';

  @override
  String get enableCommentReportingDescription =>
      'يسمح للمستخدمين بالإبلاغ عن التعليقات الفردية للإشراف عليها.';

  @override
  String get pushNotificationDeliveryTypeBreakingOnlyDescription =>
      'تفعيل للسماح للمستخدمين بالاشتراك في التنبيهات الفورية للأخبار العاجلة.';

  @override
  String get pushNotificationDeliveryTypeDailyDigestDescription =>
      'تفعيل للسماح للمستخدمين بالاشتراك في ملخص يومي للأخبار ذات الصلة.';

  @override
  String get pushNotificationDeliveryTypeWeeklyRoundupDescription =>
      'تفعيل للسماح للمستخدمين بالاشتراك في ملخص أسبوعي للأخبار ذات الصلة.';

  @override
  String get positiveInteractionTypeSaveItemDescription =>
      'يحتسب عندما يحفظ المستخدم عنوان رئيسي.';

  @override
  String get positiveInteractionTypeFollowItemDescription =>
      'يحتسب عندما يتابع المستخدم موضوعًا أو مصدرًا أو بلدًا مثل لعنوان رئيسي.';

  @override
  String get positiveInteractionTypeShareContentDescription =>
      'يحتسب عندما يشارك المستخدم عنوان رئيسي.';

  @override
  String get positiveInteractionTypeSaveFilterDescription =>
      'يحتسب عندما ينشئ المستخدم مرشحًا محفوظًا.';

  @override
  String get internalPromptLogicDescription =>
      'تحديد الشروط التي تؤدي إلى ظهور موجه الاستمتاع، مثل عدد إجراءات المستخدم وفترات التهدئة.';

  @override
  String get eligiblePositiveInteractionsDescription =>
      'اختر إجراءات المستخدم التي تُحتسب \'كتفاعلات إيجابية\' لتشغيل موجه الاستمتاع.';

  @override
  String get followUpActionsDescription =>
      'تكوين ما يحدث بعد استجابة المستخدم لموجه الاستمتاع، مثل طلب مراجعة المتجر.';

  @override
  String get analyticsTab => 'التحليلات';

  @override
  String get analyticsDescription =>
      'تكوين مزود التحليلات، وتسجيل الأحداث، ومعدلات أخذ العينات.';

  @override
  String get analyticsSystemStatusTitle => 'تفعيل نظام التحليلات';

  @override
  String get analyticsSystemStatusDescription =>
      'مفتاح رئيسي لتفعيل أو تعطيل جميع عمليات تتبع التحليلات.';

  @override
  String get analyticsProviderTitle => 'المزود النشط';

  @override
  String get analyticsProviderDescription =>
      'اختر مزود خدمة التحليلات الأساسي.';

  @override
  String get analyticsEventsTitle => 'تكوين الأحداث';

  @override
  String get analyticsEventsDescription =>
      'ضبط دقيق لتسجيل أحداث محددة. قم بتعطيل الأحداث المزعجة أو تعديل معدلات أخذ العينات.';

  @override
  String samplingRateLabel(int rate) {
    return 'معدل أخذ العينات: $rate%';
  }

  @override
  String get analyticsProviderFirebase => 'Firebase';

  @override
  String get analyticsProviderMixpanel => 'Mixpanel';

  @override
  String get analyticsEventUserRegisteredLabel => 'تسجيل مستخدم جديد';

  @override
  String get analyticsEventUserRegisteredDescription =>
      'تتبع عندما يقوم مستخدم جديد بإنشاء حساب بنجاح.';

  @override
  String get analyticsEventUserLoginLabel => 'تسجيل دخول المستخدم';

  @override
  String get analyticsEventUserLoginDescription =>
      'تتبع عندما يقوم المستخدم بتسجيل الدخول إلى التطبيق.';

  @override
  String get analyticsEventAccountLinkedLabel => 'ربط الحساب';

  @override
  String get analyticsEventAccountLinkedDescription =>
      'تتبع عندما يقوم مستخدم ضيف بربط حسابه ببيانات اعتماد دائمة.';

  @override
  String get analyticsEventUserRoleChangedLabel => 'تغيير دور المستخدم';

  @override
  String get analyticsEventUserRoleChangedDescription =>
      'تتبع عندما يتم تحديث دور المستخدم (مثل الترقية إلى مميز).';

  @override
  String get analyticsEventContentViewedLabel => 'مشاهدة المحتوى';

  @override
  String get analyticsEventContentViewedDescription =>
      'تتبع عندما يشاهد المستخدم عنوانًا أو مقالًا.';

  @override
  String get analyticsEventContentSharedLabel => 'مشاركة المحتوى';

  @override
  String get analyticsEventContentSharedDescription =>
      'تتبع عندما يشارك المستخدم المحتوى عبر منصات خارجية.';

  @override
  String get analyticsEventContentSavedLabel => 'حفظ المحتوى';

  @override
  String get analyticsEventContentSavedDescription =>
      'تتبع عندما يقوم المستخدم بحفظ عنوان في المفضلة.';

  @override
  String get analyticsEventContentUnsavedLabel => 'إلغاء حفظ المحتوى';

  @override
  String get analyticsEventContentUnsavedDescription =>
      'تتبع عندما يزيل المستخدم عنوانًا من المفضلة.';

  @override
  String get analyticsEventContentReadingTimeLabel => 'وقت قراءة المحتوى';

  @override
  String get analyticsEventContentReadingTimeDescription =>
      'تتبع المدة التي يقضيها المستخدم في قراءة مقال.';

  @override
  String get analyticsEventReactionCreatedLabel => 'إضافة رد فعل';

  @override
  String get analyticsEventReactionCreatedDescription =>
      'تتبع عندما يتفاعل المستخدم مع المحتوى.';

  @override
  String get analyticsEventReactionDeletedLabel => 'إزالة رد فعل';

  @override
  String get analyticsEventReactionDeletedDescription =>
      'تتبع عندما يزيل المستخدم رد فعله.';

  @override
  String get analyticsEventCommentCreatedLabel => 'نشر تعليق';

  @override
  String get analyticsEventCommentCreatedDescription =>
      'تتبع عندما يرسل المستخدم تعليقًا جديدًا.';

  @override
  String get analyticsEventCommentDeletedLabel => 'حذف تعليق';

  @override
  String get analyticsEventCommentDeletedDescription =>
      'تتبع عندما يحذف المستخدم تعليقه الخاص.';

  @override
  String get analyticsEventReportSubmittedLabel => 'تقديم بلاغ';

  @override
  String get analyticsEventReportSubmittedDescription =>
      'تتبع عندما يبلغ المستخدم عن محتوى أو مستخدمين آخرين.';

  @override
  String get analyticsEventHeadlineFilterCreatedLabel => 'إنشاء مرشح عناوين';

  @override
  String get analyticsEventHeadlineFilterCreatedDescription =>
      'تتبع عندما ينشئ المستخدم مرشح عناوين مخصص جديد.';

  @override
  String get analyticsEventHeadlineFilterUpdatedLabel => 'تحديث مرشح عناوين';

  @override
  String get analyticsEventHeadlineFilterUpdatedDescription =>
      'تتبع عندما يعدل المستخدم مرشح عناوين موجود.';

  @override
  String get analyticsEventHeadlineFilterUsedLabel => 'استخدام مرشح عناوين';

  @override
  String get analyticsEventHeadlineFilterUsedDescription =>
      'تتبع عندما يطبق المستخدم مرشح عناوين محفوظ.';

  @override
  String get analyticsEventSourceFilterCreatedLabel => 'إنشاء مرشح مصادر';

  @override
  String get analyticsEventSourceFilterCreatedDescription =>
      'تتبع عندما ينشئ المستخدم مرشح مصادر جديد.';

  @override
  String get analyticsEventSourceFilterUpdatedLabel => 'تحديث مرشح مصادر';

  @override
  String get analyticsEventSourceFilterUpdatedDescription =>
      'تتبع عندما يعدل المستخدم مرشح مصادر موجود.';

  @override
  String get analyticsEventSearchPerformedLabel => 'إجراء بحث';

  @override
  String get analyticsEventSearchPerformedDescription =>
      'تتبع عندما يقوم المستخدم بإجراء استعلام بحث.';

  @override
  String get analyticsEventAppReviewPromptRespondedLabel =>
      'استجابة لطلب التقييم';

  @override
  String get analyticsEventAppReviewPromptRespondedDescription =>
      'تتبع استجابات المستخدم للموجه الداخلي \'هل تستمتع بالتطبيق؟\'.';

  @override
  String get analyticsEventAppReviewStoreRequestedLabel => 'طلب تقييم المتجر';

  @override
  String get analyticsEventAppReviewStoreRequestedDescription =>
      'تتبع عندما يتم طلب مربع حوار مراجعة المتجر الأصلي لنظام التشغيل.';

  @override
  String get analyticsEventLimitExceededLabel => 'تجاوز الحد';

  @override
  String get analyticsEventLimitExceededDescription =>
      'تتبع عندما يصل المستخدم إلى حد الاستخدام (مثل حد العناصر المحفوظة).';

  @override
  String get analyticsEventLimitExceededCtaClickedLabel =>
      'النقر على إجراء الحد';

  @override
  String get analyticsEventLimitExceededCtaClickedDescription =>
      'تتبع النقرات على أزرار \'ترقية\' أو \'ربط الحساب\' في مربعات حوار الحدود.';

  @override
  String get analyticsEventPaywallPresentedLabel => 'ظهور جدار الدفع';

  @override
  String get analyticsEventPaywallPresentedDescription =>
      'تتبع عندما يتم عرض شاشة جدار الدفع للمستخدم.';

  @override
  String get analyticsEventSubscriptionStartedLabel => 'بدء الاشتراك';

  @override
  String get analyticsEventSubscriptionStartedDescription =>
      'تتبع عندما يبدأ المستخدم اشتراكًا جديدًا بنجاح.';

  @override
  String get analyticsEventSubscriptionRenewedLabel => 'تجديد الاشتراك';

  @override
  String get analyticsEventSubscriptionRenewedDescription =>
      'تتبع عندما يتم تجديد الاشتراك تلقائيًا أو يدويًا.';

  @override
  String get analyticsEventSubscriptionCancelledLabel => 'إلغاء الاشتراك';

  @override
  String get analyticsEventSubscriptionCancelledDescription =>
      'تتبع عندما يقوم المستخدم بإلغاء اشتراكه.';

  @override
  String get analyticsEventSubscriptionEndedLabel => 'انتهاء الاشتراك';

  @override
  String get analyticsEventSubscriptionEndedDescription =>
      'تتبع عندما تنتهي صلاحية الاشتراك أو يتم إنهاؤه.';

  @override
  String get analyticsEventAdImpressionLabel => 'ظهور إعلان';

  @override
  String get analyticsEventAdImpressionDescription =>
      'تتبع عندما يتم عرض إعلان للمستخدم.';

  @override
  String get analyticsEventAdClickedLabel => 'النقر على إعلان';

  @override
  String get analyticsEventAdClickedDescription =>
      'تتبع عندما ينقر المستخدم على إعلان.';

  @override
  String get analyticsEventAdLoadFailedLabel => 'فشل تحميل الإعلان';

  @override
  String get analyticsEventAdLoadFailedDescription =>
      'تتبع الأخطاء عند محاولة تحميل الإعلانات.';

  @override
  String get analyticsEventAdRewardEarnedLabel => 'كسب مكافأة الإعلان';

  @override
  String get analyticsEventAdRewardEarnedDescription =>
      'تتبع عندما يكمل المستخدم إجراء إعلان بمكافأة.';

  @override
  String get analyticsEventThemeChangedLabel => 'تغيير السمة';

  @override
  String get analyticsEventThemeChangedDescription =>
      'تتبع عندما يغير المستخدم سمة التطبيق.';

  @override
  String get analyticsEventLanguageChangedLabel => 'تغيير اللغة';

  @override
  String get analyticsEventLanguageChangedDescription =>
      'تتبع عندما يغير المستخدم لغة التطبيق.';

  @override
  String get analyticsEventFeedDensityChangedLabel => 'تغيير كثافة الموجز';

  @override
  String get analyticsEventFeedDensityChangedDescription =>
      'تتبع عندما يعدل المستخدم كثافة المعلومات في الموجز.';

  @override
  String get analyticsEventBrowserChoiceChangedLabel => 'تغيير تفضيل المتصفح';

  @override
  String get analyticsEventBrowserChoiceChangedDescription =>
      'تتبع عندما يغير المستخدم متصفحه المفضل لفتح الروابط.';

  @override
  String get analyticsEventSourceFilterUsedLabel => 'استخدام مرشح مصادر';

  @override
  String get analyticsEventSourceFilterUsedDescription =>
      'تتبع عندما يطبق المستخدم مرشح مصادر محفوظ.';

  @override
  String get analyticsEventAppTourStartedLabel => 'بدء جولة التطبيق';

  @override
  String get analyticsEventAppTourStartedDescription =>
      'تتبع عندما يتم عرض جولة التطبيق قبل المصادقة.';

  @override
  String get analyticsEventAppTourStepViewedLabel =>
      'مشاهدة خطوة في جولة التطبيق';

  @override
  String get analyticsEventAppTourStepViewedDescription =>
      'تتبع كل مشاهدة صفحة داخل جولة التطبيق.';

  @override
  String get analyticsEventAppTourCompletedLabel => 'إكمال جولة التطبيق';

  @override
  String get analyticsEventAppTourCompletedDescription =>
      'تتبع عندما يكمل المستخدم جولة التطبيق.';

  @override
  String get analyticsEventAppTourSkippedLabel => 'تخطي جولة التطبيق';

  @override
  String get analyticsEventAppTourSkippedDescription =>
      'تتبع إذا قام المستخدم بتخطي جولة التطبيق.';

  @override
  String get analyticsEventInitialPersonalizationStartedLabel =>
      'بدء التخصيص الأولي';

  @override
  String get analyticsEventInitialPersonalizationStartedDescription =>
      'تتبع عندما يبدأ تدفق التخصيص بعد المصادقة.';

  @override
  String get analyticsEventInitialPersonalizationStepViewedLabel =>
      'مشاهدة خطوة التخصيص';

  @override
  String get analyticsEventInitialPersonalizationStepViewedDescription =>
      'تتبع كل مشاهدة خطوة داخل تدفق التخصيص.';

  @override
  String get analyticsEventInitialPersonalizationCompletedLabel =>
      'إكمال التخصيص';

  @override
  String get analyticsEventInitialPersonalizationCompletedDescription =>
      'تتبع عندما يكمل المستخدم تدفق التخصيص.';

  @override
  String get analyticsEventInitialPersonalizationSkippedLabel => 'تخطي التخصيص';

  @override
  String get analyticsEventInitialPersonalizationSkippedDescription =>
      'تتبع إذا قام المستخدم بتخطي تدفق التخصيص.';

  @override
  String get timeFrameDay => '24س';

  @override
  String get timeFrameWeek => '7ي';

  @override
  String get timeFrameMonth => '30ي';

  @override
  String get timeFrameYear => 'سنة';

  @override
  String get noDataAvailable => 'لا توجد بيانات';

  @override
  String get vsPreviousPeriod => 'مقارنة بالفترة السابقة';

  @override
  String get vsPreviousDay => 'مقارنة بـ ٢٤ ساعة الماضية';

  @override
  String get vsPreviousWeek => 'مقارنة بـ ٧ أيام الماضية';

  @override
  String get vsPreviousMonth => 'مقارنة بـ ٣٠ يوم الماضية';

  @override
  String get vsPreviousYear => 'مقارنة بالسنة الماضية';

  @override
  String get kpiUsersTotalRegistered => 'إجمالي المستخدمين المسجلين';

  @override
  String get kpiUsersNewRegistrations => 'تسجيلات جديدة';

  @override
  String get kpiUsersActiveUsers => 'المستخدمون النشطون';

  @override
  String get kpiContentHeadlinesTotalPublished => 'إجمالي العناوين المنشورة';

  @override
  String get kpiContentHeadlinesTotalViews => 'إجمالي مشاهدات العناوين';

  @override
  String get kpiContentHeadlinesTotalLikes => 'إجمالي الإعجابات';

  @override
  String get kpiContentSourcesTotalSources => 'إجمالي المصادر';

  @override
  String get kpiContentSourcesNewSources => 'مصادر جديدة';

  @override
  String get kpiContentSourcesTotalFollowers => 'إجمالي متابعي المصادر';

  @override
  String get kpiContentTopicsTotalTopics => 'إجمالي المواضيع';

  @override
  String get kpiContentTopicsNewTopics => 'مواضيع جديدة';

  @override
  String get kpiContentTopicsTotalFollowers => 'إجمالي متابعي المواضيع';

  @override
  String get kpiEngagementsTotalReactions => 'إجمالي التفاعلات';

  @override
  String get kpiEngagementsTotalComments => 'إجمالي التعليقات';

  @override
  String get kpiEngagementsAverageEngagementRate => 'معدل التفاعل';

  @override
  String get kpiEngagementsReportsPending => 'بلاغات قيد الانتظار';

  @override
  String get kpiEngagementsReportsResolved => 'بلاغات تم حلها';

  @override
  String get kpiEngagementsReportsAverageResolutionTime => 'متوسط وقت الحل';

  @override
  String get kpiEngagementsAppReviewsTotalFeedback => 'إجمالي الملاحظات';

  @override
  String get kpiEngagementsAppReviewsPositiveFeedback => 'ملاحظات إيجابية';

  @override
  String get kpiEngagementsAppReviewsStoreRequests => 'طلبات تقييم المتجر';

  @override
  String get chartUsersRegistrationsOverTime => 'التسجيلات عبر الزمن';

  @override
  String get chartUsersActiveUsersOverTime => 'اتجاه المستخدمين النشطين';

  @override
  String get chartUsersRoleDistribution => 'توزيع أدوار المستخدمين';

  @override
  String get chartContentHeadlinesViewsOverTime => 'اتجاه المشاهدات';

  @override
  String get chartContentHeadlinesLikesOverTime => 'اتجاه الإعجابات';

  @override
  String get chartContentHeadlinesViewsByTopic => 'المشاهدات حسب الموضوع';

  @override
  String get chartContentSourcesHeadlinesPublishedOverTime => 'نشاط المصادر';

  @override
  String get chartContentSourcesFollowersOverTime => 'نمو متابعي المصادر';

  @override
  String get chartContentSourcesEngagementByType => 'التفاعل حسب نوع المصدر';

  @override
  String get chartContentTopicsFollowersOverTime => 'نمو متابعي المواضيع';

  @override
  String get chartContentTopicsHeadlinesPublishedOverTime => 'نشاط المواضيع';

  @override
  String get chartContentTopicsEngagementByTopic => 'التفاعل حسب الموضوع';

  @override
  String get chartEngagementsReactionsOverTime => 'اتجاه التفاعلات';

  @override
  String get chartEngagementsCommentsOverTime => 'اتجاه التعليقات';

  @override
  String get chartEngagementsReactionsByType => 'توزيع التفاعلات';

  @override
  String get chartEngagementsReportsSubmittedOverTime => 'البلاغات المقدمة';

  @override
  String get chartEngagementsReportsResolutionTimeOverTime => 'اتجاه وقت الحل';

  @override
  String get chartEngagementsReportsByReason => 'البلاغات حسب السبب';

  @override
  String get chartEngagementsAppReviewsFeedbackOverTime => 'اتجاه الملاحظات';

  @override
  String get chartEngagementsAppReviewsPositiveVsNegative => 'تحليل المشاعر';

  @override
  String get chartEngagementsAppReviewsStoreRequestsOverTime =>
      'اتجاه طلبات المتجر';

  @override
  String get chartContentSourcesStatusDistribution => 'توزيع حالة المصادر';

  @override
  String get chartContentHeadlinesBreakingNewsDistribution =>
      'توزيع الأخبار العاجلة';

  @override
  String get chartOverviewAppTourFunnel => 'قمع جولة التطبيق';

  @override
  String get chartOverviewInitialPersonalizationFunnel => 'قمع التخصيص الأولي';

  @override
  String get rankedListOverviewHeadlinesMostViewed => 'العناوين الأكثر مشاهدة';

  @override
  String get rankedListOverviewHeadlinesMostLiked => 'العناوين الأكثر إعجاباً';

  @override
  String get rankedListOverviewSourcesMostFollowed => 'المصادر الأكثر متابعة';

  @override
  String get rankedListOverviewTopicsMostFollowed => 'المواضيع الأكثر متابعة';

  @override
  String get subscriptionTab => 'الاشتراكات';

  @override
  String get subscriptionDescription =>
      'تكوين خطط الاشتراك (مثل الشهرية والسنوية) المقدمة للمستخدمين. عند التمكين، سيتم مطالبة المستخدمين الذين يصلون إلى حدود استخدام الميزات بالترقية إلى فئة مميزة.';

  @override
  String get enableSubscriptionLabel => 'تفعيل ميزة الاشتراك';

  @override
  String get enableSubscriptionDescription =>
      'المفتاح الرئيسي لنظام الاشتراك. عند التمكين، يمكن للمستخدمين شراء خطط لترقية مستوى وصولهم (مثل من عادي إلى مميز).';

  @override
  String get monthlyPlanTitle => 'الخطة الشهرية';

  @override
  String get annualPlanTitle => 'الخطة السنوية';

  @override
  String get planEnabledLabel => 'تفعيل الخطة';

  @override
  String get planRecommendedLabel => 'خطة موصى بها';

  @override
  String get planRecommendedDescription => 'يبرز هذه الخطة كأفضل خيار للقيمة.';

  @override
  String get appleProductIdLabel => 'معرف منتج متجر تطبيقات أبل';

  @override
  String get googleProductIdLabel => 'معرف منتج متجر جوجل بلاي';

  @override
  String get subscriptionPlanEnablementError =>
      'الرجاء إدخال معرّف منتج واحد على الأقل لتفعيل هذه الخطة.';

  @override
  String get subscriptionPlanDisabledNotification =>
      'تم تعطيل الخطة لعدم توفر معرّفات منتجات.';

  @override
  String get subscriptionFeatureDisabledNotification =>
      'تم تعطيل ميزة الاشتراك لعدم وجود خطط نشطة.';

  @override
  String get pushNotificationFeatureDisabledNotification =>
      'تم تعطيل نظام الإشعارات لعدم وجود أنواع تسليم نشطة.';

  @override
  String get analyticsFeatureDisabledNotification =>
      'تم تعطيل نظام التحليلات لأن جميع الأحداث معطلة.';

  @override
  String get reportingFeatureDisabledNotification =>
      'تم تعطيل نظام الإبلاغ لعدم وجود خيارات إبلاغ نشطة.';

  @override
  String get appReviewFeatureDisabledNotification =>
      'تم تعطيل نظام مراجعة التطبيق لعدم تحديد أي تفاعلات إيجابية.';

  @override
  String get subscriptionsName => 'الاشتراكات';

  @override
  String get subscriptionProvider => 'مزود المتجر';

  @override
  String get accessTier => 'مستوى الوصول';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get willAutoRenew => 'تجديد تلقائي';

  @override
  String get allAccessTiers => 'جميع المستويات';

  @override
  String get subscriptionActionCopyUserId => 'نسخ معرف المستخدم';

  @override
  String get subscriptionActionCopySubscriptionId => 'نسخ معرف الاشتراك';

  @override
  String get filterSubscriptions => 'تصفية الاشتراكات';

  @override
  String get selectStatus => 'اختر الحالة';

  @override
  String get selectProvider => 'اختر المزود';

  @override
  String get selectTier => 'اختر المستوى';

  @override
  String get noSubscriptionsFound => 'لم يتم العثور على اشتراكات.';

  @override
  String get loadingSubscriptions => 'جاري تحميل الاشتراكات';

  @override
  String get searchByUserIdOrSubscriptionId =>
      'البحث بمعرف المستخدم أو معرف الاشتراك...';

  @override
  String get subscriptionsPageDescription =>
      'واجهة للقراءة فقط لمراقبة حالات اشتراك المستخدم. تتم معالجة جميع أحداث دورة حياة الاشتراك، مثل عمليات الشراء والتجديد والإلغاء، تلقائيًا بواسطة الواجهة الخلفية من خلال المزامنة عبر إشعارات الويب هوك مع متجر تطبيقات Apple و Google Play. لا تقوم لوحة التحكم هذه ببدء أو إدارة المعاملات المالية.';

  @override
  String get subscriptionStatusActive => 'نشط';

  @override
  String get subscriptionStatusGracePeriod => 'فترة سماح';

  @override
  String get subscriptionStatusBillingIssue => 'مشكلة في الفوترة';

  @override
  String get subscriptionStatusCanceled => 'ملغى';

  @override
  String get subscriptionStatusExpired => 'منتهي';

  @override
  String get storeProviderApple => 'أبل';

  @override
  String get storeProviderGoogle => 'جوجل';

  @override
  String get chartSubscriptionsActiveOverTime => 'الاشتراكات النشطة عبر الزمن';

  @override
  String get chartSubscriptionsStatusDistribution => 'توزيع حالة الاشتراكات';

  @override
  String get chartSubscriptionsByStoreProvider => 'الاشتراكات حسب المتجر';

  @override
  String get kpiRewardsAdsWatchedTotal => 'إجمالي الإعلانات المشاهدة';

  @override
  String get kpiRewardsActiveUsersCount => 'مستخدمو المكافآت النشطون';

  @override
  String get rewardsTab => 'المكافآت';

  @override
  String get rewardsDescription =>
      'تكوين المكافآت المستندة إلى الوقت لتفاعل المستخدم.';

  @override
  String get enableRewardsLabel => 'تفعيل نظام المكافآت';

  @override
  String get enableRewardsDescription =>
      'السماح للمستخدمين بكسب المكافآت من خلال مشاهدة الإعلانات.';

  @override
  String get rewardTypeAdFree => 'تجربة خالية من الإعلانات';

  @override
  String get rewardTypeDailyDigest => 'الملخص اليومي';

  @override
  String get rewardDurationDaysLabel => 'المدة (أيام)';

  @override
  String get rewardEnabledLabel => 'مفعل';

  @override
  String get chartRewardsAdsWatchedOverTime => 'اتجاه مشاهدة الإعلانات';

  @override
  String get chartRewardsActiveByType => 'المكافآت النشطة حسب النوع';

  @override
  String get feedDecoratorUnlockRewardsDescription =>
      'يطالب المستخدمين بمشاهدة إعلان لفتح الميزات المميزة مؤقتًا.';

  @override
  String get rewardDurationDaysDescription =>
      'عدد الأيام التي تظل فيها المكافأة نشطة.';

  @override
  String get rewardsManagement => 'إدارة المكافآت';

  @override
  String get rewardsManagementPageDescription =>
      'إدارة مكافآت واستحقاقات المستخدمين.';

  @override
  String get loadingRewards => 'جاري تحميل المكافآت';

  @override
  String get noRewardsFound => 'لم يتم العثور على مكافآت.';

  @override
  String get userId => 'معرف المستخدم';

  @override
  String get activeRewards => 'المكافآت النشطة';

  @override
  String get expiry => 'تاريخ الانتهاء';

  @override
  String get filterRewards => 'تصفية المكافآت';

  @override
  String get rewardType => 'نوع المكافأة';

  @override
  String get selectRewardTypes => 'اختر أنواع المكافآت';

  @override
  String get loadingAnalytics => 'جاري تحميل التحليلات';

  @override
  String get noAnalyticsDataHeadline => 'لا توجد بيانات تحليلية';

  @override
  String get noAnalyticsDataSubheadline =>
      'لا توجد بيانات لعرضها حتى الآن. تحقق مرة أخرى لاحقًا.';

  @override
  String get androidAdUnitsTitle => 'وحدات إعلانات Android';

  @override
  String get iosAdUnitsTitle => 'وحدات إعلانات iOS';

  @override
  String get rewardedAdIdLabel => 'معرف الإعلان بمكافأة';

  @override
  String get rewardedAdIdDescription => 'معرف الوحدة للإعلانات بمكافأة.';

  @override
  String get kpiRewardsGrantedTotal => 'إجمالي المكافآت الممنوحة';

  @override
  String get analyticsEventRewardsHubViewedLabel => 'مشاهدة مركز المكافآت';

  @override
  String get analyticsEventRewardsHubViewedDescription =>
      'تتبع عندما يشاهد المستخدم مركز المكافآت.';

  @override
  String get analyticsEventRewardOfferClickedLabel => 'النقر على عرض المكافأة';

  @override
  String get analyticsEventRewardOfferClickedDescription =>
      'تتبع عندما ينقر المستخدم على عرض مكافأة معين.';

  @override
  String get analyticsEventRewardGrantedLabel => 'تم منح المكافأة';

  @override
  String get analyticsEventRewardGrantedDescription =>
      'تتبع عندما يتم إصدار مكافأة بنجاح للمستخدم.';

  @override
  String get chartRewardsGrantedOverTime => 'اتجاه المكافآت الممنوحة';

  @override
  String get android => 'أندرويد';

  @override
  String get ios => 'iOS';

  @override
  String get initialPersonalizationTitle => 'التخصيص الأولي';

  @override
  String get initialPersonalizationDescription =>
      'تكوين تدفق الإعداد للمستخدمين الجدد، بما في ذلك اختيار البلد والموضوع والمصدر.';

  @override
  String get enableInitialPersonalizationLabel => 'تفعيل التخصيص الأولي';

  @override
  String get enableInitialPersonalizationDescription =>
      'إذا تم التمكين، سيتم توجيه المستخدمين الجدد خلال تدفق تخصيص بعد التسجيل.';

  @override
  String get enableCountrySelectionLabel => 'تفعيل اختيار البلد';

  @override
  String get enableCountrySelectionDescription =>
      'السماح للمستخدمين باختيار بلدهم أثناء الإعداد.';

  @override
  String get enableTopicSelectionLabel => 'تفعيل اختيار الموضوع';

  @override
  String get enableTopicSelectionDescription =>
      'السماح للمستخدمين باختيار المواضيع التي تهمهم أثناء الإعداد.';

  @override
  String get enableSourceSelectionLabel => 'تفعيل اختيار المصدر';

  @override
  String get enableSourceSelectionDescription =>
      'السماح للمستخدمين باختيار مصادر الأخبار لمتابعتها أثناء الإعداد.';

  @override
  String get minSelectionsRequiredLabel => 'الحد الأدنى للاختيارات المطلوبة';

  @override
  String get minSelectionsRequiredDescription =>
      'العدد الإجمالي للعناصر التي يجب على المستخدم تحديدها عبر جميع الفئات الممكنة للمتابعة.';

  @override
  String get onboardingTitle => 'الإعداد الأولي';

  @override
  String get onboardingDescription =>
      'إدارة تجربة المستخدم لأول مرة، بما في ذلك جولة التطبيق والتخصيص الأولي.';

  @override
  String get enableOnboardingLabel => 'تفعيل الإعداد الأولي';

  @override
  String get enableOnboardingDescription =>
      'مفتاح رئيسي لتفعيل أو تعطيل تدفق الإعداد الأولي بالكامل (جولة التطبيق والتخصيص الأولي).';

  @override
  String get appTourTitle => 'جولة التطبيق';

  @override
  String get appTourDescription =>
      'تكوين الجولة التي تسبق المصادقة والتي تظهر للمستخدمين الجدد.';

  @override
  String get enableAppTourLabel => 'تفعيل جولة التطبيق';

  @override
  String get enableAppTourDescription =>
      'إذا تم التمكين، سيتم عرض جولة موجزة لميزات التطبيق للمستخدمين قبل تسجيل الدخول.';

  @override
  String get skippableAppTourLabel => 'جولة تطبيق قابلة للتخطي';

  @override
  String get skippableAppTourDescription =>
      'إذا تم التمكين، سيكون لدى المستخدمين خيار تخطي جولة التطبيق.';

  @override
  String get skippableInitialPersonalizationLabel => 'تخصيص قابل للتخطي';

  @override
  String get skippableInitialPersonalizationDescription =>
      'إذا تم التمكين، سيكون لدى المستخدمين خيار تخطي تدفق التخصيص.';

  @override
  String get filePickingErrorMessage => 'حدث خطأ أثناء اختيار الملف.';

  @override
  String get removeImage => 'إزالة الصورة';

  @override
  String get clickToUploadImage => 'انقر لتحميل صورة';

  @override
  String get processingImage => 'جاري معالجة الصورة...';

  @override
  String get processingImageDescription => 'يتم تحسين صورتك وستظهر قريباً.';

  @override
  String get chartMediaUploadsOverTime => 'التحميلات عبر الزمن';

  @override
  String get chartMediaUploadsByPurpose => 'التحميلات حسب الغرض';

  @override
  String get chartMediaUploadsSuccessVsFailure => 'نجاح التحميل مقابل الفشل';

  @override
  String get kpiMediaTotalUploads => 'إجمالي التحميلات';

  @override
  String get kpiMediaFailedUploads => 'التحميلات الفاشلة';

  @override
  String get kpiMediaAverageUploadTime => 'متوسط وقت التحميل (ث)';

  @override
  String get updateHeadlineTitle => 'تحديث العنوان';

  @override
  String get updateHeadlineMessage =>
      'هل تريد نشر هذه التغييرات أم حفظ التحديث كمسودة؟';

  @override
  String get analyticsEventMediaUploadStartedLabel => 'بدء تحميل الوسائط';

  @override
  String get analyticsEventMediaUploadStartedDescription =>
      'تتبع عندما يبدأ المستخدم في تحميل ملف.';

  @override
  String get analyticsEventMediaUploadCompletedLabel => 'اكتمل تحميل الوسائط';

  @override
  String get analyticsEventMediaUploadCompletedDescription =>
      'تتبع عندما يكتمل تحميل ملف بنجاح.';

  @override
  String get analyticsEventMediaUploadFailedLabel => 'فشل تحميل الوسائط';

  @override
  String get analyticsEventMediaUploadFailedDescription =>
      'تتبع عندما يفشل تحميل ملف.';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get audience => 'الجمهور';

  @override
  String get content => 'المحتوى';

  @override
  String get community => 'المجتمع';

  @override
  String get monetization => 'تحقيق الدخل';

  @override
  String get configuration => 'الإعدادات';

  @override
  String get loadingConfiguration => 'جاري تحميل الإعدادات...';

  @override
  String get noConfigurationDataHeadline => 'لا توجد بيانات إعدادات';

  @override
  String get noConfigurationDataSubheadline =>
      'تعذر تحميل الإعدادات عن بعد للتطبيق.';

  @override
  String get readOnlyConfigurationView => 'عرض الإعدادات للقراءة فقط';

  @override
  String get readOnlyConfigurationViewDescription =>
      'هذه لقطة في الوقت الفعلي للقراءة فقط لإعدادات تشغيل التطبيق. لإجراء تغييرات، انتقل إلى صفحة \'التحكم المركزي\' الرئيسية.';

  @override
  String get providers => 'المزودون';
}
