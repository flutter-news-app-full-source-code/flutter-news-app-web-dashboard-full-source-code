import 'package:flutter/material.dart';
import 'package:language_picker/language_picker.dart' as language_picker;

/// A form field for selecting a language using the `language_picker` package.
///
/// This widget wraps the language picker functionality in a standard
/// [FormField], making it easy to integrate into forms for validation
/// and state management. It presents as a read-only [TextFormField] that,
/// when tapped, opens a language selection dialog.
class LanguagePickerFormField extends FormField<language_picker.Language> {
  /// Creates a [LanguagePickerFormField].
  ///
  /// The [onSaved], [validator], [initialValue], and [autovalidateMode] are
  /// standard [FormField] properties.
  ///
  /// The [labelText] is displayed as the input field's label.
  /// The [onChanged] callback is invoked when a new language is selected.
  LanguagePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    String? labelText,
    void Function(language_picker.Language)? onChanged,
  }) : super(
          builder: (FormFieldState<language_picker.Language> state) {
            // This controller is just for displaying the text. The actual
            // value is managed by the FormField's state.
            final controller = TextEditingController(
              text: state.value?.name,
            );

            return TextFormField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                labelText: labelText ?? 'Language',
                border: const OutlineInputBorder(),
                errorText: state.errorText,
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              onTap: () {
                language_picker.showLanguagePicker(
                  context: state.context,
                  // Provide a default if no language is selected yet.
                  selectedLanguage:
                      state.value ?? language_picker.Languages.english,
                  onValuePicked: (language_picker.Language language) {
                    state.didChange(language);
                    if (onChanged != null) {
                      onChanged(language);
                    }
                    // Update the text in the read-only text field.
                    controller.text = language.name;
                  },
                );
              },
            );
          },
        );
}