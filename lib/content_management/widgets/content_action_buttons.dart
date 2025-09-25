import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
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
      return const SizedBox.shrink(); // Should not happen with current FeedItem types
    }

    // Action 1: Edit (always visible as the first action)
    visibleActions.add(
      IconButton(
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
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        tooltip: l10n.moreActions,
        onSelected: (value) {
          switch (value) {
            case 'publish':
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
            case 'archive':
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
            case 'restore':
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
            case 'delete':
              if (item is Headline) {
                context.read<ContentManagementBloc>().add(
                  DeleteHeadlineForeverRequested(itemId),
                );
              } else if (item is Topic) {
                context.read<ContentManagementBloc>().add(
                  DeleteTopicForeverRequested(itemId),
                );
              } else if (item is Source) {
                context.read<ContentManagementBloc>().add(
                  DeleteSourceForeverRequested(itemId),
                );
              }
          }
        },
        itemBuilder: (BuildContext context) => overflowMenuItems,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: visibleActions,
    );
  }
}
