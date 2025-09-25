import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/settings/bloc/settings_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/about_icon.dart';
import 'package:ui_kit/ui_kit.dart';

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
            .read<DataRepository<UserAppSettings>>(),
      )..add(SettingsLoaded(userId: context.read<AppBloc>().state.user?.id)),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  late List<ExpansionTileController> _mainTileControllers;

  @override
  void initState() {
    super.initState();
    _mainTileControllers = List.generate(
      2,
      (index) => ExpansionTileController(),
    );
  }

  @override
  void dispose() {
    for (final controller in _mainTileControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        actions: [
          AboutIcon(
            dialogTitle: l10n.settings,
            dialogDescription: l10n.settingsPageDescription,
          ),
        ],
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
                SnackBar(content: Text(l10n.settingsSavedSuccessfully)),
              );
            // Trigger AppBloc to reload settings for immediate UI update
            if (state.userAppSettings != null) {
              context.read<AppBloc>().add(
                AppUserAppSettingsChanged(state.userAppSettings!),
              );
            }
          } else if (state is SettingsUpdateFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.exception.toFriendlyMessage(context)),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.userAppSettings == null &&
              state is! SettingsLoadInProgress) {
            // If settings are null and not loading, try to load them
            context.read<SettingsBloc>().add(
              SettingsLoaded(userId: context.read<AppBloc>().state.user?.id),
            );
          }

          if (state is SettingsLoadInProgress) {
            return LoadingStateWidget(
              icon: Icons.settings,
              headline: l10n.loadingSettingsHeadline,
              subheadline: l10n.loadingSettingsSubheadline,
            );
          } else if (state is SettingsLoadFailure) {
            return FailureStateWidget(
              exception: state.exception,
              onRetry: () {
                context.read<SettingsBloc>().add(
                  SettingsLoaded(
                    userId: context.read<AppBloc>().state.user?.id,
                  ),
                );
              },
            );
          } else if (state.userAppSettings != null) {
            final userAppSettings = state.userAppSettings!;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                ExpansionTile(
                  controller: _mainTileControllers[0],
                  title: Text(l10n.appearanceSettingsLabel),
                  onExpansionChanged: (isExpanded) {
                    if (isExpanded) {
                      for (var i = 0; i < _mainTileControllers.length; i++) {
                        if (i != 0) {
                          _mainTileControllers[i].collapse();
                        }
                      }
                    }
                  },
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                  ),
                  children: [
                    ExpansionTile(
                      title: Text(l10n.themeSettingsLabel),
                      childrenPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                      ),
                      children: [
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
                                    child: Text(
                                      _getAppBaseThemeName(theme, l10n),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
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
                                    child: Text(
                                      _getAppAccentThemeName(theme, l10n),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(l10n.fontSettingsLabel),
                      childrenPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                      ),
                      children: [
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
                        _buildSettingSection(
                          context,
                          title: l10n.textScaleFactorLabel,
                          description: l10n.textScaleFactorDescription,
                          child: DropdownButton<AppTextScaleFactor>(
                            value:
                                userAppSettings.displaySettings.textScaleFactor,
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
                                    child: Text(
                                      _getAppTextScaleFactorName(scale, l10n),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
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
                                    child: Text(
                                      _getAppFontWeightName(weight, l10n),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ExpansionTile(
                  controller: _mainTileControllers[1],
                  title: Text(l10n.languageSettingsLabel),
                  onExpansionChanged: (isExpanded) {
                    if (isExpanded) {
                      for (var i = 0; i < _mainTileControllers.length; i++) {
                        if (i != 1) {
                          _mainTileControllers[i].collapse();
                        }
                      }
                    }
                  },
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                  ),
                  children: [
                    SizedBox(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxl,
                        ),
                        child: _LanguageSelectionList(
                          currentLanguage: userAppSettings.language,
                          l10n: l10n,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSettingSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: AppSpacing.lg,
        ),
        child,
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

  static const List<String> _supportedFontFamilies = [
    'SystemDefault',
    'Roboto',
    'OpenSans',
    'Lato',
    'Montserrat',
    'Merriweather',
  ];
}

/// {@template _language_selection_list}
/// A widget that displays a list of supported languages for selection.
/// {@endtemplate}
class _LanguageSelectionList extends StatelessWidget {
  /// {@macro _language_selection_list}
  const _LanguageSelectionList({
    required this.currentLanguage,
    required this.l10n,
  });

  /// The currently selected language.
  final Language currentLanguage;

  /// The localized strings for the application.
  final AppLocalizations l10n;

  /// The list of supported languages for the application.
  static final List<Language> _supportedLanguages = languagesFixturesData
      .where((lang) => lang.code == 'en' || lang.code == 'ar')
      .toList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _supportedLanguages.length,
      itemBuilder: (context, index) {
        final language = _supportedLanguages[index];
        final isSelected = language == currentLanguage;
        return ListTile(
          title: Text(
            language.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: isSelected
              ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
              : null,
          onTap: () {
            if (!isSelected) {
              context.read<SettingsBloc>().add(
                SettingsLanguageChanged(language),
              );
            }
          },
        );
      },
    );
  }
}
