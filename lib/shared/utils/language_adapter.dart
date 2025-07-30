import 'package:language_picker/languages.dart';

/// Adapts a [Language] object from the `language_picker` package to a
/// language code string (e.g., 'en', 'ar').
///
/// This is used to convert the selected language from the UI picker into the
/// format expected by the `Source` model in the core package.
String adaptPackageLanguageToLanguageCode(Language language) {
  return language.isoCode;
}

/// Adapts a language code string (e.g., 'en', 'ar') to a [Language] object
/// from the `language_picker` package.
///
/// This is used to convert the language code from a `Source` model into an
/// object that can be used to set the initial value of the language picker.
///
/// Returns `null` if the language code is not found.
Language? adaptLanguageCodeToPackageLanguage(String languageCode) {
  try {
    return Languages.defaultLanguages.firstWhere(
      (lang) => lang.isoCode.toLowerCase() == languageCode.toLowerCase(),
    );
  } catch (_) {
    // Return null if no matching language is found
    return null;
  }
}
