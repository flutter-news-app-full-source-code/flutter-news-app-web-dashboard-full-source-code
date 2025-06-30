import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_dashboard/app/bloc/app_bloc.dart';
import 'package:ht_dashboard/l10n/app_localizations.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/settings/bloc/settings_bloc.dart';
import 'package:ht_dashboard/shared/constants/app_spacing.dart';
import 'package:ht_dashboard/shared/widgets/widgets.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

/// {@template settings_page}
/// A page for user settings, allowing customization of theme and language.
/// {@endtemplate}
class SettingsPage extends StatelessWidget {
  /// {@macro settings_page}
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        userAppSettingsRepository: context
            .read<HtDataRepository<UserAppSettings>>(),
      )..add(SettingsLoaded(userId: context.read<AppBloc>().state.user?.id)),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) =>
            current is SettingsUpdateSuccess ||
            current is SettingsUpdateFailure,
        listener: (context, state) {
          if (state is SettingsUpdateSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(l10n.settingsSavedSuccessfully),
                ),
              );
            // Optionally, trigger AppBloc to reload settings if it caches them
            context.read<AppBloc>().add(
              AppUserChanged(
                context.read<AppBloc>().state.user?.copyWith(
                  // This is a simplified way to trigger AppBloc update.
                  // A more robust solution might involve AppBloc listening
                  // to SettingsBloc directly or a dedicated event.
                  // For now, we'll rely on the AppBloc's authStateChanges
                  // listener to eventually pick up the change if the
                  // repository emits it, or a manual refresh.
                  // For immediate UI update, we might need to pass the
                  // updated settings to AppBloc.
                  // For this task, we'll assume AppBloc will react
                  // to the repository change or a full app restart.
                  // A better approach would be to have AppBloc listen
                  // to UserAppSettings changes from its repository.
                ),
              ),
            );
          } else if (state is SettingsUpdateFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.settingsSaveErrorMessage(state.errorMessage),
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoadInProgress) {
            return LoadingStateWidget(
              icon: Icons.settings,
              headline: l10n.loadingSettingsHeadline,
              subheadline: l10n.loadingSettingsSubheadline,
            );
          } else if (state is SettingsLoadFailure) {
            return FailureStateWidget(
              message: l10n.failedToLoadSettingsMessage(state.errorMessage),
              onRetry: () {
                context.read<SettingsBloc>().add(
                  SettingsLoaded(
                    userId: context.read<AppBloc>().state.user?.id,
                  ),
                );
              },
            );
          } else if (state is SettingsLoadSuccess) {
            final userAppSettings = state.userAppSettings;
            return _buildSettingsContent(context, userAppSettings, l10n);
          } else if (state is SettingsUpdateSuccess) {
            final userAppSettings = state.userAppSettings;
            return _buildSettingsContent(context, userAppSettings, l10n);
          } else if (state is SettingsUpdateInProgress) {
            final userAppSettings = state.userAppSettings;
            return _buildSettingsContent(context, userAppSettings, l10n);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSettingsContent(
    BuildContext context,
    UserAppSettings userAppSettings,
    AppLocalizations l10n,
  ) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Base Theme
        _buildSettingSection(
          context,
          title: l10n.baseThemeLabel,
          description: l10n.baseThemeDescription,
          child: DropdownButton<AppBaseTheme>(
            value: userAppSettings.displaySettings.baseTheme,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(
                  SettingsBaseThemeChanged(value),
                );
              }
            },
            items: AppBaseTheme.values
                .map(
                  (theme) => DropdownMenuItem(
                    value: theme,
                    child: Text(_getAppBaseThemeName(theme, l10n)),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Accent Theme
        _buildSettingSection(
          context,
          title: l10n.accentThemeLabel,
          description: l10n.accentThemeDescription,
          child: DropdownButton<AppAccentTheme>(
            value: userAppSettings.displaySettings.accentTheme,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(
                  SettingsAccentThemeChanged(value),
                );
              }
            },
            items: AppAccentTheme.values
                .map(
                  (theme) => DropdownMenuItem(
                    value: theme,
                    child: Text(_getAppAccentThemeName(theme, l10n)),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Font Family
        _buildSettingSection(
          context,
          title: l10n.fontFamilyLabel,
          description: l10n.fontFamilyDescription,
          child: DropdownButton<String>(
            value: userAppSettings.displaySettings.fontFamily,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(
                  SettingsFontFamilyChanged(value),
                );
              }
            },
            items: _supportedFontFamilies
                .map(
                  (font) => DropdownMenuItem(
                    value: font,
                    child: Text(_getFontFamilyName(font, l10n)),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Text Scale Factor
        _buildSettingSection(
          context,
          title: l10n.textScaleFactorLabel,
          description: l10n.textScaleFactorDescription,
          child: DropdownButton<AppTextScaleFactor>(
            value: userAppSettings.displaySettings.textScaleFactor,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(
                  SettingsTextScaleFactorChanged(value),
                );
              }
            },
            items: AppTextScaleFactor.values
                .map(
                  (scale) => DropdownMenuItem(
                    value: scale,
                    child: Text(_getAppTextScaleFactorName(scale, l10n)),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Font Weight
        _buildSettingSection(
          context,
          title: l10n.fontWeightLabel,
          description: l10n.fontWeightDescription,
          child: DropdownButton<AppFontWeight>(
            value: userAppSettings.displaySettings.fontWeight,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(
                  SettingsFontWeightChanged(value),
                );
              }
            },
            items: AppFontWeight.values
                .map(
                  (weight) => DropdownMenuItem(
                    value: weight,
                    child: Text(_getAppFontWeightName(weight, l10n)),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Language
        _buildSettingSection(
          context,
          title: l10n.languageLabel,
          description: l10n.languageDescription,
          child: DropdownButton<AppLanguage>(
            value: userAppSettings.language,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(
                  SettingsLanguageChanged(value),
                );
              }
            },
            items: _supportedLanguages
                .map(
                  (lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(_getLanguageName(lang, l10n)),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildSettingSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ],
    );
  }

  String _getAppBaseThemeName(AppBaseTheme theme, AppLocalizations l10n) {
    switch (theme) {
      case AppBaseTheme.light:
        return l10n.lightTheme;
      case AppBaseTheme.dark:
        return l10n.darkTheme;
      case AppBaseTheme.system:
        return l10n.systemTheme;
    }
  }

  String _getAppAccentThemeName(AppAccentTheme theme, AppLocalizations l10n) {
    switch (theme) {
      case AppAccentTheme.defaultBlue:
        return l10n.defaultBlueTheme;
      case AppAccentTheme.newsRed:
        return l10n.newsRedTheme;
      case AppAccentTheme.graphiteGray:
        return l10n.graphiteGrayTheme;
    }
  }

  String _getFontFamilyName(String fontFamily, AppLocalizations l10n) {
    switch (fontFamily) {
      case 'SystemDefault':
        return l10n.systemDefaultFont;
      case 'Roboto':
        return 'Roboto';
      case 'OpenSans':
        return 'Open Sans';
      case 'Lato':
        return 'Lato';
      case 'Montserrat':
        return 'Montserrat';
      case 'Merriweather':
        return 'Merriweather';
      default:
        return fontFamily;
    }
  }

  String _getAppTextScaleFactorName(
    AppTextScaleFactor scale,
    AppLocalizations l10n,
  ) {
    switch (scale) {
      case AppTextScaleFactor.small:
        return l10n.smallText;
      case AppTextScaleFactor.medium:
        return l10n.mediumText;
      case AppTextScaleFactor.large:
        return l10n.largeText;
      case AppTextScaleFactor.extraLarge:
        return l10n.extraLargeText;
    }
  }

  String _getAppFontWeightName(AppFontWeight weight, AppLocalizations l10n) {
    switch (weight) {
      case AppFontWeight.light:
        return l10n.lightFontWeight;
      case AppFontWeight.regular:
        return l10n.regularFontWeight;
      case AppFontWeight.bold:
        return l10n.boldFontWeight;
    }
  }

  String _getLanguageName(AppLanguage language, AppLocalizations l10n) {
    switch (language) {
      case 'en':
        return l10n.englishLanguage;
      case 'ar':
        return l10n.arabicLanguage;
      default:
        return language;
    }
  }

  static const List<String> _supportedFontFamilies = [
    'SystemDefault',
    'Roboto',
    'OpenSans',
    'Lato',
    'Montserrat',
    'Merriweather',
  ];

  static const List<AppLanguage> _supportedLanguages = [
    'en',
    'ar',
  ];
}
