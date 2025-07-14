import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_dashboard/app_configuration/bloc/app_configuration_bloc.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/shared/constants/app_spacing.dart';
import 'package:ht_dashboard/shared/widgets/widgets.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:ht_ui_kit/ht_ui_kit.dart'; // Import for toFriendlyMessage

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

class _AppConfigurationPageState extends State<AppConfigurationPage> {
  @override
  void initState() {
    super.initState();
    context.read<AppConfigurationBloc>().add(const AppConfigurationLoaded());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appConfigurationPageTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + AppSpacing.lg),
          child: Padding(
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
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                ExpansionTile(
                  title: Text(l10n.userContentLimitsTab),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                  ),
                  children: [
                    _buildUserPreferenceLimitsSection(context, remoteConfig),
                  ],
                ),
                ExpansionTile(
                  title: Text(l10n.adSettingsTab),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                  ),
                  children: [
                    _buildAdConfigSection(context, remoteConfig),
                  ],
                ),
                ExpansionTile(
                  title: Text(l10n.inAppPromptsTab),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                  ),
                  children: [
                    _buildAccountActionConfigSection(context, remoteConfig),
                  ],
                ),
                ExpansionTile(
                  title: Text(l10n.appOperationalStatusTab),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                  ),
                  children: [
                    _buildAppStatusSection(context, remoteConfig),
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
              child: Text(context.l10n.discardChangesButton),
            ),
            const SizedBox(width: AppSpacing.md),
            ElevatedButton(
              onPressed: isDirty
                  ? () async {
                      final confirmed = await _showConfirmationDialog(context);
                      if (context.mounted && confirmed && remoteConfig != null) {
                        context.read<AppConfigurationBloc>().add(
                              AppConfigurationUpdated(remoteConfig),
                            );
                      }
                    }
                  : null,
              child: Text(context.l10n.saveChangesButton),
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
                context.l10n.confirmConfigUpdateDialogTitle,
                style: Theme.of(dialogContext).textTheme.titleLarge,
              ),
              content: Text(
                context.l10n.confirmConfigUpdateDialogContent,
                style: Theme.of(dialogContext).textTheme.bodyMedium,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(context.l10n.cancelButton),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(dialogContext).colorScheme.error,
                    foregroundColor: Theme.of(
                      dialogContext,
                    ).colorScheme.onError,
                  ),
                  child: Text(context.l10n.confirmSaveButton),
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
    final l10n = context.l10n;
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
                      AppConfigurationFieldChanged(
                        remoteConfig: newConfig,
                      ),
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
                      AppConfigurationFieldChanged(
                        remoteConfig: newConfig,
                      ),
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
                      AppConfigurationFieldChanged(
                        remoteConfig: newConfig,
                      ),
                    );
              },
              buildIntField: _buildIntField,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdConfigSection(BuildContext context, RemoteConfig remoteConfig) {
    final l10n = context.l10n;
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
                      AppConfigurationFieldChanged(
                        remoteConfig: newConfig,
                      ),
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
                      AppConfigurationFieldChanged(
                        remoteConfig: newConfig,
                      ),
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
                      AppConfigurationFieldChanged(
                        remoteConfig: newConfig,
                      ),
                    );
              },
              buildIntField: _buildIntField,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountActionConfigSection(
    BuildContext context,
    RemoteConfig remoteConfig,
  ) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.inAppPromptsDescription,
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
            _AccountActionConfigForm(
              userRole: AppUserRole.guestUser,
              remoteConfig: remoteConfig,
              onConfigChanged: (newConfig) {
                context.read<AppConfigurationBloc>().add(
                      AppConfigurationFieldChanged(
                        remoteConfig: newConfig,
                      ),
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
            _AccountActionConfigForm(
              userRole: AppUserRole.standardUser,
              remoteConfig: remoteConfig,
              onConfigChanged: (newConfig) {
                context.read<AppConfigurationBloc>().add(
                      AppConfigurationFieldChanged(
                        remoteConfig: newConfig,
                      ),
                    );
              },
              buildIntField: _buildIntField,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppStatusSection(
      BuildContext context, RemoteConfig remoteConfig) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.appOperationalStatusWarning,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
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
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
  }) buildIntField;

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
            TextEditingController(text: config.guestFollowedItemsLimit.toString());
        _savedHeadlinesLimitController =
            TextEditingController(text: config.guestSavedHeadlinesLimit.toString());
      case AppUserRole.standardUser:
        _followedItemsLimitController = TextEditingController(
            text: config.authenticatedFollowedItemsLimit.toString());
        _savedHeadlinesLimitController = TextEditingController(
            text: config.authenticatedSavedHeadlinesLimit.toString());
      case AppUserRole.premiumUser:
        _followedItemsLimitController = TextEditingController(
            text: config.premiumFollowedItemsLimit.toString());
        _savedHeadlinesLimitController = TextEditingController(
            text: config.premiumSavedHeadlinesLimit.toString());
    }
  }

  void _updateControllers() {
    final config = widget.remoteConfig.userPreferenceConfig;
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        _followedItemsLimitController.text =
            config.guestFollowedItemsLimit.toString();
        _savedHeadlinesLimitController.text =
            config.guestSavedHeadlinesLimit.toString();
      case AppUserRole.standardUser:
        _followedItemsLimitController.text =
            config.authenticatedFollowedItemsLimit.toString();
        _savedHeadlinesLimitController.text =
            config.authenticatedSavedHeadlinesLimit.toString();
      case AppUserRole.premiumUser:
        _followedItemsLimitController.text =
            config.premiumFollowedItemsLimit.toString();
        _savedHeadlinesLimitController.text =
            config.premiumSavedHeadlinesLimit.toString();
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

    return Column(
      children: [
        widget.buildIntField(
          context,
          label: 'Followed Items Limit',
          description:
              'Maximum number of countries, news sources, or categories this '
              'user role can follow (each type has its own limit).',
          value: _getFollowedItemsLimit(userPreferenceConfig),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                userPreferenceConfig:
                    _updateFollowedItemsLimit(userPreferenceConfig, value),
              ),
            );
          },
          controller: _followedItemsLimitController,
        ),
        widget.buildIntField(
          context,
          label: 'Saved Headlines Limit',
          description:
              'Maximum number of headlines this user role can save.',
          value: _getSavedHeadlinesLimit(userPreferenceConfig),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                userPreferenceConfig:
                    _updateSavedHeadlinesLimit(userPreferenceConfig, value),
              ),
            );
          },
          controller: _savedHeadlinesLimitController,
        ),
      ],
    );
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
      UserPreferenceConfig config, int value) {
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
      UserPreferenceConfig config, int value) {
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
  }) buildIntField;

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
            TextEditingController(text: adConfig.guestAdFrequency.toString());
        _adPlacementIntervalController = TextEditingController(
            text: adConfig.guestAdPlacementInterval.toString());
        _articlesToReadBeforeShowingInterstitialAdsController =
            TextEditingController(
                text: adConfig.guestArticlesToReadBeforeShowingInterstitialAds
                    .toString());
      case AppUserRole.standardUser:
        _adFrequencyController = TextEditingController(
            text: adConfig.authenticatedAdFrequency.toString());
        _adPlacementIntervalController = TextEditingController(
            text: adConfig.authenticatedAdPlacementInterval.toString());
        _articlesToReadBeforeShowingInterstitialAdsController =
            TextEditingController(
                text: adConfig
                    .standardUserArticlesToReadBeforeShowingInterstitialAds
                    .toString());
      case AppUserRole.premiumUser:
        _adFrequencyController =
            TextEditingController(text: adConfig.premiumAdFrequency.toString());
        _adPlacementIntervalController = TextEditingController(
            text: adConfig.premiumAdPlacementInterval.toString());
        _articlesToReadBeforeShowingInterstitialAdsController =
            TextEditingController(
                text: adConfig
                    .premiumUserArticlesToReadBeforeShowingInterstitialAds
                    .toString());
    }
  }

  void _updateControllers() {
    final adConfig = widget.remoteConfig.adConfig;
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        _adFrequencyController.text = adConfig.guestAdFrequency.toString();
        _adPlacementIntervalController.text =
            adConfig.guestAdPlacementInterval.toString();
        _articlesToReadBeforeShowingInterstitialAdsController.text = adConfig
            .guestArticlesToReadBeforeShowingInterstitialAds
            .toString();
      case AppUserRole.standardUser:
        _adFrequencyController.text =
            adConfig.authenticatedAdFrequency.toString();
        _adPlacementIntervalController.text =
            adConfig.authenticatedAdPlacementInterval.toString();
        _articlesToReadBeforeShowingInterstitialAdsController.text = adConfig
            .standardUserArticlesToReadBeforeShowingInterstitialAds
            .toString();
      case AppUserRole.premiumUser:
        _adFrequencyController.text = adConfig.premiumAdFrequency.toString();
        _adPlacementIntervalController.text =
            adConfig.premiumAdPlacementInterval.toString();
        _articlesToReadBeforeShowingInterstitialAdsController.text = adConfig
            .premiumUserArticlesToReadBeforeShowingInterstitialAds
            .toString();
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

    return Column(
      children: [
        widget.buildIntField(
          context,
          label: 'Ad Frequency',
          description:
              'How often an ad can appear for this user role (e.g., a value '
              'of 5 means an ad could be placed after every 5 news items).',
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
          label: 'Ad Placement Interval',
          description:
              'Minimum number of news items that must be shown before the '
              'very first ad appears for this user role.',
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
          label: 'Articles Before Interstitial Ads',
          description:
              'Number of articles this user role needs to read before a '
              'full-screen interstitial ad is shown.',
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
            guestArticlesToReadBeforeShowingInterstitialAds: value);
      case AppUserRole.standardUser:
        return config.copyWith(
            standardUserArticlesToReadBeforeShowingInterstitialAds: value);
      case AppUserRole.premiumUser:
        return config.copyWith(
            premiumUserArticlesToReadBeforeShowingInterstitialAds: value);
    }
  }
}

class _AccountActionConfigForm extends StatefulWidget {
  const _AccountActionConfigForm({
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
  }) buildIntField;

  @override
  State<_AccountActionConfigForm> createState() =>
      _AccountActionConfigFormState();
}

class _AccountActionConfigFormState extends State<_AccountActionConfigForm> {
  late final Map<FeedActionType, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant _AccountActionConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.accountActionConfig !=
        oldWidget.remoteConfig.accountActionConfig) {
      _updateControllers();
    }
  }

  Map<FeedActionType, TextEditingController> _initializeControllers() {
    final config = widget.remoteConfig.accountActionConfig;
    final daysMap = _getDaysMap(config);
    return {
      for (final type in FeedActionType.values)
        type: TextEditingController(text: (daysMap[type] ?? 0).toString()),
    };
  }

  void _updateControllers() {
    final config = widget.remoteConfig.accountActionConfig;
    final daysMap = _getDaysMap(config);
    for (final type in FeedActionType.values) {
      _controllers[type]?.text = (daysMap[type] ?? 0).toString();
    }
  }

  Map<FeedActionType, int> _getDaysMap(AccountActionConfig config) {
    switch (widget.userRole) {
      case AppUserRole.guestUser:
        return config.guestDaysBetweenActions;
      case AppUserRole.standardUser:
        return config.standardUserDaysBetweenActions;
      case AppUserRole.premiumUser:
        return {};
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _formatLabel(String enumName) {
    // Converts camelCase to Title Case
    final spaced = enumName.replaceAllMapped(
        RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}');
    return '${spaced[0].toUpperCase()}${spaced.substring(1)} Days';
  }

  @override
  Widget build(BuildContext context) {
    final accountActionConfig = widget.remoteConfig.accountActionConfig;
    final relevantActionTypes =
        _getDaysMap(accountActionConfig).keys.toList();

    return Column(
      children: relevantActionTypes.map((actionType) {
        return widget.buildIntField(
          context,
          label: _formatLabel(actionType.name),
          description:
              'Minimum number of days before showing the ${actionType.name} prompt.',
          value: _getDaysMap(accountActionConfig)[actionType] ?? 0,
          onChanged: (value) {
            final currentMap = _getDaysMap(accountActionConfig);
            final updatedMap = Map<FeedActionType, int>.from(currentMap)
              ..[actionType] = value;

            final newConfig = widget.userRole == AppUserRole.guestUser
                ? accountActionConfig.copyWith(
                    guestDaysBetweenActions: updatedMap)
                : accountActionConfig.copyWith(
                    standardUserDaysBetweenActions: updatedMap);

            widget.onConfigChanged(
              widget.remoteConfig.copyWith(accountActionConfig: newConfig),
            );
          },
          controller: _controllers[actionType],
        );
      }).toList(),
    );
  }
}
