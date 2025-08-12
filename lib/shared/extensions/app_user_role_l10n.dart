import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template app_user_role_l10n}
/// Extension on [AppUserRole] to provide localized string representations.
/// {@endtemplate}
extension AppUserRoleL10n on AppUserRole {
  /// Returns the localized name for an [AppUserRole].
  String l10n(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case AppUserRole.guestUser:
        return l10n.guestUserTab;
      case AppUserRole.standardUser:
        return l10n.authenticatedUserTab; // Using authenticatedUserTab for standardUser
      case AppUserRole.premiumUser:
        return l10n.premiumUserTab;
    }
  }
}
