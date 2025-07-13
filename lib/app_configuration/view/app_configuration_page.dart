import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_dashboard/app_configuration/bloc/app_configuration_bloc.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/shared/constants/app_spacing.dart';
import 'package:ht_dashboard/shared/widgets/widgets.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:ht_shared/src/enums/app_user_role.dart';

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
          } else if (state.status == AppConfigurationStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.appConfigSaveErrorMessage(
                      state.errorMessage ?? l10n.unknownError,
                    ),
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
              message:
                  state.errorMessage ?? l10n.failedToLoadConfigurationMessage,
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
              userRole: AppUserRole.guestUser.name,
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
              userRole: AppUserRole.standardUser.name,
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
              userRole: AppUserRole.premiumUser.name,
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
              userRole: AppUserRole.guestUser.name,
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
              userRole: AppUserRole.standardUser.name,
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
              userRole: AppUserRole.premiumUser.name,
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
              userRole: AppUserRole.guestUser.name,
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
              userRole: AppUserRole.standardUser.name,
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

  Widget _buildAppStatusSection(BuildContext context, RemoteConfig remoteConfig) {
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
          _buildDropdownField<AppStatus>(
            context,
            label: l10n.appOperationalStatusLabel,
            description: l10n.appOperationalStatusDescription,
            value: remoteConfig.appStatus,
            items: const [], // AppStatus is a model, not an enum
            itemLabelBuilder: (status) => status.isUnderMaintenance
                ? l10n.appStatusMaintenance
                : l10n.appStatusOperational,
            onChanged: (value) {
              if (value != null) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(
                    remoteConfig: remoteConfig.copyWith(appStatus: value),
                  ),
                );
              }
            },
          ),
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
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: controller,
            initialValue: controller == null
                ? value.toString()
                : null,
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
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: controller,
            initialValue: controller == null
                ? value
                : null,
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

  Widget _buildDropdownField<T>(
    BuildContext context, {
    required String label,
    required String description,
    required T value,
    required List<T> items,
    required String Function(T) itemLabelBuilder,
    required ValueChanged<T?> onChanged,
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
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<T>(
            value: value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(itemLabelBuilder(item)),
              );
            }).toList(),
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

  final String userRole;
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
  late final TextEditingController _guestFollowedItemsLimitController;
  late final TextEditingController _guestSavedHeadlinesLimitController;
  late final TextEditingController _authenticatedFollowedItemsLimitController;
  late final TextEditingController _authenticatedSavedHeadlinesLimitController;
  late final TextEditingController _premiumFollowedItemsLimitController;
  late final TextEditingController _premiumSavedHeadlinesLimitController;

  @override
  void initState() {
    super.initState();
    _guestFollowedItemsLimitController = TextEditingController(
      text: widget.remoteConfig.userPreferenceConfig.guestFollowedItemsLimit
          .toString(),
    );
    _guestSavedHeadlinesLimitController = TextEditingController(
      text: widget.remoteConfig.userPreferenceConfig.guestSavedHeadlinesLimit
          .toString(),
    );
    _authenticatedFollowedItemsLimitController = TextEditingController(
      text: widget
          .remoteConfig
          .userPreferenceConfig
          .authenticatedFollowedItemsLimit
          .toString(),
    );
    _authenticatedSavedHeadlinesLimitController = TextEditingController(
      text: widget
          .remoteConfig
          .userPreferenceConfig
          .authenticatedSavedHeadlinesLimit
          .toString(),
    );
    _premiumFollowedItemsLimitController = TextEditingController(
      text: widget.remoteConfig.userPreferenceConfig.premiumFollowedItemsLimit
          .toString(),
    );
    _premiumSavedHeadlinesLimitController = TextEditingController(
      text: widget.remoteConfig.userPreferenceConfig.premiumSavedHeadlinesLimit
          .toString(),
    );
  }

  @override
  void didUpdateWidget(covariant _UserPreferenceLimitsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.userPreferenceConfig !=
        oldWidget.remoteConfig.userPreferenceConfig) {
      _guestFollowedItemsLimitController.value = TextEditingValue(
        text: widget.remoteConfig.userPreferenceConfig.guestFollowedItemsLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget.remoteConfig.userPreferenceConfig.guestFollowedItemsLimit
              .toString()
              .length,
        ),
      );
      _guestSavedHeadlinesLimitController.value = TextEditingValue(
        text: widget.remoteConfig.userPreferenceConfig.guestSavedHeadlinesLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget.remoteConfig.userPreferenceConfig.guestSavedHeadlinesLimit
              .toString()
              .length,
        ),
      );
      _authenticatedFollowedItemsLimitController.value = TextEditingValue(
        text: widget
            .remoteConfig
            .userPreferenceConfig
            .authenticatedFollowedItemsLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .remoteConfig
              .userPreferenceConfig
              .authenticatedFollowedItemsLimit
              .toString()
              .length,
        ),
      );
      _authenticatedSavedHeadlinesLimitController.value = TextEditingValue(
        text: widget
            .remoteConfig
            .userPreferenceConfig
            .authenticatedSavedHeadlinesLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .remoteConfig
              .userPreferenceConfig
              .authenticatedSavedHeadlinesLimit
              .toString()
              .length,
        ),
      );
      _premiumFollowedItemsLimitController.value = TextEditingValue(
        text: widget.remoteConfig.userPreferenceConfig.premiumFollowedItemsLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .remoteConfig
              .userPreferenceConfig
              .premiumFollowedItemsLimit
              .toString()
              .length,
        ),
      );
      _premiumSavedHeadlinesLimitController.value = TextEditingValue(
        text: widget.remoteConfig.userPreferenceConfig.premiumSavedHeadlinesLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .remoteConfig
              .userPreferenceConfig
              .premiumSavedHeadlinesLimit
              .toString()
              .length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _guestFollowedItemsLimitController.dispose();
    _guestSavedHeadlinesLimitController.dispose();
    _authenticatedFollowedItemsLimitController.dispose();
    _authenticatedSavedHeadlinesLimitController.dispose();
    _premiumFollowedItemsLimitController.dispose();
    _premiumSavedHeadlinesLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userPreferenceConfig = widget.remoteConfig.userPreferenceConfig;

    switch (AppUserRole.values.byName(widget.userRole)) {
      case AppUserRole.guestUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Guest Followed Items Limit',
              description:
                  'Maximum number of countries, news sources, or categories a '
                  'Guest user can follow (each type has its own limit).',
              value: userPreferenceConfig.guestFollowedItemsLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    userPreferenceConfig: userPreferenceConfig.copyWith(
                      guestFollowedItemsLimit: value,
                    ),
                  ),
                );
              },
              controller: _guestFollowedItemsLimitController,
            ),
            widget.buildIntField(
              context,
              label: 'Guest Saved Headlines Limit',
              description: 'Maximum number of headlines a Guest user can save.',
              value: userPreferenceConfig.guestSavedHeadlinesLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    userPreferenceConfig: userPreferenceConfig.copyWith(
                      guestSavedHeadlinesLimit: value,
                    ),
                  ),
                );
              },
              controller: _guestSavedHeadlinesLimitController,
            ),
          ],
        );
      case AppUserRole.standardUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Standard User Followed Items Limit',
              description:
                  'Maximum number of countries, news sources, or categories a '
                  'Standard user can follow (each type has its own limit).',
              value: userPreferenceConfig.authenticatedFollowedItemsLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    userPreferenceConfig: userPreferenceConfig.copyWith(
                      authenticatedFollowedItemsLimit: value,
                    ),
                  ),
                );
              },
              controller: _authenticatedFollowedItemsLimitController,
            ),
            widget.buildIntField(
              context,
              label: 'Standard User Saved Headlines Limit',
              description:
                  'Maximum number of headlines a Standard user can save.',
              value: userPreferenceConfig.authenticatedSavedHeadlinesLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    userPreferenceConfig: userPreferenceConfig.copyWith(
                      authenticatedSavedHeadlinesLimit: value,
                    ),
                  ),
                );
              },
              controller: _authenticatedSavedHeadlinesLimitController,
            ),
          ],
        );
      case AppUserRole.premiumUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Premium Followed Items Limit',
              description:
                  'Maximum number of countries, news sources, or categories a '
                  'Premium user can follow (each type has its own limit).',
              value: userPreferenceConfig.premiumFollowedItemsLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    userPreferenceConfig: userPreferenceConfig.copyWith(
                      premiumFollowedItemsLimit: value,
                    ),
                  ),
                );
              },
              controller: _premiumFollowedItemsLimitController,
            ),
            widget.buildIntField(
              context,
              label: 'Premium Saved Headlines Limit',
              description:
                  'Maximum number of headlines a Premium user can save.',
              value: userPreferenceConfig.premiumSavedHeadlinesLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    userPreferenceConfig: userPreferenceConfig.copyWith(
                      premiumSavedHeadlinesLimit: value,
                    ),
                  ),
                );
              },
              controller: _premiumSavedHeadlinesLimitController,
            ),
          ],
        );
      case AppUserRole.none:
      case AppUserRole.admin: // Assuming admin doesn't have specific limits here
      case AppUserRole.publisher: // Assuming publisher doesn't have specific limits here
        return const SizedBox.shrink();
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

  final String userRole;
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
  late final TextEditingController _guestAdFrequencyController;
  late final TextEditingController _guestAdPlacementIntervalController;
  late final TextEditingController
  _guestArticlesToReadBeforeShowingInterstitialAdsController;
  late final TextEditingController _authenticatedAdFrequencyController;
  late final TextEditingController _authenticatedAdPlacementIntervalController;
  late final TextEditingController
  _standardUserArticlesToReadBeforeShowingInterstitialAdsController;
  late final TextEditingController _premiumAdFrequencyController;
  late final TextEditingController _premiumAdPlacementIntervalController;
  late final TextEditingController
  _premiumUserArticlesToReadBeforeShowingInterstitialAdsController;

  @override
  void initState() {
    super.initState();
    _guestAdFrequencyController = TextEditingController(
      text: widget.remoteConfig.adConfig.guestAdFrequency.toString(),
    );
    _guestAdPlacementIntervalController = TextEditingController(
      text: widget.remoteConfig.adConfig.guestAdPlacementInterval.toString(),
    );
    _guestArticlesToReadBeforeShowingInterstitialAdsController =
        TextEditingController(
          text: widget
              .remoteConfig
              .adConfig
              .guestArticlesToReadBeforeShowingInterstitialAds
              .toString(),
        );
    _authenticatedAdFrequencyController = TextEditingController(
      text: widget.remoteConfig.adConfig.authenticatedAdFrequency.toString(),
    );
    _authenticatedAdPlacementIntervalController = TextEditingController(
      text: widget.remoteConfig.adConfig.authenticatedAdPlacementInterval
          .toString(),
    );
    _standardUserArticlesToReadBeforeShowingInterstitialAdsController =
        TextEditingController(
          text: widget
              .remoteConfig
              .adConfig
              .standardUserArticlesToReadBeforeShowingInterstitialAds
              .toString(),
        );
    _premiumAdFrequencyController = TextEditingController(
      text: widget.remoteConfig.adConfig.premiumAdFrequency.toString(),
    );
    _premiumAdPlacementIntervalController = TextEditingController(
      text: widget.remoteConfig.adConfig.premiumAdPlacementInterval.toString(),
    );
    _premiumUserArticlesToReadBeforeShowingInterstitialAdsController =
        TextEditingController(
          text: widget
              .remoteConfig
              .adConfig
              .premiumUserArticlesToReadBeforeShowingInterstitialAds
              .toString(),
        );
  }

  @override
  void didUpdateWidget(covariant _AdConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.adConfig != oldWidget.remoteConfig.adConfig) {
      _guestAdFrequencyController.value = TextEditingValue(
        text: widget.remoteConfig.adConfig.guestAdFrequency.toString(),
        selection: TextSelection.collapsed(
          offset: widget.remoteConfig.adConfig.guestAdFrequency.toString().length,
        ),
      );
      _guestAdPlacementIntervalController.value = TextEditingValue(
        text: widget.remoteConfig.adConfig.guestAdPlacementInterval.toString(),
        selection: TextSelection.collapsed(
          offset: widget.remoteConfig.adConfig.guestAdPlacementInterval
              .toString()
              .length,
        ),
      );
      _guestArticlesToReadBeforeShowingInterstitialAdsController.value =
          TextEditingValue(
            text: widget
                .remoteConfig
                .adConfig
                .guestArticlesToReadBeforeShowingInterstitialAds
                .toString(),
            selection: TextSelection.collapsed(
              offset: widget
                  .remoteConfig
                  .adConfig
                  .guestArticlesToReadBeforeShowingInterstitialAds
                  .toString()
                  .length,
            ),
          );
      _authenticatedAdFrequencyController.value = TextEditingValue(
        text: widget.remoteConfig.adConfig.authenticatedAdFrequency.toString(),
        selection: TextSelection.collapsed(
          offset: widget.remoteConfig.adConfig.authenticatedAdFrequency
              .toString()
              .length,
        ),
      );
      _authenticatedAdPlacementIntervalController.value = TextEditingValue(
        text: widget.remoteConfig.adConfig.authenticatedAdPlacementInterval
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget.remoteConfig.adConfig.authenticatedAdPlacementInterval
              .toString()
              .length,
        ),
      );
      _standardUserArticlesToReadBeforeShowingInterstitialAdsController.value =
          TextEditingValue(
            text: widget
                .remoteConfig
                .adConfig
                .standardUserArticlesToReadBeforeShowingInterstitialAds
                .toString(),
            selection: TextSelection.collapsed(
              offset: widget
                  .remoteConfig
                  .adConfig
                  .standardUserArticlesToReadBeforeShowingInterstitialAds
                  .toString()
                  .length,
            ),
          );
      _premiumAdFrequencyController.value = TextEditingValue(
        text: widget.remoteConfig.adConfig.premiumAdFrequency.toString(),
        selection: TextSelection.collapsed(
          offset: widget.remoteConfig.adConfig.premiumAdFrequency
              .toString()
              .length,
        ),
      );
      _premiumAdPlacementIntervalController.value = TextEditingValue(
        text: widget.remoteConfig.adConfig.premiumAdPlacementInterval.toString(),
        selection: TextSelection.collapsed(
          offset: widget.remoteConfig.adConfig.premiumAdPlacementInterval
              .toString()
              .length,
        ),
      );
      _premiumUserArticlesToReadBeforeShowingInterstitialAdsController.value =
          TextEditingValue(
            text: widget
                .remoteConfig
                .adConfig
                .premiumUserArticlesToReadBeforeShowingInterstitialAds
                .toString(),
            selection: TextSelection.collapsed(
              offset: widget
                  .remoteConfig
                  .adConfig
                  .premiumUserArticlesToReadBeforeShowingInterstitialAds
                  .toString()
                  .length,
            ),
          );
    }
  }

  @override
  void dispose() {
    _guestAdFrequencyController.dispose();
    _guestAdPlacementIntervalController.dispose();
    _guestArticlesToReadBeforeShowingInterstitialAdsController.dispose();
    _authenticatedAdFrequencyController.dispose();
    _authenticatedAdPlacementIntervalController.dispose();
    _standardUserArticlesToReadBeforeShowingInterstitialAdsController.dispose();
    _premiumAdFrequencyController.dispose();
    _premiumAdPlacementIntervalController.dispose();
    _premiumUserArticlesToReadBeforeShowingInterstitialAdsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adConfig = widget.remoteConfig.adConfig;

    switch (AppUserRole.values.byName(widget.userRole)) {
      case AppUserRole.guestUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Guest Ad Frequency',
              description:
                  'How often an ad can appear for Guest users (e.g., a value '
                  'of 5 means an ad could be placed after every 5 news items).',
              value: adConfig.guestAdFrequency,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    adConfig: adConfig.copyWith(guestAdFrequency: value),
                  ),
                );
              },
              controller: _guestAdFrequencyController,
            ),
            widget.buildIntField(
              context,
              label: 'Guest Ad Placement Interval',
              description:
                  'Minimum number of news items that must be shown before the '
                  'very first ad appears for Guest users.',
              value: adConfig.guestAdPlacementInterval,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      guestAdPlacementInterval: value,
                    ),
                  ),
                );
              },
              controller: _guestAdPlacementIntervalController,
            ),
            widget.buildIntField(
              context,
              label: 'Guest Articles Before Interstitial Ads',
              description:
                  'Number of articles a Guest user needs to read before a '
                  'full-screen interstitial ad is shown.',
              value: adConfig.guestArticlesToReadBeforeShowingInterstitialAds,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      guestArticlesToReadBeforeShowingInterstitialAds: value,
                    ),
                  ),
                );
              },
              controller:
                  _guestArticlesToReadBeforeShowingInterstitialAdsController,
            ),
          ],
        );
      case AppUserRole.standardUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Standard User Ad Frequency',
              description:
                  'How often an ad can appear for Standard users (e.g., a value '
                  'of 10 means an ad could be placed after every 10 news items).',
              value: adConfig.authenticatedAdFrequency,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      authenticatedAdFrequency: value,
                    ),
                  ),
                );
              },
              controller: _authenticatedAdFrequencyController,
            ),
            widget.buildIntField(
              context,
              label: 'Standard User Ad Placement Interval',
              description:
                  'Minimum number of news items that must be shown before the '
                  'very first ad appears for Standard users.',
              value: adConfig.authenticatedAdPlacementInterval,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      authenticatedAdPlacementInterval: value,
                    ),
                  ),
                );
              },
              controller: _authenticatedAdPlacementIntervalController,
            ),
            widget.buildIntField(
              context,
              label: 'Standard User Articles Before Interstitial Ads',
              description:
                  'Number of articles a Standard user needs to read before a '
                  'full-screen interstitial ad is shown.',
              value: adConfig
                  .standardUserArticlesToReadBeforeShowingInterstitialAds,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      standardUserArticlesToReadBeforeShowingInterstitialAds:
                          value,
                    ),
                  ),
                );
              },
              controller:
                  _standardUserArticlesToReadBeforeShowingInterstitialAdsController,
            ),
          ],
        );
      case AppUserRole.premiumUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Premium Ad Frequency',
              description:
                  'How often an ad can appear for Premium users (0 for no ads).',
              value: adConfig.premiumAdFrequency,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    adConfig: adConfig.copyWith(premiumAdFrequency: value),
                  ),
                );
              },
              controller: _premiumAdFrequencyController,
            ),
            widget.buildIntField(
              context,
              label: 'Premium Ad Placement Interval',
              description:
                  'Minimum number of news items that must be shown before the '
                  'very first ad appears for Premium users.',
              value: adConfig.premiumAdPlacementInterval,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      premiumAdPlacementInterval: value,
                    ),
                  ),
                );
              },
              controller: _premiumAdPlacementIntervalController,
            ),
            widget.buildIntField(
              context,
              label: 'Premium User Articles Before Interstitial Ads',
              description:
                  'Number of articles a Premium user needs to read before a '
                  'full-screen interstitial ad is shown.',
              value: adConfig
                  .premiumUserArticlesToReadBeforeShowingInterstitialAds,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      premiumUserArticlesToReadBeforeShowingInterstitialAds:
                          value,
                    ),
                  ),
                );
              },
              controller:
                  _premiumUserArticlesToReadBeforeShowingInterstitialAdsController,
            ),
          ],
        );
      case AppUserRole.none:
      case AppUserRole.admin:
      case AppUserRole.publisher:
        return const SizedBox.shrink();
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

  final String userRole;
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
  State<_AccountActionConfigForm> createState() =>
      _AccountActionConfigFormState();
}

class _AccountActionConfigFormState extends State<_AccountActionConfigForm> {
  late final TextEditingController _guestDaysBetweenAccountActionsController;
  late final TextEditingController
  _standardUserDaysBetweenAccountActionsController;

  @override
  void initState() {
    super.initState();
    _guestDaysBetweenAccountActionsController = TextEditingController(
      text: widget.remoteConfig.accountActionConfig.guestDaysBetweenActions
          .toString(),
    );
    _standardUserDaysBetweenAccountActionsController = TextEditingController(
      text: widget
          .remoteConfig
          .accountActionConfig
          .standardUserDaysBetweenActions
          .toString(),
    );
  }

  @override
  void didUpdateWidget(covariant _AccountActionConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.accountActionConfig !=
        oldWidget.remoteConfig.accountActionConfig) {
      _guestDaysBetweenAccountActionsController.value = TextEditingValue(
        text: widget
            .remoteConfig
            .accountActionConfig
            .guestDaysBetweenActions
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .remoteConfig
              .accountActionConfig
              .guestDaysBetweenActions
              .toString()
              .length,
        ),
      );
      _standardUserDaysBetweenAccountActionsController.value = TextEditingValue(
        text: widget
            .remoteConfig
            .accountActionConfig
            .standardUserDaysBetweenActions
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .remoteConfig
              .accountActionConfig
              .standardUserDaysBetweenActions
              .toString()
              .length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _guestDaysBetweenAccountActionsController.dispose();
    _standardUserDaysBetweenAccountActionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountActionConfig = widget.remoteConfig.accountActionConfig;

    switch (AppUserRole.values.byName(widget.userRole)) {
      case AppUserRole.guestUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Guest Days Between In-App Prompts',
              description:
                  'Minimum number of days that must pass before a Guest user '
                  'sees another in-app prompt.',
              value: accountActionConfig.guestDaysBetweenActions[FeedActionType.linkAccount] ?? 0,
              onChanged: (value) {
                final updatedMap = Map<FeedActionType, int>.from(
                  accountActionConfig.guestDaysBetweenActions,
                );
                updatedMap[FeedActionType.linkAccount] = value;
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    accountActionConfig: accountActionConfig.copyWith(
                      guestDaysBetweenActions: updatedMap,
                    ),
                  ),
                );
              },
              controller: _guestDaysBetweenAccountActionsController,
            ),
          ],
        );
      case AppUserRole.standardUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Standard User Days Between In-App Prompts',
              description:
                  'Minimum number of days that must pass before a Standard user '
                  'sees another in-app prompt.',
              value: accountActionConfig.standardUserDaysBetweenActions[FeedActionType.linkAccount] ?? 0,
              onChanged: (value) {
                final updatedMap = Map<FeedActionType, int>.from(
                  accountActionConfig.standardUserDaysBetweenActions,
                );
                updatedMap[FeedActionType.linkAccount] = value;
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    accountActionConfig: accountActionConfig.copyWith(
                      standardUserDaysBetweenActions: updatedMap,
                    ),
                  ),
                );
              },
              controller: _standardUserDaysBetweenAccountActionsController,
            ),
          ],
        );
      case AppUserRole.premiumUser:
      case AppUserRole.admin:
      case AppUserRole.publisher:
        return const SizedBox.shrink();
    }
  }
}
