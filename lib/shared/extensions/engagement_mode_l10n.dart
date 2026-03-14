import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:veritai_dashboard/l10n/l10n.dart';

/// Extension to localize the [EngagementMode] enum.
extension EngagementModeL10n on EngagementMode {
  /// Returns the localized string representation of the [EngagementMode].
  String l10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case EngagementMode.reactionsOnly:
        return l10n.engagementModeReactionsOnly;
      case EngagementMode.reactionsAndComments:
        return l10n.engagementModeReactionsAndComments;
    }
  }
}
