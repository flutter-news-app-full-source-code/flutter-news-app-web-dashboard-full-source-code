import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_dashboard/app_configuration/bloc/app_configuration_bloc.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/shared/constants/app_spacing.dart';
import 'package:ht_dashboard/shared/widgets/widgets.dart';
import 'package:ht_shared/ht_shared.dart'; // For AppConfig and its nested models

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
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
    ); // 5 tabs for AppConfig properties
    context.read<AppConfigurationBloc>().add(const AppConfigurationLoaded());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.appConfigurationPageTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: context.l10n.userContentLimitsTab),
            Tab(text: context.l10n.adSettingsTab),
            Tab(text: context.l10n.inAppPromptsTab),
            Tab(text: context.l10n.appOperationalStatusTab),
            Tab(text: context.l10n.forceUpdateTab),
          ],
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
                    context.l10n.appConfigSaveSuccessMessage,
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
                    context.l10n.appConfigSaveErrorMessage(
                      state.errorMessage ?? context.l10n.unknownError,
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
              headline: context.l10n.loadingConfigurationHeadline,
              subheadline: context.l10n.loadingConfigurationSubheadline,
            );
          } else if (state.status == AppConfigurationStatus.failure) {
            return FailureStateWidget(
              message:
                  state.errorMessage ??
                  context.l10n.failedToLoadConfigurationMessage,
              onRetry: () {
                context.read<AppConfigurationBloc>().add(
                  const AppConfigurationLoaded(),
                );
              },
            );
          } else if (state.status == AppConfigurationStatus.success &&
              state.appConfig != null) {
            final appConfig = state.appConfig!;
            return TabBarView(
              controller: _tabController,
              children: [
                _buildUserPreferenceLimitsTab(context, appConfig),
                _buildAdConfigTab(context, appConfig),
                _buildAccountActionConfigTab(context, appConfig),
                _buildKillSwitchTab(context, appConfig),
                _buildForceUpdateTab(context, appConfig),
              ],
            );
          }
          return InitialStateWidget(
            icon: Icons.settings_applications_outlined,
            headline: context.l10n.appConfigurationPageTitle,
            subheadline: context.l10n.loadAppSettingsSubheadline,
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
    final appConfig = context.select(
      (AppConfigurationBloc bloc) => bloc.state.appConfig,
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
                      if (confirmed && appConfig != null) {
                        context.read<AppConfigurationBloc>().add(
                          AppConfigurationUpdated(appConfig),
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

  Widget _buildUserPreferenceLimitsTab(
    BuildContext context,
    AppConfig appConfig,
  ) {
    return DefaultTabController(
      length: 3, // Guest, Authenticated, Premium
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.userContentLimitsTab,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.userContentLimitsDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TabBar(
              tabs: [
                Tab(text: context.l10n.guestUserTab),
                Tab(text: context.l10n.authenticatedUserTab),
                Tab(text: context.l10n.premiumUserTab),
              ],
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 400, // Adjust height as needed
              child: TabBarView(
                children: [
                  _UserPreferenceLimitsForm(
                    userRole: UserRole.guestUser,
                    appConfig: appConfig,
                    onConfigChanged: (newConfig) {
                      context.read<AppConfigurationBloc>().add(
                        AppConfigurationFieldChanged(
                          appConfig: newConfig,
                        ),
                      );
                    },
                    buildIntField: _buildIntField,
                  ),
                  _UserPreferenceLimitsForm(
                    userRole: UserRole.standardUser,
                    appConfig: appConfig,
                    onConfigChanged: (newConfig) {
                      context.read<AppConfigurationBloc>().add(
                        AppConfigurationFieldChanged(
                          appConfig: newConfig,
                        ),
                      );
                    },
                    buildIntField: _buildIntField,
                  ),
                  _UserPreferenceLimitsForm(
                    userRole: UserRole.premiumUser,
                    appConfig: appConfig,
                    onConfigChanged: (newConfig) {
                      context.read<AppConfigurationBloc>().add(
                        AppConfigurationFieldChanged(
                          appConfig: newConfig,
                        ),
                      );
                    },
                    buildIntField: _buildIntField,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdConfigTab(BuildContext context, AppConfig appConfig) {
    return DefaultTabController(
      length: 3, // Guest, Authenticated, Premium
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.adSettingsTab,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.adSettingsDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TabBar(
              tabs: [
                Tab(text: context.l10n.guestUserTab),
                Tab(text: context.l10n.standardUserAdTab),
                Tab(text: context.l10n.premiumUserTab),
              ],
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 600, // Adjust height as needed
              child: TabBarView(
                children: [
                  _AdConfigForm(
                    userRole: UserRole.guestUser,
                    appConfig: appConfig,
                    onConfigChanged: (newConfig) {
                      context.read<AppConfigurationBloc>().add(
                        AppConfigurationFieldChanged(
                          appConfig: newConfig,
                        ),
                      );
                    },
                    buildIntField: _buildIntField,
                  ),
                  _AdConfigForm(
                    userRole: UserRole.standardUser,
                    appConfig: appConfig,
                    onConfigChanged: (newConfig) {
                      context.read<AppConfigurationBloc>().add(
                        AppConfigurationFieldChanged(
                          appConfig: newConfig,
                        ),
                      );
                    },
                    buildIntField: _buildIntField,
                  ),
                  _AdConfigForm(
                    userRole: UserRole.premiumUser,
                    appConfig: appConfig,
                    onConfigChanged: (newConfig) {
                      context.read<AppConfigurationBloc>().add(
                        AppConfigurationFieldChanged(
                          appConfig: newConfig,
                        ),
                      );
                    },
                    buildIntField: _buildIntField,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActionConfigTab(
    BuildContext context,
    AppConfig appConfig,
  ) {
    return DefaultTabController(
      length: 2, // Guest, Standard User
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.inAppPromptsTab,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.inAppPromptsDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TabBar(
              tabs: [
                Tab(text: context.l10n.guestUserTab),
                Tab(text: context.l10n.standardUserAdTab),
              ],
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200, // Adjust height as needed
              child: TabBarView(
                children: [
                  _AccountActionConfigForm(
                    userRole: UserRole.guestUser,
                    appConfig: appConfig,
                    onConfigChanged: (newConfig) {
                      context.read<AppConfigurationBloc>().add(
                        AppConfigurationFieldChanged(
                          appConfig: newConfig,
                        ),
                      );
                    },
                    buildIntField: _buildIntField,
                  ),
                  _AccountActionConfigForm(
                    userRole: UserRole.standardUser,
                    appConfig: appConfig,
                    onConfigChanged: (newConfig) {
                      context.read<AppConfigurationBloc>().add(
                        AppConfigurationFieldChanged(
                          appConfig: newConfig,
                        ),
                      );
                    },
                    buildIntField: _buildIntField,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKillSwitchTab(BuildContext context, AppConfig appConfig) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appOperationalStatusTab,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.appOperationalStatusWarning,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildDropdownField<RemoteAppStatus>(
            context,
            label: context.l10n.appOperationalStatusLabel,
            description: context.l10n.appOperationalStatusDescription,
            value: appConfig.appOperationalStatus,
            items: RemoteAppStatus.values,
            itemLabelBuilder: (status) => status.name,
            onChanged: (value) {
              if (value != null) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(
                    appConfig: appConfig.copyWith(appOperationalStatus: value),
                  ),
                );
              }
            },
          ),
          if (appConfig.appOperationalStatus == RemoteAppStatus.maintenance)
            _buildTextField(
              context,
              label: context.l10n.maintenanceMessageLabel,
              description: context.l10n.maintenanceMessageDescription,
              value: appConfig.maintenanceMessage,
              onChanged: (value) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(
                    appConfig: appConfig.copyWith(maintenanceMessage: value),
                  ),
                );
              },
            ),
          if (appConfig.appOperationalStatus == RemoteAppStatus.disabled)
            _buildTextField(
              context,
              label: context.l10n.disabledMessageLabel,
              description: context.l10n.disabledMessageDescription,
              value: appConfig.disabledMessage,
              onChanged: (value) {
                context.read<AppConfigurationBloc>().add(
                  AppConfigurationFieldChanged(
                    appConfig: appConfig.copyWith(disabledMessage: value),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildForceUpdateTab(BuildContext context, AppConfig appConfig) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.forceUpdateConfigurationTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.forceUpdateDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildTextField(
            context,
            label: context.l10n.minAllowedAppVersionLabel,
            description: context.l10n.minAllowedAppVersionDescription,
            value: appConfig.minAllowedAppVersion,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(minAllowedAppVersion: value),
                ),
              );
            },
          ),
          _buildTextField(
            context,
            label: context.l10n.latestAppVersionLabel,
            description: context.l10n.latestAppVersionDescription,
            value: appConfig.latestAppVersion,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(latestAppVersion: value),
                ),
              );
            },
          ),
          _buildTextField(
            context,
            label: context.l10n.updateRequiredMessageLabel,
            description: context.l10n.updateRequiredMessageDescription,
            value: appConfig.updateRequiredMessage,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(updateRequiredMessage: value),
                ),
              );
            },
          ),
          _buildTextField(
            context,
            label: context.l10n.updateOptionalMessageLabel,
            description: context.l10n.updateOptionalMessageDescription,
            value: appConfig.updateOptionalMessage,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(updateOptionalMessage: value),
                ),
              );
            },
          ),
          _buildTextField(
            context,
            label: context.l10n.iosStoreUrlLabel,
            description: context.l10n.iosStoreUrlDescription,
            value: appConfig.iosStoreUrl,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(iosStoreUrl: value),
                ),
              );
            },
          ),
          _buildTextField(
            context,
            label: context.l10n.androidStoreUrlLabel,
            description: context.l10n.androidStoreUrlDescription,
            value: appConfig.androidStoreUrl,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(androidStoreUrl: value),
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
    TextEditingController? controller, // Add controller parameter
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
            controller: controller, // Use controller
            initialValue: controller == null
                ? value.toString()
                : null, // Only use initialValue if no controller
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
    TextEditingController? controller, // Add controller parameter
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
            controller: controller, // Use controller
            initialValue: controller == null
                ? value
                : null, // Only use initialValue if no controller
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

  Widget _buildSwitchField(
    BuildContext context, {
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
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
          SwitchListTile(
            title: Text(label),
            value: value,
            onChanged: onChanged,
            contentPadding: EdgeInsets.zero,
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
    required this.appConfig,
    required this.onConfigChanged,
    required this.buildIntField,
  });

  final UserRole userRole;
  final AppConfig appConfig;
  final ValueChanged<AppConfig> onConfigChanged;
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
      text: widget.appConfig.userPreferenceLimits.guestFollowedItemsLimit
          .toString(),
    );
    _guestSavedHeadlinesLimitController = TextEditingController(
      text: widget.appConfig.userPreferenceLimits.guestSavedHeadlinesLimit
          .toString(),
    );
    _authenticatedFollowedItemsLimitController = TextEditingController(
      text: widget
          .appConfig
          .userPreferenceLimits
          .authenticatedFollowedItemsLimit
          .toString(),
    );
    _authenticatedSavedHeadlinesLimitController = TextEditingController(
      text: widget
          .appConfig
          .userPreferenceLimits
          .authenticatedSavedHeadlinesLimit
          .toString(),
    );
    _premiumFollowedItemsLimitController = TextEditingController(
      text: widget.appConfig.userPreferenceLimits.premiumFollowedItemsLimit
          .toString(),
    );
    _premiumSavedHeadlinesLimitController = TextEditingController(
      text: widget.appConfig.userPreferenceLimits.premiumSavedHeadlinesLimit
          .toString(),
    );
  }

  @override
  void didUpdateWidget(covariant _UserPreferenceLimitsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.appConfig.userPreferenceLimits !=
        oldWidget.appConfig.userPreferenceLimits) {
      _guestFollowedItemsLimitController.value = TextEditingValue(
        text: widget.appConfig.userPreferenceLimits.guestFollowedItemsLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget.appConfig.userPreferenceLimits.guestFollowedItemsLimit
              .toString()
              .length,
        ),
      );
      _guestSavedHeadlinesLimitController.value = TextEditingValue(
        text: widget.appConfig.userPreferenceLimits.guestSavedHeadlinesLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget.appConfig.userPreferenceLimits.guestSavedHeadlinesLimit
              .toString()
              .length,
        ),
      );
      _authenticatedFollowedItemsLimitController.value = TextEditingValue(
        text: widget
            .appConfig
            .userPreferenceLimits
            .authenticatedFollowedItemsLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .appConfig
              .userPreferenceLimits
              .authenticatedFollowedItemsLimit
              .toString()
              .length,
        ),
      );
      _authenticatedSavedHeadlinesLimitController.value = TextEditingValue(
        text: widget
            .appConfig
            .userPreferenceLimits
            .authenticatedSavedHeadlinesLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .appConfig
              .userPreferenceLimits
              .authenticatedSavedHeadlinesLimit
              .toString()
              .length,
        ),
      );
      _premiumFollowedItemsLimitController.value = TextEditingValue(
        text: widget.appConfig.userPreferenceLimits.premiumFollowedItemsLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .appConfig
              .userPreferenceLimits
              .premiumFollowedItemsLimit
              .toString()
              .length,
        ),
      );
      _premiumSavedHeadlinesLimitController.value = TextEditingValue(
        text: widget.appConfig.userPreferenceLimits.premiumSavedHeadlinesLimit
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .appConfig
              .userPreferenceLimits
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
    final userPreferenceLimits = widget.appConfig.userPreferenceLimits;

    switch (widget.userRole) {
      case UserRole.guestUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Guest Followed Items Limit',
              description:
                  'Maximum number of countries, news sources, or categories a '
                  'Guest user can follow (each type has its own limit).',
              value: userPreferenceLimits.guestFollowedItemsLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
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
              value: userPreferenceLimits.guestSavedHeadlinesLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
                      guestSavedHeadlinesLimit: value,
                    ),
                  ),
                );
              },
              controller: _guestSavedHeadlinesLimitController,
            ),
          ],
        );
      case UserRole.standardUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Standard User Followed Items Limit',
              description:
                  'Maximum number of countries, news sources, or categories a '
                  'Standard user can follow (each type has its own limit).',
              value: userPreferenceLimits.authenticatedFollowedItemsLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
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
              value: userPreferenceLimits.authenticatedSavedHeadlinesLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
                      authenticatedSavedHeadlinesLimit: value,
                    ),
                  ),
                );
              },
              controller: _authenticatedSavedHeadlinesLimitController,
            ),
          ],
        );
      case UserRole.premiumUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Premium Followed Items Limit',
              description:
                  'Maximum number of countries, news sources, or categories a '
                  'Premium user can follow (each type has its own limit).',
              value: userPreferenceLimits.premiumFollowedItemsLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
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
              value: userPreferenceLimits.premiumSavedHeadlinesLimit,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
                      premiumSavedHeadlinesLimit: value,
                    ),
                  ),
                );
              },
              controller: _premiumSavedHeadlinesLimitController,
            ),
          ],
        );
      case UserRole.admin:
        // Admin role might not have specific limits here, or could be
        // a separate configuration. For now, return empty.
        return const SizedBox.shrink();
    }
  }
}

class _AdConfigForm extends StatefulWidget {
  const _AdConfigForm({
    required this.userRole,
    required this.appConfig,
    required this.onConfigChanged,
    required this.buildIntField,
  });

  final UserRole userRole;
  final AppConfig appConfig;
  final ValueChanged<AppConfig> onConfigChanged;
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
      text: widget.appConfig.adConfig.guestAdFrequency.toString(),
    );
    _guestAdPlacementIntervalController = TextEditingController(
      text: widget.appConfig.adConfig.guestAdPlacementInterval.toString(),
    );
    _guestArticlesToReadBeforeShowingInterstitialAdsController =
        TextEditingController(
          text: widget
              .appConfig
              .adConfig
              .guestArticlesToReadBeforeShowingInterstitialAds
              .toString(),
        );
    _authenticatedAdFrequencyController = TextEditingController(
      text: widget.appConfig.adConfig.authenticatedAdFrequency.toString(),
    );
    _authenticatedAdPlacementIntervalController = TextEditingController(
      text: widget.appConfig.adConfig.authenticatedAdPlacementInterval
          .toString(),
    );
    _standardUserArticlesToReadBeforeShowingInterstitialAdsController =
        TextEditingController(
          text: widget
              .appConfig
              .adConfig
              .standardUserArticlesToReadBeforeShowingInterstitialAds
              .toString(),
        );
    _premiumAdFrequencyController = TextEditingController(
      text: widget.appConfig.adConfig.premiumAdFrequency.toString(),
    );
    _premiumAdPlacementIntervalController = TextEditingController(
      text: widget.appConfig.adConfig.premiumAdPlacementInterval.toString(),
    );
    _premiumUserArticlesToReadBeforeShowingInterstitialAdsController =
        TextEditingController(
          text: widget
              .appConfig
              .adConfig
              .premiumUserArticlesToReadBeforeShowingInterstitialAds
              .toString(),
        );
  }

  @override
  void didUpdateWidget(covariant _AdConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.appConfig.adConfig != oldWidget.appConfig.adConfig) {
      _guestAdFrequencyController.value = TextEditingValue(
        text: widget.appConfig.adConfig.guestAdFrequency.toString(),
        selection: TextSelection.collapsed(
          offset: widget.appConfig.adConfig.guestAdFrequency.toString().length,
        ),
      );
      _guestAdPlacementIntervalController.value = TextEditingValue(
        text: widget.appConfig.adConfig.guestAdPlacementInterval.toString(),
        selection: TextSelection.collapsed(
          offset: widget.appConfig.adConfig.guestAdPlacementInterval
              .toString()
              .length,
        ),
      );
      _guestArticlesToReadBeforeShowingInterstitialAdsController.value =
          TextEditingValue(
            text: widget
                .appConfig
                .adConfig
                .guestArticlesToReadBeforeShowingInterstitialAds
                .toString(),
            selection: TextSelection.collapsed(
              offset: widget
                  .appConfig
                  .adConfig
                  .guestArticlesToReadBeforeShowingInterstitialAds
                  .toString()
                  .length,
            ),
          );
      _authenticatedAdFrequencyController.value = TextEditingValue(
        text: widget.appConfig.adConfig.authenticatedAdFrequency.toString(),
        selection: TextSelection.collapsed(
          offset: widget.appConfig.adConfig.authenticatedAdFrequency
              .toString()
              .length,
        ),
      );
      _authenticatedAdPlacementIntervalController.value = TextEditingValue(
        text: widget.appConfig.adConfig.authenticatedAdPlacementInterval
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget.appConfig.adConfig.authenticatedAdPlacementInterval
              .toString()
              .length,
        ),
      );
      _standardUserArticlesToReadBeforeShowingInterstitialAdsController.value =
          TextEditingValue(
            text: widget
                .appConfig
                .adConfig
                .standardUserArticlesToReadBeforeShowingInterstitialAds
                .toString(),
            selection: TextSelection.collapsed(
              offset: widget
                  .appConfig
                  .adConfig
                  .standardUserArticlesToReadBeforeShowingInterstitialAds
                  .toString()
                  .length,
            ),
          );
      _premiumAdFrequencyController.value = TextEditingValue(
        text: widget.appConfig.adConfig.premiumAdFrequency.toString(),
        selection: TextSelection.collapsed(
          offset: widget.appConfig.adConfig.premiumAdFrequency
              .toString()
              .length,
        ),
      );
      _premiumAdPlacementIntervalController.value = TextEditingValue(
        text: widget.appConfig.adConfig.premiumAdPlacementInterval.toString(),
        selection: TextSelection.collapsed(
          offset: widget.appConfig.adConfig.premiumAdPlacementInterval
              .toString()
              .length,
        ),
      );
      _premiumUserArticlesToReadBeforeShowingInterstitialAdsController.value =
          TextEditingValue(
            text: widget
                .appConfig
                .adConfig
                .premiumUserArticlesToReadBeforeShowingInterstitialAds
                .toString(),
            selection: TextSelection.collapsed(
              offset: widget
                  .appConfig
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
    final adConfig = widget.appConfig.adConfig;

    switch (widget.userRole) {
      case UserRole.guestUser:
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
                  widget.appConfig.copyWith(
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
                  widget.appConfig.copyWith(
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
                  widget.appConfig.copyWith(
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
      case UserRole.standardUser:
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
                  widget.appConfig.copyWith(
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
                  widget.appConfig.copyWith(
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
                  widget.appConfig.copyWith(
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
      case UserRole.premiumUser:
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
                  widget.appConfig.copyWith(
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
                  widget.appConfig.copyWith(
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
                  widget.appConfig.copyWith(
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
      case UserRole.admin:
        return const SizedBox.shrink();
    }
  }
}

class _AccountActionConfigForm extends StatefulWidget {
  const _AccountActionConfigForm({
    required this.userRole,
    required this.appConfig,
    required this.onConfigChanged,
    required this.buildIntField,
  });

  final UserRole userRole;
  final AppConfig appConfig;
  final ValueChanged<AppConfig> onConfigChanged;
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
      text: widget.appConfig.accountActionConfig.guestDaysBetweenAccountActions
          .toString(),
    );
    _standardUserDaysBetweenAccountActionsController = TextEditingController(
      text: widget
          .appConfig
          .accountActionConfig
          .standardUserDaysBetweenAccountActions
          .toString(),
    );
  }

  @override
  void didUpdateWidget(covariant _AccountActionConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.appConfig.accountActionConfig !=
        oldWidget.appConfig.accountActionConfig) {
      _guestDaysBetweenAccountActionsController.value = TextEditingValue(
        text: widget
            .appConfig
            .accountActionConfig
            .guestDaysBetweenAccountActions
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .appConfig
              .accountActionConfig
              .guestDaysBetweenAccountActions
              .toString()
              .length,
        ),
      );
      _standardUserDaysBetweenAccountActionsController.value = TextEditingValue(
        text: widget
            .appConfig
            .accountActionConfig
            .standardUserDaysBetweenAccountActions
            .toString(),
        selection: TextSelection.collapsed(
          offset: widget
              .appConfig
              .accountActionConfig
              .standardUserDaysBetweenAccountActions
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
    final accountActionConfig = widget.appConfig.accountActionConfig;

    switch (widget.userRole) {
      case UserRole.guestUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Guest Days Between In-App Prompts',
              description:
                  'Minimum number of days that must pass before a Guest user '
                  'sees another in-app prompt.',
              value: accountActionConfig.guestDaysBetweenAccountActions,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.appConfig.copyWith(
                    accountActionConfig: accountActionConfig.copyWith(
                      guestDaysBetweenAccountActions: value,
                    ),
                  ),
                );
              },
              controller: _guestDaysBetweenAccountActionsController,
            ),
          ],
        );
      case UserRole.standardUser:
        return Column(
          children: [
            widget.buildIntField(
              context,
              label: 'Standard User Days Between In-App Prompts',
              description:
                  'Minimum number of days that must pass before a Standard user '
                  'sees another in-app prompt.',
              value: accountActionConfig.standardUserDaysBetweenAccountActions,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.appConfig.copyWith(
                    accountActionConfig: accountActionConfig.copyWith(
                      standardUserDaysBetweenAccountActions: value,
                    ),
                  ),
                );
              },
              controller: _standardUserDaysBetweenAccountActionsController,
            ),
          ],
        );
      case UserRole.premiumUser:
      case UserRole.admin:
        return const SizedBox.shrink();
    }
  }
}
