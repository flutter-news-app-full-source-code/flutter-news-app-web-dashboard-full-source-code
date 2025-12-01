import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/ad_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/ad_platform_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/community_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/feed_ad_settings_form.dart';
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
              key: ValueKey('advertisementsTile_$expandedIndex'),
              title: Text(l10n.advertisementsTab),
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdConfigForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
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
              key: ValueKey('pushNotificationsTile_$expandedIndex'),
              title: Text(l10n.notificationsTab),
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
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

        // Feed
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 2;
            return ExpansionTile(
              key: ValueKey('feedTile_$expandedIndex'),
              title: Text(l10n.feedTab),
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpansionTile(
                  title: Text(l10n.feedItemClickBehaviorTitle),
                  childrenPadding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.lg,
                    top: AppSpacing.md,
                    bottom: AppSpacing.md,
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.feedItemClickBehaviorDescription,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: SegmentedButton<FeedItemClickBehavior>(
                        segments: FeedItemClickBehavior.values
                            .where(
                              (b) => b != FeedItemClickBehavior.defaultBehavior,
                            )
                            .map(
                              (behavior) =>
                                  ButtonSegment<FeedItemClickBehavior>(
                                    value: behavior,
                                    label: Text(behavior.l10n(context)),
                                  ),
                            )
                            .toList(),
                        selected: {
                          widget.remoteConfig.features.feed.itemClickBehavior,
                        },
                        onSelectionChanged: (newSelection) {
                          widget.onConfigChanged(
                            widget.remoteConfig.copyWith(
                              features: widget.remoteConfig.features.copyWith(
                                feed: widget.remoteConfig.features.feed
                                    .copyWith(
                                      itemClickBehavior: newSelection.first,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                ExpansionTile(
                  title: Text(l10n.feedDecoratorsTitle),
                  childrenPadding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.lg,
                    top: AppSpacing.md,
                    bottom: AppSpacing.md,
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.feedDecoratorsDescription,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    for (final decoratorType in FeedDecoratorType.values)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: ExpansionTile(
                          title: Text(decoratorType.l10n(context)),
                          childrenPadding: const EdgeInsetsDirectional.only(
                            start: AppSpacing.xl,
                            top: AppSpacing.md,
                            bottom: AppSpacing.md,
                          ),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FeedDecoratorForm(
                              decoratorType: decoratorType,
                              remoteConfig: widget.remoteConfig,
                              onConfigChanged: widget.onConfigChanged,
                            ),
                          ],
                        ),
                      ),
                  ],
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
            const tileIndex = 3;
            return ExpansionTile(
              key: ValueKey('communityTile_$expandedIndex'),
              title: Text(l10n.communityAndEngagementTitle),
              subtitle: Text(l10n.communityAndEngagementDescription),
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
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
