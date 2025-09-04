import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/local_ads_management_bloc.dart';

/// Extension on [LocalAdsManagementTab] to provide localized descriptions.
extension LocalAdsManagementTabL10n on LocalAdsManagementTab {
  /// Returns a localized string for the [LocalAdsManagementTab] enum value.
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case LocalAdsManagementTab.native:
        return l10n.nativeAdsTab;
      case LocalAdsManagementTab.banner:
        return l10n.bannerAdsTab;
      case LocalAdsManagementTab.interstitial:
        return l10n.interstitialAdsTab;
      case LocalAdsManagementTab.video:
        return l10n.videoAdsTab;
    }
  }
}
