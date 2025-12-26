import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';

/// An extension on [AccessTier] to provide UI-related helpers.
extension AccessTierUI on AccessTier {
  /// A convenience getter to check if the user role is premium.
  bool get isPremium => this == AccessTier.premium;

  /// Returns a premium indicator icon wrapped in a tooltip if the user is a
  /// premium user.
  ///
  /// Returns a gold star icon for premium users, otherwise returns null.
  Widget? getPremiumIcon(AppLocalizations l10n) {
    if (isPremium) {
      return Tooltip(
        message: l10n.premiumUserTooltip,
        child: const Icon(Icons.star, color: Colors.amber, size: 16),
      );
    }
    return null;
  }
}
