import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/bloc/app_configuration_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template general_configuration_tab}
/// A widget representing the "General" tab in the App Configuration page.
///
/// This tab allows configuration of maintenance mode and force update settings.
/// {@endtemplate}
class GeneralConfigurationTab extends StatelessWidget {
  /// {@macro general_configuration_tab}
  const GeneralConfigurationTab({
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
        // Top-level ExpansionTile for Maintenance Section
        ExpansionTile(
          title: Text(l10n.maintenanceModeTitle),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.maintenanceModeDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SwitchListTile(
                  title: Text(l10n.isUnderMaintenanceLabel),
                  subtitle: Text(l10n.isUnderMaintenanceDescription),
                  value: remoteConfig.appStatus.isUnderMaintenance,
                  onChanged: (value) {
                    onConfigChanged(
                      remoteConfig.copyWith(
                        appStatus: remoteConfig.appStatus.copyWith(
                          isUnderMaintenance: value,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Top-level ExpansionTile for Force Update Section
        ExpansionTile(
          title: Text(l10n.forceUpdateTitle),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.forceUpdateDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppConfigTextField(
                  label: l10n.latestAppVersionLabel,
                  description: l10n.latestAppVersionDescription,
                  value: remoteConfig.appStatus.latestAppVersion,
                  onChanged: (value) {
                    onConfigChanged(
                      remoteConfig.copyWith(
                        appStatus: remoteConfig.appStatus.copyWith(
                          latestAppVersion: value,
                        ),
                      ),
                    );
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.isLatestVersionOnlyLabel),
                  subtitle: Text(l10n.isLatestVersionOnlyDescription),
                  value: remoteConfig.appStatus.isLatestVersionOnly,
                  onChanged: (value) {
                    onConfigChanged(
                      remoteConfig.copyWith(
                        appStatus: remoteConfig.appStatus.copyWith(
                          isLatestVersionOnly: value,
                        ),
                      ),
                    );
                  },
                ),
                AppConfigTextField(
                  label: l10n.iosUpdateUrlLabel,
                  description: l10n.iosUpdateUrlDescription,
                  value: remoteConfig.appStatus.iosUpdateUrl,
                  onChanged: (value) {
                    onConfigChanged(
                      remoteConfig.copyWith(
                        appStatus: remoteConfig.appStatus.copyWith(
                          iosUpdateUrl: value,
                        ),
                      ),
                    );
                  },
                ),
                AppConfigTextField(
                  label: l10n.androidUpdateUrlLabel,
                  description: l10n.androidUpdateUrlDescription,
                  value: remoteConfig.appStatus.androidUpdateUrl,
                  onChanged: (value) {
                    onConfigChanged(
                      remoteConfig.copyWith(
                        appStatus: remoteConfig.appStatus.copyWith(
                          androidUpdateUrl: value,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
