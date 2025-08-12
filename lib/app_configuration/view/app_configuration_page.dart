import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/bloc/app_configuration_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/feed_decorator_type_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template app_configuration_page}
/// A page for managing the application's remote configuration.
///
/// This page allows administrators to view and modify various application
/// settings that affect the live mobile app. Due to the sensitive nature
/// of these settings, changes require explicit confirmation.
/// {@endtemplate}
class AppConfigurationPage extends StatefulWidget {
  /// {@macro app_configuration_page}
  const AppConfigurationPage({super.key});

  @override
  State<AppConfigurationPage> createState() => _AppConfigurationPageState();
}

class _AppConfigurationPageState extends State<AppConfigurationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Controllers for the top-level ExpansionTiles to manage their expanded state.
  late List<ExpansionTileController> _mainTileControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize a controller for each of the 5 top-level ExpansionTiles.
    _mainTileControllers = List.generate(
      5,
      (index) => ExpansionTileController(),
    );
    context.read<AppConfigurationBloc>().add(const AppConfigurationLoaded());
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Dispose of all ExpansionTileControllers to prevent memory leaks.
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
        title: Text(
          l10n.appConfigurationPageTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            kTextTabBarHeight + AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                ),
                child: Text(
                  l10n.appConfigurationPageDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                tabs: [
                  Tab(text: l10n.feedTab),
                  Tab(text: l10n.advertisementsTab),
                  Tab(text: l10n.generalTab),
                ],
              ),
            ],
          ),
        ),
      ),
      body: BlocConsumer<AppConfigurationBloc, AppConfigurationState>(
        listener: (context, state) {
          if (state.status == AppConfigurationStatus.success &&
              state.showSaveSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.appConfigSaveSuccessMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            // Clear the showSaveSuccess flag after showing the snackbar
            context.read<AppConfigurationBloc>().add(
              const AppConfigurationFieldChanged(),
            );
          } else if (state.status == AppConfigurationStatus.failure &&
              state.exception != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.exception!.toFriendlyMessage(context),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status == AppConfigurationStatus.loading ||
              state.status == AppConfigurationStatus.initial) {
            return LoadingStateWidget(
              icon: Icons.settings_applications_outlined,
              headline: l10n.loadingConfigurationHeadline,
              subheadline: l10n.loadingConfigurationSubheadline,
            );
          } else if (state.status == AppConfigurationStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () {
                context.read<AppConfigurationBloc>().add(
                  const AppConfigurationLoaded(),
                );
              },
            );
          } else if (state.status == AppConfigurationStatus.success &&
              state.remoteConfig != null) {
            final remoteConfig = state.remoteConfig!;
            return TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    // Top-level ExpansionTile for User Content Limits
                    ExpansionTile(
                      controller: _mainTileControllers[0],
                      title: Text(l10n.userContentLimitsTitle),
                      onExpansionChanged: (isExpanded) {
                        if (isExpanded) {
                          // Collapse other main tiles when this one expands
                          for (
                            var i = 0;
                            i < _mainTileControllers.length;
                            i++
                          ) {
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
                        _buildUserPreferenceLimitsSection(
                          context,
                          remoteConfig,
                        ),
                      ],
                    ),
                    // Top-level ExpansionTile for Feed Decorators
                    ExpansionTile(
                      controller: _mainTileControllers[1],
                      title: Text(l10n.feedDecoratorsTitle),
                      onExpansionChanged: (isExpanded) {
                        if (isExpanded) {
                          // Collapse other main tiles when this one expands
                          for (
                            var i = 0;
                            i < _mainTileControllers.length;
                            i++
                          ) {
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
                        _buildFeedDecoratorConfigSection(context, remoteConfig),
                      ],
                    ),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    // Top-level ExpansionTile for Ad Settings
                    ExpansionTile(
                      controller: _mainTileControllers[2],
                      title: Text(l10n.adSettingsTitle),
                      onExpansionChanged: (isExpanded) {
                        if (isExpanded) {
                          // Collapse other main tiles when this one expands
                          for (
                            var i = 0;
                            i < _mainTileControllers.length;
                            i++
                          ) {
                            if (i != 2) {
                              _mainTileControllers[i].collapse();
                            }
                          }
                        }
                      },
                      childrenPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                      ),
                      children: [_buildAdConfigSection(context, remoteConfig)],
                    ),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    // Top-level ExpansionTile for Maintenance Section
                    ExpansionTile(
                      controller: _mainTileControllers[3],
                      title: Text(l10n.maintenanceModeTitle),
                      onExpansionChanged: (isExpanded) {
                        if (isExpanded) {
                          // Collapse other main tiles when this one expands
                          for (
                            var i = 0;
                            i < _mainTileControllers.length;
                            i++
                          ) {
                            if (i != 3) {
                              _mainTileControllers[i].collapse();
                            }
                          }
                        }
                      },
                      childrenPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                        vertical: AppSpacing.md,
                      ),
                      children: [
                        _buildMaintenanceSection(context, remoteConfig),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Top-level ExpansionTile for Force Update Section
                    ExpansionTile(
                      controller: _mainTileControllers[4],
                      title: Text(l10n.forceUpdateTitle),
                      onExpansionChanged: (isExpanded) {
                        if (isExpanded) {
                          // Collapse other main tiles when this one expands
                          for (
                            var i = 0;
                            i < _mainTileControllers.length;
                            i++
                          ) {
                            if (i != 4) {
                              _mainTileControllers[i].collapse();
                            }
                          }
                        }
                      },
                      childrenPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                        vertical: AppSpacing.md,
                      ),
                      children: [
                        _buildForceUpdateSection(context, remoteConfig),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }
          return InitialStateWidget(
            icon: Icons.settings_applications_outlined,
            headline: l10n.appConfigurationPageTitle,
            subheadline: l10n.loadAppSettingsSubheadline,
          ); // Fallback
        },
      ),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    final isDirty = context.select(
      (AppConfigurationBloc bloc) => bloc.state.isDirty,
    );
    final remoteConfig = context.select(
      (AppConfigurationBloc bloc) => bloc.state.remoteConfig,
    );

    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: isDirty
                  ? () {
                      // Discard changes: revert to original config
                      context.read<AppConfigurationBloc>().add(
                        const AppConfigurationDiscarded(),
                      );
                    }
                  : null,
              child: Text(AppLocalizationsX(context).l10n.discardChangesButton),
            ),
            const SizedBox(width: AppSpacing.md),
            ElevatedButton(
              onPressed: isDirty
                  ? () async {
                      final confirmed = await _showConfirmationDialog(context);
                      if (context.mounted &&
                          confirmed &&
                          remoteConfig != null) {
                        context.read<AppConfigurationBloc>().add(
                          AppConfigurationUpdated(remoteConfig),
                        );
                      }
                    }
                  : null,
              child: Text(AppLocalizationsX(context).l10n.saveChangesButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(
                AppLocalizationsX(context).l10n.confirmConfigUpdateDialogTitle,
                style: Theme.of(dialogContext).textTheme.titleLarge,
              ),
              content: Text(
                AppLocalizationsX(
                  context,
                ).l10n.confirmConfigUpdateDialogContent,
                style: Theme.of(dialogContext).textTheme.bodyMedium,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(AppLocalizationsX(context).l10n.cancelButton),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(dialogContext).colorScheme.error,
                    foregroundColor: Theme.of(
                      dialogContext,
                    ).colorScheme.onError,
                  ),
                  child: Text(
                    AppLocalizationsX(context).l10n.confirmSaveButton,
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget _buildUserPreferenceLimitsSection(
    BuildContext context,
    RemoteConfig remoteConfig,
  ) {
    final l10n = AppLocalizationsX(context).l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.userContentLimitsDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ExpansionTile(
          title: Text(l10n.guestUserTab),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
          ),
          children: [
            _UserPreferenceLimitsForm(
              userRole: AppUserRole.guestUser,
              remoteConfig: remoteConfig,
              onConfigChanged: (newConfig) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(remoteConfig: newConfig),
                );
              },
              buildIntField: _buildIntField,
            ),
          ],
        ),
        ExpansionTile(
          title: Text(l10n.authenticatedUserTab),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
          ),
          children: [
            _UserPreferenceLimitsForm(
              userRole: AppUserRole.standardUser,
              remoteConfig: remoteConfig,
              onConfigChanged: (newConfig) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(remoteConfig: newConfig),
                );
              },
              buildIntField: _buildIntField,
            ),
          ],
        ),
        ExpansionTile(
          title: Text(l10n.premiumUserTab),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
          ),
          children: [
            _UserPreferenceLimitsForm(
              userRole: AppUserRole.premiumUser,
              remoteConfig: remoteConfig,
              onConfigChanged: (newConfig) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(remoteConfig: newConfig),
                );
              },
              buildIntField: _buildIntField,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedDecoratorConfigSection(
    BuildContext context,
    RemoteConfig remoteConfig,
  ) {
    final l10n = AppLocalizationsX(context).l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.feedDecoratorsDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final decoratorType in FeedDecoratorType.values)
          ExpansionTile(
            title: Text(
              decoratorType.l10n(context),
            ),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
            ),
            children: [
              _FeedDecoratorForm(
                decoratorType: decoratorType,
                remoteConfig: remoteConfig.copyWith(
                  feedDecoratorConfig:
                      Map.from(remoteConfig.feedDecoratorConfig)..putIfAbsent(
                        decoratorType,
                        () => FeedDecoratorConfig(
                          category:
                              decoratorType ==
                                      FeedDecoratorType.suggestedTopics ||
                                  decoratorType ==
                                      FeedDecoratorType.suggestedSources
                              ? FeedDecoratorCategory.contentCollection
                              : FeedDecoratorCategory.callToAction,
                          enabled: false,
                          visibleTo: const {},
                          itemsToDisplay:
                              decoratorType ==
                                      FeedDecoratorType.suggestedTopics ||
                                  decoratorType ==
                                      FeedDecoratorType.suggestedSources
                              ? 0
                              : null,
                        ),
                      ),
                ),
                onConfigChanged: (newConfig) {
                  context.read<AppConfigurationBloc>().add(
                    AppConfigurationFieldChanged(remoteConfig: newConfig),
                  );
                },
                buildIntField: _buildIntField,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildAdConfigSection(
    BuildContext context,
    RemoteConfig remoteConfig,
  ) {
    final l10n = AppLocalizationsX(context).l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.adSettingsDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ExpansionTile(
          title: Text(l10n.guestUserTab),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
          ),
          children: [
            _AdConfigForm(
              userRole: AppUserRole.guestUser,
              remoteConfig: remoteConfig,
              onConfigChanged: (newConfig) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(remoteConfig: newConfig),
                );
              },
              buildIntField: _buildIntField,
            ),
          ],
        ),
        ExpansionTile(
          title: Text(l10n.standardUserAdTab),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
          ),
          children: [
            _AdConfigForm(
              userRole: AppUserRole.standardUser,
              remoteConfig: remoteConfig,
              onConfigChanged: (newConfig) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(remoteConfig: newConfig),
                );
              },
              buildIntField: _buildIntField,
            ),
          ],
        ),
        ExpansionTile(
          title: Text(l10n.premiumUserTab),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
          ),
          children: [
            _AdConfigForm(
              userRole: AppUserRole.premiumUser,
              remoteConfig: remoteConfig,
              onConfigChanged: (newConfig) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(remoteConfig: newConfig),
                );
              },
              buildIntField: _buildIntField,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMaintenanceSection(
    BuildContext context,
    RemoteConfig remoteConfig,
  ) {
    final l10n = AppLocalizationsX(context).l10n;
    return ExpansionTile(
      title: Text(l10n.maintenanceModeTitle),
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.md,
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.maintenanceModeDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SwitchListTile(
              title: Text(l10n.isUnderMaintenanceLabel),
              subtitle: Text(l10n.isUnderMaintenanceDescription),
              value: remoteConfig.appStatus.isUnderMaintenance,
              onChanged: (value) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(
                    remoteConfig: remoteConfig.copyWith(
                      appStatus: remoteConfig.appStatus.copyWith(
                        isUnderMaintenance: value,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForceUpdateSection(
    BuildContext context,
    RemoteConfig remoteConfig,
  ) {
    final l10n = AppLocalizationsX(context).l10n;
    return ExpansionTile(
      title: Text(l10n.forceUpdateTitle),
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.md,
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.forceUpdateDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildTextField(
              context,
              label: l10n.latestAppVersionLabel,
              description: l10n.latestAppVersionDescription,
              value: remoteConfig.appStatus.latestAppVersion,
              onChanged: (value) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(
                    remoteConfig: remoteConfig.copyWith(
                      appStatus: remoteConfig.appStatus.copyWith(
                        latestAppVersion: value,
                      ),
                    ),
                  ),
                );
              },
            ),
            SwitchListTile(
              title: Text(l10n.isLatestVersionOnlyLabel),
              subtitle: Text(l10n.isLatestVersionOnlyDescription),
              value: remoteConfig.appStatus.isLatestVersionOnly,
              onChanged: (value) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(
                    remoteConfig: remoteConfig.copyWith(
                      appStatus: remoteConfig.appStatus.copyWith(
                        isLatestVersionOnly: value,
                      ),
                    ),
                  ),
                );
              },
            ),
            _buildTextField(
              context,
              label: l10n.iosUpdateUrlLabel,
              description: l10n.iosUpdateUrlDescription,
              value: remoteConfig.appStatus.iosUpdateUrl,
              onChanged: (value) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(
                    remoteConfig: remoteConfig.copyWith(
                      appStatus: remoteConfig.appStatus.copyWith(
                        iosUpdateUrl: value,
                      ),
                    ),
                  ),
                );
              },
            ),
            _buildTextField(
              context,
              label: l10n.androidUpdateUrlLabel,
              description: l10n.androidUpdateUrlDescription,
              value: remoteConfig.appStatus.androidUpdateUrl,
              onChanged: (value) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(
                    remoteConfig: remoteConfig.copyWith(
                      appStatus: remoteConfig.appStatus.copyWith(
                        androidUpdateUrl: value,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntField(
    BuildContext context, {
    required String label,
    required String description,
    required int value,
    required ValueChanged<int> onChanged,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: controller,
            initialValue: controller == null ? value.toString() : null,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (text) {
              final parsedValue = int.tryParse(text);
              if (parsedValue != null) {
                onChanged(parsedValue);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String description,
    required String? value,
    required ValueChanged<String?> onChanged,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: controller,
            initialValue: controller == null ? value : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _UserPreferenceLimitsForm extends StatefulWidget {
  const _UserPreferenceLimitsForm({
    required this.userRole,
    required this.remoteConfig,
    required this.onConfigChanged,
    required this.buildIntField,
  });

  final AppUserRole userRole;
  final RemoteConfig remoteConfig;
  final ValueChanged<RemoteConfig> onConfigChanged;
  final Widget Function(
    BuildContext context, {
    required String label,
    required String description,
    required int value,
    required ValueChanged<int> onChanged,
    TextEditingController? controller,
  })
  buildIntField;

  @override
  State<_UserPreferenceLimitsForm> createState() =>
      _UserPreferenceLimitsFormState();
}

class _UserPreferenceLimitsFormState extends State<_UserPreferenceLimitsForm> {
  late final TextEditingController _followedItemsLimitController;
  late final TextEditingController _savedHeadlinesLimitController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant _UserPreferenceLimitsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.userPreferenceConfig !=
        oldWidget.remoteConfig.userPreferenceConfig) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final config = widget.remoteConfig.userPreferenceConfig;
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        _followedItemsLimitController =
            TextEditingController(
                text: config.guestFollowedItemsLimit.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: config.guestFollowedItemsLimit.toString().length,
              );
        _savedHeadlinesLimitController =
            TextEditingController(
                text: config.guestSavedHeadlinesLimit.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: config.guestSavedHeadlinesLimit.toString().length,
              );
      case AppUserRole.standardUser:
        _followedItemsLimitController =
            TextEditingController(
                text: config.authenticatedFollowedItemsLimit.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: config.authenticatedFollowedItemsLimit
                    .toString()
                    .length,
              );
        _savedHeadlinesLimitController =
            TextEditingController(
                text: config.authenticatedSavedHeadlinesLimit.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: config.authenticatedSavedHeadlinesLimit
                    .toString()
                    .length,
              );
      case AppUserRole.premiumUser:
        _followedItemsLimitController =
            TextEditingController(
                text: config.premiumFollowedItemsLimit.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: config.premiumFollowedItemsLimit.toString().length,
              );
        _savedHeadlinesLimitController =
            TextEditingController(
                text: config.premiumSavedHeadlinesLimit.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: config.premiumSavedHeadlinesLimit.toString().length,
              );
    }
  }

  void _updateControllers() {
    final config = widget.remoteConfig.userPreferenceConfig;
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        _followedItemsLimitController.text = config.guestFollowedItemsLimit
            .toString();
        _followedItemsLimitController.selection = TextSelection.collapsed(
          offset: _followedItemsLimitController.text.length,
        );
        _savedHeadlinesLimitController.text = config.guestSavedHeadlinesLimit
            .toString();
        _savedHeadlinesLimitController.selection = TextSelection.collapsed(
          offset: _savedHeadlinesLimitController.text.length,
        );
      case AppUserRole.standardUser:
        _followedItemsLimitController.text = config
            .authenticatedFollowedItemsLimit
            .toString();
        _followedItemsLimitController.selection = TextSelection.collapsed(
          offset: _followedItemsLimitController.text.length,
        );
        _savedHeadlinesLimitController.text = config
            .authenticatedSavedHeadlinesLimit
            .toString();
        _savedHeadlinesLimitController.selection = TextSelection.collapsed(
          offset: _savedHeadlinesLimitController.text.length,
        );
      case AppUserRole.premiumUser:
        _followedItemsLimitController.text = config.premiumFollowedItemsLimit
            .toString();
        _followedItemsLimitController.selection = TextSelection.collapsed(
          offset: _followedItemsLimitController.text.length,
        );
        _savedHeadlinesLimitController.text = config.premiumSavedHeadlinesLimit
            .toString();
        _savedHeadlinesLimitController.selection = TextSelection.collapsed(
          offset: _savedHeadlinesLimitController.text.length,
        );
    }
  }

  @override
  void dispose() {
    _followedItemsLimitController.dispose();
    _savedHeadlinesLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userPreferenceConfig = widget.remoteConfig.userPreferenceConfig;
    final l10n = AppLocalizationsX(context).l10n;

    return Column(
      children: [
        widget.buildIntField(
          context,
          label: _getFollowedItemsLimitLabel(l10n),
          description: _getFollowedItemsLimitDescription(l10n),
          value: _getFollowedItemsLimit(userPreferenceConfig),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                userPreferenceConfig: _updateFollowedItemsLimit(
                  userPreferenceConfig,
                  value,
                ),
              ),
            );
          },
          controller: _followedItemsLimitController,
        ),
        widget.buildIntField(
          context,
          label: _getSavedHeadlinesLimitLabel(l10n),
          description: _getSavedHeadlinesLimitDescription(l10n),
          value: _getSavedHeadlinesLimit(userPreferenceConfig),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                userPreferenceConfig: _updateSavedHeadlinesLimit(
                  userPreferenceConfig,
                  value,
                ),
              ),
            );
          },
          controller: _savedHeadlinesLimitController,
        ),
      ],
    );
  }

  String _getFollowedItemsLimitLabel(AppLocalizations l10n) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return l10n.guestFollowedItemsLimitLabel;
      case AppUserRole.standardUser:
        return l10n.standardUserFollowedItemsLimitLabel;
      case AppUserRole.premiumUser:
        return l10n.premiumFollowedItemsLimitLabel;
    }
  }

  String _getFollowedItemsLimitDescription(AppLocalizations l10n) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return l10n.guestFollowedItemsLimitDescription;
      case AppUserRole.standardUser:
        return l10n.standardUserFollowedItemsLimitDescription;
      case AppUserRole.premiumUser:
        return l10n.premiumFollowedItemsLimitDescription;
    }
  }

  String _getSavedHeadlinesLimitLabel(AppLocalizations l10n) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return l10n.guestSavedHeadlinesLimitLabel;
      case AppUserRole.standardUser:
        return l10n.standardUserSavedHeadlinesLimitLabel;
      case AppUserRole.premiumUser:
        return l10n.premiumSavedHeadlinesLimitLabel;
    }
  }

  String _getSavedHeadlinesLimitDescription(AppLocalizations l10n) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return l10n.guestSavedHeadlinesLimitDescription;
      case AppUserRole.standardUser:
        return l10n.standardUserSavedHeadlinesLimitDescription;
      case AppUserRole.premiumUser:
        return l10n.premiumSavedHeadlinesLimitDescription;
    }
  }

  int _getFollowedItemsLimit(UserPreferenceConfig config) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return config.guestFollowedItemsLimit;
      case AppUserRole.standardUser:
        return config.authenticatedFollowedItemsLimit;
      case AppUserRole.premiumUser:
        return config.premiumFollowedItemsLimit;
    }
  }

  int _getSavedHeadlinesLimit(UserPreferenceConfig config) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return config.guestSavedHeadlinesLimit;
      case AppUserRole.standardUser:
        return config.authenticatedSavedHeadlinesLimit;
      case AppUserRole.premiumUser:
        return config.premiumSavedHeadlinesLimit;
    }
  }

  UserPreferenceConfig _updateFollowedItemsLimit(
    UserPreferenceConfig config,
    int value,
  ) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return config.copyWith(guestFollowedItemsLimit: value);
      case AppUserRole.standardUser:
        return config.copyWith(authenticatedFollowedItemsLimit: value);
      case AppUserRole.premiumUser:
        return config.copyWith(premiumFollowedItemsLimit: value);
    }
  }

  UserPreferenceConfig _updateSavedHeadlinesLimit(
    UserPreferenceConfig config,
    int value,
  ) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return config.copyWith(guestSavedHeadlinesLimit: value);
      case AppUserRole.standardUser:
        return config.copyWith(authenticatedSavedHeadlinesLimit: value);
      case AppUserRole.premiumUser:
        return config.copyWith(premiumSavedHeadlinesLimit: value);
    }
  }
}

class _FeedDecoratorForm extends StatefulWidget {
  const _FeedDecoratorForm({
    required this.decoratorType,
    required this.remoteConfig,
    required this.onConfigChanged,
    required this.buildIntField,
  });

  final FeedDecoratorType decoratorType;
  final RemoteConfig remoteConfig;
  final ValueChanged<RemoteConfig> onConfigChanged;
  final Widget Function(
    BuildContext context, {
    required String label,
    required String description,
    required int value,
    required ValueChanged<int> onChanged,
    TextEditingController? controller,
  })
  buildIntField;

  @override
  State<_FeedDecoratorForm> createState() => _FeedDecoratorFormState();
}

class _FeedDecoratorFormState extends State<_FeedDecoratorForm> {
  late final TextEditingController _itemsToDisplayController;
  late final Map<AppUserRole, TextEditingController> _roleControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant _FeedDecoratorForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.feedDecoratorConfig[widget.decoratorType] !=
        oldWidget.remoteConfig.feedDecoratorConfig[widget.decoratorType]) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final decoratorConfig =
        widget.remoteConfig.feedDecoratorConfig[widget.decoratorType]!;
    _itemsToDisplayController =
        TextEditingController(
            text: decoratorConfig.itemsToDisplay?.toString() ?? '',
          )
          ..selection = TextSelection.collapsed(
            offset: decoratorConfig.itemsToDisplay?.toString().length ?? 0,
          );

    _roleControllers = {
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text:
                    decoratorConfig.visibleTo[role]?.daysBetweenViews
                        .toString() ??
                    '',
              )
              ..selection = TextSelection.collapsed(
                offset:
                    decoratorConfig.visibleTo[role]?.daysBetweenViews
                        .toString()
                        .length ??
                    0,
              ),
    };
  }

  void _updateControllers() {
    final decoratorConfig =
        widget.remoteConfig.feedDecoratorConfig[widget.decoratorType]!;
    _itemsToDisplayController.text =
        decoratorConfig.itemsToDisplay?.toString() ?? '';
    _itemsToDisplayController.selection = TextSelection.collapsed(
      offset: _itemsToDisplayController.text.length,
    );
    for (final role in AppUserRole.values) {
      _roleControllers[role]?.text =
          decoratorConfig.visibleTo[role]?.daysBetweenViews.toString() ?? '';
      _roleControllers[role]?.selection = TextSelection.collapsed(
        offset: _roleControllers[role]?.text.length ?? 0,
      );
    }
  }

  @override
  void dispose() {
    _itemsToDisplayController.dispose();
    for (final controller in _roleControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final decoratorConfig =
        widget.remoteConfig.feedDecoratorConfig[widget.decoratorType]!;

    return Column(
      children: [
        SwitchListTile(
          title: Text(l10n.enabledLabel),
          value: decoratorConfig.enabled,
          onChanged: (value) {
            final newDecoratorConfig = decoratorConfig.copyWith(enabled: value);
            final newFeedDecoratorConfig =
                Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                  widget.remoteConfig.feedDecoratorConfig,
                )..[widget.decoratorType] = newDecoratorConfig;
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                feedDecoratorConfig: newFeedDecoratorConfig,
              ),
            );
          },
        ),
        if (decoratorConfig.category == FeedDecoratorCategory.contentCollection)
          widget.buildIntField(
            context,
            label: l10n.itemsToDisplayLabel,
            description: l10n.itemsToDisplayDescription,
            value: decoratorConfig.itemsToDisplay ?? 0,
            onChanged: (value) {
              final newDecoratorConfig = decoratorConfig.copyWith(
                itemsToDisplay: value,
              );
              final newFeedDecoratorConfig =
                  Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                    widget.remoteConfig.feedDecoratorConfig,
                  )..[widget.decoratorType] = newDecoratorConfig;
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  feedDecoratorConfig: newFeedDecoratorConfig,
                ),
              );
            },
            controller: _itemsToDisplayController,
          ),
        ExpansionTile(
          title: Text(l10n.roleSpecificSettingsTitle),
          children: AppUserRole.values.map((role) {
            final roleConfig = decoratorConfig.visibleTo[role];
            return Column(
              children: [
                CheckboxListTile(
                  title: Text(role.l10n(context)),
                  value: roleConfig != null,
                  onChanged:
                      widget.decoratorType == FeedDecoratorType.linkAccount &&
                          (role == AppUserRole.standardUser ||
                              role == AppUserRole.premiumUser)
                      ? null // Disable for standard and premium users for linkAccount
                      : (value) {
                          final newVisibleTo =
                              Map<AppUserRole, FeedDecoratorRoleConfig>.from(
                                decoratorConfig.visibleTo,
                              );
                          if (value == true) {
                            newVisibleTo[role] = const FeedDecoratorRoleConfig(
                              daysBetweenViews: 7,
                            );
                          } else {
                            newVisibleTo.remove(role);
                          }
                          final newDecoratorConfig = decoratorConfig.copyWith(
                            visibleTo: newVisibleTo,
                          );
                          final newFeedDecoratorConfig =
                              Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                                widget.remoteConfig.feedDecoratorConfig,
                              )..[widget.decoratorType] = newDecoratorConfig;
                          widget.onConfigChanged(
                            widget.remoteConfig.copyWith(
                              feedDecoratorConfig: newFeedDecoratorConfig,
                            ),
                          );
                        },
                ),
                if (roleConfig != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: widget.buildIntField(
                      context,
                      label: l10n.daysBetweenViewsLabel,
                      description: l10n.daysBetweenViewsDescription,
                      value: roleConfig.daysBetweenViews,
                      onChanged: (value) {
                        final newRoleConfig = roleConfig.copyWith(
                          daysBetweenViews: value,
                        );
                        final newVisibleTo =
                            Map<AppUserRole, FeedDecoratorRoleConfig>.from(
                              decoratorConfig.visibleTo,
                            )..[role] = newRoleConfig;
                        final newDecoratorConfig = decoratorConfig.copyWith(
                          visibleTo: newVisibleTo,
                        );
                        final newFeedDecoratorConfig =
                            Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                              widget.remoteConfig.feedDecoratorConfig,
                            )..[widget.decoratorType] = newDecoratorConfig;
                        widget.onConfigChanged(
                          widget.remoteConfig.copyWith(
                            feedDecoratorConfig: newFeedDecoratorConfig,
                          ),
                        );
                      },
                      controller: _roleControllers[role],
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AdConfigForm extends StatefulWidget {
  const _AdConfigForm({
    required this.userRole,
    required this.remoteConfig,
    required this.onConfigChanged,
    required this.buildIntField,
  });

  final AppUserRole userRole;
  final RemoteConfig remoteConfig;
  final ValueChanged<RemoteConfig> onConfigChanged;
  final Widget Function(
    BuildContext context, {
    required String label,
    required String description,
    required int value,
    required ValueChanged<int> onChanged,
    TextEditingController? controller,
  })
  buildIntField;

  @override
  State<_AdConfigForm> createState() => _AdConfigFormState();
}

class _AdConfigFormState extends State<_AdConfigForm> {
  late final TextEditingController _adFrequencyController;
  late final TextEditingController _adPlacementIntervalController;
  late final TextEditingController
  _articlesToReadBeforeShowingInterstitialAdsController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant _AdConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.adConfig != oldWidget.remoteConfig.adConfig) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final adConfig = widget.remoteConfig.adConfig;
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        _adFrequencyController =
            TextEditingController(
                text: adConfig.guestAdFrequency.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: adConfig.guestAdFrequency.toString().length,
              );
        _adPlacementIntervalController =
            TextEditingController(
                text: adConfig.guestAdPlacementInterval.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: adConfig.guestAdPlacementInterval.toString().length,
              );
        _articlesToReadBeforeShowingInterstitialAdsController =
            TextEditingController(
                text: adConfig.guestArticlesToReadBeforeShowingInterstitialAds
                    .toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: adConfig.guestArticlesToReadBeforeShowingInterstitialAds
                    .toString()
                    .length,
              );
      case AppUserRole.standardUser:
        _adFrequencyController =
            TextEditingController(
                text: adConfig.authenticatedAdFrequency.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: adConfig.authenticatedAdFrequency.toString().length,
              );
        _adPlacementIntervalController =
            TextEditingController(
                text: adConfig.authenticatedAdPlacementInterval.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: adConfig.authenticatedAdPlacementInterval
                    .toString()
                    .length,
              );
        _articlesToReadBeforeShowingInterstitialAdsController =
            TextEditingController(
                text: adConfig
                    .standardUserArticlesToReadBeforeShowingInterstitialAds
                    .toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: adConfig
                    .standardUserArticlesToReadBeforeShowingInterstitialAds
                    .toString()
                    .length,
              );
      case AppUserRole.premiumUser:
        _adFrequencyController =
            TextEditingController(
                text: adConfig.premiumAdFrequency.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: adConfig.premiumAdFrequency.toString().length,
              );
        _adPlacementIntervalController =
            TextEditingController(
                text: adConfig.premiumAdPlacementInterval.toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: adConfig.premiumAdPlacementInterval.toString().length,
              );
        _articlesToReadBeforeShowingInterstitialAdsController =
            TextEditingController(
                text: adConfig
                    .premiumUserArticlesToReadBeforeShowingInterstitialAds
                    .toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: adConfig
                    .premiumUserArticlesToReadBeforeShowingInterstitialAds
                    .toString()
                    .length,
              );
    }
  }

  void _updateControllers() {
    final adConfig = widget.remoteConfig.adConfig;
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        _adFrequencyController.text = adConfig.guestAdFrequency.toString();
        _adFrequencyController.selection = TextSelection.collapsed(
          offset: _adFrequencyController.text.length,
        );
        _adPlacementIntervalController.text = adConfig.guestAdPlacementInterval
            .toString();
        _adPlacementIntervalController.selection = TextSelection.collapsed(
          offset: _adPlacementIntervalController.text.length,
        );
        _articlesToReadBeforeShowingInterstitialAdsController.text = adConfig
            .guestArticlesToReadBeforeShowingInterstitialAds
            .toString();
        _articlesToReadBeforeShowingInterstitialAdsController
            .selection = TextSelection.collapsed(
          offset:
              _articlesToReadBeforeShowingInterstitialAdsController.text.length,
        );
      case AppUserRole.standardUser:
        _adFrequencyController.text = adConfig.authenticatedAdFrequency
            .toString();
        _adFrequencyController.selection = TextSelection.collapsed(
          offset: _adFrequencyController.text.length,
        );
        _adPlacementIntervalController.text = adConfig
            .authenticatedAdPlacementInterval
            .toString();
        _adPlacementIntervalController.selection = TextSelection.collapsed(
          offset: _adPlacementIntervalController.text.length,
        );
        _articlesToReadBeforeShowingInterstitialAdsController.text = adConfig
            .standardUserArticlesToReadBeforeShowingInterstitialAds
            .toString();
        _articlesToReadBeforeShowingInterstitialAdsController
            .selection = TextSelection.collapsed(
          offset:
              _articlesToReadBeforeShowingInterstitialAdsController.text.length,
        );
      case AppUserRole.premiumUser:
        _adFrequencyController.text = adConfig.premiumAdFrequency.toString();
        _adFrequencyController.selection = TextSelection.collapsed(
          offset: _adFrequencyController.text.length,
        );
        _adPlacementIntervalController.text = adConfig
            .premiumAdPlacementInterval
            .toString();
        _adPlacementIntervalController.selection = TextSelection.collapsed(
          offset: _adPlacementIntervalController.text.length,
        );
        _articlesToReadBeforeShowingInterstitialAdsController.text = adConfig
            .premiumUserArticlesToReadBeforeShowingInterstitialAds
            .toString();
        _articlesToReadBeforeShowingInterstitialAdsController
            .selection = TextSelection.collapsed(
          offset:
              _articlesToReadBeforeShowingInterstitialAdsController.text.length,
        );
    }
  }

  @override
  void dispose() {
    _adFrequencyController.dispose();
    _adPlacementIntervalController.dispose();
    _articlesToReadBeforeShowingInterstitialAdsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adConfig = widget.remoteConfig.adConfig;
    final l10n = AppLocalizationsX(context).l10n;

    return Column(
      children: [
        widget.buildIntField(
          context,
          label: l10n.adFrequencyLabel,
          description: l10n.adFrequencyDescription,
          value: _getAdFrequency(adConfig),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: _updateAdFrequency(adConfig, value),
              ),
            );
          },
          controller: _adFrequencyController,
        ),
        widget.buildIntField(
          context,
          label: l10n.adPlacementIntervalLabel,
          description: l10n.adPlacementIntervalDescription,
          value: _getAdPlacementInterval(adConfig),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: _updateAdPlacementInterval(adConfig, value),
              ),
            );
          },
          controller: _adPlacementIntervalController,
        ),
        widget.buildIntField(
          context,
          label: l10n.articlesBeforeInterstitialAdsLabel,
          description: l10n.articlesBeforeInterstitialAdsDescription,
          value: _getArticlesBeforeInterstitial(adConfig),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: _updateArticlesBeforeInterstitial(adConfig, value),
              ),
            );
          },
          controller: _articlesToReadBeforeShowingInterstitialAdsController,
        ),
      ],
    );
  }

  int _getAdFrequency(AdConfig config) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return config.guestAdFrequency;
      case AppUserRole.standardUser:
        return config.authenticatedAdFrequency;
      case AppUserRole.premiumUser:
        return config.premiumAdFrequency;
    }
  }

  int _getAdPlacementInterval(AdConfig config) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return config.guestAdPlacementInterval;
      case AppUserRole.standardUser:
        return config.authenticatedAdPlacementInterval;
      case AppUserRole.premiumUser:
        return config.premiumAdPlacementInterval;
    }
  }

  int _getArticlesBeforeInterstitial(AdConfig config) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return config.guestArticlesToReadBeforeShowingInterstitialAds;
      case AppUserRole.standardUser:
        return config.standardUserArticlesToReadBeforeShowingInterstitialAds;
      case AppUserRole.premiumUser:
        return config.premiumUserArticlesToReadBeforeShowingInterstitialAds;
    }
  }

  AdConfig _updateAdFrequency(AdConfig config, int value) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return config.copyWith(guestAdFrequency: value);
      case AppUserRole.standardUser:
        return config.copyWith(authenticatedAdFrequency: value);
      case AppUserRole.premiumUser:
        return config.copyWith(premiumAdFrequency: value);
    }
  }

  AdConfig _updateAdPlacementInterval(AdConfig config, int value) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return config.copyWith(guestAdPlacementInterval: value);
      case AppUserRole.standardUser:
        return config.copyWith(authenticatedAdPlacementInterval: value);
      case AppUserRole.premiumUser:
        return config.copyWith(premiumAdPlacementInterval: value);
    }
  }

  AdConfig _updateArticlesBeforeInterstitial(AdConfig config, int value) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return config.copyWith(
          guestArticlesToReadBeforeShowingInterstitialAds: value,
        );
      case AppUserRole.standardUser:
        return config.copyWith(
          standardUserArticlesToReadBeforeShowingInterstitialAds: value,
        );
      case AppUserRole.premiumUser:
        return config.copyWith(
          premiumUserArticlesToReadBeforeShowingInterstitialAds: value,
        );
    }
  }
}
