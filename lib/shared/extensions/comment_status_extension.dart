import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

extension CommentStatusX on CommentStatus {
  /// Returns a localized, admin-centric string for the [CommentStatus].
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case CommentStatus.pendingReview:
        return l10n.commentStatusPendingReview;
      case CommentStatus.approved:
        return l10n.commentStatusApproved;
      case CommentStatus.rejected:
        return l10n.commentStatusRejected;
      case CommentStatus.flaggedByAI:
        return l10n.commentStatusFlaggedByAI;
      case CommentStatus.hiddenByUser:
        return l10n.commentStatusHiddenByUser;
    }
  }
}