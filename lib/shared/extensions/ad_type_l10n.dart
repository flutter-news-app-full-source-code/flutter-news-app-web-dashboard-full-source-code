import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// Extension on [AdType] to provide localized descriptions.
extension AdTypeL10n on AdType {
  /// Returns a localized string for the [AdType] enum value.
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case AdType.banner:
        return l10n.bannerAdType;
      case AdType.native:
        return l10n.nativeAdType;
      case AdType.interstitial:
        return l10n.interstitialAdType;
      case AdType.video:
        return l10n.videoAdType;
      case AdType.rewarded:
        return l10n.rewardedAdType;
    }
  }
}
