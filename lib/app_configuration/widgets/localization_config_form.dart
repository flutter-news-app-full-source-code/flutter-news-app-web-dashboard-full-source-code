import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/supported_language_flag.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/supported_language_l10n.dart';
import 'package:core_ui/core_ui.dart';

/// {@template localization_config_form}
/// A form widget for configuring application localization settings.
///
/// Allows selecting enabled languages and the default fallback language.
/// {@endtemplate}
class LocalizationConfigForm extends StatelessWidget {
  /// {@macro localization_config_form}
  const LocalizationConfigForm({
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
    final localizationConfig = remoteConfig.app.localization;
    const supportedLanguages = SupportedLanguage.values;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.localizationConfigDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.enabledLanguagesLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: supportedLanguages.map((language) {
              final isSelected = localizationConfig.enabledLanguages.contains(
                language,
              );
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      language.flagUrl,
                      width: 24,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.flag, size: 16),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(language.l10n(context)),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  final currentList = List<SupportedLanguage>.from(
                    localizationConfig.enabledLanguages,
                  );

                  if (selected) {
                    currentList.add(language);
                  } else {
                    // Validation: Cannot disable the default language
                    if (language == localizationConfig.defaultLanguage) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.cannotDisableDefaultLanguage),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                      return;
                    }
                    // Validation: Must have at least one language
                    if (currentList.length <= 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.atLeastOneLanguageRequired),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                      return;
                    }
                    currentList.remove(language);
                  }

                  onConfigChanged(
                    remoteConfig.copyWith(
                      app: remoteConfig.app.copyWith(
                        localization: localizationConfig.copyWith(
                          supportedLanguages: currentList,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<SupportedLanguage>(
            value: localizationConfig.defaultLanguage,
            decoration: InputDecoration(
              labelText: l10n.defaultLanguageLabel,
              border: const OutlineInputBorder(),
              helperText: l10n.defaultLanguageDescription,
            ),
            items: localizationConfig.enabledLanguages.map((language) {
              return DropdownMenuItem(
                value: language,
                child: Row(
                  children: [
                    Image.network(
                      language.flagUrl,
                      width: 24,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.flag, size: 16),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(language.l10n(context)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onConfigChanged(
                  remoteConfig.copyWith(
                    app: remoteConfig.app.copyWith(
                      localization: localizationConfig.copyWith(
                        defaultLanguage: value,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
