import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template update_config_form}
/// A form widget for configuring application update settings.
/// {@endtemplate}
class UpdateConfigForm extends StatefulWidget {
  /// {@macro update_config_form}
  const UpdateConfigForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<UpdateConfigForm> createState() => _UpdateConfigFormState();
}

class _UpdateConfigFormState extends State<UpdateConfigForm> {
  late final TextEditingController _latestVersionController;
  late final TextEditingController _iosUrlController;
  late final TextEditingController _androidUrlController;

  @override
  void initState() {
    super.initState();
    final updateConfig = widget.remoteConfig.app.update;
    _latestVersionController = TextEditingController(
      text: updateConfig.latestAppVersion,
    );
    _iosUrlController = TextEditingController(text: updateConfig.iosUpdateUrl);
    _androidUrlController = TextEditingController(
      text: updateConfig.androidUpdateUrl,
    );
  }

  @override
  void didUpdateWidget(covariant UpdateConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.app.update != oldWidget.remoteConfig.app.update) {
      final updateConfig = widget.remoteConfig.app.update;
      _latestVersionController.text = updateConfig.latestAppVersion;
      _iosUrlController.text = updateConfig.iosUpdateUrl;
      _androidUrlController.text = updateConfig.androidUpdateUrl;
    }
  }

  @override
  void dispose() {
    _latestVersionController.dispose();
    _iosUrlController.dispose();
    _androidUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final appConfig = widget.remoteConfig.app;
    final updateConfig = appConfig.update;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.updateConfigDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppConfigTextField(
            label: l10n.latestAppVersionLabel,
            description: l10n.latestAppVersionDescription,
            value: updateConfig.latestAppVersion,
            onChanged: (value) {
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  app: appConfig.copyWith(
                    update: updateConfig.copyWith(latestAppVersion: value),
                  ),
                ),
              );
            },
            controller: _latestVersionController,
          ),
          SwitchListTile(
            title: Text(l10n.isLatestVersionOnlyLabel),
            subtitle: Text(l10n.isLatestVersionOnlyDescription),
            value: updateConfig.isLatestVersionOnly,
            onChanged: (value) {
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  app: appConfig.copyWith(
                    update: updateConfig.copyWith(isLatestVersionOnly: value),
                  ),
                ),
              );
            },
          ),
          AppConfigTextField(
            label: l10n.iosUpdateUrlLabel,
            description: l10n.iosUpdateUrlDescription,
            value: updateConfig.iosUpdateUrl,
            onChanged: (value) {
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  app: appConfig.copyWith(
                    update: updateConfig.copyWith(iosUpdateUrl: value),
                  ),
                ),
              );
            },
            controller: _iosUrlController,
          ),
          AppConfigTextField(
            label: l10n.androidUpdateUrlLabel,
            description: l10n.androidUpdateUrlDescription,
            value: updateConfig.androidUpdateUrl,
            onChanged: (value) {
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  app: appConfig.copyWith(
                    update: updateConfig.copyWith(androidUpdateUrl: value),
                  ),
                ),
              );
            },
            controller: _androidUrlController,
          ),
        ],
      ),
    );
  }
}
