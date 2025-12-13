import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/confirmation_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template content_action_buttons}
/// A widget that displays action buttons for content management items
/// (Headlines, Topics, Sources) based on their [ContentStatus].
///
/// It shows a maximum of two primary icons, with additional actions
/// accessible via a dropdown menu.
/// {@endtemplate}
class ContentActionButtons extends StatelessWidget {
  /// {@macro content_action_buttons}
  const ContentActionButtons({
    required this.item,
    required this.l10n,
    super.key,
  });

  /// The content item for which to display actions.
  final FeedItem item;

  /// The localized strings for the application.
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final visibleActions = <Widget>[];
    final overflowMenuItems = <PopupMenuEntry<String>>[];

    // Determine item ID and status
    String itemId;
    ContentStatus status;

    if (item is Headline) {
      itemId = (item as Headline).id;
      status = (item as Headline).status;
    } else if (item is Topic) {
      itemId = (item as Topic).id;
      status = (item as Topic).status;
    } else if (item is Source) {
      itemId = (item as Source).id;
      status = (item as Source).status;
    } else {
      return const SizedBox.shrink();
    }

    // Action 1: Edit (always visible as the first action)
    visibleActions.add(
      IconButton(
        visualDensity: VisualDensity.compact,
        iconSize: 20,
        icon: const Icon(Icons.edit),
        tooltip: l10n.edit,
        onPressed: () {
          String routeName;
          switch (item.type) {
            case 'headline':
              routeName = Routes.editHeadlineName;
            case 'topic':
              routeName = Routes.editTopicName;
            case 'source':
              routeName = Routes.editSourceName;
            default:
              return;
          }
          context.goNamed(
            routeName,
            pathParameters: {'id': itemId},
          );
        },
      ),
    );

    // Determine contextual action and add to overflow
    switch (status) {
      case ContentStatus.draft:
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'publish',
            child: Row(
              children: [
                const Icon(Icons.publish),
                const SizedBox(width: AppSpacing.sm),
                Text(l10n.publish),
              ],
            ),
          ),
        );
        // Delete is allowed for all draft items
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete_forever),
                const SizedBox(width: AppSpacing.sm),
                Text(l10n.deleteForever),
              ],
            ),
          ),
        );
      case ContentStatus.active:
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'archive',
            child: Row(
              children: [
                const Icon(Icons.archive),
                const SizedBox(width: AppSpacing.sm),
                Text(l10n.archive),
              ],
            ),
          ),
        );
      // Delete is NOT allowed for active items
      case ContentStatus.archived:
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'restore',
            child: Row(
              children: [
                const Icon(Icons.unarchive),
                const SizedBox(width: AppSpacing.sm),
                Text(l10n.restore),
              ],
            ),
          ),
        );
        // Delete is only allowed for archived headlines
        if (item is Headline) {
          overflowMenuItems.add(
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_forever),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.deleteForever),
                ],
              ),
            ),
          );
        }
    }

    // The ellipsis button is always shown if there are any overflow actions.
    // Given the current logic, there will always be at least one overflow item
    // (publish/archive/restore for draft/active/archived, and delete for draft/archived headlines).
    // So, we will always show the ellipsis.
    visibleActions.add(
      SizedBox(
        width: 32,
        child: PopupMenuButton<String>(
          iconSize: 20,
          icon: const Icon(Icons.more_vert),
          tooltip: l10n.moreActions,
          onSelected: (value) {
            _handleAction(context, value, itemId, l10n);
          },
          itemBuilder: (BuildContext context) => overflowMenuItems,
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: visibleActions,
    );
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          title: title,
          content: content,
          confirmText: confirmText,
          onConfirm: onConfirm,
        );
      },
    );
  }

  void _handleAction(
    BuildContext context,
    String action,
    String itemId,
    AppLocalizations l10n,
  ) {
    switch (action) {
      case 'publish':
        _showConfirmationDialog(
          context: context,
          title: l10n.publishItemTitle,
          content: l10n.publishItemContent,
          confirmText: l10n.publish,
          onConfirm: () {
            if (item is Headline) {
              context.read<ContentManagementBloc>().add(
                PublishHeadlineRequested(itemId),
              );
            } else if (item is Topic) {
              context.read<ContentManagementBloc>().add(
                PublishTopicRequested(itemId),
              );
            } else if (item is Source) {
              context.read<ContentManagementBloc>().add(
                PublishSourceRequested(itemId),
              );
            }
          },
        );
      case 'archive':
        _showConfirmationDialog(
          context: context,
          title: l10n.archiveItemTitle,
          content: l10n.archiveItemContent,
          confirmText: l10n.archive,
          onConfirm: () {
            if (item is Headline) {
              context.read<ContentManagementBloc>().add(
                ArchiveHeadlineRequested(itemId),
              );
            } else if (item is Topic) {
              context.read<ContentManagementBloc>().add(
                ArchiveTopicRequested(itemId),
              );
            } else if (item is Source) {
              context.read<ContentManagementBloc>().add(
                ArchiveSourceRequested(itemId),
              );
            }
          },
        );
      case 'restore':
        _showConfirmationDialog(
          context: context,
          title: l10n.restoreItemTitle,
          content: l10n.restoreItemContent,
          confirmText: l10n.restore,
          onConfirm: () {
            if (item is Headline) {
              context.read<ContentManagementBloc>().add(
                RestoreHeadlineRequested(itemId),
              );
            } else if (item is Topic) {
              context.read<ContentManagementBloc>().add(
                RestoreTopicRequested(itemId),
              );
            } else if (item is Source) {
              context.read<ContentManagementBloc>().add(
                RestoreSourceRequested(itemId),
              );
            }
          },
        );
      case 'delete':
        _showConfirmationDialog(
          context: context,
          title: l10n.deleteItemTitle,
          content: l10n.deleteItemContent,
          confirmText: l10n.deleteForever,
          onConfirm: () {
            if (item is Headline) {
              context.read<ContentManagementBloc>().add(
                DeleteHeadlineForeverRequested(itemId),
              );
            }
          },
        );
    }
  }
}
