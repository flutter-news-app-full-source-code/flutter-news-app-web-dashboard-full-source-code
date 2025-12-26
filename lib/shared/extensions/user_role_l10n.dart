import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template user_role_l10n}
/// Extension on [UserRole] to provide localized string representations.
/// {@endtemplate}
extension UserRoleL10n on UserRole {
  /// Returns the localized name for a [UserRole].
  String l10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case UserRole.admin:
        return l10n.adminRole;
      case UserRole.publisher:
        return l10n.publisherRole;
      case UserRole.user:
        return l10n.user;
    }
  }
}
