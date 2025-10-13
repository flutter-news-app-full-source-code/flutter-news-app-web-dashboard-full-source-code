import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/widgets/content_action_buttons.dart'
    show ContentActionButtons;
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/local_ads_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template local_ad_action_buttons}
/// A widget that displays action buttons for local ad items
/// (Native, Banner, Interstitial, Video) based on their [ContentStatus].
///
/// It shows a maximum of two primary icons, with additional actions
/// accessible via a dropdown menu, mirroring the functionality of
/// [ContentActionButtons] for content management items.
/// {@endtemplate}
class LocalAdActionButtons extends StatelessWidget {
  /// {@macro local_ad_action_buttons}
  const LocalAdActionButtons({
    required this.item,
    required this.l10n,
    super.key,
  });

  /// The local ad item for which to display actions.
  final LocalAd item;

  /// The localized strings for the application.
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final visibleActions = <Widget>[];
    final overflowMenuItems = <PopupMenuEntry<String>>[];

    // Determine item ID and status
    final itemId = item.id;
    final status = switch (item) {
      final LocalNativeAd ad => ad.status,
      final LocalBannerAd ad => ad.status,
      final LocalInterstitialAd ad => ad.status,
      final LocalVideoAd ad => ad.status,
      // Wildcard pattern to ensure exhaustive matching for LocalAd subtypes.
      _ => throw StateError('Unknown LocalAd type: ${item.runtimeType}'),
    };

    // Action 1: Edit (always visible as the first action)
    visibleActions.add(
      IconButton(
        visualDensity: VisualDensity.compact,
        iconSize: 20,
        icon: const Icon(Icons.edit),
        tooltip: l10n.edit,
        onPressed: () {
          String routeName;
          switch (item.adType) {
            case 'native':
              routeName = Routes.editLocalNativeAdName;
            case 'banner':
              routeName = Routes.editLocalBannerAdName;
            case 'interstitial':
              routeName = Routes.editLocalInterstitialAdName;
            case 'video':
              routeName = Routes.editLocalVideoAdName;
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
        // Local ads are not expected to have a 'draft' status in this context,
        // but including for completeness if the model changes.
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
        // Add "Copy ID" option for active ads
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'copyId',
            child: Row(
              children: [
                const Icon(Icons.copy),
                const SizedBox(width: AppSpacing.sm),
                Text(l10n.copyId),
              ],
            ),
          ),
        );
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

    // The ellipsis button is always shown if there are any overflow actions.
    // Given the current logic, there will always be at least one overflow item
    // (archive/restore/delete).
    visibleActions.add(
      SizedBox(
        width: 32,
        child: PopupMenuButton<String>(
          iconSize: 20,
          icon: const Icon(Icons.more_vert),
          tooltip: l10n.moreActions,
          onSelected: (value) {
            switch (value) {
              case 'publish':
                // Local ads are not expected to be 'published' from draft,
                // but including for completeness.
                context.read<LocalAdsManagementBloc>().add(
                  RestoreLocalAdRequested(itemId),
                );
              case 'copyId':
                // Copy the ad ID to the clipboard
                Clipboard.setData(ClipboardData(text: itemId)).then((_) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.idCopied),
                    ),
                  );
                });
              case 'archive':
                context.read<LocalAdsManagementBloc>().add(
                  ArchiveLocalAdRequested(itemId),
                );
              case 'restore':
                context.read<LocalAdsManagementBloc>().add(
                  RestoreLocalAdRequested(itemId),
                );
              case 'delete':
                context.read<LocalAdsManagementBloc>().add(
                  DeleteLocalAdForeverRequested(itemId),
                );
            }
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
}
