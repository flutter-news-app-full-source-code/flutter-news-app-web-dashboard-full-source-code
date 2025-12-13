import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// Defines the filter options for a user's authentication status.
enum AuthenticationFilter {
  /// Show all users regardless of authentication status.
  all,

  /// Show only authenticated users.
  authenticated,

  /// Show only anonymous users.
  anonymous,
}

/// An extension to get the localized string for [AuthenticationFilter].
extension AuthenticationFilterL10n on AuthenticationFilter {
  /// Returns the localized string for the authentication filter option.
  String l10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case AuthenticationFilter.all:
        return l10n.any;
      case AuthenticationFilter.authenticated:
        return l10n.authenticationAuthenticated;
      case AuthenticationFilter.anonymous:
        return l10n.authenticationAnonymous;
    }
  }
}
