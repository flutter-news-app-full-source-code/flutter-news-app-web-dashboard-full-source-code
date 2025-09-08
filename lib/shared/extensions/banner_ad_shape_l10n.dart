import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template banner_ad_shape_l10n}
/// Extension on [BannerAdShape] to provide localized string representations.
/// {@endtemplate}
extension BannerAdShapeL10n on BannerAdShape {
  /// Returns the localized name for a [BannerAdShape].
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case BannerAdShape.square:
        return l10n.bannerAdShapeSquare;
      case BannerAdShape.rectangle:
        return l10n.bannerAdShapeRectangle;
    }
  }
}
