import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template feed_decorator_type_l10n}
/// Extension on [FeedDecoratorType] to provide localized string representations.
/// {@endtemplate}
extension FeedDecoratorTypeL10n on FeedDecoratorType {
  /// Returns the localized name for a [FeedDecoratorType].
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case FeedDecoratorType.linkAccount:
        return l10n.feedDecoratorTypeLinkAccount;
      case FeedDecoratorType.upgrade:
        return l10n.feedDecoratorTypeUpgrade;
      case FeedDecoratorType.rateApp:
        return l10n.feedDecoratorTypeRateApp;
      case FeedDecoratorType.enableNotifications:
        return l10n.feedDecoratorTypeEnableNotifications;
      case FeedDecoratorType.suggestedTopics:
        return l10n.feedDecoratorTypeSuggestedTopics;
      case FeedDecoratorType.suggestedSources:
        return l10n.feedDecoratorTypeSuggestedSources;
    }
  }
}
