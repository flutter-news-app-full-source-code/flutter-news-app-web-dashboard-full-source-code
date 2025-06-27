import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_dashboard/app_configuration/bloc/app_configuration_bloc.dart';
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
          'App Configuration',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'User Preferences'),
            Tab(text: 'Ad Config'),
            Tab(text: 'Account Actions'),
            Tab(text: 'Kill Switch'),
            Tab(text: 'Force Update'),
          ],
        ),
      ),
      body: BlocConsumer<AppConfigurationBloc, AppConfigurationState>(
        listener: (context, state) {
          if (state.status == AppConfigurationStatus.success &&
              state.isDirty == false) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    'App configuration saved successfully!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
          } else if (state.status == AppConfigurationStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    'Error: ${state.errorMessage ?? "Unknown error"}',
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
            return const LoadingStateWidget(
              icon: Icons.settings_applications_outlined,
              headline: 'Loading Configuration',
              subheadline: 'Please wait while settings are loaded...',
            );
          } else if (state.status == AppConfigurationStatus.failure) {
            return FailureStateWidget(
              message: state.errorMessage ?? 'Failed to load configuration.',
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
          return const InitialStateWidget(
            icon: Icons.settings_applications_outlined,
            headline: 'App Configuration',
            subheadline: 'Load application settings from the backend.',
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
                      // Discard changes: reload original config
                      context.read<AppConfigurationBloc>().add(
                        const AppConfigurationLoaded(),
                      );
                    }
                  : null,
              child: const Text('Discard Changes'),
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
              child: const Text('Save Changes'),
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
                'Confirm Configuration Update',
                style: Theme.of(dialogContext).textTheme.titleLarge,
              ),
              content: Text(
                'Are you sure you want to apply these changes to the live application configuration? This is a critical operation.',
                style: Theme.of(dialogContext).textTheme.bodyMedium,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(dialogContext).colorScheme.error,
                    foregroundColor: Theme.of(
                      dialogContext,
                    ).colorScheme.onError,
                  ),
                  child: const Text('Confirm Save'),
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
    final userPreferenceLimits = appConfig.userPreferenceLimits;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Preference Limits',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'These settings define the maximum number of items a user can follow or save, tiered by user role. Changes here directly impact user capabilities.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildIntField(
            context,
            label: 'Guest Followed Items Limit',
            description:
                'Max countries, sources, or categories a Guest user can follow (each).',
            value: userPreferenceLimits.guestFollowedItemsLimit,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
                      guestFollowedItemsLimit: value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Guest Saved Headlines Limit',
            description: 'Max headlines a Guest user can save.',
            value: userPreferenceLimits.guestSavedHeadlinesLimit,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
                      guestSavedHeadlinesLimit: value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Authenticated Followed Items Limit',
            description:
                'Max countries, sources, or categories an Authenticated user can follow (each).',
            value: userPreferenceLimits.authenticatedFollowedItemsLimit,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
                      authenticatedFollowedItemsLimit: value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Authenticated Saved Headlines Limit',
            description: 'Max headlines an Authenticated user can save.',
            value: userPreferenceLimits.authenticatedSavedHeadlinesLimit,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
                      authenticatedSavedHeadlinesLimit: value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Premium Followed Items Limit',
            description:
                'Max countries, sources, or categories a Premium user can follow (each).',
            value: userPreferenceLimits.premiumFollowedItemsLimit,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
                      premiumFollowedItemsLimit: value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Premium Saved Headlines Limit',
            description: 'Max headlines a Premium user can save.',
            value: userPreferenceLimits.premiumSavedHeadlinesLimit,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    userPreferenceLimits: userPreferenceLimits.copyWith(
                      premiumSavedHeadlinesLimit: value,
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

  Widget _buildAdConfigTab(BuildContext context, AppConfig appConfig) {
    final adConfig = appConfig.adConfig;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ad Configuration',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'These settings control how ads are injected and displayed in the application, tiered by user role. AdFrequency determines how often an ad can be injected, and AdPlacementInterval sets a minimum number of primary items before the first ad.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildIntField(
            context,
            label: 'Guest Ad Frequency',
            description:
                'How often an ad can be injected for Guest users (e.g., 5 means after every 5 primary items).',
            value: adConfig.guestAdFrequency,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    adConfig: adConfig.copyWith(guestAdFrequency: value),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Guest Ad Placement Interval',
            description:
                'Minimum primary items before the first ad for Guest users.',
            value: adConfig.guestAdPlacementInterval,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      guestAdPlacementInterval: value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Authenticated Ad Frequency',
            description:
                'How often an ad can be injected for Authenticated users.',
            value: adConfig.authenticatedAdFrequency,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      authenticatedAdFrequency: value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Authenticated Ad Placement Interval',
            description:
                'Minimum primary items before the first ad for Authenticated users.',
            value: adConfig.authenticatedAdPlacementInterval,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      authenticatedAdPlacementInterval: value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Premium Ad Frequency',
            description:
                'How often an ad can be injected for Premium users (0 for no ads).',
            value: adConfig.premiumAdFrequency,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    adConfig: adConfig.copyWith(premiumAdFrequency: value),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Premium Ad Placement Interval',
            description:
                'Minimum primary items before the first ad for Premium users.',
            value: adConfig.premiumAdPlacementInterval,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      premiumAdPlacementInterval: value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Guest Articles Before Interstitial Ads',
            description:
                'Number of articles a Guest user reads before an interstitial ad is shown.',
            value: adConfig.guestArticlesToReadBeforeShowingInterstitialAds,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      guestArticlesToReadBeforeShowingInterstitialAds: value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Standard User Articles Before Interstitial Ads',
            description:
                'Number of articles a Standard user reads before an interstitial ad is shown.',
            value:
                adConfig.standardUserArticlesToReadBeforeShowingInterstitialAds,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      standardUserArticlesToReadBeforeShowingInterstitialAds:
                          value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Premium User Articles Before Interstitial Ads',
            description:
                'Number of articles a Premium user reads before an interstitial ad is shown.',
            value:
                adConfig.premiumUserArticlesToReadBeforeShowingInterstitialAds,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      premiumUserArticlesToReadBeforeShowingInterstitialAds:
                          value,
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

  Widget _buildAccountActionConfigTab(
    BuildContext context,
    AppConfig appConfig,
  ) {
    final accountActionConfig = appConfig.accountActionConfig;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Action Configuration',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'These settings control the display frequency of in-feed account actions (e.g., link account, upgrade prompts), tiered by user role.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildIntField(
            context,
            label: 'Guest Days Between Account Actions',
            description:
                'Minimum days between showing account actions to Guest users.',
            value: accountActionConfig.guestDaysBetweenAccountActions,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    accountActionConfig: accountActionConfig.copyWith(
                      guestDaysBetweenAccountActions: value,
                    ),
                  ),
                ),
              );
            },
          ),
          _buildIntField(
            context,
            label: 'Standard User Days Between Account Actions',
            description:
                'Minimum days between showing account actions to Standard users.',
            value: accountActionConfig.standardUserDaysBetweenAccountActions,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(
                    accountActionConfig: accountActionConfig.copyWith(
                      standardUserDaysBetweenAccountActions: value,
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

  Widget _buildKillSwitchTab(BuildContext context, AppConfig appConfig) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kill Switch & App Status',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'WARNING: These settings can disable the entire mobile application. Use with extreme caution.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSwitchField(
            context,
            label: 'Kill Switch Enabled',
            description:
                "If enabled, the app's operational status will be enforced.",
            value: appConfig.killSwitchEnabled,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(killSwitchEnabled: value),
                ),
              );
            },
          ),
          _buildDropdownField<RemoteAppStatus>(
            context,
            label: 'App Operational Status',
            description:
                'The current operational status of the app (e.g., active, maintenance, disabled).',
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
          _buildTextField(
            context,
            label: 'Maintenance Message',
            description:
                'Message displayed when the app is in maintenance mode.',
            value: appConfig.maintenanceMessage,
            onChanged: (value) {
              context.read<AppConfigurationBloc>().add(
                AppConfigurationFieldChanged(
                  appConfig: appConfig.copyWith(maintenanceMessage: value),
                ),
              );
            },
          ),
          _buildTextField(
            context,
            label: 'Disabled Message',
            description:
                'Message displayed when the app is permanently disabled.',
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
            'Force Update Configuration',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'These settings control app version enforcement. Users on versions below the minimum allowed will be forced to update.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildTextField(
            context,
            label: 'Minimum Allowed App Version',
            description:
                'The lowest app version allowed to run (e.g., "1.2.0").',
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
            label: 'Latest App Version',
            description: 'The latest available app version (e.g., "1.5.0").',
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
            label: 'Update Required Message',
            description: 'Message displayed when a force update is required.',
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
            label: 'Update Optional Message',
            description: 'Message displayed for an optional update.',
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
            label: 'iOS Store URL',
            description: 'URL to the app on the Apple App Store.',
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
            label: 'Android Store URL',
            description: 'URL to the app on the Google Play Store.',
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
            initialValue: value.toString(),
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
            initialValue: value,
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
