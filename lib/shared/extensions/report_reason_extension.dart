import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

extension ReportReasonX on String {
  /// Returns a localized, admin-centric string for a report reason.
  ///
  /// This extension maps the raw string value of various report reason enums
  /// (e.g., [HeadlineReportReason], [SourceReportReason], [CommentReportReason])
  /// to a user-friendly, localized string.
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      // HeadlineReportReason
      case 'misinformationOrFakeNews':
        return l10n.reportReasonMisinformationOrFakeNews;
      case 'clickbaitTitle':
        return l10n.reportReasonClickbaitTitle;
      case 'offensiveOrHateSpeech':
        return l10n.reportReasonOffensiveOrHateSpeech;
      case 'spamOrScam':
        return l10n.reportReasonSpamOrScam;
      case 'brokenLink':
        return l10n.reportReasonBrokenLink;
      case 'paywalled':
        return l10n.reportReasonPaywalled;

      // SourceReportReason
      case 'lowQualityJournalism':
        return l10n.reportReasonLowQualityJournalism;
      case 'highAdDensity':
        return l10n.reportReasonHighAdDensity;
      case 'blog':
        return l10n.reportReasonBlog;
      case 'governmentSource':
        return l10n.reportReasonGovernmentSource;
      case 'aggregator':
        return l10n.reportReasonAggregator;
      case 'other':
        return l10n.reportReasonOther;
      case 'frequentPaywalls':
        return l10n.reportReasonFrequentPaywalls;
      case 'impersonation':
        return l10n.reportReasonImpersonation;

      default:
        return this; // Fallback to raw string if no localization found
    }
  }
}
