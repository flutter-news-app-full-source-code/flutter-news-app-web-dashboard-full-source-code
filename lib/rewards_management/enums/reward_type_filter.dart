import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// Defines the filter options for reward types.
enum RewardTypeFilter {
  /// Show all rewards.
  all,

  /// Show only Ad-Free rewards.
  adFree,

  /// Show only Daily Digest rewards.
  dailyDigest;

  /// Returns the localized label for the filter option.
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case RewardTypeFilter.all:
        return l10n.any;
      case RewardTypeFilter.adFree:
        return l10n.rewardTypeAdFree;
      case RewardTypeFilter.dailyDigest:
        return l10n.rewardTypeDailyDigest;
    }
  }

  /// Converts the filter to a [RewardType] if applicable.
  RewardType? toRewardType() {
    switch (this) {
      case RewardTypeFilter.all:
        return null;
      case RewardTypeFilter.adFree:
        return RewardType.adFree;
      case RewardTypeFilter.dailyDigest:
        return RewardType.dailyDigest;
    }
  }
}
