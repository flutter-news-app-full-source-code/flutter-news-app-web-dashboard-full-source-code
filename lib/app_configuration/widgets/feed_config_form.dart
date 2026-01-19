import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/feed_decorator_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/feed_decorator_type_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/feed_item_click_behavior_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template feed_config_form}
/// A form widget for configuring feed settings.
/// {@endtemplate}
class FeedConfigForm extends StatelessWidget {
  /// {@macro feed_config_form}
  const FeedConfigForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  String _getDecoratorDescription(
    BuildContext context,
    FeedDecoratorType type,
  ) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (type) {
      case FeedDecoratorType.linkAccount:
        return l10n.feedDecoratorLinkAccountDescription;
      case FeedDecoratorType.unlockRewards:
        return l10n.feedDecoratorUnlockRewardsDescription;
      case FeedDecoratorType.rateApp:
        return l10n.feedDecoratorRateAppDescription;
      case FeedDecoratorType.suggestedTopics:
        return l10n.feedDecoratorSuggestedTopicsDescription;
      case FeedDecoratorType.suggestedSources:
        return l10n.feedDecoratorSuggestedSourcesDescription;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: Text(l10n.feedItemClickBehaviorTitle),
          subtitle: Text(
            l10n.feedItemClickBehaviorDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SegmentedButton<FeedItemClickBehavior>(
                segments: FeedItemClickBehavior.values
                    .where(
                      (b) => b != FeedItemClickBehavior.defaultBehavior,
                    )
                    .map(
                      (behavior) => ButtonSegment<FeedItemClickBehavior>(
                        value: behavior,
                        label: Text(behavior.l10n(context)),
                      ),
                    )
                    .toList(),
                selected: {
                  remoteConfig.features.feed.itemClickBehavior,
                },
                onSelectionChanged: (newSelection) {
                  onConfigChanged(
                    remoteConfig.copyWith(
                      features: remoteConfig.features.copyWith(
                        feed: remoteConfig.features.feed.copyWith(
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
          subtitle: Text(
            l10n.feedDecoratorsDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final decoratorType in FeedDecoratorType.values)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ExpansionTile(
                  title: Text(decoratorType.l10n(context)),
                  subtitle: Text(
                    _getDecoratorDescription(context, decoratorType),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  childrenPadding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.xl,
                    top: AppSpacing.md,
                    bottom: AppSpacing.md,
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FeedDecoratorForm(
                      decoratorType: decoratorType,
                      remoteConfig: remoteConfig,
                      onConfigChanged: onConfigChanged,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
