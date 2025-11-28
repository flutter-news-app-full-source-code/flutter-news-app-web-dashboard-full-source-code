import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template ad_config_form}
/// A form widget for configuring global ad settings.
///
/// This widget primarily controls the global enable/disable switch for ads.
/// {@endtemplate}
class AdConfigForm extends StatelessWidget {
  /// {@macro ad_config_form}
  const AdConfigForm({
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
    final features = remoteConfig.features;
    final ads = features.ads;
    final l10n = AppLocalizationsX(context).l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text(l10n.enableGlobalAdsLabel),
            value: ads.enabled,
            onChanged: (value) {
              onConfigChanged(
                remoteConfig.copyWith(
                  features: features.copyWith(
                    ads: ads.copyWith(enabled: value),
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
