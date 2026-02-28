// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get authenticationPageHeadline => 'डैशबोर्ड एक्सेस';

  @override
  String get authenticationPageSubheadline =>
      'प्रशासकों और प्रकाशकों के लिए सुरक्षित साइन-इन।';

  @override
  String get authenticationEmailSignInButton => 'ईमेल के साथ साइन इन करें';

  @override
  String get emailSignInPageTitle => 'सुरक्षित ईमेल साइन-इन';

  @override
  String get requestCodePageHeadline => 'सुरक्षित ईमेल साइन-इन';

  @override
  String get requestCodePageSubheadline =>
      'सुरक्षित साइन-इन कोड प्राप्त करने के लिए अपना अधिकृत ईमेल दर्ज करें।';

  @override
  String get requestCodeEmailLabel => 'ईमेल';

  @override
  String get requestCodeEmailHint => 'your.email@example.com';

  @override
  String get accountLinkingEmailValidationError =>
      'कृपया एक मान्य ईमेल पता दर्ज करें।';

  @override
  String get requestCodeSendCodeButton => 'कोड भेजें';

  @override
  String requestCodeResendButtonCooldown(int seconds) {
    return '${seconds}s में पुनः भेजें';
  }

  @override
  String get emailCodeSentPageTitle => 'कोड सत्यापित करें';

  @override
  String emailCodeSentConfirmation(String email) {
    return 'हमने $email पर 6-अंकों का कोड भेजा है';
  }

  @override
  String get emailCodeSentInstructions =>
      'कृपया अपना इनबॉक्स जांचें और जारी रखने के लिए नीचे कोड दर्ज करें।';

  @override
  String demoVerificationCodeMessage(String code) {
    return 'डेमो मोड में, कोड का उपयोग करें: $code';
  }

  @override
  String get emailCodeVerificationHint => '6-अंकों का कोड';

  @override
  String get emailCodeValidationEmptyError => 'कोड खाली नहीं हो सकता।';

  @override
  String get emailCodeValidationLengthError => 'कोड 6 अंकों का होना चाहिए।';

  @override
  String get emailCodeVerificationButtonLabel => 'कोड सत्यापित करें';

  @override
  String get overview => 'अवलोकन';

  @override
  String get contentManagement => 'सामग्री प्रबंधन';

  @override
  String get contentManagementPageDescription =>
      'मोबाइल एप्लिकेशन के लिए समाचार सुर्खियों, विषयों और स्रोतों का प्रबंधन करें।';

  @override
  String get headlines => 'सुर्खियां';

  @override
  String get headline => 'सुर्खी';

  @override
  String get topics => 'विषय';

  @override
  String get topic => 'विषय';

  @override
  String get sources => 'स्रोत';

  @override
  String get source => 'स्रोत';

  @override
  String get appConfiguration => 'रिमोट कॉन्फ़िगरेशन';

  @override
  String get appConfigurationPageDescription =>
      'सामग्री सीमाओं से लेकर परिचालन स्थिति तक, मोबाइल ऐप के लिए वैश्विक सेटिंग्स प्रबंधित करें।';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get appConfigurationPageTitle => 'रिमोट कॉन्फ़िगरेशन';

  @override
  String get feedTab => 'फ़ीड';

  @override
  String get advertisementsTab => 'विज्ञापन';

  @override
  String get systemTab => 'सिस्टम';

  @override
  String get userContentLimitsTitle => 'उपयोगकर्ता सामग्री सीमाएं';

  @override
  String get userContentLimitsDescription =>
      'प्रत्येक उपयोगकर्ता स्तर के लिए अनुसरण की गई वस्तुओं और सहेजी गई सुर्खियों पर सीमाएं निर्धारित करें।';

  @override
  String get feedActionsTitle => 'फ़ीड क्रियाएं';

  @override
  String get feedActionsDescription =>
      'कॉन्फ़िगर करें कि फ़ीड में कितनी बार एक्शन विजेट (जैसे, \'ऐप रेट करें\') इंजेक्ट करना है।';

  @override
  String get feedDecoratorsTitle => 'फ़ीड डेकोरेटर्स';

  @override
  String get feedDecoratorsDescription =>
      'कॉन्फ़िगर करें कि विभिन्न उपयोगकर्ता भूमिकाओं के लिए फ़ीड में सामग्री को कैसे सजाया और प्रस्तुत किया जाता है।';

  @override
  String get adSettingsTitle => 'विज्ञापन सेटिंग्स';

  @override
  String get adSettingsDescription =>
      'विभिन्न उपयोगकर्ता भूमिकाओं के लिए विज्ञापन आवृत्ति और प्लेसमेंट प्रबंधित करें।';

  @override
  String get maintenanceModeTitle => 'रखरखाव मोड';

  @override
  String get maintenanceModeDescription =>
      'सभी उपयोगकर्ताओं को रखरखाव स्क्रीन दिखाने के लिए सक्षम करें।';

  @override
  String get forceUpdateTitle => 'ऐप अपडेट के लिए बाध्य करें';

  @override
  String get forceUpdateDescription =>
      'उपयोगकर्ताओं के लिए अनिवार्य ऐप अपडेट कॉन्फ़िगर करें।';

  @override
  String get forceUpdateTab => 'बाध्यकारी अपडेट';

  @override
  String get appConfigSaveSuccessMessage =>
      'रिमोट कॉन्फ़िगरेशन सफलतापूर्वक सहेजा गया। मोबाइल क्लाइंट अपने अगले लॉन्च पर अपडेट होंगे।';

  @override
  String appConfigSaveErrorMessage(String errorMessage) {
    return 'त्रुटि: $errorMessage';
  }

  @override
  String get unknownError => 'अज्ञात त्रुटि';

  @override
  String get loadingConfigurationHeadline => 'कॉन्फ़िगरेशन लोड हो रहा है';

  @override
  String get loadingConfigurationSubheadline =>
      'सेटिंग्स लोड होने तक कृपया प्रतीक्षा करें...';

  @override
  String get failedToLoadConfigurationMessage =>
      'कॉन्फ़िगरेशन लोड करने में विफल।';

  @override
  String get loadAppSettingsSubheadline =>
      'बैकएंड से एप्लिकेशन सेटिंग्स लोड करें।';

  @override
  String get discardChangesButton => 'परिवर्तन छोड़ें';

  @override
  String get saveChangesButton => 'परिवर्तन सहेजें';

  @override
  String get confirmConfigUpdateDialogTitle =>
      'कॉन्फ़िगरेशन अपडेट की पुष्टि करें';

  @override
  String get confirmConfigUpdateDialogContent =>
      'क्या आप वाकई इन परिवर्तनों को लाइव एप्लिकेशन कॉन्फ़िगरेशन पर लागू करना चाहते हैं? यह एक महत्वपूर्ण ऑपरेशन है।';

  @override
  String get cancelButton => 'रद्द करें';

  @override
  String get confirmSaveButton => 'सहेजने की पुष्टि करें';

  @override
  String get guestUserTab => 'अतिथि';

  @override
  String get authenticatedUserTab => 'प्रमाणित';

  @override
  String get premiumUserTab => 'प्रीमियम';

  @override
  String get guestFollowedItemsLimitLabel => 'अतिथि अनुसरण वस्तु सीमा';

  @override
  String get guestFollowedItemsLimitDescription =>
      'देशों, समाचार स्रोतों या विषयों की अधिकतम संख्या जिन्हें एक अतिथि उपयोगकर्ता अनुसरण कर सकता है (प्रत्येक प्रकार की अपनी सीमा होती है)।';

  @override
  String get guestSavedHeadlinesLimitLabel => 'अतिथि सहेजी गई सुर्खियां सीमा';

  @override
  String get guestSavedHeadlinesLimitDescription =>
      'सुर्खियों की अधिकतम संख्या जिन्हें एक अतिथि उपयोगकर्ता सहेज सकता है।';

  @override
  String get standardUserFollowedItemsLimitLabel =>
      'मानक उपयोगकर्ता अनुसरण वस्तु सीमा';

  @override
  String get standardUserFollowedItemsLimitDescription =>
      'देशों, समाचार स्रोतों या विषयों की अधिकतम संख्या जिन्हें एक मानक उपयोगकर्ता अनुसरण कर सकता है।';

  @override
  String get standardUserSavedHeadlinesLimitLabel =>
      'मानक उपयोगकर्ता सहेजी गई सुर्खियां सीमा';

  @override
  String get standardUserSavedHeadlinesLimitDescription =>
      'सुर्खियों की अधिकतम संख्या जिन्हें एक मानक उपयोगकर्ता सहेज सकता है।';

  @override
  String get premiumFollowedItemsLimitLabel =>
      'प्रीमियम उपयोगकर्ता अनुसरण वस्तु सीमा';

  @override
  String get premiumFollowedItemsLimitDescription =>
      'देशों, समाचार स्रोतों या विषयों की अधिकतम संख्या जिन्हें एक प्रीमियम उपयोगकर्ता अनुसरण कर सकता है।';

  @override
  String get premiumSavedHeadlinesLimitLabel =>
      'प्रीमियम उपयोगकर्ता सहेजी गई सुर्खियां सीमा';

  @override
  String get premiumSavedHeadlinesLimitDescription =>
      'सुर्खियों की अधिकतम संख्या जिन्हें एक प्रीमियम उपयोगकर्ता सहेज सकता है।';

  @override
  String get standardUserAdTab => 'मानक उपयोगकर्ता';

  @override
  String get guestAdFrequencyLabel => 'अतिथि विज्ञापन आवृत्ति';

  @override
  String get guestAdFrequencyDescription =>
      'अतिथि उपयोगकर्ताओं के लिए विज्ञापन कितनी बार दिखाई दे सकता है (उदाहरण के लिए, 5 के मान का अर्थ है कि प्रत्येक 5 समाचार वस्तुओं के बाद एक विज्ञापन रखा जा सकता है)।';

  @override
  String get guestAdPlacementIntervalLabel => 'अतिथि विज्ञापन प्लेसमेंट अंतराल';

  @override
  String get guestAdPlacementIntervalDescription =>
      'अतिथि उपयोगकर्ताओं के लिए पहला विज्ञापन दिखाई देने से पहले दिखाई जाने वाली समाचार वस्तुओं की न्यूनतम संख्या।';

  @override
  String get guestArticlesBeforeInterstitialAdsLabel =>
      'इंटरस्टिशियल विज्ञापनों से पहले अतिथि लेख';

  @override
  String get guestArticlesBeforeInterstitialAdsDescription =>
      'पूर्ण-स्क्रीन इंटरस्टिशियल विज्ञापन दिखाए जाने से पहले अतिथि उपयोगकर्ता को जितने लेख पढ़ने की आवश्यकता है।';

  @override
  String get standardUserAdFrequencyLabel => 'मानक उपयोगकर्ता विज्ञापन आवृत्ति';

  @override
  String get standardUserAdFrequencyDescription =>
      'मानक उपयोगकर्ताओं के लिए विज्ञापन कितनी बार दिखाई दे सकता है (उदाहरण के लिए, 10 के मान का अर्थ है कि प्रत्येक 10 समाचार वस्तुओं के बाद एक विज्ञापन रखा जा सकता है)।';

  @override
  String get standardUserAdPlacementIntervalLabel =>
      'मानक उपयोगकर्ता विज्ञापन प्लेसमेंट अंतराल';

  @override
  String get standardUserAdPlacementIntervalDescription =>
      'मानक उपयोगकर्ताओं के लिए पहला विज्ञापन दिखाई देने से पहले दिखाई जाने वाली समाचार वस्तुओं की न्यूनतम संख्या।';

  @override
  String get standardUserArticlesBeforeInterstitialAdsLabel =>
      'इंटरस्टिशियल विज्ञापनों से पहले मानक उपयोगकर्ता लेख';

  @override
  String get standardUserArticlesBeforeInterstitialAdsDescription =>
      'पूर्ण-स्क्रीन इंटरस्टिशियल विज्ञापन दिखाए जाने से पहले मानक उपयोगकर्ता को जितने लेख पढ़ने की आवश्यकता है।';

  @override
  String get premiumAdFrequencyLabel => 'प्रीमियम उपयोगकर्ता विज्ञापन आवृत्ति';

  @override
  String get premiumAdFrequencyDescription =>
      'प्रीमियम उपयोगकर्ताओं के लिए विज्ञापन कितनी बार दिखाई दे सकता है (कोई विज्ञापन नहीं के लिए 0)।';

  @override
  String get premiumAdPlacementIntervalLabel =>
      'प्रीमियम उपयोगकर्ता विज्ञापन प्लेसमेंट अंतराल';

  @override
  String get premiumAdPlacementIntervalDescription =>
      'प्रीमियम उपयोगकर्ताओं के लिए पहला विज्ञापन दिखाई देने से पहले दिखाई जाने वाली समाचार वस्तुओं की न्यूनतम संख्या।';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsLabel =>
      'इंटरस्टिशियल विज्ञापनों से पहले प्रीमियम उपयोगकर्ता लेख';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsDescription =>
      'पूर्ण-स्क्रीन इंटरस्टिशियल विज्ञापन दिखाए जाने से पहले प्रीमियम उपयोगकर्ता को जितने लेख पढ़ने की आवश्यकता है।';

  @override
  String get appOperationalStatusWarning =>
      'चेतावनी: ऐप की परिचालन स्थिति बदलने से सभी उपयोगकर्ता प्रभावित हो सकते हैं। अत्यधिक सावधानी के साथ उपयोग करें।';

  @override
  String get appOperationalStatusLabel => 'ऐप परिचालन स्थिति';

  @override
  String get appOperationalStatusDescription =>
      'ऐप की वर्तमान परिचालन स्थिति (जैसे, सक्रिय, रखरखाव, अक्षम)।';

  @override
  String get maintenanceMessageLabel => 'रखरखाव संदेश';

  @override
  String get maintenanceMessageDescription =>
      'ऐप रखरखाव मोड में होने पर प्रदर्शित संदेश।';

  @override
  String get disabledMessageLabel => 'अक्षम संदेश';

  @override
  String get disabledMessageDescription =>
      'ऐप स्थायी रूप से अक्षम होने पर प्रदर्शित संदेश।';

  @override
  String get forceUpdateConfigurationTitle =>
      'अपडेट कॉन्फ़िगरेशन के लिए बाध्य करें';

  @override
  String get minAllowedAppVersionLabel => 'न्यूनतम अनुमत ऐप संस्करण';

  @override
  String get minAllowedAppVersionDescription =>
      'चलने के लिए अनुमत न्यूनतम ऐप संस्करण (जैसे, \"1.2.0\")।';

  @override
  String get latestAppVersionLabel => 'नवीनतम ऐप संस्करण';

  @override
  String get latestAppVersionDescription =>
      'नवीनतम उपलब्ध ऐप संस्करण (जैसे, \"1.5.0\")।';

  @override
  String get updateRequiredMessageLabel => 'अपडेट आवश्यक संदेश';

  @override
  String get updateRequiredMessageDescription =>
      'बाध्यकारी अपडेट आवश्यक होने पर प्रदर्शित संदेश।';

  @override
  String get updateOptionalMessageLabel => 'वैकल्पिक अपडेट संदेश';

  @override
  String get updateOptionalMessageDescription =>
      'वैकल्पिक अपडेट के लिए प्रदर्शित संदेश।';

  @override
  String get iosStoreUrlLabel => 'iOS स्टोर URL';

  @override
  String get iosStoreUrlDescription => 'Apple ऐप स्टोर पर ऐप का URL।';

  @override
  String get androidStoreUrlLabel => 'Android स्टोर URL';

  @override
  String get androidUpdateUrlDescription => 'Google Play स्टोर पर ऐप का URL।';

  @override
  String get guestDaysBetweenInAppPromptsLabel =>
      'अतिथि इन-ऐप प्रॉम्प्ट के बीच के दिन';

  @override
  String get guestDaysBetweenInAppPromptsDescription =>
      'अतिथि उपयोगकर्ता को दूसरा इन-ऐप प्रॉम्प्ट दिखने से पहले बीतने वाले दिनों की न्यूनतम संख्या।';

  @override
  String get standardUserDaysBetweenInAppPromptsLabel =>
      'मानक उपयोगकर्ता इन-ऐप प्रॉम्प्ट के बीच के दिन';

  @override
  String get standardUserDaysBetweenInAppPromptsDescription =>
      'मानक उपयोगकर्ता को दूसरा इन-ऐप प्रॉम्प्ट दिखने से पहले बीतने वाले दिनों की न्यूनतम संख्या।';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get settingsSavedSuccessfully => 'सेटिंग्स सफलतापूर्वक सहेजी गईं!';

  @override
  String settingsSaveErrorMessage(String errorMessage) {
    return 'सेटिंग्स सहेजने में त्रुटि: $errorMessage';
  }

  @override
  String get loadingSettingsHeadline => 'सेटिंग्स लोड हो रही हैं';

  @override
  String get loadingSettingsSubheadline =>
      'आपकी सेटिंग्स लोड होने तक कृपया प्रतीक्षा करें...';

  @override
  String failedToLoadSettingsMessage(String errorMessage) {
    return 'सेटिंग्स लोड करने में विफल: $errorMessage';
  }

  @override
  String get baseThemeLabel => 'आधार थीम';

  @override
  String get baseThemeDescription => 'ऐप का समग्र लाइट या डार्क स्वरूप चुनें।';

  @override
  String get lightTheme => 'लाइट';

  @override
  String get darkTheme => 'डार्क';

  @override
  String get systemTheme => 'सिस्टम डिफॉल्ट';

  @override
  String get accentThemeLabel => 'एक्सेंट थीम';

  @override
  String get accentThemeDescription =>
      'इंटरैक्टिव तत्वों के लिए प्राथमिक एक्सेंट रंग चुनें।';

  @override
  String get defaultBlueTheme => 'डिफॉल्ट ब्लू';

  @override
  String get newsRedTheme => 'न्यूज रेड';

  @override
  String get graphiteGrayTheme => 'ग्रेफाइट ग्रे';

  @override
  String get fontFamilyLabel => 'फ़ॉन्ट परिवार';

  @override
  String get fontFamilyDescription =>
      'पूरे एप्लिकेशन में उपयोग किया जाने वाला फ़ॉन्ट चुनें।';

  @override
  String get systemDefaultFont => 'सिस्टम डिफॉल्ट';

  @override
  String get textScaleFactorLabel => 'टेक्स्ट का आकार';

  @override
  String get textScaleFactorDescription =>
      'ऐप में टेक्स्ट के समग्र आकार को समायोजित करें।';

  @override
  String get smallText => 'छोटा';

  @override
  String get mediumText => 'मध्यम';

  @override
  String get largeText => 'बड़ा';

  @override
  String get extraLargeText => 'बहुत बड़ा';

  @override
  String get fontWeightLabel => 'फ़ॉन्ट वेट';

  @override
  String get fontWeightDescription => 'टेक्स्ट की मोटाई चुनें।';

  @override
  String get lightFontWeight => 'लाइट';

  @override
  String get regularFontWeight => 'रेगुलर';

  @override
  String get boldFontWeight => 'बोल्ड';

  @override
  String get languageLabel => 'भाषा';

  @override
  String get languageDescription => 'एप्लिकेशन की भाषा चुनें।';

  @override
  String get edit => 'संपादित करें';

  @override
  String get englishLanguage => 'अंग्रेजी';

  @override
  String get arabicLanguage => 'अरबी';

  @override
  String get appearanceSettingsLabel => 'स्वरूप';

  @override
  String get languageSettingsLabel => 'भाषा';

  @override
  String get themeSettingsLabel => 'थीम सेटिंग्स';

  @override
  String get fontSettingsLabel => 'फ़ॉन्ट सेटिंग्स';

  @override
  String get settingsPageDescription =>
      'डैशबोर्ड इंटरफ़ेस के लिए अपनी व्यक्तिगत प्राथमिकताएं कॉन्फ़िगर करें, जिसमें दृश्य प्रस्तुति और भाषा चयन शामिल है।';

  @override
  String get appearanceSettingsDescription =>
      'डैशबोर्ड की दृश्य विशेषताओं को समायोजित करें, जिसमें थीम, एक्सेंट रंग और टाइपोग्राफिक शैलियाँ शामिल हैं।';

  @override
  String get loadingHeadlines => 'सुर्खियां लोड हो रही हैं';

  @override
  String get pleaseWait => 'कृपया प्रतीक्षा करें...';

  @override
  String get noHeadlinesFound => 'कोई सुर्खियां नहीं मिलीं।';

  @override
  String get headlineTitle => 'शीर्षक';

  @override
  String get excerpt => 'अंश';

  @override
  String get countryName => 'देश';

  @override
  String get publishedAt => 'प्रकाशित समय';

  @override
  String get actions => 'क्रियाएं';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get loadingTopics => 'विषय लोड हो रहे हैं';

  @override
  String get noTopicsFound => 'कोई विषय नहीं मिला।';

  @override
  String get topicName => 'विषय';

  @override
  String get description => 'विवरण';

  @override
  String get notAvailable => 'N/A';

  @override
  String get loadingSources => 'स्रोत लोड हो रहे हैं';

  @override
  String get noSourcesFound => 'कोई स्रोत नहीं मिला।';

  @override
  String get sourceName => 'स्रोत';

  @override
  String get sourceType => 'प्रकार';

  @override
  String get language => 'भाषा';

  @override
  String get editTopic => 'विषय संपादित करें';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get loadingTopic => 'विषय लोड हो रहा है';

  @override
  String get icon => 'आइकन';

  @override
  String get topicUpdatedSuccessfully => 'विषय सफलतापूर्वक अपडेट किया गया।';

  @override
  String get cannotUpdateTopicError =>
      'अपडेट नहीं किया जा सकता: मूल विषय डेटा लोड नहीं हुआ।';

  @override
  String get createTopic => 'विषय बनाएं';

  @override
  String get topicCreatedSuccessfully => 'विषय सफलतापूर्वक बनाया गया।';

  @override
  String get editSource => 'स्रोत संपादित करें';

  @override
  String get sourceUpdatedSuccessfully => 'स्रोत सफलतापूर्वक अपडेट किया गया।';

  @override
  String get loadingSource => 'स्रोत लोड हो रहा है...';

  @override
  String get sourceUrl => 'URL';

  @override
  String get headquarters => 'मुख्यालय';

  @override
  String get none => 'कोई नहीं';

  @override
  String get cannotUpdateSourceError =>
      'अपडेट नहीं किया जा सकता: मूल स्रोत डेटा लोड नहीं हुआ।';

  @override
  String get sourceTypeNewsAgency => 'समाचार एजेंसी';

  @override
  String get sourceTypeLocalNewsOutlet => 'स्थानीय समाचार आउटलेट';

  @override
  String get sourceTypeNationalNewsOutlet => 'राष्ट्रीय समाचार आउटलेट';

  @override
  String get sourceTypeInternationalNewsOutlet =>
      'अंतर्राष्ट्रीय समाचार आउटलेट';

  @override
  String get sourceTypeSpecializedPublisher => 'विशिष्ट प्रकाशक';

  @override
  String get sourceTypeBlog => 'ब्लॉग';

  @override
  String get sourceTypeGovernmentSource => 'सरकारी स्रोत';

  @override
  String get sourceTypeAggregator => 'एग्रीगेटर';

  @override
  String get sourceTypeOther => 'अन्य';

  @override
  String get editHeadline => 'सुर्खी संपादित करें';

  @override
  String get headlineUpdatedSuccessfully => 'सुर्खी सफलतापूर्वक अपडेट की गई।';

  @override
  String get loadingHeadline => 'सुर्खी लोड हो रही है...';

  @override
  String get image => 'छवि';

  @override
  String get cannotUpdateHeadlineError =>
      'अपडेट नहीं किया जा सकता: मूल सुर्खी डेटा लोड नहीं हुआ।';

  @override
  String get createHeadline => 'सुर्खी बनाएं';

  @override
  String get headlineCreatedSuccessfully => 'सुर्खी सफलतापूर्वक बनाई गई।';

  @override
  String get loadingData => 'डेटा लोड हो रहा है...';

  @override
  String get loadingFullList => 'पूरी सूची लोड हो रही है...';

  @override
  String get createSource => 'स्रोत बनाएं';

  @override
  String get updateSourceTitle => 'स्रोत अपडेट करें';

  @override
  String get updateSourceMessage =>
      'क्या आप इन परिवर्तनों को प्रकाशित करना चाहते हैं या अपडेट को ड्राफ्ट के रूप में सहेजना चाहते हैं?';

  @override
  String get sourceCreatedSuccessfully => 'स्रोत सफलतापूर्वक बनाया गया।';

  @override
  String get updateTopicTitle => 'विषय अपडेट करें';

  @override
  String get status => 'स्थिति';

  @override
  String get updateTopicMessage =>
      'क्या आप इन परिवर्तनों को प्रकाशित करना चाहते हैं या अपडेट को ड्राफ्ट के रूप में सहेजना चाहते हैं?';

  @override
  String get lastUpdated => 'अंतिम अपडेट';

  @override
  String get contentStatusActive => 'सक्रिय';

  @override
  String get contentStatusArchived => 'संग्रहीत';

  @override
  String get contentStatusDraft => 'ड्राफ्ट';

  @override
  String get totalHeadlines => 'कुल सुर्खियां';

  @override
  String get totalTopics => 'कुल विषय';

  @override
  String get totalSources => 'कुल स्रोत';

  @override
  String get loadingOverview => 'डैशबोर्ड अवलोकन लोड हो रहा है...';

  @override
  String get loadingOverviewSubheadline =>
      'नवीनतम आंकड़े प्राप्त किए जा रहे हैं...';

  @override
  String get overviewLoadFailure => 'डैशबोर्ड अवलोकन डेटा लोड करने में विफल।';

  @override
  String get recentHeadlines => 'हालिया सुर्खियां';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get noRecentHeadlines =>
      'प्रदर्शित करने के लिए कोई हालिया सुर्खियां नहीं हैं।';

  @override
  String get systemStatus => 'सिस्टम स्थिति';

  @override
  String get quickActions => 'त्वरित क्रियाएं';

  @override
  String get createHeadlineAction => 'सुर्खी बनाएं';

  @override
  String get manageContentAction => 'सामग्री प्रबंधित करें';

  @override
  String get appConfigAction => 'ऐप कॉन्फ़िगरेशन';

  @override
  String get appStatusActive => 'सक्रिय';

  @override
  String get appStatusDisabled => 'अक्षम';

  @override
  String demoEmailHint(String email) {
    return 'डेमो के लिए, ईमेल का उपयोग करें: $email';
  }

  @override
  String demoCodeHint(String code) {
    return 'डेमो के लिए, कोड का उपयोग करें: $code';
  }

  @override
  String get appStatusMaintenance => 'रखरखाव';

  @override
  String get appStatusOperational => 'परिचालन';

  @override
  String get isUnderMaintenanceLabel => 'रखरखाव के अधीन';

  @override
  String get isUnderMaintenanceDescription =>
      'मोबाइल ऐप को रखरखाव मोड में डालने के लिए टॉगल करें, जिससे उपयोगकर्ता की पहुंच रुक जाएगी।';

  @override
  String get isLatestVersionOnlyLabel =>
      'केवल नवीनतम संस्करण के लिए बाध्य करें';

  @override
  String get isLatestVersionOnlyDescription =>
      'यदि सक्षम है, तो उपयोगकर्ताओं को ऐप का उपयोग जारी रखने के लिए नवीनतम ऐप संस्करण में अपडेट करना होगा।';

  @override
  String get iosUpdateUrlLabel => 'iOS अपडेट URL';

  @override
  String get iosUpdateUrlDescription => 'iOS ऐप अपडेट के लिए URL।';

  @override
  String get androidUpdateUrlLabel => 'Android अपडेट URL';

  @override
  String get followedItemsLimitLabel => 'अनुसरण की गई वस्तु सीमा';

  @override
  String get followedItemsLimitDescription =>
      'देशों, समाचार स्रोतों या श्रेणियों की अधिकतम संख्या जिन्हें यह उपयोगकर्ता भूमिका अनुसरण कर सकती है (प्रत्येक प्रकार की अपनी सीमा होती है)।';

  @override
  String get savedFeedFiltersLimitLabel => 'सहेजे गए फ़िल्टर सीमा';

  @override
  String get savedFeedFiltersLimitDescription =>
      'फ़ीड फ़िल्टर की अधिकतम संख्या जिन्हें यह उपयोगकर्ता भूमिका सहेज सकती है।';

  @override
  String get adFrequencyLabel => 'विज्ञापन आवृत्ति';

  @override
  String get adFrequencyDescription =>
      'इस उपयोगकर्ता भूमिका के लिए विज्ञापन कितनी बार दिखाई दे सकता है (उदाहरण के लिए, 5 के मान का अर्थ है कि प्रत्येक 5 समाचार वस्तुओं के बाद एक विज्ञापन रखा जा सकता है)।';

  @override
  String get savedFeedFilterLimitsTitle => 'सहेजे गए फ़िल्टर सीमाएं';

  @override
  String get savedFeedFilterLimitsDescription =>
      'प्रत्येक उपयोगकर्ता स्तर के लिए सहेजे गए फ़ीड फ़िल्टर की संख्या पर सीमाएं निर्धारित करें।';

  @override
  String get adPlacementIntervalLabel => 'विज्ञापन प्लेसमेंट अंतराल';

  @override
  String get adPlacementIntervalDescription =>
      'इस उपयोगकर्ता भूमिका के लिए पहला विज्ञापन दिखाई देने से पहले दिखाई जाने वाली समाचार वस्तुओं की न्यूनतम संख्या।';

  @override
  String get articlesBeforeInterstitialAdsLabel =>
      'इंटरस्टिशियल विज्ञापनों से पहले लेख';

  @override
  String get articlesBeforeInterstitialAdsDescription =>
      'पूर्ण-स्क्रीन इंटरस्टिशियल विज्ञापन दिखाए जाने से पहले इस उपयोगकर्ता भूमिका को जितने लेख पढ़ने की आवश्यकता है।';

  @override
  String get daysSuffix => 'दिन';

  @override
  String daysBetweenPromptDescription(String actionType) {
    return '$actionType प्रॉम्प्ट दिखाने से पहले दिनों की न्यूनतम संख्या।';
  }

  @override
  String get retryButtonText => 'पुनः प्रयास करें';

  @override
  String get feedActionTypeLinkAccount => 'खाता लिंक करें';

  @override
  String get feedActionTypeRateApp => 'ऐप रेट करें';

  @override
  String get feedActionTypeFollowTopics => 'विषयों का अनुसरण करें';

  @override
  String get feedActionTypeFollowSources => 'स्रोतों का अनुसरण करें';

  @override
  String get feedActionTypeUpgrade => 'अपग्रेड करें';

  @override
  String get feedActionTypeEnableNotifications => 'सूचनाएं सक्षम करें';

  @override
  String get countryPickerSearchLabel => 'खोजें';

  @override
  String get countryPickerSearchHint => 'खोजने के लिए टाइप करना शुरू करें...';

  @override
  String get countryPickerSelectCountryLabel => 'एक देश चुनें';

  @override
  String get archivedHeadlines => 'संग्रहीत सुर्खियां';

  @override
  String get loadingArchivedHeadlines => 'संग्रहीत सुर्खियां लोड हो रही हैं';

  @override
  String get noArchivedHeadlinesFound => 'कोई संग्रहीत सुर्खियां नहीं मिलीं।';

  @override
  String get restore => 'पुनर्स्थापित करें';

  @override
  String get deleteForever => 'हमेशा के लिए हटाएं';

  @override
  String get archivedTopics => 'संग्रहीत विषय';

  @override
  String get loadingArchivedTopics => 'संग्रहीत विषय लोड हो रहे हैं';

  @override
  String get noArchivedTopicsFound => 'कोई संग्रहीत विषय नहीं मिला।';

  @override
  String get archivedSources => 'संग्रहीत स्रोत';

  @override
  String get loadingArchivedSources => 'संग्रहीत स्रोत लोड हो रहे हैं';

  @override
  String get noArchivedSourcesFound => 'कोई संग्रहीत स्रोत नहीं मिला।';

  @override
  String get archivedItems => 'संग्रहीत वस्तुएं';

  @override
  String get addNewItem => 'नई वस्तु जोड़ें';

  @override
  String get archive => 'संग्रह';

  @override
  String headlineDeleted(String title) {
    return '\'\'$title\'\' हटा दिया गया।';
  }

  @override
  String get undo => 'पूर्ववत करें';

  @override
  String get enabledLabel => 'सक्षम';

  @override
  String get itemsToDisplayLabel => 'प्रदर्शित करने के लिए वस्तुएं';

  @override
  String get itemsToDisplayDescription =>
      'इस डेकोरेटर में प्रदर्शित करने के लिए वस्तुओं की संख्या।';

  @override
  String get roleSpecificSettingsTitle => 'भूमिका विशिष्ट सेटिंग्स';

  @override
  String get daysBetweenViewsLabel => 'दृश्यों के बीच के दिन';

  @override
  String get daysBetweenViewsDescription =>
      'यह सेटिंग दिनों की न्यूनतम संख्या निर्धारित करती है जो किसी उपयोगकर्ता को डेकोरेटर फिर से दिखाए जाने से पहले बीतनी चाहिए, बशर्ते संबंधित कार्य अभी तक पूरा न हुआ हो।';

  @override
  String get feedDecoratorTypeLinkAccount => 'खाता लिंक करें';

  @override
  String get feedDecoratorTypeUpgrade => 'प्रीमियम में अपग्रेड करें';

  @override
  String get feedDecoratorTypeRateApp => 'ऐप रेट करें';

  @override
  String get feedDecoratorTypeEnableNotifications => 'सूचनाएं सक्षम करें';

  @override
  String get feedDecoratorTypeSuggestedTopics => 'सुझाए गए विषय';

  @override
  String get feedDecoratorTypeSuggestedSources => 'सुझाए गए स्रोत';

  @override
  String get guestUserRole => 'अतिथि उपयोगकर्ता';

  @override
  String get standardUserRole => 'मानक उपयोगकर्ता';

  @override
  String get premiumUserRole => 'प्रीमियम उपयोगकर्ता';

  @override
  String get dashboardTitle => 'डैशबोर्ड';

  @override
  String get clearSelection => 'चयन साफ़ करें';

  @override
  String get search => 'खोजें';

  @override
  String get noResultsFound => 'कोई परिणाम नहीं मिला।';

  @override
  String get close => 'बंद करें';

  @override
  String get apply => 'लागू करें';

  @override
  String visibleToRoleLabel(String roleName) {
    return '$roleName को दृश्यमान';
  }

  @override
  String get adPlatformConfigurationTitle =>
      'विज्ञापन प्लेटफ़ॉर्म कॉन्फ़िगरेशन';

  @override
  String get primaryAdPlatformTitle => 'प्राथमिक विज्ञापन प्लेटफ़ॉर्म';

  @override
  String get primaryAdPlatformDescription =>
      'पूरे एप्लिकेशन में उपयोग किए जाने वाले प्राथमिक विज्ञापन प्लेटफ़ॉर्म को चुनें।';

  @override
  String get adUnitIdentifiersTitle => 'विज्ञापन इकाई पहचानकर्ता';

  @override
  String get adUnitIdentifiersDescription =>
      'चयनित विज्ञापन प्लेटफ़ॉर्म के लिए विज्ञापन इकाई आईडी कॉन्फ़िगर करें।';

  @override
  String get feedAdSettingsTitle => 'फ़ीड विज्ञापन सेटिंग्स';

  @override
  String get enableFeedAdsLabel => 'फ़ीड विज्ञापन सक्षम करें';

  @override
  String get feedAdTypeSelectionTitle => 'फ़ीड विज्ञापन प्रकार चयन';

  @override
  String get feedAdTypeSelectionDescription =>
      'मुख्य फ़ीड में प्रदर्शित करने के लिए विज्ञापनों का प्रकार चुनें (नेटिव या बैनर)।';

  @override
  String get userRoleFrequencySettingsTitle =>
      'उपयोगकर्ता भूमिका आवृत्ति सेटिंग्स';

  @override
  String get userRoleFrequencySettingsDescription =>
      'उपयोगकर्ता भूमिकाओं के आधार पर विज्ञापन आवृत्ति और प्लेसमेंट अंतराल कॉन्फ़िगर करें।';

  @override
  String get articleAdSettingsTitle => 'लेख विज्ञापन सेटिंग्स';

  @override
  String get enableArticleAdsLabel => 'लेख विज्ञापन सक्षम करें';

  @override
  String get defaultInArticleAdTypeSelectionTitle =>
      'डिफ़ॉल्ट इन-आर्टिकल विज्ञापन प्रकार चयन';

  @override
  String get defaultInArticleAdTypeSelectionDescription =>
      'लेखों के भीतर प्रदर्शित करने के लिए विज्ञापनों का डिफ़ॉल्ट प्रकार चुनें (नेटिव या बैनर)।';

  @override
  String get inArticleAdSlotPlacementsTitle =>
      'इन-आर्टिकल विज्ञापन स्लॉट प्लेसमेंट';

  @override
  String get inArticleAdSlotPlacementsDescription =>
      'लेख सामग्री के भीतर विशिष्ट विज्ञापन स्लॉट सक्षम या अक्षम करें।';

  @override
  String get feedNativeAdIdLabel => 'फ़ीड नेटिव विज्ञापन आईडी';

  @override
  String get feedNativeAdIdDescription =>
      'फ़ीड में नेटिव विज्ञापनों के लिए इकाई आईडी।';

  @override
  String get feedBannerAdIdLabel => 'फ़ीड बैनर विज्ञापन आईडी';

  @override
  String get feedBannerAdIdDescription =>
      'फ़ीड में बैनर विज्ञापनों के लिए इकाई आईडी।';

  @override
  String get articleInterstitialAdIdLabel => 'लेख इंटरस्टिशियल विज्ञापन आईडी';

  @override
  String get articleInterstitialAdIdDescription =>
      'लेखों में इंटरस्टिशियल विज्ञापनों के लिए इकाई आईडी।';

  @override
  String get inArticleNativeAdIdLabel => 'इन-आर्टिकल नेटिव विज्ञापन आईडी';

  @override
  String get inArticleNativeAdIdDescription =>
      'लेखों के भीतर नेटिव विज्ञापनों के लिए इकाई आईडी।';

  @override
  String get inArticleBannerAdIdLabel => 'इन-आर्टिकल बैनर विज्ञापन आईडी';

  @override
  String get inArticleBannerAdIdDescription =>
      'लेखों के भीतर बैनर विज्ञापनों के लिए इकाई आईडी।';

  @override
  String get inArticleAdSlotTypeAboveArticleContinueReadingButton =>
      '\'पढ़ना जारी रखें\' बटन के ऊपर';

  @override
  String get inArticleAdSlotTypeBelowArticleContinueReadingButton =>
      '\'पढ़ना जारी रखें\' बटन के नीचे';

  @override
  String idCopiedToClipboard(String id) {
    return 'आईडी \'$id\' क्लिपबोर्ड पर कॉपी की गई।';
  }

  @override
  String get copyId => 'आईडी कॉपी करें';

  @override
  String get enableGlobalAdsLabel => 'विज्ञापन सक्षम करें';

  @override
  String get feedToArticleInterstitialAdIdLabel =>
      'फ़ीड से लेख इंटरस्टिशियल विज्ञापन आईडी';

  @override
  String get feedToArticleInterstitialAdIdDescription =>
      'जब कोई उपयोगकर्ता फ़ीड से लेख पर नेविगेट करता है तो प्रदर्शित होने वाले इंटरस्टिशियल विज्ञापनों के लिए विज्ञापन इकाई आईडी।';

  @override
  String get interstitialAdSettingsTitle => 'इंटरस्टिशियल विज्ञापन सेटिंग्स';

  @override
  String get enableInterstitialAdsLabel => 'इंटरस्टिशियल विज्ञापन सक्षम करें';

  @override
  String get userRoleInterstitialFrequencyTitle =>
      'उपयोगकर्ता भूमिका के अनुसार इंटरस्टिशियल विज्ञापन आवृत्ति';

  @override
  String get userRoleInterstitialFrequencyDescription =>
      'कॉन्फ़िगर करें कि किसी उपयोगकर्ता को उनकी भूमिका के आधार पर इंटरस्टिशियल विज्ञापन दिखाए जाने से पहले कितने ट्रांज़िशन करने होंगे।';

  @override
  String get transitionsBeforeInterstitialAdsLabel =>
      'इंटरस्टिशियल विज्ञापनों से पहले ट्रांज़िशन';

  @override
  String get transitionsBeforeInterstitialAdsDescription =>
      'इंटरस्टिशियल विज्ञापन प्रदर्शित होने से पहले उपयोगकर्ता को जितने ट्रांज़िशन (जैसे, लेख खोलना) करने होंगे।';

  @override
  String get adPlatformTypeAdmob => 'AdMob';

  @override
  String get nativeAdsTab => 'नेटिव विज्ञापन';

  @override
  String get bannerAdsTab => 'बैनर विज्ञापन';

  @override
  String get interstitialAdsTab => 'इंटरस्टिशियल विज्ञापन';

  @override
  String get videoAdsTab => 'वीडियो विज्ञापन';

  @override
  String get bannerAdType => 'बैनर';

  @override
  String get nativeAdType => 'नेटिव';

  @override
  String get interstitialAdType => 'इंटरस्टिशियल';

  @override
  String get videoAdType => 'वीडियो';

  @override
  String get rewardedAdType => 'रिवॉर्डेड';

  @override
  String get bannerAdShapeSelectionTitle => 'बैनर विज्ञापन आकार';

  @override
  String get bannerAdShapeSelectionDescription =>
      'लेखों में प्रदर्शित बैनर विज्ञापनों के लिए पसंदीदा दृश्य आकार चुनें।';

  @override
  String get bannerAdShapeSquare => 'वर्गाकार';

  @override
  String get bannerAdShapeRectangle => 'आयताकार';

  @override
  String get loadingDraftHeadlines => 'ड्राफ्ट सुर्खियां लोड हो रही हैं';

  @override
  String get noDraftHeadlinesFound => 'कोई ड्राफ्ट सुर्खियां नहीं मिलीं';

  @override
  String get publish => 'प्रकाशित करें';

  @override
  String get saveAsDraft => 'ड्राफ्ट के रूप में सहेजें';

  @override
  String get invalidFormTitle => 'अमान्य फ़ॉर्म';

  @override
  String get invalidFormMessage =>
      'कृपया प्रकाशित करने से पहले सभी आवश्यक फ़ील्ड भरें। आप ड्राफ्ट के रूप में सहेज सकते हैं या अपने परिवर्तनों को छोड़ सकते हैं।';

  @override
  String get completeForm => 'फ़ॉर्म पूरा करें';

  @override
  String get discard => 'छोड़ें';

  @override
  String get drafts => 'ड्राफ्ट';

  @override
  String get draftsIconTooltip => 'ड्राफ्ट';

  @override
  String get draftHeadlines => 'ड्राफ्ट सुर्खियां';

  @override
  String get draftTopics => 'ड्राफ्ट विषय';

  @override
  String get draftSources => 'ड्राफ्ट स्रोत';

  @override
  String get saveHeadlineTitle => 'सुर्खी सहेजें';

  @override
  String get saveHeadlineMessage =>
      'क्या आप इस सुर्खी को प्रकाशित करना चाहते हैं या इसे ड्राफ्ट के रूप में सहेजना चाहते हैं?';

  @override
  String get saveTopicTitle => 'विषय सहेजें';

  @override
  String get saveTopicMessage =>
      'क्या आप इस विषय को प्रकाशित करना चाहते हैं या इसे ड्राफ्ट के रूप में सहेजना चाहते हैं?';

  @override
  String get saveSourceTitle => 'स्रोत सहेजें';

  @override
  String get saveSourceMessage =>
      'क्या आप इस स्रोत को प्रकाशित करना चाहते हैं या इसे ड्राफ्ट के रूप में सहेजना चाहते हैं?';

  @override
  String get loadingDraftTopics => 'ड्राफ्ट विषय लोड हो रहे हैं...';

  @override
  String get noDraftTopicsFound => 'कोई ड्राफ्ट विषय नहीं मिला।';

  @override
  String topicDeleted(String topicTitle) {
    return 'विषय \"$topicTitle\" हटा दिया गया।';
  }

  @override
  String get loadingDraftSources => 'ड्राफ्ट स्रोत लोड हो रहे हैं...';

  @override
  String get noDraftSourcesFound => 'कोई ड्राफ्ट स्रोत नहीं मिला।';

  @override
  String sourceDeleted(String sourceName) {
    return 'स्रोत \"$sourceName\" हटा दिया गया।';
  }

  @override
  String get publishTopic => 'विषय प्रकाशित करें';

  @override
  String get publishSource => 'स्रोत प्रकाशित करें';

  @override
  String enableInArticleAdsForRoleLabel(String role) {
    return '$role के लिए इन-आर्टिकल विज्ञापन सक्षम करें';
  }

  @override
  String get moreActions => 'अधिक क्रियाएं';

  @override
  String get filter => 'फ़िल्टर';

  @override
  String get applyFilters => 'फ़िल्टर लागू करें';

  @override
  String get filterHeadlines => 'सुर्खियां फ़िल्टर करें';

  @override
  String get filterTopics => 'विषय फ़िल्टर करें';

  @override
  String get filterSources => 'स्रोत फ़िल्टर करें';

  @override
  String get searchByHeadlineTitle => 'सुर्खी शीर्षक से खोजें...';

  @override
  String get searchByTopicName => 'नाम या आईडी से खोजें...';

  @override
  String get searchBySourceName => 'नाम या आईडी से खोजें...';

  @override
  String get selectSources => 'स्रोत चुनें';

  @override
  String get selectTopics => 'विषय चुनें';

  @override
  String get countries => 'देश';

  @override
  String get selectCountries => 'देश चुनें';

  @override
  String get selectSourceTypes => 'स्रोत प्रकार चुनें';

  @override
  String get selectLanguages => 'भाषाएं चुनें';

  @override
  String get selectHeadquarters => 'मुख्यालय चुनें';

  @override
  String get resetFiltersButtonText => 'फ़िल्टर रीसेट करें';

  @override
  String get noResultsWithCurrentFilters =>
      'वर्तमान फ़िल्टर के साथ कोई परिणाम नहीं मिला। उन्हें रीसेट करने का प्रयास करें।';

  @override
  String get aboutIconTooltip => 'इस पेज के बारे में';

  @override
  String get closeButtonText => 'बंद करें';

  @override
  String get logo => 'लोगो';

  @override
  String get userManagement => 'उपयोगकर्ता प्रबंधन';

  @override
  String get userManagementPageDescription =>
      'सिस्टम उपयोगकर्ताओं को प्रबंधित करें, जिसमें उनकी भूमिकाएं और अनुमतियां शामिल हैं।';

  @override
  String get loadingUsers => 'उपयोगकर्ता लोड हो रहे हैं';

  @override
  String get noUsersFound => 'कोई उपयोगकर्ता नहीं मिला।';

  @override
  String get email => 'ईमेल';

  @override
  String get appRole => 'ऐप भूमिका';

  @override
  String get dashboardRole => 'डैशबोर्ड भूमिका';

  @override
  String get createdAt => 'बनाया गया';

  @override
  String get promoteToPublisher => 'प्रकाशक के रूप में पदोन्नत करें';

  @override
  String get demoteToUser => 'उपयोगकर्ता के रूप में पदावनत करें';

  @override
  String get adminRole => 'प्रशासक';

  @override
  String get publisherRole => 'प्रकाशक';

  @override
  String get filterUsers => 'उपयोगकर्ता फ़िल्टर करें';

  @override
  String get searchByUserEmail => 'ईमेल या आईडी से खोजें...';

  @override
  String get selectAppRoles => 'ऐप भूमिकाएं चुनें';

  @override
  String get selectDashboardRoles => 'डैशबोर्ड भूमिकाएं चुनें';

  @override
  String get authentication => 'प्रमाणीकरण';

  @override
  String get subscription => 'सदस्यता';

  @override
  String get authenticationAnonymous => 'अनाम';

  @override
  String get authenticationAuthenticated => 'प्रमाणित';

  @override
  String get subscriptionFree => 'मुफ़्त';

  @override
  String get subscriptionPremium => 'प्रीमियम';

  @override
  String get savedHeadlineFilterLimitsTitle => 'सहेजे गए सुर्खी फ़िल्टर सीमाएं';

  @override
  String get savedHeadlineFilterLimitsDescription =>
      'प्रत्येक उपयोगकर्ता स्तर के लिए सहेजे गए सुर्खी फ़िल्टर की संख्या पर सीमाएं निर्धारित करें, जिसमें कुल, पिन किए गए और अधिसूचना सदस्यता शामिल हैं।';

  @override
  String get totalLimitLabel => 'कुल सीमा';

  @override
  String get totalLimitDescription =>
      'इस प्रकार के फ़िल्टर की कुल संख्या जो एक उपयोगकर्ता बना सकता है।';

  @override
  String get pinnedLimitLabel => 'पिन की गई सीमा';

  @override
  String get pinnedLimitDescription =>
      'इस प्रकार के फ़िल्टर की अधिकतम संख्या जिन्हें पिन किया जा सकता है।';

  @override
  String get notificationSubscriptionLimitLabel => 'अधिसूचना सदस्यता सीमा';

  @override
  String get notificationSubscriptionLimitDescription =>
      'इस अधिसूचना प्रकार के लिए उपयोगकर्ता जितने फ़िल्टर सब्सक्राइब कर सकता है, उनकी अधिकतम संख्या।';

  @override
  String get pushNotificationSubscriptionDeliveryTypeBreakingOnly =>
      'ब्रेकिंग न्यूज';

  @override
  String get pushNotificationSubscriptionDeliveryTypeWeeklyRoundup =>
      'साप्ताहिक राउंडअप';

  @override
  String get isBreakingNewsLabel => 'ब्रेकिंग न्यूज के रूप में चिह्नित करें';

  @override
  String get isBreakingNewsDescription =>
      'इसे सक्षम करने से प्रकाशन पर सभी सब्सक्राइब किए गए उपयोगकर्ताओं को तत्काल पुश अधिसूचना भेजी जाएगी।';

  @override
  String get isBreakingNewsDescriptionEdit =>
      'संपादन के दौरान इस स्थिति को बदलने से नई पुश अधिसूचना ट्रिगर नहीं होगी, क्योंकि सूचनाएं केवल प्रारंभिक निर्माण पर भेजी जाती हैं।';

  @override
  String get confirmBreakingNewsTitle =>
      'ब्रेकिंग न्यूज प्रकाशन की पुष्टि करें';

  @override
  String get confirmBreakingNewsMessage =>
      'क्या आप वाकई इसे ब्रेकिंग न्यूज के रूप में प्रकाशित करना चाहते हैं? यह क्रिया सभी सब्सक्राइब किए गए उपयोगकर्ताओं को तत्काल पुश अधिसूचना भेजेगी।';

  @override
  String get confirmPublishButton => 'पुष्टि करें और प्रकाशित करें';

  @override
  String get cannotDraftBreakingNews =>
      'ब्रेकिंग न्यूज को ड्राफ्ट के रूप में सहेजा नहीं जा सकता। कृपया इसे प्रकाशित करें या \'ब्रेकिंग न्यूज\' टॉगल को अक्षम करें।';

  @override
  String get ok => 'ठीक है';

  @override
  String get breakingNewsFilterTitle => 'ब्रेकिंग न्यूज';

  @override
  String get breakingNewsFilterAll => 'सभी';

  @override
  String get breakingNewsFilterBreakingOnly => 'केवल ब्रेकिंग';

  @override
  String get breakingNewsFilterNonBreakingOnly => 'गैर-ब्रेकिंग';

  @override
  String get notificationsTab => 'सूचनाएं';

  @override
  String get pushNotificationSettingsTitle => 'पुश अधिसूचना सेटिंग्स';

  @override
  String get pushNotificationSettingsDescription =>
      'पुश अधिसूचना प्रणाली के लिए वैश्विक सेटिंग्स प्रबंधित करें, जिसमें प्राथमिक प्रदाता और कौन से अधिसूचना प्रकार सक्रिय हैं, शामिल हैं।';

  @override
  String get pushNotificationSystemStatusTitle => 'सूचनाएं सक्षम करें';

  @override
  String get pushNotificationSystemStatusDescription =>
      'सभी पुश सूचनाओं को सक्षम या अक्षम करने के लिए एक वैश्विक स्विच।';

  @override
  String get pushNotificationPrimaryProviderTitle => 'प्राथमिक प्रदाता';

  @override
  String get pushNotificationPrimaryProviderDescription =>
      'प्राथमिक सेवा प्रदाता चुनें। सुनिश्चित करें कि चुना गया प्रदाता प्रलेखन के अनुसार आपके बैकएंड की .env फ़ाइल में सही ढंग से कॉन्फ़िगर किया गया है।';

  @override
  String get pushNotificationDeliveryTypesTitle => 'वितरण प्रकार';

  @override
  String get pushNotificationDeliveryTypesDescription =>
      'विशिष्ट प्रकार की पुश सूचनाओं को वैश्विक स्तर पर सक्षम या अक्षम करें।';

  @override
  String get pushNotificationProviderFirebase => 'Firebase';

  @override
  String get pushNotificationProviderOneSignal => 'OneSignal';

  @override
  String get appTab => 'सामान्य';

  @override
  String get featuresTab => 'विशेषताएं';

  @override
  String get limitsTab => 'सीमाएं';

  @override
  String get maintenanceConfigTitle => 'रखरखाव मोड';

  @override
  String get maintenanceConfigDescription =>
      'ऐप को रखरखाव मोड में डालने के लिए सक्षम करें, जिससे उपयोगकर्ता की पहुंच रुक जाएगी।';

  @override
  String get updateConfigTitle => 'अपडेट सेटिंग्स';

  @override
  String get updateConfigDescription =>
      'उपयोगकर्ताओं के लिए अनिवार्य ऐप अपडेट कॉन्फ़िगर करें।';

  @override
  String get generalAppConfigTitle => 'सामान्य ऐप सेटिंग्स';

  @override
  String get generalAppConfigDescription =>
      'सेवा की शर्तें और गोपनीयता नीति URL जैसी सामान्य एप्लिकेशन सेटिंग्स प्रबंधित करें।';

  @override
  String get termsOfServiceUrlLabel => 'सेवा की शर्तें URL';

  @override
  String get termsOfServiceUrlDescription =>
      'एप्लिकेशन के सेवा की शर्तें पेज का URL।';

  @override
  String get privacyPolicyUrlLabel => 'गोपनीयता नीति URL';

  @override
  String get privacyPolicyUrlDescription =>
      'एप्लिकेशन के गोपनीयता नीति पेज का URL।';

  @override
  String get navigationAdConfigTitle => 'नेविगेशन विज्ञापन सेटिंग्स';

  @override
  String get enableNavigationAdsLabel => 'नेविगेशन विज्ञापन सक्षम करें';

  @override
  String get navigationAdFrequencyTitle => 'नेविगेशन विज्ञापन आवृत्ति';

  @override
  String get navigationAdFrequencyDescription =>
      'कॉन्फ़िगर करें कि किसी उपयोगकर्ता को उनकी भूमिका के आधार पर इंटरस्टिशियल विज्ञापन दिखाए जाने से पहले कितने ट्रांज़िशन करने होंगे।';

  @override
  String get internalNavigationsBeforeAdLabel =>
      'विज्ञापन से पहले आंतरिक नेविगेशन';

  @override
  String get internalNavigationsBeforeAdDescription =>
      'इंटरस्टिशियल विज्ञापन प्रदर्शित होने से पहले उपयोगकर्ता को जितने आंतरिक पेज-टू-पेज नेविगेशन करने होंगे।';

  @override
  String get externalNavigationsBeforeAdLabel =>
      'विज्ञापन से पहले बाहरी नेविगेशन';

  @override
  String get externalNavigationsBeforeAdDescription =>
      'इंटरस्टिशियल विज्ञापन प्रदर्शित होने से पहले उपयोगकर्ता को जितने बाहरी नेविगेशन करने होंगे।';

  @override
  String get nativeAdIdLabel => 'नेटिव विज्ञापन आईडी';

  @override
  String get nativeAdIdDescription => 'नेटिव विज्ञापनों के लिए इकाई आईडी।';

  @override
  String get bannerAdIdLabel => 'बैनर विज्ञापन आईडी';

  @override
  String get bannerAdIdDescription => 'बैनर विज्ञापनों के लिए इकाई आईडी।';

  @override
  String get interstitialAdIdLabel => 'इंटरस्टिशियल विज्ञापन आईडी';

  @override
  String get interstitialAdIdDescription =>
      'इंटरस्टिशियल विज्ञापनों के लिए इकाई आईडी।';

  @override
  String get savedHeadlinesLimitLabel => 'सहेजी गई सुर्खियां सीमा';

  @override
  String get savedHeadlinesLimitDescription =>
      'सुर्खियों की अधिकतम संख्या जिन्हें यह उपयोगकर्ता भूमिका सहेज सकती है।';

  @override
  String get appUpdateManagementTitle => 'एप्लिकेशन अपडेट प्रबंधन';

  @override
  String get feedItemClickBehaviorTitle => 'फ़ीड आइटम क्लिक व्यवहार';

  @override
  String get feedItemClickBehaviorDescription =>
      'सुर्खियां खोलने के लिए डिफ़ॉल्ट ब्राउज़र सेट करें। इसे उपयोगकर्ताओं द्वारा उनके ऐप की फ़ीड सेटिंग्स में ओवरराइड किया जा सकता है।';

  @override
  String get feedItemClickBehaviorInternalNavigation => 'इन-ऐप ब्राउज़र';

  @override
  String get feedItemClickBehaviorExternalNavigation => 'सिस्टम ब्राउज़र';

  @override
  String get userLimitsTitle => 'उपयोगकर्ता सीमाएं';

  @override
  String get userLimitsDescription =>
      'उपयोगकर्ता-विशिष्ट सुविधाओं और सामग्री के लिए सीमाएं परिभाषित करें।';

  @override
  String get appStatusAndUpdatesDescription =>
      'एप्लिकेशन की परिचालन स्थिति को नियंत्रित करें और अपडेट आवश्यकताओं को प्रबंधित करें।';

  @override
  String get advertisementsDescription =>
      'वैश्विक नियंत्रण, प्लेटफ़ॉर्म और प्लेसमेंट सहित सभी विज्ञापन सेटिंग्स प्रबंधित करें।';

  @override
  String get notificationsDescription =>
      'प्रदाताओं और वितरण प्रकारों सहित पुश अधिसूचना प्रणाली को कॉन्फ़िगर करें।';

  @override
  String get feedDescription =>
      'उपयोगकर्ता के सामग्री फ़ीड के व्यवहार और स्वरूप को नियंत्रित करें।';

  @override
  String get notificationSubscriptionBreakingOnlyDescription =>
      'उन सदस्यताओं के लिए सीमा जो मिलान वाली सुर्खियों के लिए तत्काल अलर्ट भेजती हैं।';

  @override
  String get notificationSubscriptionWeeklyRoundupDescription =>
      'उन सदस्यताओं के लिए सीमा जो मिलान वाली सुर्खियों का साप्ताहिक सारांश भेजती हैं।';

  @override
  String get appStatusAndUpdatesTitle => 'ऐप स्थिति और अपडेट';

  @override
  String get enableForcedUpdatesLabel => 'बाध्यकारी अपडेट सक्षम करें';

  @override
  String get enableForcedUpdatesDescription =>
      'सक्षम होने पर, आप मोबाइल ऐप के लिए न्यूनतम आवश्यक संस्करण निर्दिष्ट कर सकते।';

  @override
  String get appUrlsTitle => 'एप्लिकेशन URL';

  @override
  String get appUrlsDescription =>
      'एप्लिकेशन के भीतर उपयोग किए जाने वाले बाहरी और आंतरिक URL प्रबंधित करें।';

  @override
  String get communityAndEngagementTitle => 'समुदाय और जुड़ाव';

  @override
  String get communityAndEngagementDescription =>
      'उपयोगकर्ता जुड़ाव और रिपोर्टिंग टूल कॉन्फ़िगर करें। जवाबदेही सुनिश्चित करने के लिए, यहां कॉन्फ़िगर की गई सेटिंग्स के बावजूद, मोबाइल ऐप के भीतर अतिथि उपयोगकर्ताओं के लिए ये सुविधाएं अनुपलब्ध हैं।';

  @override
  String get userEngagementTitle => 'उपयोगकर्ता जुड़ाव';

  @override
  String get userEngagementDescription =>
      'प्रतिक्रियाएं और टिप्पणियां कॉन्फ़िगर करें।';

  @override
  String get contentReportingTitle => 'सामग्री रिपोर्टिंग';

  @override
  String get contentReportingDescription =>
      'उपयोगकर्ता क्या रिपोर्ट कर सकते हैं, इसके लिए नियम निर्धारित करें।';

  @override
  String get appReviewFunnelTitle => 'ऐप समीक्षाएं';

  @override
  String get appReviewFunnelDescription =>
      'उपयोगकर्ता की संतुष्टि को कैप्चर करने और वैकल्पिक रूप से समीक्षाओं का अनुरोध करने की प्रक्रिया को प्रबंधित करें।';

  @override
  String get enableEngagementFeaturesLabel => 'जुड़ाव सुविधाएं सक्षम करें';

  @override
  String get enableEngagementFeaturesDescription =>
      'सभी प्रतिक्रिया और टिप्पणी कार्यक्षमता को वैश्विक स्तर पर सक्रिय या निष्क्रिय करता है।';

  @override
  String get engagementModeLabel => 'जुड़ाव मोड';

  @override
  String get engagementModeDescription =>
      'निर्धारित करता है कि उपयोगकर्ता केवल प्रतिक्रिया दे सकते हैं या सामग्री पर टिप्पणियां भी जोड़ सकते हैं।';

  @override
  String get engagementModeReactionsOnly => 'केवल प्रतिक्रियाएं';

  @override
  String get engagementModeReactionsAndComments =>
      'प्रतिक्रियाएं और टिप्पणियां';

  @override
  String get enableReportingSystemLabel => 'रिपोर्टिंग सिस्टम सक्षम करें';

  @override
  String get enableReportingSystemDescription =>
      'सभी उपयोगकर्ता-सामना करने वाले रिपोर्टिंग विकल्पों को वैश्विक स्तर पर सक्रिय या निष्क्रिय करता है।';

  @override
  String get enableHeadlineReportingLabel => 'सुर्खी रिपोर्टिंग सक्षम करें';

  @override
  String get enableSourceReportingLabel => 'स्रोत रिपोर्टिंग सक्षम करें';

  @override
  String get enableCommentReportingLabel => 'टिप्पणी रिपोर्टिंग सक्षम करें';

  @override
  String get enableAppFeedbackSystemLabel => 'ऐप फीडबैक सिस्टम सक्षम करें';

  @override
  String get enableAppFeedbackSystemDescription =>
      'आंतरिक प्रणाली को सक्रिय करता है जो समय-समय पर उपयोगकर्ताओं से पूछती है कि क्या वे ऐप का आनंद ले रहे हैं।';

  @override
  String get interactionCycleThresholdLabel => 'इंटरैक्शन साइकिल थ्रेशोल्ड';

  @override
  String get interactionCycleThresholdDescription =>
      'आनंद प्रॉम्प्ट को ट्रिगर करने के लिए आवश्यक सकारात्मक क्रियाओं (जैसे, सहेजना, पसंद करना) की संख्या को परिभाषित करता है। प्रॉम्प्ट हर बार दिखाया जाता है जब उपयोगकर्ता की कुल सकारात्मक क्रियाएं इस संख्या का गुणज होती हैं।';

  @override
  String get initialPromptCooldownLabel => 'प्रारंभिक प्रॉम्प्ट कूलडाउन (दिन)';

  @override
  String get initialPromptCooldownDescription =>
      'पहली बार आनंद प्रॉम्प्ट दिखाने से पहले प्रतीक्षा करने के दिनों की संख्या, यह कूलडाउन सुनिश्चित करता है कि उपयोगकर्ताओं से तब तक नहीं पूछा जाता जब तक कि उन्होंने ऐप का पर्याप्त उपयोग न कर लिया हो।';

  @override
  String get requestStoreReviewLabel =>
      '\'हां\' के बाद स्टोर समीक्षा का अनुरोध करें';

  @override
  String get requestStoreReviewDescription =>
      'यदि सक्षम है, तो आनंद प्रॉम्प्ट पर \'हां\' प्रतिक्रिया देने वाले उपयोगकर्ताओं को आधिकारिक OS स्टोर समीक्षा संवाद दिखाया जाएगा।';

  @override
  String get requestWrittenFeedbackLabel =>
      '\'नहीं\' के बाद लिखित फीडबैक का अनुरोध करें';

  @override
  String get requestWrittenFeedbackDescription =>
      'यदि सक्षम है, तो \'नहीं\' प्रतिक्रिया देने वाले उपयोगकर्ताओं को सीधे टीम को लिखित फीडबैक प्रदान करने के लिए प्रेरित किया जाएगा।';

  @override
  String get internalPromptLogicTitle => 'आंतरिक प्रॉम्प्ट लॉजिक';

  @override
  String get eligiblePositiveInteractionsTitle => 'पात्र सकारात्मक इंटरैक्शन';

  @override
  String get positiveInteractionTypeSaveItem => 'एक सामग्री वस्तु सहेजें';

  @override
  String get positiveInteractionTypeFollowItem => 'एक इकाई का अनुसरण करें';

  @override
  String get positiveInteractionTypeShareContent =>
      'एक सामग्री वस्तु साझा करें';

  @override
  String get positiveInteractionTypeSaveFilter => 'एक सहेजा गया फ़िल्टर बनाएं';

  @override
  String get followUpActionsTitle => 'फॉलो-अप क्रियाएं';

  @override
  String get enableCommunityFeaturesLabel => 'सामुदायिक सुविधाएं सक्षम करें';

  @override
  String get enableCommunityFeaturesDescription =>
      'जुड़ाव और रिपोर्टिंग सहित सभी समुदाय-संबंधित कार्यक्षमता को वैश्विक स्तर पर सक्रिय या निष्क्रिय करता है।';

  @override
  String get communityManagementPageDescription =>
      'जुड़ाव (प्रतिक्रियाएं और टिप्पणियां), सामग्री रिपोर्ट और ऐप समीक्षाओं सहित उपयोगकर्ता-जनित सामग्री प्रबंधित करें।';

  @override
  String get engagements => 'जुड़ाव';

  @override
  String get reports => 'रिपोर्ट';

  @override
  String get appReviews => 'ऐप समीक्षाएं';

  @override
  String get user => 'उपयोगकर्ता';

  @override
  String get engagedContent => 'जुड़ाव वाली सामग्री';

  @override
  String get reaction => 'प्रतिक्रिया';

  @override
  String get comment => 'टिप्पणी';

  @override
  String get commentStatus => 'टिप्पणी स्थिति';

  @override
  String get hasCommentFilterLabel => 'टिप्पणी शामिल है';

  @override
  String get hasCommentFilterDescription =>
      'केवल वे जुड़ाव दिखाएं जिनमें लिखित टिप्पणी शामिल है।';

  @override
  String get date => 'तारीख';

  @override
  String get approveComment => 'टिप्पणी स्वीकृत करें';

  @override
  String get rejectComment => 'टिप्पणी अस्वीकार करें';

  @override
  String get viewEngagedContent => 'सामग्री देखें';

  @override
  String get copyUserId => 'उपयोगकर्ता आईडी कॉपी करें';

  @override
  String get reporter => 'रिपोर्टर';

  @override
  String get reportedItem => 'रिपोर्ट की गई वस्तु';

  @override
  String get reason => 'कारण';

  @override
  String get reportStatus => 'रिपोर्ट स्थिति';

  @override
  String get viewReportedItem => 'वस्तु देखें';

  @override
  String get markAsInReview => 'समीक्षा के अधीन चिह्नित करें';

  @override
  String get resolveReport => 'रिपोर्ट हल करें';

  @override
  String get initialFeedback => 'प्रारंभिक फीडबैक';

  @override
  String get osPromptRequested => 'OS प्रॉम्प्ट अनुरोधित?';

  @override
  String get feedbackHistory => 'फीडबैक इतिहास';

  @override
  String get lastInteraction => 'अंतिम इंटरैक्शन';

  @override
  String get viewFeedbackHistory => 'इतिहास देखें';

  @override
  String get reactionTypeLike => 'पसंद';

  @override
  String get reactionTypeInsightful => 'ज्ञानवर्धक';

  @override
  String get reactionTypeAmusing => 'मनोरंजक';

  @override
  String get reactionTypeSad => 'दुखी';

  @override
  String get reactionTypeAngry => 'क्रोधित';

  @override
  String get reactionTypeSkeptical => 'संदेही';

  @override
  String get initialAppReviewFeedbackPositive => 'सकारात्मक';

  @override
  String get initialAppReviewFeedbackNegative => 'नकारात्मक';

  @override
  String get filterCommunity => 'सामुदायिक सामग्री फ़िल्टर करें';

  @override
  String get searchByEngagementUser => 'उपयोगकर्ता ईमेल द्वारा खोजें...';

  @override
  String get searchByReportReporter => 'रिपोर्टर ईमेल द्वारा खोजें...';

  @override
  String get searchByAppReviewUser => 'उपयोगकर्ता ईमेल द्वारा खोजें...';

  @override
  String get selectCommentStatus => 'टिप्पणी स्थिति चुनें';

  @override
  String get selectReportStatus => 'रिपोर्ट स्थिति चुनें';

  @override
  String get selectInitialFeedback => 'प्रारंभिक फीडबैक चुनें';

  @override
  String get selectReportableEntity => 'रिपोर्ट की गई वस्तु का प्रकार चुनें';

  @override
  String get reportableEntityHeadline => 'सुर्खी';

  @override
  String get reportableEntitySource => 'स्रोत';

  @override
  String get reportableEntityComment => 'टिप्पणी';

  @override
  String get noEngagementsFound => 'कोई जुड़ाव नहीं मिला।';

  @override
  String get noReportsFound => 'कोई रिपोर्ट नहीं मिली।';

  @override
  String get noAppReviewsFound => 'कोई ऐप समीक्षा नहीं मिली।';

  @override
  String get loadingEngagements => 'जुड़ाव लोड हो रहे हैं';

  @override
  String get loadingReports => 'रिपोर्ट लोड हो रही हैं';

  @override
  String get loadingAppReviews => 'ऐप समीक्षाएं लोड हो रही हैं';

  @override
  String get userIdCopied => 'उपयोगकर्ता आईडी क्लिपबोर्ड पर कॉपी की गई।';

  @override
  String get reportStatusUpdated => 'रिपोर्ट स्थिति अपडेट की गई।';

  @override
  String feedbackHistoryForUser(String email) {
    return '$email के लिए फीडबैक इतिहास';
  }

  @override
  String get noFeedbackHistory =>
      'इस उपयोगकर्ता के लिए कोई फीडबैक इतिहास उपलब्ध नहीं है।';

  @override
  String feedbackProvidedAt(String date) {
    return 'फीडबैक प्रदान किया गया: $date';
  }

  @override
  String feedbackReason(String reason) {
    return 'कारण: $reason';
  }

  @override
  String get noReasonProvided => 'कोई कारण नहीं दिया गया।';

  @override
  String get yes => 'हां';

  @override
  String get no => 'नहीं';

  @override
  String get reportReasonMisinformationOrFakeNews => 'गलत सूचना / फर्जी खबरें';

  @override
  String get reportReasonClickbaitTitle => 'क्लिकबेट शीर्षक';

  @override
  String get reportReasonOffensiveOrHateSpeech => 'अपमानजनक / अभद्र भाषा';

  @override
  String get reportReasonSpamOrScam => 'स्पैम / घोटाला';

  @override
  String get reportReasonBrokenLink => 'टूटा हुआ लिंक';

  @override
  String get reportReasonPaywalled => 'पेवॉल';

  @override
  String get reportReasonLowQualityJournalism =>
      'निम्न गुणवत्ता वाली पत्रकारिता';

  @override
  String get reportReasonHighAdDensity => 'उच्च विज्ञापन घनत्व';

  @override
  String get reportReasonBlog => 'ब्लॉग';

  @override
  String get reportReasonGovernmentSource => 'सरकारी स्रोत';

  @override
  String get reportReasonAggregator => 'एग्रीगेटर';

  @override
  String get reportReasonOther => 'अन्य';

  @override
  String get reportReasonFrequentPaywalls => 'बार-बार पेवॉल';

  @override
  String get reportReasonImpersonation => 'प्रतिरूपण';

  @override
  String get noNegativeFeedbackHistory =>
      'इस उपयोगकर्ता के लिए कोई नकारात्मक फीडबैक इतिहास नहीं मिला।';

  @override
  String get reject => 'अस्वीकार करें';

  @override
  String get commentStatusFlaggedByAi => 'AI द्वारा ध्वजांकित';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get rejectCommentConfirmation =>
      'क्या आप वाकई इस टिप्पणी को अस्वीकार करना और स्थायी रूप से हटाना चाहते हैं? इस क्रिया को पूर्ववत नहीं किया जा सकता।';

  @override
  String get searchByUserId => 'उपयोगकर्ता आईडी द्वारा खोजें...';

  @override
  String get viewReportedHeadline => 'सुर्खी देखें';

  @override
  String get viewReportedSource => 'स्रोत देखें';

  @override
  String get viewReportedComment => 'टिप्पणी देखें';

  @override
  String get entityType => 'इकाई प्रकार';

  @override
  String get feedback => 'फीडबैक';

  @override
  String get feedbackDetails => 'फीडबैक विवरण';

  @override
  String get moderationStatusPendingReview => 'समीक्षा लंबित';

  @override
  String get moderationStatusResolved => 'हल किया गया';

  @override
  String get hasComment => 'टिप्पणी है';

  @override
  String get any => 'कोई भी';

  @override
  String get withComment => 'टिप्पणी के साथ';

  @override
  String get withoutComment => 'टिप्पणी के बिना';

  @override
  String get reportResolved => 'रिपोर्ट हल हो गई।';

  @override
  String get commentApproved => 'टिप्पणी स्वीकृत।';

  @override
  String get commentRejected => 'टिप्पणी अस्वीकृत।';

  @override
  String get copyHeadlineId => 'सुर्खी आईडी कॉपी करें';

  @override
  String get copyReportedItemId => 'रिपोर्ट की गई वस्तु आईडी कॉपी करें';

  @override
  String get viewFeedbackDetails => 'फीडबैक विवरण देखें';

  @override
  String get reportDetails => 'रिपोर्ट विवरण';

  @override
  String get commentDetails => 'टिप्पणी विवरण';

  @override
  String get communityManagement => 'सामुदायिक प्रबंधन';

  @override
  String get navContent => 'सामग्री';

  @override
  String get navUsers => 'उपयोगकर्ता';

  @override
  String get navCommunity => 'समुदाय';

  @override
  String get confirmPromotionTitle => 'पदोन्नति की पुष्टि करें';

  @override
  String confirmPromotionMessage(String email) {
    return 'क्या आप वाकई $email को प्रकाशक के रूप में पदोन्नत करना चाहते हैं?';
  }

  @override
  String get confirmDemotionTitle => 'पदावनति की पुष्टि करें';

  @override
  String confirmDemotionMessage(String email) {
    return 'क्या आप वाकई $email को मानक उपयोगकर्ता के रूप में पदावनत करना चाहते हैं?';
  }

  @override
  String get premiumUserTooltip => 'प्रीमियम';

  @override
  String get adminUserTooltip => 'प्रशासक';

  @override
  String get publisherUserTooltip => 'प्रकाशक';

  @override
  String get breakingNewsHint => 'यह एक ब्रेकिंग न्यूज सुर्खी है';

  @override
  String get breakingNewsFilterDescription =>
      'केवल ब्रेकिंग न्यूज सुर्खियां दिखाएं';

  @override
  String publishItemTitle(String itemType) {
    return '$itemType प्रकाशित करें?';
  }

  @override
  String publishItemContent(String itemType) {
    return 'क्या आप वाकई इस $itemType को प्रकाशित करना चाहते हैं? यह सार्वजनिक रूप से दृश्यमान हो जाएगा।';
  }

  @override
  String archiveItemTitle(String itemType) {
    return '$itemType संग्रहित करें?';
  }

  @override
  String archiveItemContent(String itemType) {
    return 'क्या आप वाकई इस $itemType को संग्रहित करना चाहते हैं? यह सार्वजनिक दृश्य से छिप जाएगा।';
  }

  @override
  String restoreItemTitle(String itemType) {
    return '$itemType पुनर्स्थापित करें?';
  }

  @override
  String restoreItemContent(String itemType) {
    return 'क्या आप वाकई इस $itemType को पुनर्स्थापित करना चाहते हैं? यह फिर से सक्रिय और सार्वजनिक रूप से दृश्यमान हो जाएगा।';
  }

  @override
  String deleteItemTitle(String itemType) {
    return '$itemType हटाएं?';
  }

  @override
  String deleteItemContent(String itemType) {
    return 'क्या आप वाकई इस $itemType को हटाना चाहते हैं? ';
  }

  @override
  String itemDeletedSnackbar(String itemType, String itemName) {
    return '$itemType \"$itemName\" हटा दिया गया।';
  }

  @override
  String get adPlatformConfigurationDescription =>
      'प्राथमिक विज्ञापन प्रदाता चुनें और उनकी संबंधित विज्ञापन इकाई आईडी कॉन्फ़िगर करें।';

  @override
  String get feedAdSettingsDescription =>
      'उपयोगकर्ता के सामग्री फ़ीड के भीतर विज्ञापन दृश्यता, प्रकार और आवृत्ति को नियंत्रित करें।';

  @override
  String get navigationAdConfigDescription =>
      'उपयोगकर्ता नेविगेशन के दौरान दिखाई देने वाले इंटरस्टिशियल विज्ञापनों को कॉन्फ़िगर करें।';

  @override
  String get feedDecoratorLinkAccountDescription =>
      'अतिथि उपयोगकर्ताओं को पूर्ण खाता बनाने के लिए प्रेरित करता है।';

  @override
  String get feedDecoratorUpgradeDescription =>
      'मानक उपयोगकर्ताओं को प्रीमियम सदस्यता में अपग्रेड करने के लिए प्रेरित करता है।';

  @override
  String get feedDecoratorRateAppDescription =>
      'उपयोगकर्ताओं को ऐप स्टोर में एप्लिकेशन को रेट करने के लिए प्रेरित करता है।';

  @override
  String get feedDecoratorEnableNotificationsDescription =>
      'उपयोगकर्ताओं को पुश सूचनाएं सक्षम करने के लिए प्रेरित करता है।';

  @override
  String get feedDecoratorSuggestedTopicsDescription =>
      'उन विषयों का संग्रह दिखाता है जिनमें उपयोगकर्ता अनुसरण करने में रुचि रख सकता है।';

  @override
  String get feedDecoratorSuggestedSourcesDescription =>
      'उन स्रोतों का संग्रह दिखाता है जिनमें उपयोगकर्ता अनुसरण करने में रुचि रख सकता है।';

  @override
  String get enableGlobalAdsDescription =>
      'एप्लिकेशन के भीतर सभी विज्ञापनों को वैश्विक स्तर पर सक्रिय या निष्क्रिय करें।';

  @override
  String get enableFeedAdsDescription =>
      'सामग्री फ़ीड के भीतर सभी विज्ञापनों की दृश्यता को नियंत्रित करें।';

  @override
  String visibleToRoleDescription(String roleName) {
    return 'सक्षम होने पर, यह सुविधा \'$roleName\' भूमिका वाले उपयोगकर्ताओं के लिए सक्रिय होगी।';
  }

  @override
  String get enableDecoratorDescription =>
      'सभी पात्र उपयोगकर्ताओं के लिए इस डेकोरेटर को वैश्विक स्तर पर सक्रिय या निष्क्रिय करें।';

  @override
  String get enableNavigationAdsDescription =>
      'उपयोगकर्ता नेविगेशन के दौरान दिखाई देने वाले इंटरस्टिशियल विज्ञापनों की दृश्यता को नियंत्रित करें।';

  @override
  String get enableHeadlineReportingDescription =>
      'उपयोगकर्ताओं को गलत सूचना या क्लिकबेट जैसी समस्याओं के लिए व्यक्तिगत सुर्खियों की रिपोर्ट करने की अनुमति दें।';

  @override
  String get enableSourceReportingDescription =>
      'उपयोगकर्ताओं को निम्न गुणवत्ता या पूर्वाग्रह जैसी समस्याओं के लिए संपूर्ण समाचार स्रोतों की रिपोर्ट करने की अनुमति दें।';

  @override
  String get enableCommentReportingDescription =>
      'उपयोगकर्ताओं को मॉडरेशन के लिए व्यक्तिगत टिप्पणियों की रिपोर्ट करने की अनुमति दें।';

  @override
  String get pushNotificationDeliveryTypeBreakingOnlyDescription =>
      'उपयोगकर्ताओं को ब्रेकिंग न्यूज के लिए तत्काल अलर्ट सब्सक्राइब करने की अनुमति देने के लिए सक्षम करें।';

  @override
  String get pushNotificationDeliveryTypeDailyDigestDescription =>
      'उपयोगकर्ताओं को प्रासंगिक समाचारों के दैनिक सारांश को सब्सक्राइब करने की अनुमति देने के लिए सक्षम करें।';

  @override
  String get pushNotificationDeliveryTypeWeeklyRoundupDescription =>
      'उपयोगकर्ताओं को प्रासंगिक समाचारों के साप्ताहिक राउंडअप को सब्सक्राइब करने की अनुमति देने के लिए सक्षम करें।';

  @override
  String get positiveInteractionTypeSaveItemDescription =>
      'जब कोई उपयोगकर्ता सुर्खी बुकमार्क करता है तो गिना जाता है।';

  @override
  String get positiveInteractionTypeFollowItemDescription =>
      'जब कोई उपयोगकर्ता सुर्खी विषय, स्रोत या देश का अनुसरण करता है तो गिना जाता है।';

  @override
  String get positiveInteractionTypeShareContentDescription =>
      'जब कोई उपयोगकर्ता सुर्खी साझा करता है तो गिना जाता है।';

  @override
  String get positiveInteractionTypeSaveFilterDescription =>
      'जब कोई उपयोगकर्ता सहेजा गया फ़िल्टर बनाता है तो गिना जाता है।';

  @override
  String get internalPromptLogicDescription =>
      'उन स्थितियों को परिभाषित करें जो आनंद प्रॉम्प्ट को ट्रिगर करती हैं, जैसे उपयोगकर्ता क्रियाओं की संख्या और कूलडाउन अवधि।';

  @override
  String get eligiblePositiveInteractionsDescription =>
      'चुनें कि आनंद प्रॉम्प्ट को ट्रिगर करने के लिए किन उपयोगकर्ता क्रियाओं को \'सकारात्मक इंटरैक्शन\' के रूप में गिना जाता है।';

  @override
  String get followUpActionsDescription =>
      'कॉन्फ़िगर करें कि उपयोगकर्ता द्वारा आनंद प्रॉम्प्ट का जवाब देने के बाद क्या होता है, जैसे स्टोर समीक्षा का अनुरोध करना।';

  @override
  String get analyticsTab => 'एनालिटिक्स';

  @override
  String get analyticsDescription =>
      'एनालिटिक्स प्रदाता, इवेंट लॉगिंग और सैंपलिंग दरें कॉन्फ़िगर करें।';

  @override
  String get analyticsSystemStatusTitle => 'एनालिटिक्स सिस्टम सक्षम करें';

  @override
  String get analyticsSystemStatusDescription =>
      'सभी एनालिटिक्स ट्रैकिंग को सक्षम या अक्षम करने के लिए मास्टर स्विच।';

  @override
  String get analyticsProviderTitle => 'सक्रिय प्रदाता';

  @override
  String get analyticsProviderDescription =>
      'प्राथमिक एनालिटिक्स सेवा प्रदाता चुनें।';

  @override
  String get analyticsEventsTitle => 'इवेंट कॉन्फ़िगरेशन';

  @override
  String get analyticsEventsDescription =>
      'विशिष्ट इवेंट्स के लिए लॉगिंग को फाइन-ट्यून करें। शोर वाले इवेंट्स को अक्षम करें या सैंपलिंग दरों को समायोजित करें।';

  @override
  String samplingRateLabel(int rate) {
    return 'सैंपलिंग दर: $rate%';
  }

  @override
  String get analyticsProviderFirebase => 'Firebase';

  @override
  String get analyticsProviderMixpanel => 'Mixpanel';

  @override
  String get analyticsEventUserRegisteredLabel => 'उपयोगकर्ता पंजीकरण';

  @override
  String get analyticsEventUserRegisteredDescription =>
      'ट्रैक करें कि नया उपयोगकर्ता सफलतापूर्वक खाता कब बनाता है।';

  @override
  String get analyticsEventUserLoginLabel => 'उपयोगकर्ता लॉगिन';

  @override
  String get analyticsEventUserLoginDescription =>
      'ट्रैक करें कि उपयोगकर्ता एप्लिकेशन में कब लॉगिन करता है।';

  @override
  String get analyticsEventAccountLinkedLabel => 'खाता लिंकिंग';

  @override
  String get analyticsEventAccountLinkedDescription =>
      'ट्रैक करें कि अतिथि उपयोगकर्ता अपने खाते को स्थायी क्रेडेंशियल से कब लिंक करता है।';

  @override
  String get analyticsEventUserRoleChangedLabel => 'उपयोगकर्ता भूमिका परिवर्तन';

  @override
  String get analyticsEventUserRoleChangedDescription =>
      'ट्रैक करें कि उपयोगकर्ता की भूमिका कब अपडेट की जाती है (जैसे, प्रीमियम में अपग्रेड)।';

  @override
  String get analyticsEventContentViewedLabel => 'सामग्री दृश्य';

  @override
  String get analyticsEventContentViewedDescription =>
      'ट्रैक करें कि उपयोगकर्ता सुर्खी या लेख कब देखता है।';

  @override
  String get analyticsEventContentSharedLabel => 'सामग्री साझाकरण';

  @override
  String get analyticsEventContentSharedDescription =>
      'ट्रैक करें कि उपयोगकर्ता बाहरी प्लेटफ़ॉर्म के माध्यम से सामग्री कब साझा करता है।';

  @override
  String get analyticsEventContentSavedLabel => 'सामग्री सहेजना';

  @override
  String get analyticsEventContentSavedDescription =>
      'ट्रैक करें कि उपयोगकर्ता सुर्खी कब बुकमार्क करता है।';

  @override
  String get analyticsEventContentUnsavedLabel => 'सामग्री सहेजना रद्द करना';

  @override
  String get analyticsEventContentUnsavedDescription =>
      'ट्रैक करें कि उपयोगकर्ता बुकमार्क कब हटाता है।';

  @override
  String get analyticsEventContentReadingTimeLabel => 'सामग्री पढ़ने का समय';

  @override
  String get analyticsEventContentReadingTimeDescription =>
      'उपयोगकर्ता द्वारा लेख पढ़ने में बिताए गए समय को ट्रैक करें।';

  @override
  String get analyticsEventReactionCreatedLabel => 'प्रतिक्रिया जोड़ी गई';

  @override
  String get analyticsEventReactionCreatedDescription =>
      'ट्रैक करें कि उपयोगकर्ता सामग्री पर कब प्रतिक्रिया देता है।';

  @override
  String get analyticsEventReactionDeletedLabel => 'प्रतिक्रिया हटाई गई';

  @override
  String get analyticsEventReactionDeletedDescription =>
      'ट्रैक करें कि उपयोगकर्ता अपनी प्रतिक्रिया कब हटाता है।';

  @override
  String get analyticsEventCommentCreatedLabel => 'टिप्पणी पोस्ट की गई';

  @override
  String get analyticsEventCommentCreatedDescription =>
      'ट्रैक करें कि उपयोगकर्ता नई टिप्पणी कब सबमिट करता है।';

  @override
  String get analyticsEventCommentDeletedLabel => 'टिप्पणी हटाई गई';

  @override
  String get analyticsEventCommentDeletedDescription =>
      'ट्रैक करें कि उपयोगकर्ता अपनी टिप्पणी कब हटाता है।';

  @override
  String get analyticsEventReportSubmittedLabel => 'रिपोर्ट सबमिट की गई';

  @override
  String get analyticsEventReportSubmittedDescription =>
      'ट्रैक करें कि उपयोगकर्ता सामग्री या अन्य उपयोगकर्ताओं की रिपोर्ट कब करता है।';

  @override
  String get analyticsEventHeadlineFilterCreatedLabel =>
      'सुर्खी फ़िल्टर निर्माण';

  @override
  String get analyticsEventHeadlineFilterCreatedDescription =>
      'ट्रैक करें कि उपयोगकर्ता नया कस्टम सुर्खी फ़िल्टर कब बनाता है।';

  @override
  String get analyticsEventHeadlineFilterUpdatedLabel => 'सुर्खी फ़िल्टर अपडेट';

  @override
  String get analyticsEventHeadlineFilterUpdatedDescription =>
      'ट्रैक करें कि उपयोगकर्ता मौजूदा सुर्खी फ़िल्टर को कब संशोधित करता है।';

  @override
  String get analyticsEventHeadlineFilterUsedLabel => 'सुर्खी फ़िल्टर उपयोग';

  @override
  String get analyticsEventHeadlineFilterUsedDescription =>
      'ट्रैक करें कि उपयोगकर्ता सहेजा गया सुर्खी फ़िल्टर कब लागू करता है।';

  @override
  String get analyticsEventSearchPerformedLabel => 'खोज की गई';

  @override
  String get analyticsEventSearchPerformedDescription =>
      'ट्रैक करें कि उपयोगकर्ता खोज क्वेरी कब करता है।';

  @override
  String get analyticsEventAppReviewPromptRespondedLabel =>
      'समीक्षा प्रॉम्प्ट प्रतिक्रिया';

  @override
  String get analyticsEventAppReviewPromptRespondedDescription =>
      'आंतरिक \'ऐप का आनंद ले रहे हैं?\' प्रॉम्प्ट पर उपयोगकर्ता की प्रतिक्रियाओं को ट्रैक करें।';

  @override
  String get analyticsEventAppReviewStoreRequestedLabel =>
      'स्टोर समीक्षा अनुरोध';

  @override
  String get analyticsEventAppReviewStoreRequestedDescription =>
      'ट्रैक करें कि नेटिव OS स्टोर समीक्षा संवाद का अनुरोध कब किया जाता है।';

  @override
  String get analyticsEventLimitExceededLabel => 'सीमा पार हो गई';

  @override
  String get analyticsEventLimitExceededDescription =>
      'ट्रैक करें कि उपयोगकर्ता उपयोग सीमा (जैसे, सहेजी गई वस्तुओं की सीमा) तक कब पहुंचता है।';

  @override
  String get analyticsEventLimitExceededCtaClickedLabel => 'सीमा CTA क्लिक';

  @override
  String get analyticsEventLimitExceededCtaClickedDescription =>
      'सीमा संवादों में \'अपग्रेड\' या \'खाता लिंक करें\' बटन पर क्लिक को ट्रैक करें।';

  @override
  String get analyticsEventPaywallPresentedLabel => 'पेवॉल इंप्रेशन';

  @override
  String get analyticsEventPaywallPresentedDescription =>
      'ट्रैक करें कि उपयोगकर्ता को पेवॉल स्क्रीन कब दिखाई जाती है।';

  @override
  String get analyticsEventSubscriptionStartedLabel => 'सदस्यता शुरू';

  @override
  String get analyticsEventSubscriptionStartedDescription =>
      'ट्रैक करें कि उपयोगकर्ता सफलतापूर्वक नई सदस्यता कब शुरू करता है।';

  @override
  String get analyticsEventSubscriptionRenewedLabel => 'सदस्यता नवीनीकरण';

  @override
  String get analyticsEventSubscriptionRenewedDescription =>
      'ट्रैक करें कि सदस्यता स्वचालित रूप से या मैन्युअल रूप से कब नवीनीकृत की जाती है।';

  @override
  String get analyticsEventSubscriptionCancelledLabel => 'सदस्यता रद्द';

  @override
  String get analyticsEventSubscriptionCancelledDescription =>
      'ट्रैक करें कि उपयोगकर्ता अपनी सदस्यता कब रद्द करता है।';

  @override
  String get analyticsEventSubscriptionEndedLabel => 'सदस्यता समाप्त';

  @override
  String get analyticsEventSubscriptionEndedDescription =>
      'ट्रैक करें कि सदस्यता कब समाप्त या समाप्त हो जाती है।';

  @override
  String get analyticsEventAdImpressionLabel => 'विज्ञापन इंप्रेशन';

  @override
  String get analyticsEventAdImpressionDescription =>
      'ट्रैक करें कि उपयोगकर्ता को विज्ञापन कब प्रदर्शित किया जाता है।';

  @override
  String get analyticsEventAdClickedLabel => 'विज्ञापन क्लिक';

  @override
  String get analyticsEventAdClickedDescription =>
      'ट्रैक करें कि उपयोगकर्ता विज्ञापन पर कब क्लिक करता है।';

  @override
  String get analyticsEventAdLoadFailedLabel => 'विज्ञापन लोड विफल';

  @override
  String get analyticsEventAdLoadFailedDescription =>
      'विज्ञापन लोड करने के प्रयास के दौरान त्रुटियों को ट्रैक करें।';

  @override
  String get analyticsEventAdRewardEarnedLabel => 'विज्ञापन इनाम अर्जित';

  @override
  String get analyticsEventAdRewardEarnedDescription =>
      'ट्रैक करें कि उपयोगकर्ता रिवॉर्डेड विज्ञापन क्रिया कब पूरी करता है।';

  @override
  String get analyticsEventThemeChangedLabel => 'थीम परिवर्तन';

  @override
  String get analyticsEventThemeChangedDescription =>
      'ट्रैक करें कि उपयोगकर्ता एप्लिकेशन थीम कब बदलता है।';

  @override
  String get analyticsEventLanguageChangedLabel => 'भाषा परिवर्तन';

  @override
  String get analyticsEventLanguageChangedDescription =>
      'ट्रैक करें कि उपयोगकर्ता एप्लिकेशन भाषा कब बदलता है।';

  @override
  String get analyticsEventFeedDensityChangedLabel => 'फ़ीड घनत्व परिवर्तन';

  @override
  String get analyticsEventFeedDensityChangedDescription =>
      'ट्रैक करें कि उपयोगकर्ता फ़ीड की सूचना घनत्व को कब समायोजित करता है।';

  @override
  String get analyticsEventBrowserChoiceChangedLabel =>
      'ब्राउज़र प्राथमिकता परिवर्तन';

  @override
  String get analyticsEventBrowserChoiceChangedDescription =>
      'ट्रैक करें कि उपयोगकर्ता लिंक खोलने के लिए अपना पसंदीदा ब्राउज़र कब बदलता है।';

  @override
  String get analyticsEventAppTourStartedLabel => 'ऐप टूर शुरू';

  @override
  String get analyticsEventAppTourStartedDescription =>
      'ट्रैक करें कि प्रमाणीकरण-पूर्व ऐप टूर कब दिखाया जाता है।';

  @override
  String get analyticsEventAppTourStepViewedLabel => 'ऐप टूर स्टेप दृश्य';

  @override
  String get analyticsEventAppTourStepViewedDescription =>
      'ऐप टूर के भीतर प्रत्येक पेज दृश्य को ट्रैक करें।';

  @override
  String get analyticsEventAppTourCompletedLabel => 'ऐप टूर पूरा';

  @override
  String get analyticsEventAppTourCompletedDescription =>
      'ट्रैक करें कि उपयोगकर्ता ऐप टूर कब पूरा करता है।';

  @override
  String get analyticsEventAppTourSkippedLabel => 'ऐप टूर छोड़ा गया';

  @override
  String get analyticsEventAppTourSkippedDescription =>
      'ट्रैक करें कि क्या उपयोगकर्ता ऐप टूर छोड़ देता है।';

  @override
  String get analyticsEventInitialPersonalizationStartedLabel =>
      'प्रारंभिक वैयक्तिकरण शुरू';

  @override
  String get analyticsEventInitialPersonalizationStartedDescription =>
      'ट्रैक करें कि प्रमाणीकरण के बाद वैयक्तिकरण प्रवाह कब शुरू होता है।';

  @override
  String get analyticsEventInitialPersonalizationStepViewedLabel =>
      'वैयक्तिकरण स्टेप दृश्य';

  @override
  String get analyticsEventInitialPersonalizationStepViewedDescription =>
      'वैयक्तिकरण प्रवाह के भीतर प्रत्येक स्टेप दृश्य को ट्रैक करें।';

  @override
  String get analyticsEventInitialPersonalizationCompletedLabel =>
      'वैयक्तिकरण पूरा';

  @override
  String get analyticsEventInitialPersonalizationCompletedDescription =>
      'ट्रैक करें कि उपयोगकर्ता वैयक्तिकरण प्रवाह कब पूरा करता है।';

  @override
  String get analyticsEventInitialPersonalizationSkippedLabel =>
      'वैयक्तिकरण छोड़ा गया';

  @override
  String get analyticsEventInitialPersonalizationSkippedDescription =>
      'ट्रैक करें कि क्या उपयोगकर्ता वैयक्तिकरण प्रवाह छोड़ देता है।';

  @override
  String get timeFrameDay => '24H';

  @override
  String get timeFrameWeek => '7D';

  @override
  String get timeFrameMonth => '30D';

  @override
  String get timeFrameYear => '1Y';

  @override
  String get noDataAvailable => 'कोई डेटा उपलब्ध नहीं';

  @override
  String get vsPreviousPeriod => 'बनाम पिछली अवधि';

  @override
  String get vsPreviousDay => 'बनाम पिछला 24h';

  @override
  String get vsPreviousWeek => 'बनाम पिछला 7 दिन';

  @override
  String get vsPreviousMonth => 'बनाम पिछला 30 दिन';

  @override
  String get vsPreviousYear => 'बनाम पिछला वर्ष';

  @override
  String get kpiUsersTotalRegistered => 'कुल पंजीकृत उपयोगकर्ता';

  @override
  String get kpiUsersNewRegistrations => 'नए पंजीकरण';

  @override
  String get kpiUsersActiveUsers => 'सक्रिय उपयोगकर्ता';

  @override
  String get kpiContentHeadlinesTotalPublished => 'कुल प्रकाशित सुर्खियां';

  @override
  String get kpiContentHeadlinesTotalViews => 'कुल सुर्खी दृश्य';

  @override
  String get kpiContentHeadlinesTotalLikes => 'कुल सुर्खी पसंद';

  @override
  String get kpiContentSourcesTotalSources => 'कुल स्रोत';

  @override
  String get kpiContentSourcesNewSources => 'नए स्रोत';

  @override
  String get kpiContentSourcesTotalFollowers => 'कुल स्रोत अनुयायी';

  @override
  String get kpiContentTopicsTotalTopics => 'कुल विषय';

  @override
  String get kpiContentTopicsNewTopics => 'नए विषय';

  @override
  String get kpiContentTopicsTotalFollowers => 'कुल विषय अनुयायी';

  @override
  String get kpiEngagementsTotalReactions => 'कुल प्रतिक्रियाएं';

  @override
  String get kpiEngagementsTotalComments => 'कुल टिप्पणियां';

  @override
  String get kpiEngagementsAverageEngagementRate => 'औसत जुड़ाव दर';

  @override
  String get kpiEngagementsReportsPending => 'लंबित रिपोर्ट';

  @override
  String get kpiEngagementsReportsResolved => 'हल की गई रिपोर्ट';

  @override
  String get kpiEngagementsReportsAverageResolutionTime => 'औसत समाधान समय';

  @override
  String get kpiEngagementsAppReviewsTotalFeedback => 'कुल फीडबैक';

  @override
  String get kpiEngagementsAppReviewsPositiveFeedback => 'सकारात्मक फीडबैक';

  @override
  String get kpiEngagementsAppReviewsStoreRequests => 'स्टोर समीक्षा अनुरोध';

  @override
  String get chartUsersRegistrationsOverTime => 'समय के साथ पंजीकरण';

  @override
  String get chartUsersActiveUsersOverTime => 'सक्रिय उपयोगकर्ता रुझान';

  @override
  String get chartUsersRoleDistribution => 'उपयोगकर्ता भूमिका वितरण';

  @override
  String get chartContentHeadlinesViewsOverTime => 'सुर्खी दृश्य रुझान';

  @override
  String get chartContentHeadlinesLikesOverTime => 'सुर्खी पसंद रुझान';

  @override
  String get chartContentHeadlinesViewsByTopic => 'विषय के अनुसार दृश्य';

  @override
  String get chartContentSourcesHeadlinesPublishedOverTime => 'स्रोत गतिविधि';

  @override
  String get chartContentSourcesFollowersOverTime => 'स्रोत अनुयायी वृद्धि';

  @override
  String get chartContentSourcesEngagementByType =>
      'स्रोत प्रकार के अनुसार जुड़ाव';

  @override
  String get chartContentTopicsFollowersOverTime => 'विषय अनुयायी वृद्धि';

  @override
  String get chartContentTopicsHeadlinesPublishedOverTime => 'विषय गतिविधि';

  @override
  String get chartContentTopicsEngagementByTopic => 'विषय के अनुसार जुड़ाव';

  @override
  String get chartEngagementsReactionsOverTime => 'प्रतिक्रिया रुझान';

  @override
  String get chartEngagementsCommentsOverTime => 'टिप्पणी रुझान';

  @override
  String get chartEngagementsReactionsByType => 'प्रतिक्रिया वितरण';

  @override
  String get chartEngagementsReportsSubmittedOverTime => 'सबमिट की गई रिपोर्ट';

  @override
  String get chartEngagementsReportsResolutionTimeOverTime =>
      'समाधान समय रुझान';

  @override
  String get chartEngagementsReportsByReason => 'कारण के अनुसार रिपोर्ट';

  @override
  String get chartEngagementsAppReviewsFeedbackOverTime => 'फीडबैक रुझान';

  @override
  String get chartEngagementsAppReviewsPositiveVsNegative => 'भावना विश्लेषण';

  @override
  String get chartEngagementsAppReviewsStoreRequestsOverTime =>
      'स्टोर अनुरोध रुझान';

  @override
  String get chartContentSourcesStatusDistribution => 'स्रोत स्थिति वितरण';

  @override
  String get chartContentHeadlinesBreakingNewsDistribution =>
      'ब्रेकिंग न्यूज वितरण';

  @override
  String get chartOverviewAppTourFunnel => 'ऐप टूर फ़नल';

  @override
  String get chartOverviewInitialPersonalizationFunnel =>
      'प्रारंभिक वैयक्तिकरण फ़नल';

  @override
  String get rankedListOverviewHeadlinesMostViewed =>
      'सर्वाधिक देखी गई सुर्खियां';

  @override
  String get rankedListOverviewHeadlinesMostLiked =>
      'सर्वाधिक पसंद की गई सुर्खियां';

  @override
  String get rankedListOverviewSourcesMostFollowed =>
      'सर्वाधिक अनुसरण किए गए स्रोत';

  @override
  String get rankedListOverviewTopicsMostFollowed =>
      'सर्वाधिक अनुसरण किए गए विषय';

  @override
  String get subscriptionTab => 'सदस्यताएं';

  @override
  String get subscriptionDescription =>
      'उपयोगकर्ताओं को दी जाने वाली सदस्यता योजनाओं (जैसे, मासिक, वार्षिक) को कॉन्फ़िगर करें। सक्षम होने पर, जो उपयोगकर्ता अपनी सुविधा सीमा तक पहुँच जाते हैं, उन्हें प्रीमियम स्तर पर अपग्रेड करने के लिए प्रेरित किया जाएगा।';

  @override
  String get enableSubscriptionLabel => 'सदस्यता सुविधा सक्षम करें';

  @override
  String get enableSubscriptionDescription =>
      'सदस्यता प्रणाली के लिए मास्टर स्विच। सक्षम होने पर, उपयोगकर्ता अपने एक्सेस स्तर (जैसे, मानक से प्रीमियम तक) को अपग्रेड करने के लिए योजनाएं खरीद सकते हैं।';

  @override
  String get monthlyPlanTitle => 'मासिक योजना';

  @override
  String get annualPlanTitle => 'वार्षिक योजना';

  @override
  String get planEnabledLabel => 'योजना सक्षम करें';

  @override
  String get planRecommendedLabel => 'अनुशंसित योजना';

  @override
  String get planRecommendedDescription =>
      'इस योजना को सर्वोत्तम मूल्य विकल्प के रूप में हाइलाइट करता है।';

  @override
  String get appleProductIdLabel => 'Apple ऐप स्टोर उत्पाद आईडी';

  @override
  String get googleProductIdLabel => 'Google Play स्टोर उत्पाद आईडी';

  @override
  String get subscriptionPlanEnablementError =>
      'कृपया इस योजना को सक्षम करने के लिए कम से कम एक उत्पाद आईडी दर्ज करें।';

  @override
  String get subscriptionPlanDisabledNotification =>
      'योजना अक्षम है क्योंकि कोई उत्पाद आईडी प्रदान नहीं की गई है।';

  @override
  String get subscriptionFeatureDisabledNotification =>
      'सदस्यता सुविधा अक्षम है क्योंकि कोई योजना सक्रिय नहीं है।';

  @override
  String get pushNotificationFeatureDisabledNotification =>
      'पुश अधिसूचना प्रणाली अक्षम है क्योंकि कोई वितरण प्रकार सक्रिय नहीं है।';

  @override
  String get analyticsFeatureDisabledNotification =>
      'एनालिटिक्स सिस्टम अक्षम है क्योंकि सभी इवेंट अक्षम हैं।';

  @override
  String get reportingFeatureDisabledNotification =>
      'रिपोर्टिंग सिस्टम अक्षम है क्योंकि कोई रिपोर्टिंग विकल्प सक्रिय नहीं है।';

  @override
  String get appReviewFeatureDisabledNotification =>
      'ऐप समीक्षा प्रणाली अक्षम है क्योंकि कोई सकारात्मक इंटरैक्शन नहीं चुना गया है।';

  @override
  String get subscriptionsName => 'सदस्यताएं';

  @override
  String get subscriptionProvider => 'स्टोर प्रदाता';

  @override
  String get accessTier => 'एक्सेस स्तर';

  @override
  String get expiryDate => 'समाप्ति तिथि';

  @override
  String get willAutoRenew => 'स्वतः नवीनीकरण';

  @override
  String get allAccessTiers => 'सभी स्तर';

  @override
  String get subscriptionActionCopyUserId => 'उपयोगकर्ता आईडी कॉपी करें';

  @override
  String get subscriptionActionCopySubscriptionId => 'सदस्यता आईडी कॉपी करें';

  @override
  String get filterSubscriptions => 'सदस्यताएं फ़िल्टर करें';

  @override
  String get selectStatus => 'स्थिति चुनें';

  @override
  String get selectProvider => 'प्रदाता चुनें';

  @override
  String get selectTier => 'स्तर चुनें';

  @override
  String get noSubscriptionsFound => 'कोई सदस्यता नहीं मिली।';

  @override
  String get loadingSubscriptions => 'सदस्यताएं लोड हो रही हैं';

  @override
  String get searchByUserIdOrSubscriptionId =>
      'उपयोगकर्ता आईडी या सदस्यता आईडी द्वारा खोजें...';

  @override
  String get subscriptionsPageDescription =>
      'उपयोगकर्ता सदस्यता स्थितियों की निगरानी के लिए एक रीड-ओनली इंटरफ़ेस प्रदान करता है। सभी जीवनचक्र इवेंट, जैसे खरीदारी, नवीनीकरण और रद्दीकरण, Apple ऐप स्टोर और Google Play के साथ वेबहुक सिंक्रोनाइज़ेशन के माध्यम से बैकएंड द्वारा स्वचालित रूप से संसाधित किए जाते हैं। यह डैशबोर्ड वित्तीय लेनदेन शुरू या प्रबंधित नहीं करता है।';

  @override
  String get subscriptionStatusActive => 'सक्रिय';

  @override
  String get subscriptionStatusGracePeriod => 'रियायती अवधि';

  @override
  String get subscriptionStatusBillingIssue => 'बिलिंग समस्या';

  @override
  String get subscriptionStatusCanceled => 'रद्द';

  @override
  String get subscriptionStatusExpired => 'समाप्त';

  @override
  String get storeProviderApple => 'Apple';

  @override
  String get storeProviderGoogle => 'Google';

  @override
  String get chartSubscriptionsActiveOverTime => 'समय के साथ सक्रिय सदस्यताएं';

  @override
  String get chartSubscriptionsStatusDistribution => 'सदस्यता स्थिति वितरण';

  @override
  String get chartSubscriptionsByStoreProvider => 'स्टोर के अनुसार सदस्यताएं';

  @override
  String get kpiRewardsAdsWatchedTotal => 'कुल देखे गए विज्ञापन';

  @override
  String get kpiRewardsActiveUsersCount => 'सक्रिय इनाम उपयोगकर्ता';

  @override
  String get rewardsTab => 'इनाम';

  @override
  String get rewardsDescription =>
      'उपयोगकर्ता जुड़ाव के लिए समय-आधारित इनाम कॉन्फ़िगर करें।';

  @override
  String get enableRewardsLabel => 'इनाम प्रणाली सक्षम करें';

  @override
  String get enableRewardsDescription =>
      'उपयोगकर्ताओं को विज्ञापन देखकर इनाम अर्जित करने की अनुमति दें।';

  @override
  String get rewardTypeAdFree => 'विज्ञापन-मुक्त अनुभव';

  @override
  String get rewardDurationDaysLabel => 'अवधि (दिन)';

  @override
  String get rewardEnabledLabel => 'सक्षम';

  @override
  String get chartRewardsAdsWatchedOverTime => 'देखे गए विज्ञापनों का रुझान';

  @override
  String get chartRewardsActiveByType => 'प्रकार के अनुसार सक्रिय इनाम';

  @override
  String get feedDecoratorUnlockRewardsDescription =>
      'उपयोगकर्ताओं को प्रीमियम सुविधाओं को अस्थायी रूप से अनलॉक करने के लिए विज्ञापन देखने के लिए प्रेरित करता है।';

  @override
  String get rewardDurationDaysDescription =>
      'इनाम जितने दिनों तक सक्रिय रहता है।';

  @override
  String get rewardsManagement => 'इनाम प्रबंधन';

  @override
  String get rewardsManagementPageDescription =>
      'उपयोगकर्ता इनाम और पात्रताएं प्रबंधित करें।';

  @override
  String get loadingRewards => 'इनाम लोड हो रहे हैं';

  @override
  String get noRewardsFound => 'कोई इनाम नहीं मिला।';

  @override
  String get userId => 'उपयोगकर्ता आईडी';

  @override
  String get activeRewards => 'सक्रिय इनाम';

  @override
  String get expiry => 'समाप्ति';

  @override
  String get filterRewards => 'इनाम फ़िल्टर करें';

  @override
  String get rewardType => 'इनाम प्रकार';

  @override
  String get selectRewardTypes => 'इनाम प्रकार चुनें';

  @override
  String get loadingAnalytics => 'एनालिटिक्स लोड हो रहा है';

  @override
  String get noAnalyticsDataHeadline => 'कोई एनालिटिक्स डेटा नहीं';

  @override
  String get noAnalyticsDataSubheadline =>
      'अभी प्रदर्शित करने के लिए कोई डेटा नहीं है। बाद में फिर से जांचें।';

  @override
  String get androidAdUnitsTitle => 'Android विज्ञापन इकाइयां';

  @override
  String get iosAdUnitsTitle => 'iOS विज्ञापन इकाइयां';

  @override
  String get rewardedAdIdLabel => 'रिवॉर्डेड विज्ञापन आईडी';

  @override
  String get rewardedAdIdDescription =>
      'रिवॉर्डेड विज्ञापनों के लिए इकाई आईडी।';

  @override
  String get kpiRewardsGrantedTotal => 'कुल प्रदान किए गए इनाम';

  @override
  String get analyticsEventRewardsHubViewedLabel => 'इनाम हब दृश्य';

  @override
  String get analyticsEventRewardsHubViewedDescription =>
      'ट्रैक करें कि उपयोगकर्ता इनाम हब कब देखता है।';

  @override
  String get analyticsEventRewardOfferClickedLabel => 'इनाम ऑफ़र क्लिक';

  @override
  String get analyticsEventRewardOfferClickedDescription =>
      'ट्रैक करें कि उपयोगकर्ता किसी विशिष्ट इनाम ऑफ़र पर कब क्लिक करता है।';

  @override
  String get analyticsEventRewardGrantedLabel => 'इनाम प्रदान किया गया';

  @override
  String get analyticsEventRewardGrantedDescription =>
      'ट्रैक करें कि उपयोगकर्ता को इनाम सफलतापूर्वक कब जारी किया जाता है।';

  @override
  String get chartRewardsGrantedOverTime => 'प्रदान किए गए इनामों का रुझान';

  @override
  String get android => 'Android';

  @override
  String get ios => 'iOS';

  @override
  String get initialPersonalizationTitle => 'प्रारंभिक वैयक्तिकरण';

  @override
  String get initialPersonalizationDescription =>
      'देश, विषय और स्रोत चयन सहित नए उपयोगकर्ताओं के लिए ऑनबोर्डिंग प्रवाह कॉन्फ़िगर करें।';

  @override
  String get enableInitialPersonalizationLabel =>
      'प्रारंभिक वैयक्तिकरण सक्षम करें';

  @override
  String get enableInitialPersonalizationDescription =>
      'यदि सक्षम है, तो नए उपयोगकर्ताओं को पंजीकरण के बाद वैयक्तिकरण प्रवाह के माध्यम से निर्देशित किया जाएगा।';

  @override
  String get enableCountrySelectionLabel => 'देश चयन सक्षम करें';

  @override
  String get enableCountrySelectionDescription =>
      'उपयोगकर्ताओं को ऑनबोर्डिंग के दौरान अपना देश चुनने की अनुमति दें।';

  @override
  String get enableTopicSelectionLabel => 'विषय चयन सक्षम करें';

  @override
  String get enableTopicSelectionDescription =>
      'उपयोगकर्ताओं को ऑनबोर्डिंग के दौरान रुचि के विषय चुनने की अनुमति दें।';

  @override
  String get enableSourceSelectionLabel => 'स्रोत चयन सक्षम करें';

  @override
  String get enableSourceSelectionDescription =>
      'उपयोगकर्ताओं को ऑनबोर्डिंग के दौरान अनुसरण करने के लिए समाचार स्रोत चुनने की अनुमति दें।';

  @override
  String get minSelectionsRequiredLabel => 'न्यूनतम चयन आवश्यक';

  @override
  String get minSelectionsRequiredDescription =>
      'आगे बढ़ने के लिए उपयोगकर्ता को सभी सक्षम श्रेणियों में जितनी वस्तुओं का चयन करना होगा, उनकी कुल संख्या।';

  @override
  String get onboardingTitle => 'ऑनबोर्डिंग';

  @override
  String get onboardingDescription =>
      'ऐप टूर और प्रारंभिक वैयक्तिकरण सहित पहली बार उपयोगकर्ता अनुभव प्रबंधित करें।';

  @override
  String get enableOnboardingLabel => 'ऑनबोर्डिंग सक्षम करें';

  @override
  String get enableOnboardingDescription =>
      'संपूर्ण ऑनबोर्डिंग प्रवाह (ऐप टूर और प्रारंभिक वैयक्तिकरण) को सक्षम या अक्षम करने के लिए एक मास्टर स्विच।';

  @override
  String get appTourTitle => 'ऐप टूर';

  @override
  String get appTourDescription =>
      'नए उपयोगकर्ताओं को दिखाए गए प्रमाणीकरण-पूर्व टूर को कॉन्फ़िगर करें।';

  @override
  String get enableAppTourLabel => 'ऐप टूर सक्षम करें';

  @override
  String get enableAppTourDescription =>
      'यदि सक्षम है, तो उपयोगकर्ताओं के लॉगिन करने से पहले उन्हें ऐप की सुविधाओं का एक संक्षिप्त टूर दिखाया जाएगा।';

  @override
  String get skippableAppTourLabel => 'छोड़ने योग्य ऐप टूर';

  @override
  String get skippableAppTourDescription =>
      'यदि सक्षम है, तो उपयोगकर्ताओं के पास ऐप टूर छोड़ने का विकल्प होगा।';

  @override
  String get skippableInitialPersonalizationLabel => 'छोड़ने योग्य वैयक्तिकरण';

  @override
  String get skippableInitialPersonalizationDescription =>
      'यदि सक्षम है, तो उपयोगकर्ताओं के पास वैयक्तिकरण प्रवाह छोड़ने का विकल्प होगा।';

  @override
  String get filePickingErrorMessage => 'फ़ाइल चुनते समय एक त्रुटि हुई।';

  @override
  String get removeImage => 'छवि हटाएं';

  @override
  String get clickToUploadImage => 'छवि अपलोड करने के लिए क्लिक करें';

  @override
  String get processingImage => 'छवि संसाधित की जा रही है...';

  @override
  String get processingImageDescription =>
      'आपकी छवि अनुकूलित की जा रही है और जल्द ही दिखाई देगी।';

  @override
  String get chartMediaUploadsOverTime => 'समय के साथ अपलोड';

  @override
  String get chartMediaUploadsByPurpose => 'उद्देश्य के अनुसार अपलोड';

  @override
  String get chartMediaUploadsSuccessVsFailure => 'अपलोड सफलता बनाम विफलता';

  @override
  String get kpiMediaTotalUploads => 'कुल अपलोड';

  @override
  String get kpiMediaFailedUploads => 'विफल अपलोड';

  @override
  String get kpiMediaAverageUploadTime => 'औसत अपलोड समय (s)';

  @override
  String get updateHeadlineTitle => 'सुर्खी अपडेट करें';

  @override
  String get updateHeadlineMessage =>
      'क्या आप इन परिवर्तनों को प्रकाशित करना चाहते हैं या अपडेट को ड्राफ्ट के रूप में सहेजना चाहते हैं?';

  @override
  String get analyticsEventMediaUploadStartedLabel => 'मीडिया अपलोड शुरू';

  @override
  String get analyticsEventMediaUploadStartedDescription =>
      'ट्रैक करें कि उपयोगकर्ता फ़ाइल अपलोड कब शुरू करता है।';

  @override
  String get analyticsEventMediaUploadCompletedLabel => 'मीडिया अपलोड पूरा';

  @override
  String get analyticsEventMediaUploadCompletedDescription =>
      'ट्रैक करें कि फ़ाइल अपलोड सफलतापूर्वक कब पूरा होता है।';

  @override
  String get analyticsEventMediaUploadFailedLabel => 'मीडिया अपलोड विफल';

  @override
  String get analyticsEventMediaUploadFailedDescription =>
      'ट्रैक करें कि फ़ाइल अपलोड कब विफल होता है।';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get aboutOverviewPageTitle => 'अवलोकन पेज के बारे में';

  @override
  String get aboutOverviewPageDescription =>
      'यह पेज प्रमुख एप्लिकेशन मेट्रिक्स का उच्च-स्तरीय अवलोकन प्रदान करता है। प्रदर्शित आंकड़े लाइव नहीं हैं; वे बैकएंड द्वारा समय-समय पर अपडेट किए जाते हैं। रिफ्रेश अंतराल सर्वर-साइड कॉन्फ़िगर किया गया है।';

  @override
  String get audience => 'दर्शक';

  @override
  String get content => 'सामग्री';

  @override
  String get community => 'समुदाय';

  @override
  String get monetization => 'मुद्रीकरण';

  @override
  String get configuration => 'कॉन्फ़िगरेशन';

  @override
  String get loadingConfiguration => 'कॉन्फ़िगरेशन लोड हो रहा है...';

  @override
  String get noConfigurationDataHeadline => 'कोई कॉन्फ़िगरेशन डेटा नहीं';

  @override
  String get noConfigurationDataSubheadline =>
      'एप्लिकेशन का रिमोट कॉन्फ़िगरेशन लोड नहीं हो सका।';

  @override
  String get readOnlyConfigurationView => 'रीड-ओनली कॉन्फ़िगरेशन दृश्य';

  @override
  String get readOnlyConfigurationViewDescription =>
      'यह एप्लिकेशन की परिचालन सेटिंग्स का रीयल-टाइम, रीड-ओनली स्नैपशॉट है। परिवर्तन करने के लिए, मुख्य \'रिमोट कॉन्फ़िगरेशन\' पेज पर जाएं।';

  @override
  String get providers => 'प्रदाता';

  @override
  String get summary => 'सारांश';

  @override
  String get about => 'के बारे में';

  @override
  String get localizationConfigDescription =>
      'समर्थित भाषाओं और डिफ़ॉल्ट फ़ॉलबैक को कॉन्फ़िगर करें।';

  @override
  String get enabledLanguagesLabel => 'सक्षम भाषाएं';

  @override
  String get cannotDisableDefaultLanguage =>
      'डिफ़ॉल्ट भाषा को अक्षम नहीं किया जा सकता।';

  @override
  String get atLeastOneLanguageRequired => 'कम से कम एक भाषा सक्षम होनी चाहिए।';

  @override
  String get defaultLanguageLabel => 'डिफ़ॉल्ट भाषा';

  @override
  String get defaultLanguageDescription =>
      'यदि उपयोगकर्ता की प्राथमिकता समर्थित नहीं है तो फ़ॉलबैक भाषा।';

  @override
  String get localizationTitle => 'स्थानीयकरण';

  @override
  String get localizationDescription =>
      'मोबाइल ऐप और डैशबोर्ड के लिए सक्रिय भाषाओं को नियंत्रित करें। भाषा सक्षम करने से उपयोगकर्ता अनुवादित सामग्री देख सकते हैं और डैशबोर्ड फ़ॉर्म में संबंधित इनपुट फ़ील्ड जुड़ जाते हैं। बिना अनुवाद वाली सामग्री डिफ़ॉल्ट भाषा पर वापस आ जाती है।';

  @override
  String defaultLanguageRequired(String language) {
    return 'डिफ़ॉल्ट भाषा ($language) आवश्यक है।';
  }

  @override
  String get languageNameEn => 'अंग्रेजी';

  @override
  String get languageNameEs => 'स्पेनिश';

  @override
  String get languageNameFr => 'फ्रेंच';

  @override
  String get languageNameAr => 'अरबी';

  @override
  String get languageNamePt => 'पुर्तगाली';

  @override
  String get languageNameDe => 'जर्मन';

  @override
  String get languageNameIt => 'इतालवी';

  @override
  String get languageNameZh => 'चीनी';

  @override
  String get languageNameHi => 'हिंदी';

  @override
  String get languageNameJa => 'जापानी';
}
