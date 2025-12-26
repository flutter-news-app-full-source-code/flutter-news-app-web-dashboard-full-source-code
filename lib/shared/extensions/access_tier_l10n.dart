import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// Extension on [AccessTier] to provide localized strings.
extension AccessTierL10n on AccessTier {
  /// Returns the localized name of the access tier.
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case AccessTier.guest:
        return l10n.guestUserRole;
      case AccessTier.standard:
        return l10n.standardUserRole;
      case AccessTier.premium:
        return l10n.premiumUserRole;
    }
  }
}
