import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template initial_personalization_form}
/// A form widget for configuring the initial personalization flow.
/// {@endtemplate}
class InitialPersonalizationForm extends StatelessWidget {
  /// {@macro initial_personalization_form}
  const InitialPersonalizationForm({
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
    final config = remoteConfig.app.initialPersonalization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableInitialPersonalizationLabel),
          subtitle: Text(l10n.enableInitialPersonalizationDescription),
          value: config.isEnabled,
          onChanged: (value) {
            onConfigChanged(
              remoteConfig.copyWith(
                app: remoteConfig.app.copyWith(
                  initialPersonalization: config.copyWith(isEnabled: value),
                ),
              ),
            );
          },
        ),
        if (config.isEnabled) ...[
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: AppSpacing.lg),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.enableCountrySelectionLabel),
                  subtitle: Text(l10n.enableCountrySelectionDescription),
                  value: config.isCountrySelectionEnabled,
                  onChanged: (value) {
                    onConfigChanged(
                      remoteConfig.copyWith(
                        app: remoteConfig.app.copyWith(
                          initialPersonalization: config.copyWith(
                            isCountrySelectionEnabled: value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.enableTopicSelectionLabel),
                  subtitle: Text(l10n.enableTopicSelectionDescription),
                  value: config.isTopicSelectionEnabled,
                  onChanged: (value) {
                    onConfigChanged(
                      remoteConfig.copyWith(
                        app: remoteConfig.app.copyWith(
                          initialPersonalization: config.copyWith(
                            isTopicSelectionEnabled: value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.enableSourceSelectionLabel),
                  subtitle: Text(l10n.enableSourceSelectionDescription),
                  value: config.isSourceSelectionEnabled,
                  onChanged: (value) {
                    onConfigChanged(
                      remoteConfig.copyWith(
                        app: remoteConfig.app.copyWith(
                          initialPersonalization: config.copyWith(
                            isSourceSelectionEnabled: value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  initialValue: config.minSelectionsRequired.toString(),
                  decoration: InputDecoration(
                    labelText: l10n.minSelectionsRequiredLabel,
                    helperText: l10n.minSelectionsRequiredDescription,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    final intValue = int.tryParse(value);
                    if (intValue != null) {
                      onConfigChanged(
                        remoteConfig.copyWith(
                          app: remoteConfig.app.copyWith(
                            initialPersonalization: config.copyWith(
                              minSelectionsRequired: intValue,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Value cannot be empty';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
