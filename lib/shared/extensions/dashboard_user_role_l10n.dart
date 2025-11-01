import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template dashboard_user_role_l10n}
/// Extension on [DashboardUserRole] to provide localized string representations.
/// {@endtemplate}
extension DashboardUserRoleL10n on DashboardUserRole {
  /// Returns the localized name for a [DashboardUserRole].
  String l10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case DashboardUserRole.admin:
        return l10n.adminRole;
      case DashboardUserRole.publisher:
        return l10n.publisherRole;
      case DashboardUserRole.none:
        return l10n.none;
    }
  }
}
