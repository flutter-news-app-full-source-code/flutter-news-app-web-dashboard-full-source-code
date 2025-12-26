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
        if (analyticsConfig.enabled) ...[
          const SizedBox(height: AppSpacing.lg),
          _buildProviderSection(context, l10n, analyticsConfig),
          const SizedBox(height: AppSpacing.lg),
          _buildEventsSection(context, l10n, analyticsConfig),
        ],
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
            segments: AnalyticsProvider.values
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
          children: AnalyticsEvent.values.map((event) {
            final isEnabled = !config.disabledEvents.contains(event);
            final samplingRate = config.eventSamplingRates[event] ?? 1.0;
            final (label, description) = _getEventInfo(l10n, event);

            return Column(
              children: [
                CheckboxListTile(
                  title: Text(label),
                  subtitle: Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  value: isEnabled,
                  onChanged: (value) {
                    final newDisabledEvents = Set<AnalyticsEvent>.from(
                      config.disabledEvents,
                    );
                    if (value ?? false) {
                      newDisabledEvents.remove(event);
                    } else {
                      newDisabledEvents.add(event);
                    }

                    var newEnabled = config.enabled;
                    if (newDisabledEvents.length ==
                        AnalyticsEvent.values.length) {
                      newEnabled = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.analyticsFeatureDisabledNotification,
                          ),
                        ),
                      );
                    }

                    onConfigChanged(
                      remoteConfig.copyWith(
                        features: remoteConfig.features.copyWith(
                          analytics: config.copyWith(
                            enabled: newEnabled,
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
                            min: 0,
                            max: 1,
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

  (String, String) _getEventInfo(AppLocalizations l10n, AnalyticsEvent event) {
    switch (event) {
      case AnalyticsEvent.userRegistered:
        return (
          l10n.analyticsEventUserRegisteredLabel,
          l10n.analyticsEventUserRegisteredDescription,
        );
      case AnalyticsEvent.userLogin:
        return (
          l10n.analyticsEventUserLoginLabel,
          l10n.analyticsEventUserLoginDescription,
        );
      case AnalyticsEvent.accountLinked:
        return (
          l10n.analyticsEventAccountLinkedLabel,
          l10n.analyticsEventAccountLinkedDescription,
        );
      case AnalyticsEvent.userRoleChanged:
        return (
          l10n.analyticsEventUserRoleChangedLabel,
          l10n.analyticsEventUserRoleChangedDescription,
        );
      case AnalyticsEvent.contentViewed:
        return (
          l10n.analyticsEventContentViewedLabel,
          l10n.analyticsEventContentViewedDescription,
        );
      case AnalyticsEvent.contentShared:
        return (
          l10n.analyticsEventContentSharedLabel,
          l10n.analyticsEventContentSharedDescription,
        );
      case AnalyticsEvent.contentSaved:
        return (
          l10n.analyticsEventContentSavedLabel,
          l10n.analyticsEventContentSavedDescription,
        );
      case AnalyticsEvent.contentUnsaved:
        return (
          l10n.analyticsEventContentUnsavedLabel,
          l10n.analyticsEventContentUnsavedDescription,
        );
      case AnalyticsEvent.contentReadingTime:
        return (
          l10n.analyticsEventContentReadingTimeLabel,
          l10n.analyticsEventContentReadingTimeDescription,
        );
      case AnalyticsEvent.reactionCreated:
        return (
          l10n.analyticsEventReactionCreatedLabel,
          l10n.analyticsEventReactionCreatedDescription,
        );
      case AnalyticsEvent.reactionDeleted:
        return (
          l10n.analyticsEventReactionDeletedLabel,
          l10n.analyticsEventReactionDeletedDescription,
        );
      case AnalyticsEvent.commentCreated:
        return (
          l10n.analyticsEventCommentCreatedLabel,
          l10n.analyticsEventCommentCreatedDescription,
        );
      case AnalyticsEvent.commentDeleted:
        return (
          l10n.analyticsEventCommentDeletedLabel,
          l10n.analyticsEventCommentDeletedDescription,
        );
      case AnalyticsEvent.reportSubmitted:
        return (
          l10n.analyticsEventReportSubmittedLabel,
          l10n.analyticsEventReportSubmittedDescription,
        );
      case AnalyticsEvent.headlineFilterCreated:
        return (
          l10n.analyticsEventHeadlineFilterCreatedLabel,
          l10n.analyticsEventHeadlineFilterCreatedDescription,
        );
      case AnalyticsEvent.headlineFilterUpdated:
        return (
          l10n.analyticsEventHeadlineFilterUpdatedLabel,
          l10n.analyticsEventHeadlineFilterUpdatedDescription,
        );
      case AnalyticsEvent.headlineFilterUsed:
        return (
          l10n.analyticsEventHeadlineFilterUsedLabel,
          l10n.analyticsEventHeadlineFilterUsedDescription,
        );
      case AnalyticsEvent.sourceFilterCreated:
        return (
          l10n.analyticsEventSourceFilterCreatedLabel,
          l10n.analyticsEventSourceFilterCreatedDescription,
        );
      case AnalyticsEvent.sourceFilterUpdated:
        return (
          l10n.analyticsEventSourceFilterUpdatedLabel,
          l10n.analyticsEventSourceFilterUpdatedDescription,
        );
      case AnalyticsEvent.searchPerformed:
        return (
          l10n.analyticsEventSearchPerformedLabel,
          l10n.analyticsEventSearchPerformedDescription,
        );
      case AnalyticsEvent.appReviewPromptResponded:
        return (
          l10n.analyticsEventAppReviewPromptRespondedLabel,
          l10n.analyticsEventAppReviewPromptRespondedDescription,
        );
      case AnalyticsEvent.appReviewStoreRequested:
        return (
          l10n.analyticsEventAppReviewStoreRequestedLabel,
          l10n.analyticsEventAppReviewStoreRequestedDescription,
        );
      case AnalyticsEvent.limitExceeded:
        return (
          l10n.analyticsEventLimitExceededLabel,
          l10n.analyticsEventLimitExceededDescription,
        );
      case AnalyticsEvent.limitExceededCtaClicked:
        return (
          l10n.analyticsEventLimitExceededCtaClickedLabel,
          l10n.analyticsEventLimitExceededCtaClickedDescription,
        );
      case AnalyticsEvent.paywallPresented:
        return (
          l10n.analyticsEventPaywallPresentedLabel,
          l10n.analyticsEventPaywallPresentedDescription,
        );
      case AnalyticsEvent.subscriptionStarted:
        return (
          l10n.analyticsEventSubscriptionStartedLabel,
          l10n.analyticsEventSubscriptionStartedDescription,
        );
      case AnalyticsEvent.subscriptionRenewed:
        return (
          l10n.analyticsEventSubscriptionRenewedLabel,
          l10n.analyticsEventSubscriptionRenewedDescription,
        );
      case AnalyticsEvent.subscriptionCancelled:
        return (
          l10n.analyticsEventSubscriptionCancelledLabel,
          l10n.analyticsEventSubscriptionCancelledDescription,
        );
      case AnalyticsEvent.subscriptionEnded:
        return (
          l10n.analyticsEventSubscriptionEndedLabel,
          l10n.analyticsEventSubscriptionEndedDescription,
        );
      case AnalyticsEvent.adImpression:
        return (
          l10n.analyticsEventAdImpressionLabel,
          l10n.analyticsEventAdImpressionDescription,
        );
      case AnalyticsEvent.adClicked:
        return (
          l10n.analyticsEventAdClickedLabel,
          l10n.analyticsEventAdClickedDescription,
        );
      case AnalyticsEvent.adLoadFailed:
        return (
          l10n.analyticsEventAdLoadFailedLabel,
          l10n.analyticsEventAdLoadFailedDescription,
        );
      case AnalyticsEvent.adRewardEarned:
        return (
          l10n.analyticsEventAdRewardEarnedLabel,
          l10n.analyticsEventAdRewardEarnedDescription,
        );
      case AnalyticsEvent.themeChanged:
        return (
          l10n.analyticsEventThemeChangedLabel,
          l10n.analyticsEventThemeChangedDescription,
        );
      case AnalyticsEvent.languageChanged:
        return (
          l10n.analyticsEventLanguageChangedLabel,
          l10n.analyticsEventLanguageChangedDescription,
        );
      case AnalyticsEvent.feedDensityChanged:
        return (
          l10n.analyticsEventFeedDensityChangedLabel,
          l10n.analyticsEventFeedDensityChangedDescription,
        );
      case AnalyticsEvent.browserChoiceChanged:
        return (
          l10n.analyticsEventBrowserChoiceChangedLabel,
          l10n.analyticsEventBrowserChoiceChangedDescription,
        );
      case AnalyticsEvent.sourceFilterUsed:
        return (
          l10n.analyticsEventSourceFilterUsedLabel,
          l10n.analyticsEventSourceFilterUsedDescription,
        );
    }
  }
}
