import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/general_app_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/update_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template app_configuration_tab}
/// A widget representing the "App" tab in the App Configuration page.
///
/// This tab allows configuration of application-level settings like
/// maintenance mode, force updates, and general app settings.
/// {@endtemplate}
class AppConfigurationTab extends StatefulWidget {
  /// {@macro app_configuration_tab}
  const AppConfigurationTab({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<AppConfigurationTab> createState() => _AppConfigurationTabState();
}

class _AppConfigurationTabState extends State<AppConfigurationTab> {
  /// Notifier for the index of the currently expanded top-level ExpansionTile.
  ///
  /// A value of `null` means no tile is expanded.
  final ValueNotifier<int?> _expandedTileIndex = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _expandedTileIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final appConfig = widget.remoteConfig.app;
    final maintenanceConfig = appConfig.maintenance;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Maintenance Config as a direct SwitchListTile
        SwitchListTile(
          title: Text(l10n.isUnderMaintenanceLabel),
          subtitle: Text(l10n.isUnderMaintenanceDescription),
          value: maintenanceConfig.isUnderMaintenance,
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                app: appConfig.copyWith(
                  maintenance: maintenanceConfig.copyWith(
                    isUnderMaintenance: value,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Update Config
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 1;
            return ExpansionTile(
              key: ValueKey('updateConfigTile_$expandedIndex'),
              title: Text(l10n.appUpdateManagementTitle),
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              children: [
                UpdateConfigForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // General App Config
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 2;
            return ExpansionTile(
              key: ValueKey('generalAppConfigTile_$expandedIndex'),
              title: Text(l10n.appLegalInformationTitle),
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              children: [
                GeneralAppConfigForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
