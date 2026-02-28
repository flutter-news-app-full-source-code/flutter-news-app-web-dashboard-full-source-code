import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template maintenance_config_form}
/// A form widget for configuring application maintenance settings.
/// {@endtemplate}
class MaintenanceConfigForm extends StatelessWidget {
  /// {@macro maintenance_config_form}
  const MaintenanceConfigForm({
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
    final appConfig = remoteConfig.app;
    final maintenanceConfig = appConfig.maintenance;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.maintenanceConfigDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SwitchListTile(
            title: Text(l10n.isUnderMaintenanceLabel),
            subtitle: Text(l10n.isUnderMaintenanceDescription),
            value: maintenanceConfig.isUnderMaintenance,
            onChanged: (value) {
              onConfigChanged(
                remoteConfig.copyWith(
                  app: appConfig.copyWith(
                    maintenance: maintenanceConfig.copyWith(
                      isUnderMaintenance: value,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
