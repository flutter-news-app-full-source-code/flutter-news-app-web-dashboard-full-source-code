import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// Defines the filter options for a user's subscription status.
enum SubscriptionFilter {
  /// Show all users regardless of subscription status.
  all,

  /// Show only users with a free subscription.
  free,

  /// Show only users with a premium subscription.
  premium,
}

/// An extension to get the localized string for [SubscriptionFilter].
extension SubscriptionFilterL10n on SubscriptionFilter {
  /// Returns the localized string for the subscription filter option.
  String l10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case SubscriptionFilter.all:
        return l10n.any;
      case SubscriptionFilter.free:
        return l10n.subscriptionFree;
      case SubscriptionFilter.premium:
        return l10n.subscriptionPremium;
    }
  }
}
