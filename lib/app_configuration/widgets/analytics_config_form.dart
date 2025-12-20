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
                      title: Text(event.name),
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
}
