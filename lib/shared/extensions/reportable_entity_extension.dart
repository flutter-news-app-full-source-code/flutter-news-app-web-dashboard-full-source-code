import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

extension ReportableEntityX on ReportableEntity {
  /// Returns a localized, admin-centric string for the [ReportableEntity].
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case ReportableEntity.headline:
        return l10n.reportableEntityHeadline;
      case ReportableEntity.source:
        return l10n.reportableEntitySource;
      case ReportableEntity.engagement:
        return l10n.reportableEntityComment;
    }
  }
}
