import 'package:core/core.dart' as core;
import 'package:country_picker/country_picker.dart' as picker;

/// Adapts a [picker.Country] from the `country_picker` package to a
/// [core.Country] model.
///
/// This is used when a user selects a country from the picker and we need to
/// update our application state with our internal [core.Country] model.
core.Country adaptPackageCountryToCoreCountry(picker.Country packageCountry) {
  final now = DateTime.now();
  return core.Country(
    // Use the ISO code as a unique, deterministic ID, since we are no longer
    // fetching countries as entities from a database.
    id: packageCountry.countryCode,
    isoCode: packageCountry.countryCode,
    name: packageCountry.name,
    // Construct a flag URL from a public CDN using the ISO code.
    flagUrl:
        'https://flagcdn.com/h40/${packageCountry.countryCode.toLowerCase()}.png',
    createdAt: now,
    updatedAt: now,
    status: core.ContentStatus.active,
  );
}

/// Adapts a [core.Country] model to a [picker.Country] from the
/// `country_picker` package.
///
/// This is used when we have an existing [core.Country] (e.g., when editing a
/// headline) and need to display it in the UI using the `country_picker`
/// package's widgets.
picker.Country adaptCoreCountryToPackageCountry(core.Country coreCountry) {
  return picker.Country.parse(coreCountry.isoCode);
}
