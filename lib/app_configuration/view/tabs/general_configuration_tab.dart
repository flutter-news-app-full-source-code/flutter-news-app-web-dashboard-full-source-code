import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template general_configuration_tab}
/// A widget representing the "General" tab in the App Configuration page.
///
/// This tab allows configuration of maintenance mode and force update settings.
/// {@endtemplate}
class GeneralConfigurationTab extends StatefulWidget {
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
  State<GeneralConfigurationTab> createState() =>
      _GeneralConfigurationTabState();
}

class _GeneralConfigurationTabState extends State<GeneralConfigurationTab> {
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

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Top-level ExpansionTile for Maintenance Section
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 0;
            return ExpansionTile(
              key: ValueKey('maintenanceModeTile_$expandedIndex'),
              title: Text(l10n.maintenanceModeTitle),
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.maintenanceModeDescription,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SwitchListTile(
                      title: Text(l10n.isUnderMaintenanceLabel),
                      subtitle: Text(l10n.isUnderMaintenanceDescription),
                      value: widget.remoteConfig.appStatus.isUnderMaintenance,
                      onChanged: (value) {
                        widget.onConfigChanged(
                          widget.remoteConfig.copyWith(
                            appStatus: widget.remoteConfig.appStatus.copyWith(
                              isUnderMaintenance: value,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        // Top-level ExpansionTile for Force Update Section
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 1;
            return ExpansionTile(
              key: ValueKey('forceUpdateTile_$expandedIndex'),
              title: Text(l10n.forceUpdateTitle),
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.forceUpdateDescription,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppConfigTextField(
                      label: l10n.latestAppVersionLabel,
                      description: l10n.latestAppVersionDescription,
                      value: widget.remoteConfig.appStatus.latestAppVersion,
                      onChanged: (value) {
                        widget.onConfigChanged(
                          widget.remoteConfig.copyWith(
                            appStatus: widget.remoteConfig.appStatus.copyWith(
                              latestAppVersion: value,
                            ),
                          ),
                        );
                      },
                    ),
                    SwitchListTile(
                      title: Text(l10n.isLatestVersionOnlyLabel),
                      subtitle: Text(l10n.isLatestVersionOnlyDescription),
                      value: widget.remoteConfig.appStatus.isLatestVersionOnly,
                      onChanged: (value) {
                        widget.onConfigChanged(
                          widget.remoteConfig.copyWith(
                            appStatus: widget.remoteConfig.appStatus.copyWith(
                              isLatestVersionOnly: value,
                            ),
                          ),
                        );
                      },
                    ),
                    AppConfigTextField(
                      label: l10n.iosUpdateUrlLabel,
                      description: l10n.iosUpdateUrlDescription,
                      value: widget.remoteConfig.appStatus.iosUpdateUrl,
                      onChanged: (value) {
                        widget.onConfigChanged(
                          widget.remoteConfig.copyWith(
                            appStatus: widget.remoteConfig.appStatus.copyWith(
                              iosUpdateUrl: value,
                            ),
                          ),
                        );
                      },
                    ),
                    AppConfigTextField(
                      label: l10n.androidUpdateUrlLabel,
                      description: l10n.androidUpdateUrlDescription,
                      value: widget.remoteConfig.appStatus.androidUpdateUrl,
                      onChanged: (value) {
                        widget.onConfigChanged(
                          widget.remoteConfig.copyWith(
                            appStatus: widget.remoteConfig.appStatus.copyWith(
                              androidUpdateUrl: value,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
