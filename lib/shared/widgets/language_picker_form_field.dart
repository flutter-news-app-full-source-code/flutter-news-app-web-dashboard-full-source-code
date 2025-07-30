import 'package:flutter/material.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';

/// A form field for selecting a language using the `language_picker` package.
///
/// This widget wraps the language picker functionality in a standard
/// [FormField], making it easy to integrate into forms for validation
/// and state management. It presents as a read-only [TextFormField] that,
/// when tapped, opens a language selection dialog.
class LanguagePickerFormField extends FormField<Language> {
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
    void Function(Language)? onChanged,
  }) : super(
          builder: (FormFieldState<Language> state) {
            // This controller is just for displaying the text. The actual
            // value is managed by the FormField's state.
            final controller = TextEditingController(
              text: state.value?.name,
            );

            // Helper to build a simple list item for the dialog.
            Widget buildDialogItem(Language language) => Row(
                  children: <Widget>[
                    Text(language.name),
                    const SizedBox(width: 8),
                    Flexible(child: Text('(${language.isoCode})')),
                  ],
                );

            void openLanguagePickerDialog() {
              showDialog<void>(
                context: state.context,
                builder: (context) => LanguagePickerDialog(
                  isSearchable: true,
                  title: const Text('Select your language'),
                  onValuePicked: (Language language) {
                    state.didChange(language);
                    onChanged?.call(language);
                    controller.text = language.name;
                  },
                  itemBuilder: buildDialogItem,
                ),
              );
            }

            return TextFormField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                labelText: labelText ?? 'Language',
                border: const OutlineInputBorder(),
                errorText: state.errorText,
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              onTap: openLanguagePickerDialog,
            );
          },
        );
}