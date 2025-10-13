import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/user_preset_limits_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template user_presets_configuration_tab}
/// A widget representing the "User Presets" tab in the App Configuration page.
///
/// This tab allows configuration of user preset limits, such as saved filters.
/// {@endtemplate}
class UserPresetsConfigurationTab extends StatelessWidget {
  /// {@macro user_presets_configuration_tab}
  const UserPresetsConfigurationTab({
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
        ExpansionTile(
          title: Text(l10n.userPresetsTab),
          initiallyExpanded: true,
          childrenPadding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            UserPresetLimitsForm(
              remoteConfig: remoteConfig,
              onConfigChanged: onConfigChanged,
            ),
          ],
        ),
      ],
    );
  }
}
