import 'package:core/core.dart';
import 'package:verity_dashboard/l10n/app_localizations.dart';

extension FetchIntervalX on FetchInterval {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case FetchInterval.every15Minutes:
        return l10n.fetchIntervalEvery15Minutes;
      case FetchInterval.every30Minutes:
        return l10n.fetchIntervalEvery30Minutes;
      case FetchInterval.hourly:
        return l10n.fetchIntervalHourly;
      case FetchInterval.everySixHours:
        return l10n.fetchIntervalEverySixHours;
      case FetchInterval.daily:
        return l10n.fetchIntervalDaily;
    }
  }

  String get shortName {
    switch (this) {
      case FetchInterval.every15Minutes:
        return '15m';
      case FetchInterval.every30Minutes:
        return '30m';
      case FetchInterval.hourly:
        return '1h';
      case FetchInterval.everySixHours:
        return '6h';
      case FetchInterval.daily:
        return '24h';
    }
  }
}
