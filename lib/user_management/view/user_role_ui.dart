import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';

/// An extension on [UserRole] to provide UI-related helpers.
extension UserRoleUI on UserRole {
  /// A convenience getter to check if the user has a privileged dashboard role.
  bool get isPrivileged {
    return this == UserRole.admin || this == UserRole.publisher;
  }

  /// Returns a role indicator icon wrapped in a tooltip.
  Widget? getRoleIcon(AppLocalizations l10n) {
    switch (this) {
      case UserRole.admin:
        return Tooltip(
          message: l10n.adminUserTooltip,
          child: const Icon(
            Icons.admin_panel_settings,
            color: Colors.blueAccent,
            size: 16,
          ),
        );
      case UserRole.publisher:
        return Tooltip(
          message: l10n.publisherUserTooltip,
          child: const Icon(
            Icons.publish,
            color: Colors.green,
            size: 16,
          ),
        );
      case UserRole.user:
        return null;
    }
  }
}
