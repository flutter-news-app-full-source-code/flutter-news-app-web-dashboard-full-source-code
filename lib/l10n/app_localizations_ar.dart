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
  String get contentManagementPageDescription =>
      'إدارة العناوين الإخبارية والفئات والمصادر للوحة القيادة.';

  @override
  String get headlines => 'العناوين الرئيسية';

  @override
  String get categories => 'الفئات';

  @override
  String get sources => 'المصادر';

  @override
  String get appConfiguration => 'إعدادات التطبيق';

  @override
  String get appConfigurationPageDescription =>
      'تكوين الإعدادات العامة للتطبيق المحمول، بما في ذلك حدود محتوى المستخدم، وقواعد عرض الإعلانات، والتنبيهات داخل التطبيق، وحالة التشغيل، ومعلمات التحديث الإجباري.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appConfigurationPageTitle => 'إعدادات التطبيق';

  @override
  String get userContentLimitsTab => 'حدود محتوى المستخدم';

  @override
  String get adSettingsTab => 'إعدادات الإعلانات';

  @override
  String get inAppPromptsTab => 'تنبيهات داخل التطبيق';

  @override
  String get appOperationalStatusTab => 'حالة تشغيل التطبيق';

  @override
  String get forceUpdateTab => 'تحديث إجباري';

  @override
  String get appConfigSaveSuccessMessage => 'تم حفظ إعدادات التطبيق بنجاح!';

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
  String get userContentLimitsDescription =>
      'تحدد هذه الإعدادات الحد الأقصى لعدد البلدان ومصادر الأخبار والفئات والعناوين المحفوظة التي يمكن للمستخدم متابعتها أو حفظها. تختلف الحدود حسب نوع المستخدم (ضيف، عادي، مميز) وتؤثر بشكل مباشر على المحتوى الذي يمكن للمستخدمين تنسيقه.';

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
      'الحد الأقصى لعدد البلدان أو مصادر الأخبار أو الفئات التي يمكن للمستخدم الضيف متابعتها (لكل نوع حد خاص به).';

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
      'الحد الأقصى لعدد البلدان أو مصادر الأخبار أو الفئات التي يمكن للمستخدم العادي متابعتها (لكل نوع حد خاص به).';

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
      'الحد الأقصى لعدد البلدان أو مصادر الأخبار أو الفئات التي يمكن للمستخدم المميز متابعتها (لكل نوع حد خاص به).';

  @override
  String get premiumSavedHeadlinesLimitLabel =>
      'حد العناوين المحفوظة للمستخدم المميز';

  @override
  String get premiumSavedHeadlinesLimitDescription =>
      'الحد الأقصى لعدد العناوين الرئيسية التي يمكن للمستخدم المميز حفظها.';

  @override
  String get adSettingsDescription =>
      'تتحكم هذه الإعدادات في كيفية عرض الإعلانات ضمن موجز الأخبار في التطبيق، مع قواعد مختلفة للمستخدمين الضيوف والعاديين والمميزين. تحدد \"تكرار الإعلان\" عدد مرات ظهور الإعلان، بينما تحدد \"فترة وضع الإعلان\" عدد عناصر الأخبار التي يجب عرضها قبل ظهور الإعلان الأول.';

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
  String get inAppPromptsDescription =>
      'تتحكم هذه الإعدادات في عدد مرات عرض الرسائل الخاصة داخل التطبيق أو \"التنبيهات\" للمستخدمين في موجز الأخبار الخاص بهم. تشجع هذه التنبيهات على إجراءات مثل ربط حساب (للضيوف) أو الترقية إلى اشتراك مميز (للمستخدمين الموثقين). يختلف التكرار حسب نوع المستخدم.';

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
  String get forceUpdateDescription =>
      'تتحكم هذه الإعدادات في فرض إصدار التطبيق. سيتم إجبار المستخدمين الذين يستخدمون إصدارات أقل من الحد الأدنى المسموح به على التحديث.';

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
  String get androidStoreUrlDescription =>
      'رابط التطبيق على متجر Google Play Store.';

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
  String get publishedAt => 'تاريخ النشر';

  @override
  String get actions => 'الإجراءات';

  @override
  String get unknown => 'غير معروف';

  @override
  String get loadingCategories => 'جاري تحميل الفئات';

  @override
  String get noCategoriesFound => 'لم يتم العثور على فئات.';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get description => 'الوصف';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get loadingSources => 'جاري تحميل المصادر';

  @override
  String get noSourcesFound => 'لم يتم العثور على مصادر.';

  @override
  String get sourceName => 'الاسم';

  @override
  String get sourceType => 'النوع';

  @override
  String get language => 'اللغة';

  @override
  String get editCategory => 'تعديل الفئة';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get loadingCategory => 'جاري تحميل الفئة';

  @override
  String get iconUrl => 'رابط الأيقونة';

  @override
  String get categoryUpdatedSuccessfully => 'تم تحديث الفئة بنجاح.';

  @override
  String get cannotUpdateCategoryError =>
      'لا يمكن التحديث: لم يتم تحميل بيانات الفئة الأصلية.';

  @override
  String get createCategory => 'إنشاء فئة';

  @override
  String get categoryCreatedSuccessfully => 'تم إنشاء الفئة بنجاح.';

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
  String get imageUrl => 'رابط الصورة';

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
  String get createSource => 'إنشاء مصدر';

  @override
  String get sourceCreatedSuccessfully => 'تم إنشاء المصدر بنجاح.';
}
