import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template navigation_ad_settings_form}
/// A form widget for configuring navigation ad settings.
/// {@endtemplate}
class NavigationAdSettingsForm extends StatefulWidget {
  /// {@macro navigation_ad_settings_form}
  const NavigationAdSettingsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<NavigationAdSettingsForm> createState() =>
      _NavigationAdSettingsFormState();
}

class _NavigationAdSettingsFormState extends State<NavigationAdSettingsForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late final Map<AppUserRole, TextEditingController>
  _internalNavigationsControllers;
  late final Map<AppUserRole, TextEditingController>
  _externalNavigationsControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppUserRole.values.length,
      vsync: this,
    );
    _initializeControllers();
  }

  void _initializeControllers() {
    final navAdConfig =
        widget.remoteConfig.features.ads.navigationAdConfiguration;
    _internalNavigationsControllers = {
      for (final role in AppUserRole.values)
        role: TextEditingController(
          text: _getInternalNavigations(navAdConfig, role).toString(),
        ),
    };
    _externalNavigationsControllers = {
      for (final role in AppUserRole.values)
        role: TextEditingController(
          text: _getExternalNavigations(navAdConfig, role).toString(),
        ),
    };
  }

  void _updateControllers() {
    final navAdConfig =
        widget.remoteConfig.features.ads.navigationAdConfiguration;
    for (final role in AppUserRole.values) {
      final newInternalValue = _getInternalNavigations(
        navAdConfig,
        role,
      ).toString();
      if (_internalNavigationsControllers[role]?.text != newInternalValue) {
        _internalNavigationsControllers[role]?.text = newInternalValue;
      }
      final newExternalValue = _getExternalNavigations(
        navAdConfig,
        role,
      ).toString();
      if (_externalNavigationsControllers[role]?.text != newExternalValue) {
        _externalNavigationsControllers[role]?.text = newExternalValue;
      }
    }
  }

  @override
  void didUpdateWidget(covariant NavigationAdSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.features.ads.navigationAdConfiguration !=
        oldWidget.remoteConfig.features.ads.navigationAdConfiguration) {
      _updateControllers();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in _internalNavigationsControllers.values) {
      c.dispose();
    }
    for (final c in _externalNavigationsControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final features = widget.remoteConfig.features;
    final adConfig = features.ads;
    final navAdConfig = adConfig.navigationAdConfiguration;

    return ExpansionTile(
      title: Text(l10n.navigationAdConfigTitle),
      subtitle: Text(
        l10n.navigationAdConfigDescription,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      childrenPadding: const EdgeInsetsDirectional.only(
        start: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableNavigationAdsLabel),
          value: navAdConfig.enabled,
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                features: features.copyWith(
                  ads: adConfig.copyWith(
                    navigationAdConfiguration: navAdConfig.copyWith(
                      enabled: value,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        ExpansionTile(
          title: Text(l10n.navigationAdFrequencyTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.navigationAdFrequencyDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SizedBox(
                height: kTextTabBarHeight,
                child: TabBar(
                  controller: _tabController,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  tabs: AppUserRole.values
                      .map((role) => Tab(text: role.l10n(context)))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 350,
              child: TabBarView(
                controller: _tabController,
                children: AppUserRole.values
                    .map(
                      (role) => _buildRoleSpecificFields(
                        context,
                        l10n,
                        role,
                        navAdConfig,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AppUserRole role,
    NavigationAdConfiguration config,
  ) {
    final roleConfig = config.visibleTo[role];

    return SingleChildScrollView(
      child: Column(
        children: [
          SwitchListTile(
            title: Text(l10n.visibleToRoleLabel(role.l10n(context))),
            value: roleConfig != null,
            onChanged: (value) {
              final newVisibleTo =
                  Map<AppUserRole, NavigationAdFrequencyConfig>.from(
                    config.visibleTo,
                  );
              if (value) {
                newVisibleTo[role] = const NavigationAdFrequencyConfig(
                  internalNavigationsBeforeShowingInterstitialAd: 5,
                  externalNavigationsBeforeShowingInterstitialAd: 1,
                );
              } else {
                newVisibleTo.remove(role);
              }
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  features: widget.remoteConfig.features.copyWith(
                    ads: widget.remoteConfig.features.ads.copyWith(
                      navigationAdConfiguration: config.copyWith(
                        visibleTo: newVisibleTo,
                      ),
                    ),
                  ),
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
              child: Column(
                children: [
                  AppConfigIntField(
                    label: l10n.internalNavigationsBeforeAdLabel,
                    description: l10n.internalNavigationsBeforeAdDescription,
                    value: roleConfig
                        .internalNavigationsBeforeShowingInterstitialAd,
                    onChanged: (value) {
                      final newRoleConfig = roleConfig.copyWith(
                        internalNavigationsBeforeShowingInterstitialAd: value,
                      );
                      final newVisibleTo =
                          Map<AppUserRole, NavigationAdFrequencyConfig>.from(
                            config.visibleTo,
                          )..[role] = newRoleConfig;
                      widget.onConfigChanged(
                        widget.remoteConfig.copyWith(
                          features: widget.remoteConfig.features.copyWith(
                            ads: widget.remoteConfig.features.ads.copyWith(
                              navigationAdConfiguration: config.copyWith(
                                visibleTo: newVisibleTo,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    controller: _internalNavigationsControllers[role],
                  ),
                  AppConfigIntField(
                    label: l10n.externalNavigationsBeforeAdLabel,
                    description: l10n.externalNavigationsBeforeAdDescription,
                    value: roleConfig
                        .externalNavigationsBeforeShowingInterstitialAd,
                    onChanged: (value) {
                      final newRoleConfig = roleConfig.copyWith(
                        externalNavigationsBeforeShowingInterstitialAd: value,
                      );
                      final newVisibleTo =
                          Map<AppUserRole, NavigationAdFrequencyConfig>.from(
                            config.visibleTo,
                          )..[role] = newRoleConfig;
                      widget.onConfigChanged(
                        widget.remoteConfig.copyWith(
                          features: widget.remoteConfig.features.copyWith(
                            ads: widget.remoteConfig.features.ads.copyWith(
                              navigationAdConfiguration: config.copyWith(
                                visibleTo: newVisibleTo,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    controller: _externalNavigationsControllers[role],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  int _getInternalNavigations(
    NavigationAdConfiguration config,
    AppUserRole role,
  ) {
    return config
            .visibleTo[role]
            ?.internalNavigationsBeforeShowingInterstitialAd ??
        0;
  }

  int _getExternalNavigations(
    NavigationAdConfiguration config,
    AppUserRole role,
  ) {
    return config
            .visibleTo[role]
            ?.externalNavigationsBeforeShowingInterstitialAd ??
        0;
  }
}
