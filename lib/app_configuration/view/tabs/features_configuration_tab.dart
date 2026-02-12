import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/ad_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/ad_platform_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/analytics_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/community_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/feed_ad_settings_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/feed_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/navigation_ad_settings_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/onboarding_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/push_notification_settings_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/rewards_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

enum _FeatureTile {
  onboarding,
  advertisements,
  rewards,
  pushNotifications,
  analytics,
  feed,
  community,
}

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
  final ValueNotifier<_FeatureTile?> _expandedTile =
      ValueNotifier<_FeatureTile?>(null);

  @override
  void dispose() {
    _expandedTile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Onboarding
        ValueListenableBuilder<_FeatureTile?>(
          valueListenable: _expandedTile,
          builder: (context, expandedTile, child) {
            const tile = _FeatureTile.onboarding;
            return ExpansionTile(
              leading: Icon(
                Icons.explore_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('onboardingTile_$expandedTile'),
              title: Text(l10n.onboardingTitle),
              subtitle: Text(
                l10n.onboardingDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              onExpansionChanged: (bool isExpanded) {
                _expandedTile.value = isExpanded ? tile : null;
              },
              initiallyExpanded: expandedTile == tile,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.xxl,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OnboardingConfigForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        // Advertisements
        ValueListenableBuilder<_FeatureTile?>(
          valueListenable: _expandedTile,
          builder: (context, expandedTile, child) {
            const tile = _FeatureTile.advertisements;
            return ExpansionTile(
              leading: Icon(
                Icons.paid_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('advertisementsTile_$expandedTile'),
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
                _expandedTile.value = isExpanded ? tile : null;
              },
              initiallyExpanded: expandedTile == tile,
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

        // Rewards
        ValueListenableBuilder<_FeatureTile?>(
          valueListenable: _expandedTile,
          builder: (context, expandedTile, child) {
            const tile = _FeatureTile.rewards;
            return ExpansionTile(
              leading: Icon(
                Icons.card_giftcard_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('rewardsTile_$expandedTile'),
              title: Text(l10n.rewardsTab),
              subtitle: Text(
                l10n.rewardsDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              onExpansionChanged: (bool isExpanded) {
                _expandedTile.value = isExpanded ? tile : null;
              },
              initiallyExpanded: expandedTile == tile,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.xxl,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RewardsConfigForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Push Notifications
        ValueListenableBuilder<_FeatureTile?>(
          valueListenable: _expandedTile,
          builder: (context, expandedTile, child) {
            const tile = _FeatureTile.pushNotifications;
            return ExpansionTile(
              leading: Icon(
                Icons.notifications_active_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('pushNotificationsTile_$expandedTile'),
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
                _expandedTile.value = isExpanded ? tile : null;
              },
              initiallyExpanded: expandedTile == tile,
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
        ValueListenableBuilder<_FeatureTile?>(
          valueListenable: _expandedTile,
          builder: (context, expandedTile, child) {
            const tile = _FeatureTile.analytics;
            return ExpansionTile(
              leading: Icon(
                Icons.analytics_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('analyticsTile_$expandedTile'),
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
                _expandedTile.value = isExpanded ? tile : null;
              },
              initiallyExpanded: expandedTile == tile,
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
        ValueListenableBuilder<_FeatureTile?>(
          valueListenable: _expandedTile,
          builder: (context, expandedTile, child) {
            const tile = _FeatureTile.feed;
            return ExpansionTile(
              leading: Icon(
                Icons.dynamic_feed_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('feedTile_$expandedTile'),
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
                _expandedTile.value = isExpanded ? tile : null;
              },
              initiallyExpanded: expandedTile == tile,
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
        ValueListenableBuilder<_FeatureTile?>(
          valueListenable: _expandedTile,
          builder: (context, expandedTile, child) {
            const tile = _FeatureTile.community;
            return ExpansionTile(
              leading: Icon(
                Icons.groups_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('communityTile_$expandedTile'),
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
                _expandedTile.value = isExpanded ? tile : null;
              },
              initiallyExpanded: expandedTile == tile,
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
