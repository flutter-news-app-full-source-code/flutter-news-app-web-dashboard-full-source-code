import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// Provides a localized string representation for
/// [PushNotificationSubscriptionDeliveryType].
extension PushNotificationSubscriptionDeliveryTypeL10n
    on PushNotificationSubscriptionDeliveryType {
  /// Returns the localized string for the enum value.
  String l10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case PushNotificationSubscriptionDeliveryType.breakingOnly:
        return l10n.pushNotificationSubscriptionDeliveryTypeBreakingOnly;
    }
  }
}
