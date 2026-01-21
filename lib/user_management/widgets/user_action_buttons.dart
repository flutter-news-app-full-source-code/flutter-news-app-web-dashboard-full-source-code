import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/confirmation_dialog.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_management_bloc.dart';

/// {@template user_action_buttons}
/// A widget that displays contextual action buttons for a user in the user
/// management table.
///
/// Actions are presented in a [PopupMenuButton] and are conditionally
/// displayed based on the user's role and permissions. This follows a similar
/// pattern to the content management action buttons but is tailored for user
/// management.
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
    // visibleActions holds the primary action icons that are always visible.
    final visibleActions = <Widget>[];
    // overflowMenuItems holds actions that are in the popup menu.
    final overflowMenuItems = <PopupMenuEntry<String>>[];

    // Rule: Do not show any actions for admin users.
    if (user.role == UserRole.admin) {
      return const SizedBox.shrink();
    }
    // Primary action: Copy User ID. This is always available for non-admins.
    visibleActions.add(
      IconButton(
        visualDensity: VisualDensity.compact,
        iconSize: 20,
        icon: const Icon(Icons.copy),
        tooltip: l10n.copyId,
        onPressed: () => _onCopyId(context),
      ),
    );
    // Add contextual actions to the overflow menu based on the user's role.
    switch (user.role) {
      case UserRole.user:
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'promote',
            child: Text(l10n.promoteToPublisher),
          ),
        );
      case UserRole.publisher:
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'demote',
            child: Text(l10n.demoteToUser),
          ),
        );
      case UserRole.admin:
        // No actions for admins, handled by the initial check.
        break;
    }
    // Add the overflow menu button if there are items in it.
    if (overflowMenuItems.isNotEmpty) {
      visibleActions.add(
        SizedBox(
          width: 32,
          child: PopupMenuButton<String>(
            iconSize: 20,
            icon: const Icon(Icons.more_vert),
            tooltip: l10n.moreActions,
            onSelected: (value) {
              switch (value) {
                case 'promote':
                  _onPromote(context);
                case 'demote':
                  _onDemote(context);
              }
            },
            itemBuilder: (context) => overflowMenuItems,
          ),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: visibleActions,
    );
  }

  void _onPromote(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        title: l10n.confirmPromotionTitle,
        content: l10n.confirmPromotionMessage(user.email),
        confirmText: l10n.promoteToPublisher,
        onConfirm: () {
          context.read<UserManagementBloc>().add(
            UserRoleChanged(
              userId: user.id,
              role: UserRole.publisher,
            ),
          );
        },
      ),
    );
  }

  void _onDemote(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        title: l10n.confirmDemotionTitle,
        content: l10n.confirmDemotionMessage(user.email),
        confirmText: l10n.demoteToUser,
        onConfirm: () {
          context.read<UserManagementBloc>().add(
            UserRoleChanged(
              userId: user.id,
              role: UserRole.user,
            ),
          );
        },
      ),
    );
  }

  void _onCopyId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: user.id));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.idCopiedToClipboard(user.id))),
      );
  }
}
