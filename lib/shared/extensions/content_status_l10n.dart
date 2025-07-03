import 'package:flutter/widgets.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_shared/ht_shared.dart';

/// Provides a localized string representation for [ContentStatus].
extension ContentStatusL10n on ContentStatus {
  /// Returns the localized string for the status.
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case ContentStatus.active:
        return l10n.contentStatusActive;
      case ContentStatus.archived:
        return l10n.contentStatusArchived;
      case ContentStatus.draft:
        return l10n.contentStatusDraft;
    }
  }
}