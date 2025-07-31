import 'package:core/core.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';

/// Adds localization support to the [SourceType] enum.
extension SourceTypeL10n on SourceType {
  /// Returns the localized name for the source type.
  ///
  /// This requires an [AppLocalizations] instance, which is typically
  /// retrieved from the build context.
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case SourceType.newsAgency:
        return l10n.sourceTypeNewsAgency;
      case SourceType.localNewsOutlet:
        return l10n.sourceTypeLocalNewsOutlet;
      case SourceType.nationalNewsOutlet:
        return l10n.sourceTypeNationalNewsOutlet;
      case SourceType.internationalNewsOutlet:
        return l10n.sourceTypeInternationalNewsOutlet;
      case SourceType.specializedPublisher:
        return l10n.sourceTypeSpecializedPublisher;
      case SourceType.blog:
        return l10n.sourceTypeBlog;
      case SourceType.governmentSource:
        return l10n.sourceTypeGovernmentSource;
      case SourceType.aggregator:
        return l10n.sourceTypeAggregator;
      case SourceType.other:
        return l10n.sourceTypeOther;
    }
  }
}
