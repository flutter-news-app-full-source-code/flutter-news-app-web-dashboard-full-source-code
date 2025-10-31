import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/widgets/content_action_buttons.dart' show ContentActionButtons;
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_management_bloc.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template user_action_buttons}
/// A widget that displays contextual action buttons for a user in the user
/// management table.
///
/// Actions are presented in a [PopupMenuButton] and are conditionally
/// displayed based on the user's role and permissions. This follows a similar
/// pattern to [ContentActionButtons] but is tailored for user management.
/// {@endtemplate}
class UserActionButtons extends StatelessWidget {
  /// {@macro user_action_buttons}
  const UserActionButtons({
    required this.user,
    required this.l10n,
    super.key,
  });

  /// The user for whom to display actions.
  final User user;

  /// The localized strings.
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final overflowMenuItems = <PopupMenuEntry<String>>[];

    // Rule: Do not show any actions for admin users.
    if (user.dashboardRole == DashboardUserRole.admin) {
      return const SizedBox.shrink();
    }

    // Add contextual actions based on the user's current dashboard role.
    switch (user.dashboardRole) {
      case DashboardUserRole.none:
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'promote',
            child: Row(
              children: [
                const Icon(Icons.arrow_upward),
                const SizedBox(width: AppSpacing.sm),
                Text(l10n.promoteToPublisher),
              ],
            ),
          ),
        );
      case DashboardUserRole.publisher:
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'demote',
            child: Row(
              children: [
                const Icon(Icons.arrow_downward),
                const SizedBox(width: AppSpacing.sm),
                Text(l10n.demoteToUser),
              ],
            ),
          ),
        );
      case DashboardUserRole.admin:
        // No actions for admins, handled by the initial check.
        break;
    }

    // Add the "Copy User ID" action for all non-admin users.
    overflowMenuItems.add(
      PopupMenuItem<String>(
        value: 'copy_id',
        child: Row(
          children: [
            const Icon(Icons.copy),
            const SizedBox(width: AppSpacing.sm),
            Text(l10n.copyId),
          ],
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<String>(
          iconSize: 20,
          icon: const Icon(Icons.more_vert),
          tooltip: l10n.moreActions,
          onSelected: (value) {
            switch (value) {
              case 'promote':
                context.read<UserManagementBloc>().add(
                  UserDashboardRoleChanged(
                    userId: user.id,
                    dashboardRole: DashboardUserRole.publisher,
                  ),
                );
              case 'demote':
                context.read<UserManagementBloc>().add(
                  UserDashboardRoleChanged(
                    userId: user.id,
                    dashboardRole: DashboardUserRole.none,
                  ),
                );
              case 'copy_id':
                Clipboard.setData(ClipboardData(text: user.id));
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(l10n.idCopiedToClipboard(user.id))),
                  );
            }
          },
          itemBuilder: (context) => overflowMenuItems,
        ),
      ],
    );
  }
}
