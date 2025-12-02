import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// Provides a localized string representation for [ModerationStatus].
extension ModerationStatusL10n on ModerationStatus {
  /// Returns the localized string for the moderation status.
  String l10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case ModerationStatus.pendingReview:
        return l10n.moderationStatusPendingReview;
      case ModerationStatus.resolved:
        return l10n.moderationStatusResolved;
    }
  }
}
