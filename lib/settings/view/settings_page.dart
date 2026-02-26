import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/settings/bloc/settings_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/supported_language_flag.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/supported_language_l10n.dart';
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
        appSettingsRepository: context.read<DataRepository<AppSettings>>(),
      )..add(SettingsLoaded(userId: context.read<AppBloc>().state.user?.id)),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.settings),
            const SizedBox(
              width: AppSpacing.xs,
            ),
            AboutIcon(
              dialogTitle: l10n.settings,
              dialogDescription: l10n.settingsPageDescription,
            ),
          ],
        ),
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
            if (state.appSettings != null) {
              context.read<AppBloc>().add(
                AppUserAppSettingsChanged(
                  state.appSettings!,
                ),
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
          if (state.appSettings == null && state is! SettingsLoadInProgress) {
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
          } else if (state.appSettings != null) {
            final appSettings = state.appSettings!;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _SettingsCard(
                  title: l10n.appearanceSettingsLabel,
                  children: [
                    _buildSettingSection(
                      context,
                      title: l10n.baseThemeLabel,
                      description: l10n.baseThemeDescription,
                      child: SegmentedButton<AppBaseTheme>(
                        segments: [
                          ButtonSegment(
                            value: AppBaseTheme.light,
                            label: Text(l10n.lightTheme),
                            icon: const Icon(Icons.light_mode_outlined),
                          ),
                          ButtonSegment(
                            value: AppBaseTheme.dark,
                            label: Text(l10n.darkTheme),
                            icon: const Icon(Icons.dark_mode_outlined),
                          ),
                          ButtonSegment(
                            value: AppBaseTheme.system,
                            label: Text(l10n.systemTheme),
                            icon: const Icon(Icons.brightness_auto_outlined),
                          ),
                        ],
                        selected: {appSettings.displaySettings.baseTheme},
                        onSelectionChanged: (selection) {
                          context.read<SettingsBloc>().add(
                            SettingsBaseThemeChanged(selection.first),
                          );
                        },
                      ),
                    ),
                    const Divider(height: AppSpacing.lg),
                    _buildSettingSection(
                      context,
                      title: l10n.accentThemeLabel,
                      description: l10n.accentThemeDescription,
                      child: Row(
                        children: AppAccentTheme.values.map((accent) {
                          return _AccentColorCircle(
                            color: _getAppAccentThemeColor(accent, context),
                            isSelected:
                                appSettings.displaySettings.accentTheme ==
                                accent,
                            onTap: () => context.read<SettingsBloc>().add(
                              SettingsAccentThemeChanged(accent),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(height: AppSpacing.lg),
                    _buildSettingSection(
                      context,
                      title: l10n.textScaleFactorLabel,
                      description: l10n.textScaleFactorDescription,
                      child: SizedBox(
                        width: 250,
                        child: Slider(
                          value: AppTextScaleFactor.values
                              .indexOf(
                                appSettings.displaySettings.textScaleFactor,
                              )
                              .toDouble(),
                          min: 0,
                          max: (AppTextScaleFactor.values.length - 1)
                              .toDouble(),
                          divisions: AppTextScaleFactor.values.length - 1,
                          label: _getAppTextScaleFactorName(
                            appSettings.displaySettings.textScaleFactor,
                            l10n,
                          ),
                          onChanged: (value) {
                            final newScale =
                                AppTextScaleFactor.values[value.toInt()];
                            context.read<SettingsBloc>().add(
                              SettingsTextScaleFactorChanged(newScale),
                            );
                          },
                        ),
                      ),
                    ),
                    const Divider(height: AppSpacing.lg),
                    _buildSettingSection(
                      context,
                      title: l10n.fontWeightLabel,
                      description: l10n.fontWeightDescription,
                      child: SegmentedButton<AppFontWeight>(
                        segments: [
                          ButtonSegment(
                            value: AppFontWeight.light,
                            label: Text(l10n.lightFontWeight),
                          ),
                          ButtonSegment(
                            value: AppFontWeight.regular,
                            label: Text(l10n.regularFontWeight),
                          ),
                          ButtonSegment(
                            value: AppFontWeight.bold,
                            label: Text(l10n.boldFontWeight),
                          ),
                        ],
                        selected: {appSettings.displaySettings.fontWeight},
                        onSelectionChanged: (selection) {
                          context.read<SettingsBloc>().add(
                            SettingsFontWeightChanged(selection.first),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _SettingsCard(
                  title: l10n.languageSettingsLabel,
                  children: [
                    SizedBox(
                      height: 120,
                      child: _LanguageSelectionList(
                        currentLanguage: appSettings.language,
                        l10n: l10n,
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
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            ...children,
          ],
        ),
      ),
    );
  }
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
                color: Theme.of(context).colorScheme.onSurface,
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

class _AccentColorCircle extends StatelessWidget {
  const _AccentColorCircle({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 3,
                )
              : null,
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 18,
              )
            : null,
      ),
    );
  }
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
  final SupportedLanguage currentLanguage;

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
        SupportedLanguage? supportedLanguage;
        try {
          supportedLanguage = SupportedLanguage.values.byName(language.code);
        } catch (_) {}

        final isSelected = language.code == currentLanguage.name;
        return ListTile(
          title: Row(
            children: [
              if (supportedLanguage != null) ...[
                Image.network(
                  supportedLanguage.flagUrl,
                  width: 24,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.flag, size: 16),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(supportedLanguage.l10n(context)),
              ] else
                Text(language.name),
            ],
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

Color _getAppAccentThemeColor(AppAccentTheme theme, BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  switch (theme) {
    case AppAccentTheme.defaultBlue:
      return (isDark ? FlexColorScheme.dark : FlexColorScheme.light)(
        scheme: FlexScheme.shadBlue,
        useMaterial3: true,
      ).toScheme.primary;
    case AppAccentTheme.newsRed:
      return (isDark ? FlexColorScheme.dark : FlexColorScheme.light)(
        scheme: FlexScheme.shadRed,
        useMaterial3: true,
      ).toScheme.primary;
    case AppAccentTheme.graphiteGray:
      return (isDark ? FlexColorScheme.dark : FlexColorScheme.light)(
        scheme: FlexScheme.shadGray,
        useMaterial3: true,
      ).toScheme.primary;
  }
}
