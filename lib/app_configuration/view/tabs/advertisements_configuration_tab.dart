import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/ad_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template advertisements_configuration_tab}
/// A widget representing the "Advertisements" tab in the App Configuration page.
///
/// This tab allows configuration of various ad settings.
/// {@endtemplate}
class AdvertisementsConfigurationTab extends StatelessWidget {
  /// {@macro advertisements_configuration_tab}
  const AdvertisementsConfigurationTab({
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
        // Top-level ExpansionTile for Ad Settings
        ExpansionTile(
          title: Text(l10n.adSettingsTitle),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
          ),
          children: [
            AdConfigForm(
              remoteConfig: remoteConfig,
              onConfigChanged: onConfigChanged,
            ),
          ],
        ),
      ],
    );
  }
}
