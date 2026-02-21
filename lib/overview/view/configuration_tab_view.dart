import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/bloc/configuration/configuration_view_bloc.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfigurationTabView extends StatefulWidget {
  const ConfigurationTabView({super.key});

  @override
  State<ConfigurationTabView> createState() => _ConfigurationTabViewState();
}

class _ConfigurationTabViewState extends State<ConfigurationTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizationsX(context).l10n;

    return BlocBuilder<ConfigurationViewBloc, ConfigurationViewState>(
      builder: (context, state) {
        switch (state.status) {
          case ConfigurationViewStatus.initial:
          case ConfigurationViewStatus.loading:
            return LoadingStateWidget(
              icon: Icons.settings_outlined,
              headline: l10n.loadingConfiguration,
              subheadline: l10n.pleaseWait,
            );

          case ConfigurationViewStatus.failure:
            return FailureStateWidget(
              exception: UnknownException(state.error.toString()),
              onRetry: () => context.read<ConfigurationViewBloc>().add(
                const ConfigurationViewSubscriptionRequested(null),
              ),
            );

          case ConfigurationViewStatus.success:
            final remoteConfig = state.remoteConfig;

            if (remoteConfig == null) {
              return InitialStateWidget(
                icon: Icons.settings_outlined,
                headline: l10n.noConfigurationDataHeadline, // New Key
                subheadline: l10n.noConfigurationDataSubheadline, // New Key
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _ConfigView(remoteConfig: remoteConfig),
            );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ConfigView extends StatelessWidget {
  const _ConfigView({required this.remoteConfig});

  final RemoteConfig remoteConfig;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.readOnlyConfigurationView, // New Key
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.readOnlyConfigurationViewDescription, // New Key
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.lg),
        _Section(
          title: l10n.appStatusAndUpdatesTitle,
          children: [
            _SettingTile(
              title: l10n.isUnderMaintenanceLabel,
              value: remoteConfig.app.maintenance.isUnderMaintenance,
            ),
            _SettingTile(
              title: l10n.isLatestVersionOnlyLabel,
              value: remoteConfig.app.update.isLatestVersionOnly,
            ),
            _SettingTile(
              title: l10n.latestAppVersionLabel,
              value: remoteConfig.app.update.latestAppVersion,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _Section(
          title: l10n.featuresTab,
          children: [
            _SettingTile(
              title: l10n.enableGlobalAdsLabel,
              value: remoteConfig.features.ads.enabled,
            ),
            _SettingTile(
              title: l10n.pushNotificationSystemStatusTitle,
              value: remoteConfig.features.pushNotifications.enabled,
            ),
            _SettingTile(
              title: l10n.enableCommunityFeaturesLabel,
              value: remoteConfig.features.community.enabled,
            ),
            _SettingTile(
              title: l10n.enableRewardsLabel,
              value: remoteConfig.features.rewards.enabled,
            ),
            _SettingTile(
              title: l10n.enableOnboardingLabel,
              value: remoteConfig.features.onboarding.isEnabled,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _Section(
          title: l10n.providers,
          children: [
            _SettingTile(
              title: l10n.analyticsProviderTitle,
              value: remoteConfig.features.analytics.activeProvider.name,
            ),
            _SettingTile(
              title: l10n.primaryAdPlatformTitle,
              value: remoteConfig.features.ads.primaryAdPlatform.name,
            ),
            _SettingTile(
              title: l10n.pushNotificationPrimaryProviderTitle,
              value:
                  remoteConfig.features.pushNotifications.primaryProvider.name,
            ),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ExpansionTile(
        title: Text(title),
        initiallyExpanded: true,
        children: children,
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.title, required this.value});

  final String title;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget valueWidget;

    if (value is bool) {
      valueWidget = Chip(
        label: Text(value == true ? 'Enabled' : 'Disabled'),
        backgroundColor: value == true
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        labelStyle: TextStyle(
          color: value == true ? Colors.green.shade800 : Colors.red.shade800,
          fontWeight: FontWeight.bold,
        ),
        side: BorderSide.none,
      );
    } else if (value is String &&
        (value.startsWith('http') || value.startsWith('https'))) {
      valueWidget = InkWell(
        onTap: () => launchUrl(Uri.parse(value as String)),
        child: Text(
          value.toString(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            decoration: TextDecoration.underline,
            decorationColor: theme.colorScheme.primary,
          ),
        ),
      );
    } else {
      valueWidget = Text(
        value.toString(),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return ListTile(
      title: Text(title, style: theme.textTheme.titleSmall),
      trailing: valueWidget,
    );
  }
}
