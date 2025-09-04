import 'package:core/core.dart';

/// Extension on [LocalAd] to provide a convenient way to get its [AdType].
extension LocalAdX on LocalAd {
  /// Converts the [LocalAd]'s `adType` string to an [AdType] enum value.
  ///
  /// Throws a [FormatException] if the `adType` string does not correspond
  /// to a valid [AdType] enum value.
  AdType toAdType() {
    switch (adType) {
      case 'native':
        return AdType.native;
      case 'banner':
        return AdType.banner;
      case 'interstitial':
        return AdType.interstitial;
      case 'video':
        return AdType.video;
      default:
        throw FormatException('Unknown AdType for LocalAd: $adType');
    }
  }
}
