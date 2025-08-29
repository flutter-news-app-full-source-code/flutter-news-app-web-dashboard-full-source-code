import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/feed_decorator_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/user_preference_limits_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/feed_decorator_type_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template feed_configuration_tab}
/// A widget representing the "Feed" tab in the App Configuration page.
///
/// This tab allows configuration of user content limits and feed decorators.
/// {@endtemplate}
class FeedConfigurationTab extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Top-level ExpansionTile for User Content Limits
        ExpansionTile(
          title: Text(l10n.userContentLimitsTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.xxl,
          ),
          children: [
            UserPreferenceLimitsForm(
              remoteConfig: remoteConfig,
              onConfigChanged: onConfigChanged,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // New Top-level ExpansionTile for Feed Decorators
        ExpansionTile(
          title: Text(l10n.feedDecoratorsTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.xxl,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          children: [
            Text(
              l10n.feedDecoratorsDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                    start: AppSpacing.xxl,
                  ),
                  children: [
                    FeedDecoratorForm(
                      decoratorType: decoratorType,
                      remoteConfig: remoteConfig.copyWith(
                        feedDecoratorConfig:
                            Map.from(
                              remoteConfig.feedDecoratorConfig,
                            )..putIfAbsent(
                              decoratorType,
                              () => FeedDecoratorConfig(
                                category:
                                    decoratorType ==
                                            FeedDecoratorType.suggestedTopics ||
                                        decoratorType ==
                                            FeedDecoratorType.suggestedSources
                                    ? FeedDecoratorCategory.contentCollection
                                    : FeedDecoratorCategory.callToAction,
                                enabled: false,
                                visibleTo: const {},
                                itemsToDisplay:
                                    decoratorType ==
                                            FeedDecoratorType.suggestedTopics ||
                                        decoratorType ==
                                            FeedDecoratorType.suggestedSources
                                    ? 0
                                    : null,
                              ),
                            ),
                      ),
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
