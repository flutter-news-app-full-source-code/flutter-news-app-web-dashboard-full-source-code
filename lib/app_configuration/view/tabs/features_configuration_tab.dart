import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/ad_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/ad_platform_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/analytics_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/community_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/feed_ad_settings_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/feed_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/feed_decorator_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/navigation_ad_settings_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/push_notification_settings_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/feed_decorator_type_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/feed_item_click_behavior_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template features_configuration_tab}
/// A widget representing the "Features" tab in the App Configuration page.
///
/// This tab allows configuration of user-facing features like ads,
/// push notifications, and feed settings.
/// {@endtemplate}
class FeaturesConfigurationTab extends StatefulWidget {
  /// {@macro features_configuration_tab}
  const FeaturesConfigurationTab({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<FeaturesConfigurationTab> createState() =>
      _FeaturesConfigurationTabState();
}

class _FeaturesConfigurationTabState extends State<FeaturesConfigurationTab> {
  /// Notifier for the index of the currently expanded top-level ExpansionTile.
  ///
  /// A value of `null` means no tile is expanded.
  final ValueNotifier<int?> _expandedTileIndex = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _expandedTileIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Advertisements
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 0;
            return ExpansionTile(
              leading: Icon(
                Icons.paid_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('advertisementsTile_$expandedIndex'),
              title: Text(l10n.advertisementsTab),
              subtitle: Text(
                l10n.advertisementsDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              onExpansionChanged: (bool isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.xxl,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdConfigForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
                if (widget.remoteConfig.features.ads.enabled) ...[
                  const SizedBox(height: AppSpacing.lg),
                  AdPlatformConfigForm(
                    remoteConfig: widget.remoteConfig,
                    onConfigChanged: widget.onConfigChanged,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FeedAdSettingsForm(
                    remoteConfig: widget.remoteConfig,
                    onConfigChanged: widget.onConfigChanged,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  NavigationAdSettingsForm(
                    remoteConfig: widget.remoteConfig,
                    onConfigChanged: widget.onConfigChanged,
                  ),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Push Notifications
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 1;
            return ExpansionTile(
              leading: Icon(
                Icons.notifications_active_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('pushNotificationsTile_$expandedIndex'),
              title: Text(l10n.notificationsTab),
              subtitle: Text(
                l10n.notificationsDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              onExpansionChanged: (bool isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.xxl,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PushNotificationSettingsForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Analytics
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 2;
            return ExpansionTile(
              leading: Icon(
                Icons.analytics_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('analyticsTile_$expandedIndex'),
              title: Text(l10n.analyticsTab),
              subtitle: Text(
                l10n.analyticsDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              onExpansionChanged: (bool isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.xxl,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnalyticsConfigForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        
        // Feed
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 3;
            return ExpansionTile(
              leading: Icon(
                Icons.dynamic_feed_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('feedTile_$expandedIndex'),
              title: Text(l10n.feedTab),
              subtitle: Text(
                l10n.feedDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              onExpansionChanged: (bool isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.xxl,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FeedConfigForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Community & Engagement
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 4;
            return ExpansionTile(
              leading: Icon(
                Icons.groups_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('communityTile_$expandedIndex'),
              title: Text(l10n.communityAndEngagementTitle),
              subtitle: Text(
                l10n.communityAndEngagementDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              onExpansionChanged: (bool isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.xxl,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommunityConfigForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
