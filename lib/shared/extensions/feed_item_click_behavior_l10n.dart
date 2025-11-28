import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// Extension to localize the [FeedItemClickBehavior] enum.
extension FeedItemClickBehaviorL10n on FeedItemClickBehavior {
  /// Returns the localized string representation of the
  /// [FeedItemClickBehavior].
  String l10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case FeedItemClickBehavior.internalNavigation:
        return l10n.feedItemClickBehaviorInternalNavigation;
      case FeedItemClickBehavior.externalNavigation:
        return l10n.feedItemClickBehaviorExternalNavigation;
      case FeedItemClickBehavior.defaultBehavior:
        return ''; // Mobile client related, should not be displayed in the dashboard UI.
    }
  }
}
