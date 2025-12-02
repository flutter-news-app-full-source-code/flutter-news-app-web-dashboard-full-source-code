import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

extension InitialAppReviewFeedbackX on AppReviewFeedback {
  /// Returns a localized, admin-centric string for the
  /// [AppReviewFeedback].
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case AppReviewFeedback.positive:
        return l10n.initialAppReviewFeedbackPositive;
      case AppReviewFeedback.negative:
        return l10n.initialAppReviewFeedbackNegative;
    }
  }
}
