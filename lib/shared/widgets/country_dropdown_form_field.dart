import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// A reusable dropdown form field for selecting a country.
class CountryDropdownFormField extends StatelessWidget {
  /// {@macro country_dropdown_form_field}
  const CountryDropdownFormField({
    required this.countries,
    required this.onChanged,
    this.initialValue,
    this.labelText,
    super.key,
  });

  /// The list of countries to display in the dropdown.
  final List<Country> countries;

  /// The currently selected country.
  final Country? initialValue;

  /// The callback that is called when the user selects a country.
  final ValueChanged<Country?> onChanged;

  /// The text to display as the label for the form field.
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return DropdownButtonFormField<Country?>(
      value: initialValue,
      decoration: InputDecoration(
        labelText: labelText ?? l10n.countryName,
        border: const OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.none)),
        ...countries.map(
          (c) => DropdownMenuItem(value: c, child: Text(c.name)),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
