import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// A reusable dropdown form field for selecting a language.
class LanguageDropdownFormField extends StatelessWidget {
  /// {@macro language_dropdown_form_field}
  const LanguageDropdownFormField({
    required this.languages,
    required this.onChanged,
    this.initialValue,
    this.labelText,
    super.key,
  });

  /// The list of languages to display in the dropdown.
  final List<Language> languages;

  /// The currently selected language.
  final Language? initialValue;

  /// The callback that is called when the user selects a language.
  final ValueChanged<Language?> onChanged;

  /// The text to display as the label for the form field.
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return DropdownButtonFormField<Language?>(
      value: initialValue,
      decoration: InputDecoration(
        labelText: labelText ?? l10n.language,
        border: const OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.none)),
        ...languages.map(
          (l) => DropdownMenuItem(value: l, child: Text(l.name)),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
