import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// Extension on [AdPlatformType] to provide localized string representations.
extension AdPlatformTypeL10n on AdPlatformType {
  /// Returns a localized string for the [AdPlatformType].
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case AdPlatformType.admob:
        return l10n.adPlatformTypeAdmob;
      case AdPlatformType.local:
        return l10n.adPlatformTypeLocal;
    }
  }
}
