import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template app_urls_form}
/// A form widget for configuring application URLs.
///
/// This form manages settings like Terms of Service and Privacy Policy URLs.
/// {@endtemplate}
class AppUrlsForm extends StatefulWidget {
  /// {@macro app_urls_form}
  const AppUrlsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<AppUrlsForm> createState() => _AppUrlsFormState();
}

class _AppUrlsFormState extends State<AppUrlsForm> {
  late final TextEditingController _termsUrlController;
  late final TextEditingController _privacyUrlController;

  @override
  void initState() {
    super.initState();
    final generalConfig = widget.remoteConfig.app.general;
    _termsUrlController = _createController(generalConfig.termsOfServiceUrl);
    _privacyUrlController = _createController(generalConfig.privacyPolicyUrl);
  }

  TextEditingController _createController(String text) {
    return TextEditingController(text: text)
      ..selection = TextSelection.collapsed(offset: text.length);
  }

  void _updateControllerText(TextEditingController controller, String text) {
    if (controller.text != text) {
      controller
        ..text = text
        ..selection = TextSelection.collapsed(offset: text.length);
    }
  }

  @override
  void didUpdateWidget(covariant AppUrlsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.app.general != oldWidget.remoteConfig.app.general) {
      final generalConfig = widget.remoteConfig.app.general;
      _updateControllerText(
        _termsUrlController,
        generalConfig.termsOfServiceUrl,
      );
      _updateControllerText(
        _privacyUrlController,
        generalConfig.privacyPolicyUrl,
      );
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }
}
