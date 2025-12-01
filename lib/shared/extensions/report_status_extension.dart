import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

extension ReportStatusX on ReportStatus {
  /// Returns a localized, admin-centric string for the [ReportStatus].
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case ReportStatus.submitted:
        return l10n.reportStatusSubmitted;
      case ReportStatus.inReview:
        return l10n.reportStatusInReview;
      case ReportStatus.resolved:
        return l10n.reportStatusResolved;
    }
  }
}