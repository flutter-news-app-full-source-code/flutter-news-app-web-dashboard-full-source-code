import 'package:country_picker/country_picker.dart' as picker;
import 'package:flutter/material.dart';
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
              labelText: 'Search', // TODO(fulleni): Localize this string
              hintText:
                  'Start typing to search...', // TODO(fulleni): Localize this
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
                  'Select a country', // TODO(you): Localize this string
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