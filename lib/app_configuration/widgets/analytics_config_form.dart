import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template analytics_config_form}
/// A form widget for configuring analytics settings.
/// {@endtemplate}
class AnalyticsConfigForm extends StatelessWidget {
  /// {@macro analytics_config_form}
  const AnalyticsConfigForm({
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
    final features = remoteConfig.features;
    final analyticsConfig = features.analytics;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.analyticsSystemStatusTitle),
          subtitle: Text(l10n.analyticsSystemStatusDescription),
          value: analyticsConfig.enabled,
          onChanged: (value) {
            onConfigChanged(
              remoteConfig.copyWith(
                features: features.copyWith(
                  analytics: analyticsConfig.copyWith(enabled: value),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildProviderSection(context, l10n, analyticsConfig),
        const SizedBox(height: AppSpacing.lg),
        _buildEventsSection(context, l10n, analyticsConfig),
      ],
    );
  }

  Widget _buildProviderSection(
    BuildContext context,
    AppLocalizations l10n,
    AnalyticsConfig config,
  ) {
    return ExpansionTile(
      title: Text(l10n.analyticsProviderTitle),
      subtitle: Text(
        l10n.analyticsProviderDescription,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
          child: SegmentedButton<AnalyticsProvider>(
            segments:
                AnalyticsProvider.values
                    .where((provider) => provider != AnalyticsProvider.demo)
                    .map((provider) {
                      return ButtonSegment<AnalyticsProvider>(
                        value: provider,
                        label: Text(_getProviderLabel(l10n, provider)),
                      );
                    })
                    .toList(),
            selected: {config.activeProvider},
            onSelectionChanged: (newSelection) {
              onConfigChanged(
                remoteConfig.copyWith(
                  features: remoteConfig.features.copyWith(
                    analytics: config.copyWith(
                      activeProvider: newSelection.first,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventsSection(
    BuildContext context,
    AppLocalizations l10n,
    AnalyticsConfig config,
  ) {
    return ExpansionTile(
      title: Text(l10n.analyticsEventsTitle),
      subtitle: Text(
        l10n.analyticsEventsDescription,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      childrenPadding: const EdgeInsetsDirectional.only(
        start: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // We use a Column here instead of ListView because it's inside a scrollable parent
        Column(
          children:
              AnalyticsEvent.values.map((event) {
                final isEnabled = !config.disabledEvents.contains(event);
                final samplingRate = config.eventSamplingRates[event] ?? 1.0;

                return Column(
                  children: [
                    CheckboxListTile(
                      title: Text(_getEventLabel(context, event)),
                      subtitle: Text(
                        _getEventDescription(context, event),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      value: isEnabled,
                      onChanged: (value) {
                        final newDisabledEvents = Set<AnalyticsEvent>.from(
                          config.disabledEvents,
                        );
                        if (value == true) {
                          newDisabledEvents.remove(event);
                        } else {
                          newDisabledEvents.add(event);
                        }
                        onConfigChanged(
                          remoteConfig.copyWith(
                            features: remoteConfig.features.copyWith(
                              analytics: config.copyWith(
                                disabledEvents: newDisabledEvents,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (isEnabled)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: AppSpacing.xxl,
                          end: AppSpacing.md,
                          bottom: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            Text(
                              l10n.samplingRateLabel(
                                (samplingRate * 100).toInt(),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Expanded(
                              child: Slider(
                                value: samplingRate,
                                min: 0.0,
                                max: 1.0,
                                divisions: 20,
                                label: '${(samplingRate * 100).toInt()}%',
                                onChanged: (value) {
                                  final newSamplingRates =
                                      Map<AnalyticsEvent, double>.from(
                                        config.eventSamplingRates,
                                      );
                                  // If value is 1.0, we can remove it from the map to save space/default
                                  if (value == 1.0) {
                                    newSamplingRates.remove(event);
                                  } else {
                                    newSamplingRates[event] = value;
                                  }
                                  onConfigChanged(
                                    remoteConfig.copyWith(
                                      features: remoteConfig.features.copyWith(
                                        analytics: config.copyWith(
                                          eventSamplingRates: newSamplingRates,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Divider(height: 1),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }

  String _getProviderLabel(AppLocalizations l10n, AnalyticsProvider provider) {
    switch (provider) {
      case AnalyticsProvider.firebase:
        return l10n.analyticsProviderFirebase;
      case AnalyticsProvider.mixpanel:
        return l10n.analyticsProviderMixpanel;
      case AnalyticsProvider.demo:
        // Fallback, though filtered out in UI
        return 'Demo';
    }
  }

  String _getEventLabel(BuildContext context, AnalyticsEvent event) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (event) {
      case AnalyticsEvent.userRegistered:
        return l10n.analyticsEventUserRegisteredLabel;
      case AnalyticsEvent.userLogin:
        return l10n.analyticsEventUserLoginLabel;
      case AnalyticsEvent.accountLinked:
        return l10n.analyticsEventAccountLinkedLabel;
      case AnalyticsEvent.userRoleChanged:
        return l10n.analyticsEventUserRoleChangedLabel;
      case AnalyticsEvent.contentViewed:
        return l10n.analyticsEventContentViewedLabel;
      case AnalyticsEvent.contentShared:
        return l10n.analyticsEventContentSharedLabel;
      case AnalyticsEvent.contentSaved:
        return l10n.analyticsEventContentSavedLabel;
      case AnalyticsEvent.contentUnsaved:
        return l10n.analyticsEventContentUnsavedLabel;
      case AnalyticsEvent.contentReadingTime:
        return l10n.analyticsEventContentReadingTimeLabel;
      case AnalyticsEvent.reactionCreated:
        return l10n.analyticsEventReactionCreatedLabel;
      case AnalyticsEvent.reactionDeleted:
        return l10n.analyticsEventReactionDeletedLabel;
      case AnalyticsEvent.commentCreated:
        return l10n.analyticsEventCommentCreatedLabel;
      case AnalyticsEvent.commentDeleted:
        return l10n.analyticsEventCommentDeletedLabel;
      case AnalyticsEvent.reportSubmitted:
        return l10n.analyticsEventReportSubmittedLabel;
      case AnalyticsEvent.headlineFilterCreated:
        return l10n.analyticsEventHeadlineFilterCreatedLabel;
      case AnalyticsEvent.headlineFilterUpdated:
        return l10n.analyticsEventHeadlineFilterUpdatedLabel;
      case AnalyticsEvent.headlineFilterUsed:
        return l10n.analyticsEventHeadlineFilterUsedLabel;
      case AnalyticsEvent.sourceFilterCreated:
        return l10n.analyticsEventSourceFilterCreatedLabel;
      case AnalyticsEvent.sourceFilterUpdated:
        return l10n.analyticsEventSourceFilterUpdatedLabel;
      case AnalyticsEvent.searchPerformed:
        return l10n.analyticsEventSearchPerformedLabel;
      case AnalyticsEvent.appReviewPromptResponded:
        return l10n.analyticsEventAppReviewPromptRespondedLabel;
      case AnalyticsEvent.appReviewStoreRequested:
        return l10n.analyticsEventAppReviewStoreRequestedLabel;
      case AnalyticsEvent.limitExceeded:
        return l10n.analyticsEventLimitExceededLabel;
      case AnalyticsEvent.limitExceededCtaClicked:
        return l10n.analyticsEventLimitExceededCtaClickedLabel;
      case AnalyticsEvent.paywallPresented:
        return l10n.analyticsEventPaywallPresentedLabel;
      case AnalyticsEvent.subscriptionStarted:
        return l10n.analyticsEventSubscriptionStartedLabel;
      case AnalyticsEvent.subscriptionRenewed:
        return l10n.analyticsEventSubscriptionRenewedLabel;
      case AnalyticsEvent.subscriptionCancelled:
        return l10n.analyticsEventSubscriptionCancelledLabel;
      case AnalyticsEvent.subscriptionEnded:
        return l10n.analyticsEventSubscriptionEndedLabel;
      case AnalyticsEvent.adImpression:
        return l10n.analyticsEventAdImpressionLabel;
      case AnalyticsEvent.adClicked:
        return l10n.analyticsEventAdClickedLabel;
      case AnalyticsEvent.adLoadFailed:
        return l10n.analyticsEventAdLoadFailedLabel;
      case AnalyticsEvent.adRewardEarned:
        return l10n.analyticsEventAdRewardEarnedLabel;
      case AnalyticsEvent.themeChanged:
        return l10n.analyticsEventThemeChangedLabel;
      case AnalyticsEvent.languageChanged:
        return l10n.analyticsEventLanguageChangedLabel;
      case AnalyticsEvent.feedDensityChanged:
        return l10n.analyticsEventFeedDensityChangedLabel;
      case AnalyticsEvent.browserChoiceChanged:
        return l10n.analyticsEventBrowserChoiceChangedLabel;
      case AnalyticsEvent.sourceFilterUsed:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String _getEventDescription(BuildContext context, AnalyticsEvent event) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (event) {
      case AnalyticsEvent.userRegistered:
        return l10n.analyticsEventUserRegisteredDescription;
      case AnalyticsEvent.userLogin:
        return l10n.analyticsEventUserLoginDescription;
      case AnalyticsEvent.accountLinked:
        return l10n.analyticsEventAccountLinkedDescription;
      case AnalyticsEvent.userRoleChanged:
        return l10n.analyticsEventUserRoleChangedDescription;
      case AnalyticsEvent.contentViewed:
        return l10n.analyticsEventContentViewedDescription;
      case AnalyticsEvent.contentShared:
        return l10n.analyticsEventContentSharedDescription;
      case AnalyticsEvent.contentSaved:
        return l10n.analyticsEventContentSavedDescription;
      case AnalyticsEvent.contentUnsaved:
        return l10n.analyticsEventContentUnsavedDescription;
      case AnalyticsEvent.contentReadingTime:
        return l10n.analyticsEventContentReadingTimeDescription;
      case AnalyticsEvent.reactionCreated:
        return l10n.analyticsEventReactionCreatedDescription;
      case AnalyticsEvent.reactionDeleted:
        return l10n.analyticsEventReactionDeletedDescription;
      case AnalyticsEvent.commentCreated:
        return l10n.analyticsEventCommentCreatedDescription;
      case AnalyticsEvent.commentDeleted:
        return l10n.analyticsEventCommentDeletedDescription;
      case AnalyticsEvent.reportSubmitted:
        return l10n.analyticsEventReportSubmittedDescription;
      case AnalyticsEvent.headlineFilterCreated:
        return l10n.analyticsEventHeadlineFilterCreatedDescription;
      case AnalyticsEvent.headlineFilterUpdated:
        return l10n.analyticsEventHeadlineFilterUpdatedDescription;
      case AnalyticsEvent.headlineFilterUsed:
        return l10n.analyticsEventHeadlineFilterUsedDescription;
      case AnalyticsEvent.sourceFilterCreated:
        return l10n.analyticsEventSourceFilterCreatedDescription;
      case AnalyticsEvent.sourceFilterUpdated:
        return l10n.analyticsEventSourceFilterUpdatedDescription;
      case AnalyticsEvent.searchPerformed:
        return l10n.analyticsEventSearchPerformedDescription;
      case AnalyticsEvent.appReviewPromptResponded:
        return l10n.analyticsEventAppReviewPromptRespondedDescription;
      case AnalyticsEvent.appReviewStoreRequested:
        return l10n.analyticsEventAppReviewStoreRequestedDescription;
      case AnalyticsEvent.limitExceeded:
        return l10n.analyticsEventLimitExceededDescription;
      case AnalyticsEvent.limitExceededCtaClicked:
        return l10n.analyticsEventLimitExceededCtaClickedDescription;
      case AnalyticsEvent.paywallPresented:
        return l10n.analyticsEventPaywallPresentedDescription;
      case AnalyticsEvent.subscriptionStarted:
        return l10n.analyticsEventSubscriptionStartedDescription;
      case AnalyticsEvent.subscriptionRenewed:
        return l10n.analyticsEventSubscriptionRenewedDescription;
      case AnalyticsEvent.subscriptionCancelled:
        return l10n.analyticsEventSubscriptionCancelledDescription;
      case AnalyticsEvent.subscriptionEnded:
        return l10n.analyticsEventSubscriptionEndedDescription;
      case AnalyticsEvent.adImpression:
        return l10n.analyticsEventAdImpressionDescription;
      case AnalyticsEvent.adClicked:
        return l10n.analyticsEventAdClickedDescription;
      case AnalyticsEvent.adLoadFailed:
        return l10n.analyticsEventAdLoadFailedDescription;
      case AnalyticsEvent.adRewardEarned:
        return l10n.analyticsEventAdRewardEarnedDescription;
      case AnalyticsEvent.themeChanged:
        return l10n.analyticsEventThemeChangedDescription;
      case AnalyticsEvent.languageChanged:
        return l10n.analyticsEventLanguageChangedDescription;
      case AnalyticsEvent.feedDensityChanged:
        return l10n.analyticsEventFeedDensityChangedDescription;
      case AnalyticsEvent.browserChoiceChanged:
        return l10n.analyticsEventBrowserChoiceChangedDescription;
      case AnalyticsEvent.sourceFilterUsed:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
