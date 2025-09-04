import 'package:core/core.dart';

/// Defines extension methods for [LocalAd] to convert its `adType` string
/// to the corresponding [AdType] enum.
extension LocalAdToAdType on LocalAd {
  /// Converts the `adType` string of this [LocalAd] instance to an [AdType] enum.
  ///
  /// Throws a [StateError] if the `adType` string does not correspond to a
  /// valid [AdType] enum value.
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
        throw StateError('Unknown adType: $adType');
    }
  }
}
