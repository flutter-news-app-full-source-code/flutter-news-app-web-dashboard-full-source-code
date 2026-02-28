import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/access_tier_l10n.dart';

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

  late final Map<AccessTier, TextEditingController>
  _internalNavigationsControllers;
  late final Map<AccessTier, TextEditingController>
  _externalNavigationsControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AccessTier.values.length,
      vsync: this,
    );
    _initializeControllers();
  }

  void _initializeControllers() {
    final navAdConfig =
        widget.remoteConfig.features.ads.navigationAdConfiguration;
    _internalNavigationsControllers = {
      for (final tier in AccessTier.values)
        tier: TextEditingController(
          text: _getInternalNavigations(navAdConfig, tier).toString(),
        ),
    };
    _externalNavigationsControllers = {
      for (final tier in AccessTier.values)
        tier: TextEditingController(
          text: _getExternalNavigations(navAdConfig, tier).toString(),
        ),
    };
  }

  void _updateControllers() {
    final navAdConfig =
        widget.remoteConfig.features.ads.navigationAdConfiguration;
    for (final tier in AccessTier.values) {
      final newInternalValue = _getInternalNavigations(
        navAdConfig,
        tier,
      ).toString();
      if (_internalNavigationsControllers[tier]?.text != newInternalValue) {
        _internalNavigationsControllers[tier]?.text = newInternalValue;
      }
      final newExternalValue = _getExternalNavigations(
        navAdConfig,
        tier,
      ).toString();
      if (_externalNavigationsControllers[tier]?.text != newExternalValue) {
        _externalNavigationsControllers[tier]?.text = newExternalValue;
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
          subtitle: Text(l10n.enableNavigationAdsDescription),
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
                  tabs: AccessTier.values
                      .map((tier) => Tab(text: tier.l10n(context)))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 350,
              child: TabBarView(
                controller: _tabController,
                children: AccessTier.values
                    .map(
                      (tier) => _buildTierSpecificFields(
                        context,
                        l10n,
                        tier,
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

  Widget _buildTierSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AccessTier tier,
    NavigationAdConfiguration config,
  ) {
    final tierConfig = config.visibleTo[tier];

    return SingleChildScrollView(
      child: Column(
        children: [
          SwitchListTile(
            title: Text(l10n.visibleToRoleLabel(tier.l10n(context))),
            subtitle: Text(l10n.visibleToRoleDescription(tier.l10n(context))),
            value: tierConfig != null,
            onChanged: (value) {
              final newVisibleTo =
                  Map<AccessTier, NavigationAdFrequencyConfig>.from(
                    config.visibleTo,
                  );
              if (value) {
                newVisibleTo[tier] = const NavigationAdFrequencyConfig(
                  internalNavigationsBeforeShowingInterstitialAd: 5,
                  externalNavigationsBeforeShowingInterstitialAd: 1,
                );
              } else {
                newVisibleTo.remove(tier);
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
          if (tierConfig != null)
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
                    value: tierConfig
                        .internalNavigationsBeforeShowingInterstitialAd,
                    onChanged: (value) {
                      final newTierConfig = tierConfig.copyWith(
                        internalNavigationsBeforeShowingInterstitialAd: value,
                      );
                      final newVisibleTo =
                          Map<AccessTier, NavigationAdFrequencyConfig>.from(
                            config.visibleTo,
                          )..[tier] = newTierConfig;
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
                    controller: _internalNavigationsControllers[tier],
                  ),
                  AppConfigIntField(
                    label: l10n.externalNavigationsBeforeAdLabel,
                    description: l10n.externalNavigationsBeforeAdDescription,
                    value: tierConfig
                        .externalNavigationsBeforeShowingInterstitialAd,
                    onChanged: (value) {
                      final newTierConfig = tierConfig.copyWith(
                        externalNavigationsBeforeShowingInterstitialAd: value,
                      );
                      final newVisibleTo =
                          Map<AccessTier, NavigationAdFrequencyConfig>.from(
                            config.visibleTo,
                          )..[tier] = newTierConfig;
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
                    controller: _externalNavigationsControllers[tier],
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
    AccessTier tier,
  ) {
    return config
            .visibleTo[tier]
            ?.internalNavigationsBeforeShowingInterstitialAd ??
        0;
  }

  int _getExternalNavigations(
    NavigationAdConfiguration config,
    AccessTier tier,
  ) {
    return config
            .visibleTo[tier]
            ?.externalNavigationsBeforeShowingInterstitialAd ??
        0;
  }
}
