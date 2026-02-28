import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/engagement_mode_l10n.dart';

/// {@template engagement_settings_form}
/// A form widget for configuring user engagement settings.
/// {@endtemplate}
class EngagementSettingsForm extends StatelessWidget {
  /// {@macro engagement_settings_form}
  const EngagementSettingsForm({
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
    final communityConfig = remoteConfig.features.community;
    final engagementConfig = communityConfig.engagement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableEngagementFeaturesLabel),
          subtitle: Text(l10n.enableEngagementFeaturesDescription),
          value: engagementConfig.enabled,
          onChanged: (value) {
            final newConfig = communityConfig.copyWith(
              engagement: engagementConfig.copyWith(enabled: value),
            );
            onConfigChanged(
              remoteConfig.copyWith(
                features: remoteConfig.features.copyWith(community: newConfig),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        if (engagementConfig.enabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.engagementModeDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                SegmentedButton<EngagementMode>(
                  segments: EngagementMode.values
                      .map(
                        (mode) => ButtonSegment<EngagementMode>(
                          value: mode,
                          label: Text(mode.l10n(context)),
                        ),
                      )
                      .toList(),
                  selected: {engagementConfig.engagementMode},
                  onSelectionChanged: (newSelection) {
                    final newConfig = communityConfig.copyWith(
                      engagement: engagementConfig.copyWith(
                        engagementMode: newSelection.first,
                      ),
                    );
                    onConfigChanged(
                      remoteConfig.copyWith(
                        features: remoteConfig.features.copyWith(
                          community: newConfig,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
