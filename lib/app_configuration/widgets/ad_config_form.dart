import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template ad_config_form}
/// A form widget for configuring global ad settings.
///
/// This widget primarily controls the global enable/disable switch for ads.
/// {@endtemplate}
class AdConfigForm extends StatefulWidget {
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
  State<AdConfigForm> createState() => _AdConfigFormState();
}

class _AdConfigFormState extends State<AdConfigForm> {
  @override
  Widget build(BuildContext context) {
    final adConfig = widget.remoteConfig.adConfig;
    final l10n = AppLocalizationsX(context).l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableGlobalAdsLabel),
          value: adConfig.enabled,
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: adConfig.copyWith(enabled: value),
              ),
            );
          },
        ),
      ],
    );
  }
}
