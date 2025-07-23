import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// Provides a localized string representation for [ContentStatus].
extension ContentStatusL10n on ContentStatus {
  /// Returns the localized string for the status.
  String l10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case ContentStatus.active:
        return l10n.contentStatusActive;
      case ContentStatus.archived:
        return l10n.contentStatusArchived;
      case ContentStatus.draft:
        return l10n.contentStatusDraft;
    }
  }
}
