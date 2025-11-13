import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/push_notification_provider_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/push_notification_subscription_delivery_type_l10n.dart';
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
    final pushConfig = remoteConfig.pushNotificationConfig;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(l10n.pushNotificationSettingsTitle),
            childrenPadding: const EdgeInsetsDirectional.only(
              start: AppSpacing.lg,
              top: AppSpacing.md,
              bottom: AppSpacing.md,
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.pushNotificationSettingsDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildSystemStatusSection(context, l10n, pushConfig),
              const SizedBox(height: AppSpacing.lg),
              _buildPrimaryProviderSection(context, l10n, pushConfig),
              const SizedBox(height: AppSpacing.lg),
              _buildDeliveryTypesSection(context, l10n, pushConfig),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatusSection(
    BuildContext context,
    AppLocalizations l10n,
    PushNotificationConfig pushConfig,
  ) {
    return ExpansionTile(
      title: Text(l10n.pushNotificationSystemStatusTitle),
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      children: [
        SwitchListTile(
          title: Text(l10n.enabledLabel),
          subtitle: Text(l10n.pushNotificationSystemStatusDescription),
          value: pushConfig.enabled,
          onChanged: (value) {
            onConfigChanged(
              remoteConfig.copyWith(
                pushNotificationConfig: pushConfig.copyWith(enabled: value),
              ),
            );
          },
        ),
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
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.pushNotificationPrimaryProviderDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SegmentedButton<PushNotificationProvider>(
          segments: PushNotificationProvider.values
              .map(
                (provider) => ButtonSegment<PushNotificationProvider>(
                  value: provider,
                  label: Text(provider.l10n(context)),
                ),
              )
              .toList(),
          selected: {pushConfig.primaryProvider},
          onSelectionChanged: (newSelection) {
            onConfigChanged(
              remoteConfig.copyWith(
                pushNotificationConfig: pushConfig.copyWith(
                  primaryProvider: newSelection.first,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeliveryTypesSection(
    BuildContext context,
    AppLocalizations l10n,
    PushNotificationConfig pushConfig,
  ) {
    return ExpansionTile(
      title: Text(l10n.pushNotificationDeliveryTypesTitle),
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.pushNotificationDeliveryTypesDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Column(
          children: PushNotificationSubscriptionDeliveryType.values
              .map(
                (type) => SwitchListTile(
                  title: Text(type.l10n(context)),
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
                    onConfigChanged(
                      remoteConfig.copyWith(
                        pushNotificationConfig: pushConfig.copyWith(
                          deliveryConfigs: newDeliveryConfigs,
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
