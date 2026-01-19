import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template push_notification_settings_form}
/// A form widget for configuring push notification settings.
/// {@endtemplate}
class PushNotificationSettingsForm extends StatelessWidget {
  /// {@macro push_notification_settings_form}
  const PushNotificationSettingsForm({
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
    final pushConfig = features.pushNotifications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.pushNotificationSystemStatusTitle),
          subtitle: Text(l10n.pushNotificationSystemStatusDescription),
          value: pushConfig.enabled,
          onChanged: (value) {
            final newDeliveryConfigs = value
                ? {
                    for (final type
                        in PushNotificationSubscriptionDeliveryType.values)
                      type: true,
                  }
                : pushConfig.deliveryConfigs;
            onConfigChanged(
              remoteConfig.copyWith(
                features: features.copyWith(
                  pushNotifications: pushConfig.copyWith(
                    enabled: value,
                    deliveryConfigs: newDeliveryConfigs,
                  ),
                ),
              ),
            );
          },
        ),
        if (pushConfig.enabled) ...[
          const SizedBox(height: AppSpacing.lg),
          _buildPrimaryProviderSection(context, l10n, pushConfig),
          const SizedBox(height: AppSpacing.lg),
          _buildDeliveryTypesSection(context, l10n, pushConfig),
        ],
      ],
    );
  }

  Widget _buildPrimaryProviderSection(
    BuildContext context,
    AppLocalizations l10n,
    PushNotificationConfig pushConfig,
  ) {
    return ExpansionTile(
      title: Text(l10n.pushNotificationPrimaryProviderTitle),
      subtitle: Text(
        l10n.pushNotificationPrimaryProviderDescription,
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
          child: SegmentedButton<PushNotificationProviders>(
            segments: PushNotificationProviders.values
                .map(
                  (provider) => ButtonSegment<PushNotificationProviders>(
                    value: provider,
                    label: Text(provider.l10n(context)),
                  ),
                )
                .toList(),
            selected: {pushConfig.primaryProvider},
            onSelectionChanged: (newSelection) {
              onConfigChanged(
                remoteConfig.copyWith(
                  features: remoteConfig.features.copyWith(
                    pushNotifications: pushConfig.copyWith(
                      primaryProvider: newSelection.first,
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

  String _getDeliveryTypeDescription(
    BuildContext context,
    PushNotificationSubscriptionDeliveryType type,
  ) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (type) {
      case PushNotificationSubscriptionDeliveryType.breakingOnly:
        return l10n.pushNotificationDeliveryTypeBreakingOnlyDescription;
      case PushNotificationSubscriptionDeliveryType.dailyDigest:
        return l10n.pushNotificationDeliveryTypeDailyDigestDescription;
    }
  }

  Widget _buildDeliveryTypesSection(
    BuildContext context,
    AppLocalizations l10n,
    PushNotificationConfig pushConfig,
  ) {
    return ExpansionTile(
      title: Text(l10n.pushNotificationDeliveryTypesTitle),
      subtitle: Text(
        l10n.pushNotificationDeliveryTypesDescription,
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
        Column(
          children: PushNotificationSubscriptionDeliveryType.values
              .map(
                (type) => SwitchListTile(
                  title: Text(type.l10n(context)),
                  subtitle: Text(_getDeliveryTypeDescription(context, type)),
                  value: pushConfig.deliveryConfigs[type] ?? false,
                  onChanged: (value) {
                    final newDeliveryConfigs =
                        Map<
                          PushNotificationSubscriptionDeliveryType,
                          bool
                        >.from(
                          pushConfig.deliveryConfigs,
                        );
                    newDeliveryConfigs[type] = value;

                    var newEnabled = pushConfig.enabled;
                    if (!newDeliveryConfigs.values.contains(true)) {
                      newEnabled = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.pushNotificationFeatureDisabledNotification,
                          ),
                        ),
                      );
                    }

                    onConfigChanged(
                      remoteConfig.copyWith(
                        features: remoteConfig.features.copyWith(
                          pushNotifications: pushConfig.copyWith(
                            enabled: newEnabled,
                            deliveryConfigs: newDeliveryConfigs,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
