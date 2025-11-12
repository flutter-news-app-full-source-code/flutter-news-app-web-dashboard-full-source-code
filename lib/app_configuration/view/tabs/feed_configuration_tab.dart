import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/feed_decorator_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/saved_feed_filters_limit_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/user_preference_limits_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/feed_decorator_type_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template feed_configuration_tab}
/// A widget representing the "Feed" tab in the App Configuration page.
///
/// This tab allows configuration of user content limits and feed decorators.
/// {@endtemplate}
class FeedConfigurationTab extends StatefulWidget {
  /// {@macro feed_configuration_tab}
  const FeedConfigurationTab({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<FeedConfigurationTab> createState() => _FeedConfigurationTabState();
}

class _FeedConfigurationTabState extends State<FeedConfigurationTab> {
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
        // Top-level ExpansionTile for User Content Limits
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 0;
            return ExpansionTile(
              key: ValueKey('userContentLimitsTile_$expandedIndex'),
              title: Text(l10n.userContentLimitsTitle),
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              children: [
                Text(
                  l10n.userContentLimitsDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                UserPreferenceLimitsForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        // New Top-level ExpansionTile for User Preset Limits
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 1;
            return ExpansionTile(
              key: ValueKey('savedFeedFilterLimitsTile_$expandedIndex'),
              title: Text(l10n.savedFeedFilterLimitsTitle),
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              children: [
                Text(
                  l10n.savedFeedFilterLimitsDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SavedFeedFiltersLimitForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        // New Top-level ExpansionTile for Feed Decorators
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 2;
            return ExpansionTile(
              key: ValueKey('feedDecoratorsTile_$expandedIndex'),
              title: Text(l10n.feedDecoratorsTitle),
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
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
                // Individual ExpansionTiles for each Feed Decorator, nested
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
                          remoteConfig: widget.remoteConfig.copyWith(
                            feedDecoratorConfig:
                                Map.from(
                                  widget.remoteConfig.feedDecoratorConfig,
                                )..putIfAbsent(
                                  decoratorType,
                                  () => FeedDecoratorConfig(
                                    category:
                                        decoratorType ==
                                                FeedDecoratorType
                                                    .suggestedTopics ||
                                            decoratorType ==
                                                FeedDecoratorType
                                                    .suggestedSources
                                        ? FeedDecoratorCategory
                                              .contentCollection
                                        : FeedDecoratorCategory.callToAction,
                                    enabled: false,
                                    visibleTo: const {},
                                    itemsToDisplay:
                                        decoratorType ==
                                                FeedDecoratorType
                                                    .suggestedTopics ||
                                            decoratorType ==
                                                FeedDecoratorType
                                                    .suggestedSources
                                        ? 0
                                        : null,
                                  ),
                                ),
                          ),
                          onConfigChanged: widget.onConfigChanged,
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
