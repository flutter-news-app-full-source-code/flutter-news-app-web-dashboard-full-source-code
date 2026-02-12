import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template onboarding_config_form}
/// A form widget for configuring the onboarding experience, including the
/// App Tour and Initial Personalization flows.
/// {@endtemplate}
class OnboardingConfigForm extends StatelessWidget {
  /// {@macro onboarding_config_form}
  const OnboardingConfigForm({
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
    final onboardingConfig = remoteConfig.features.onboarding;
    final appTourConfig = onboardingConfig.appTour;
    final personalizationConfig = onboardingConfig.initialPersonalization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Tour Configuration
        ExpansionTile(
          title: Text(l10n.appTourTitle),
          subtitle: Text(
            l10n.appTourDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(l10n.enableAppTourLabel),
              subtitle: Text(l10n.enableAppTourDescription),
              value: appTourConfig.isEnabled,
              onChanged: (value) {
                onConfigChanged(
                  remoteConfig.copyWith(
                    features: remoteConfig.features.copyWith(
                      onboarding: onboardingConfig.copyWith(
                        appTour: appTourConfig.copyWith(isEnabled: value),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (appTourConfig.isEnabled)
              SwitchListTile(
                title: Text(l10n.skippableAppTourLabel),
                subtitle: Text(l10n.skippableAppTourDescription),
                value: appTourConfig.isSkippable,
                onChanged: (value) {
                  onConfigChanged(
                    remoteConfig.copyWith(
                      features: remoteConfig.features.copyWith(
                        onboarding: onboardingConfig.copyWith(
                          appTour: appTourConfig.copyWith(isSkippable: value),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Initial Personalization Configuration
        ExpansionTile(
          title: Text(l10n.initialPersonalizationTitle),
          subtitle: Text(
            l10n.initialPersonalizationDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(l10n.enableInitialPersonalizationLabel),
              subtitle: Text(l10n.enableInitialPersonalizationDescription),
              value: personalizationConfig.isEnabled,
              onChanged: (value) {
                onConfigChanged(
                  remoteConfig.copyWith(
                    features: remoteConfig.features.copyWith(
                      onboarding: onboardingConfig.copyWith(
                        initialPersonalization: personalizationConfig.copyWith(
                          isEnabled: value,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (personalizationConfig.isEnabled) ...[
              SwitchListTile(
                title: Text(l10n.skippableInitialPersonalizationLabel),
                subtitle: Text(l10n.skippableInitialPersonalizationDescription),
                value: personalizationConfig.isSkippable,
                onChanged: (value) {
                  onConfigChanged(
                    remoteConfig.copyWith(
                      features: remoteConfig.features.copyWith(
                        onboarding: onboardingConfig.copyWith(
                          initialPersonalization: personalizationConfig
                              .copyWith(isSkippable: value),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                initialValue: personalizationConfig.minSelectionsRequired
                    .toString(),
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
                        features: remoteConfig.features.copyWith(
                          onboarding: onboardingConfig.copyWith(
                            initialPersonalization: personalizationConfig
                                .copyWith(
                                  minSelectionsRequired: intValue,
                                ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ],
    );
  }
}
