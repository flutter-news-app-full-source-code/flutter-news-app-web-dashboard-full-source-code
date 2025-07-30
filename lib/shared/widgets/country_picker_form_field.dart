import 'package:country_picker/country_picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// A form field for selecting a country using the `country_picker` package.
class CountryPickerFormField extends StatelessWidget {
  /// Creates a [CountryPickerFormField].
  const CountryPickerFormField({
    required this.onChanged,
    this.initialValue,
    this.labelText,
    super.key,
  });

  /// The currently selected country. Can be null.
  final picker.Country? initialValue;

  /// Callback function that is called when a new country is selected.
  final ValueChanged<picker.Country> onChanged;

  /// The text to display as the label for the form field.
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return InkWell(
      onTap: () {
        picker.showCountryPicker(
          context: context,
          onSelect: onChanged,
          countryListTheme: picker.CountryListThemeData(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            textStyle: Theme.of(context).textTheme.bodyMedium,
            bottomSheetHeight: MediaQuery.of(context).size.height * 0.8,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.md),
              topRight: Radius.circular(AppSpacing.md),
            ),
            inputDecoration: InputDecoration(
              labelText: l10n.countryPickerSearchLabel,
              hintText: l10n.countryPickerSearchHint,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
            ),
          ),
        );
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
        child: Row(
          children: [
            if (initialValue != null) ...[
              Text(initialValue!.flagEmoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  initialValue!.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ] else
              Expanded(
                child: Text(
                  l10n.countryPickerSelectCountryLabel,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}