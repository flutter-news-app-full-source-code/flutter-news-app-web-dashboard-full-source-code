import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template general_app_config_form}
/// A form widget for configuring general application settings.
///
/// This form manages settings like Terms of Service and Privacy Policy URLs.
/// {@endtemplate}
class GeneralAppConfigForm extends StatefulWidget {
  /// {@macro general_app_config_form}
  const GeneralAppConfigForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<GeneralAppConfigForm> createState() => _GeneralAppConfigFormState();
}

class _GeneralAppConfigFormState extends State<GeneralAppConfigForm> {
  late final TextEditingController _termsUrlController;
  late final TextEditingController _privacyUrlController;

  @override
  void initState() {
    super.initState();
    _termsUrlController = TextEditingController(
      text: widget.remoteConfig.app.general.termsOfServiceUrl,
    );
    _privacyUrlController = TextEditingController(
      text: widget.remoteConfig.app.general.privacyPolicyUrl,
    );
  }

  @override
  void didUpdateWidget(covariant GeneralAppConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.app.general != oldWidget.remoteConfig.app.general) {
      _termsUrlController.text =
          widget.remoteConfig.app.general.termsOfServiceUrl;
      _privacyUrlController.text =
          widget.remoteConfig.app.general.privacyPolicyUrl;
    }
  }

  @override
  void dispose() {
    _termsUrlController.dispose();
    _privacyUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final appConfig = widget.remoteConfig.app;
    final generalConfig = appConfig.general;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.generalAppConfigDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppConfigTextField(
            label: l10n.termsOfServiceUrlLabel,
            description: l10n.termsOfServiceUrlDescription,
            value: generalConfig.termsOfServiceUrl,
            onChanged: (value) {
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  app: appConfig.copyWith(
                    general: generalConfig.copyWith(
                      termsOfServiceUrl: value,
                    ),
                  ),
                ),
              );
            },
            controller: _termsUrlController,
          ),
          AppConfigTextField(
            label: l10n.privacyPolicyUrlLabel,
            description: l10n.privacyPolicyUrlDescription,
            value: generalConfig.privacyPolicyUrl,
            onChanged: (value) {
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  app: appConfig.copyWith(
                    general: generalConfig.copyWith(
                      privacyPolicyUrl: value,
                    ),
                  ),
                ),
              );
            },
            controller: _privacyUrlController,
          ),
        ],
      ),
    );
  }
}
