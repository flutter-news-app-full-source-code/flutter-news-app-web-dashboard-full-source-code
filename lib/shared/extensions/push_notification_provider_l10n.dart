import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// Extension to localize the [PushNotificationProviders] enum.
extension PushNotificationProviderL10n on PushNotificationProviders {
  /// Returns the localized string representation of the
  /// [PushNotificationProviders].
  String l10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case PushNotificationProviders.firebase:
        return l10n.pushNotificationProviderFirebase;
      case PushNotificationProviders.oneSignal:
        return l10n.pushNotificationProviderOneSignal;
    }
  }
}
