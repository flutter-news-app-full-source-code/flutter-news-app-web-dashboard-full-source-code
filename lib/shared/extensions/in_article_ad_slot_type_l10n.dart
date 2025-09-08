import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template in_article_ad_slot_type_l10n}
/// Extension on [InArticleAdSlotType] to provide localized string representations.
/// {@endtemplate}
extension InArticleAdSlotTypeL10n on InArticleAdSlotType {
  /// Returns the localized name for an [InArticleAdSlotType].
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case InArticleAdSlotType.aboveArticleContinueReadingButton:
        return l10n.inArticleAdSlotTypeAboveArticleContinueReadingButton;
      case InArticleAdSlotType.belowArticleContinueReadingButton:
        return l10n.inArticleAdSlotTypeBelowArticleContinueReadingButton;
    }
  }
}
