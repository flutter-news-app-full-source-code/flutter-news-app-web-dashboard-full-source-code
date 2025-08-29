import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template ad_config_form}
/// A form widget for configuring ad settings based on user role.
///
/// This widget uses a [TabBar] to allow selection of an [AppUserRole]
/// and then conditionally renders the relevant input fields for that role.
/// {@endtemplate}
class AdConfigForm extends StatefulWidget {
  /// {@macro ad_config_form}
  const AdConfigForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<AdConfigForm> createState() => _AdConfigFormState();
}

class _AdConfigFormState extends State<AdConfigForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final Map<AppUserRole, TextEditingController> _adFrequencyControllers;
  late final Map<AppUserRole, TextEditingController>
  _adPlacementIntervalControllers;
  late final Map<AppUserRole, TextEditingController>
  _articlesToReadBeforeShowingInterstitialAdsControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppUserRole.values.length,
      vsync: this,
    );
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant AdConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.adConfig != oldWidget.remoteConfig.adConfig) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final adConfig = widget.remoteConfig.adConfig;
    _adFrequencyControllers = {
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text: _getAdFrequency(adConfig, role).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: _getAdFrequency(adConfig, role).toString().length,
              ),
    };
    _adPlacementIntervalControllers = {
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text: _getAdPlacementInterval(adConfig, role).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: _getAdPlacementInterval(
                  adConfig,
                  role,
                ).toString().length,
              ),
    };
    _articlesToReadBeforeShowingInterstitialAdsControllers = {
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text: _getArticlesBeforeInterstitial(adConfig, role).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: _getArticlesBeforeInterstitial(
                  adConfig,
                  role,
                ).toString().length,
              ),
    };
  }

  void _updateControllers() {
    final adConfig = widget.remoteConfig.adConfig;
    for (final role in AppUserRole.values) {
      final newFrequencyValue = _getAdFrequency(adConfig, role).toString();
      if (_adFrequencyControllers[role]?.text != newFrequencyValue) {
        _adFrequencyControllers[role]?.text = newFrequencyValue;
        _adFrequencyControllers[role]?.selection = TextSelection.collapsed(
          offset: newFrequencyValue.length,
        );
      }

      final newPlacementIntervalValue = _getAdPlacementInterval(
        adConfig,
        role,
      ).toString();
      if (_adPlacementIntervalControllers[role]?.text !=
          newPlacementIntervalValue) {
        _adPlacementIntervalControllers[role]?.text = newPlacementIntervalValue;
        _adPlacementIntervalControllers[role]?.selection =
            TextSelection.collapsed(
              offset: newPlacementIntervalValue.length,
            );
      }

      final newInterstitialValue = _getArticlesBeforeInterstitial(
        adConfig,
        role,
      ).toString();
      if (_articlesToReadBeforeShowingInterstitialAdsControllers[role]?.text !=
          newInterstitialValue) {
        _articlesToReadBeforeShowingInterstitialAdsControllers[role]?.text =
            newInterstitialValue;
        _articlesToReadBeforeShowingInterstitialAdsControllers[role]
            ?.selection = TextSelection.collapsed(
          offset: newInterstitialValue.length,
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final controller in _adFrequencyControllers.values) {
      controller.dispose();
    }
    for (final controller in _adPlacementIntervalControllers.values) {
      controller.dispose();
    }
    for (final controller
        in _articlesToReadBeforeShowingInterstitialAdsControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adConfig = widget.remoteConfig.adConfig;
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
        // Replaced SegmentedButton with TabBar for role selection
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
        // TabBarView to display role-specific fields
        SizedBox(
          height: 400, // Fixed height for TabBarView within a ListView
          child: TabBarView(
            controller: _tabController,
            children: AppUserRole.values
                .map(
                  (role) => _buildRoleSpecificFields(
                    context,
                    l10n,
                    role,
                    adConfig,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AppUserRole role,
    AdConfig config,
  ) {
    return Column(
      children: [
        AppConfigIntField(
          label: l10n.adFrequencyLabel,
          description: l10n.adFrequencyDescription,
          value: _getAdFrequency(config, role),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: _updateAdFrequency(config, value, role),
              ),
            );
          },
          controller: _adFrequencyControllers[role],
        ),
        AppConfigIntField(
          label: l10n.adPlacementIntervalLabel,
          description: l10n.adPlacementIntervalDescription,
          value: _getAdPlacementInterval(config, role),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: _updateAdPlacementInterval(config, value, role),
              ),
            );
          },
          controller: _adPlacementIntervalControllers[role],
        ),
        AppConfigIntField(
          label: l10n.articlesBeforeInterstitialAdsLabel,
          description: l10n.articlesBeforeInterstitialAdsDescription,
          value: _getArticlesBeforeInterstitial(config, role),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: _updateArticlesBeforeInterstitial(
                  config,
                  value,
                  role,
                ),
              ),
            );
          },
          controller:
              _articlesToReadBeforeShowingInterstitialAdsControllers[role],
        ),
      ],
    );
  }

  int _getAdFrequency(AdConfig config, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.feedAdConfiguration.frequencyConfig.guestAdFrequency;
      case AppUserRole.standardUser:
        return config
            .feedAdConfiguration
            .frequencyConfig
            .authenticatedAdFrequency;
      case AppUserRole.premiumUser:
        return config.feedAdConfiguration.frequencyConfig.premiumAdFrequency;
    }
  }

  int _getAdPlacementInterval(AdConfig config, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return config
            .feedAdConfiguration
            .frequencyConfig
            .guestAdPlacementInterval;
      case AppUserRole.standardUser:
        return config
            .feedAdConfiguration
            .frequencyConfig
            .authenticatedAdPlacementInterval;
      case AppUserRole.premiumUser:
        return config
            .feedAdConfiguration
            .frequencyConfig
            .premiumAdPlacementInterval;
    }
  }

  int _getArticlesBeforeInterstitial(AdConfig config, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return config
            .articleAdConfiguration
            .interstitialAdConfiguration
            .frequencyConfig
            .guestArticlesToReadBeforeShowingInterstitialAds;
      case AppUserRole.standardUser:
        return config
            .articleAdConfiguration
            .interstitialAdConfiguration
            .frequencyConfig
            .standardUserArticlesToReadBeforeShowingInterstitialAds;
      case AppUserRole.premiumUser:
        return config
            .articleAdConfiguration
            .interstitialAdConfiguration
            .frequencyConfig
            .premiumUserArticlesToReadBeforeShowingInterstitialAds;
    }
  }

  AdConfig _updateAdFrequency(AdConfig config, int value, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.copyWith(
          feedAdConfiguration: config.feedAdConfiguration.copyWith(
            frequencyConfig: config.feedAdConfiguration.frequencyConfig
                .copyWith(guestAdFrequency: value),
          ),
        );
      case AppUserRole.standardUser:
        return config.copyWith(
          feedAdConfiguration: config.feedAdConfiguration.copyWith(
            frequencyConfig: config.feedAdConfiguration.frequencyConfig
                .copyWith(authenticatedAdFrequency: value),
          ),
        );
      case AppUserRole.premiumUser:
        return config.copyWith(
          feedAdConfiguration: config.feedAdConfiguration.copyWith(
            frequencyConfig: config.feedAdConfiguration.frequencyConfig
                .copyWith(premiumAdFrequency: value),
          ),
        );
    }
  }

  AdConfig _updateAdPlacementInterval(
    AdConfig config,
    int value,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.copyWith(
          feedAdConfiguration: config.feedAdConfiguration.copyWith(
            frequencyConfig: config.feedAdConfiguration.frequencyConfig
                .copyWith(guestAdPlacementInterval: value),
          ),
        );
      case AppUserRole.standardUser:
        return config.copyWith(
          feedAdConfiguration: config.feedAdConfiguration.copyWith(
            frequencyConfig: config.feedAdConfiguration.frequencyConfig
                .copyWith(authenticatedAdPlacementInterval: value),
          ),
        );
      case AppUserRole.premiumUser:
        return config.copyWith(
          feedAdConfiguration: config.feedAdConfiguration.copyWith(
            frequencyConfig: config.feedAdConfiguration.frequencyConfig
                .copyWith(premiumAdPlacementInterval: value),
          ),
        );
    }
  }

  AdConfig _updateArticlesBeforeInterstitial(
    AdConfig config,
    int value,
    AppUserRole role,
  ) {
    final currentFrequencyConfig = config
        .articleAdConfiguration
        .interstitialAdConfiguration
        .frequencyConfig;

    ArticleInterstitialAdFrequencyConfig newFrequencyConfig;

    switch (role) {
      case AppUserRole.guestUser:
        newFrequencyConfig = currentFrequencyConfig.copyWith(
          guestArticlesToReadBeforeShowingInterstitialAds: value,
        );
      case AppUserRole.standardUser:
        newFrequencyConfig = currentFrequencyConfig.copyWith(
          standardUserArticlesToReadBeforeShowingInterstitialAds: value,
        );
      case AppUserRole.premiumUser:
        newFrequencyConfig = currentFrequencyConfig.copyWith(
          premiumUserArticlesToReadBeforeShowingInterstitialAds: value,
        );
    }

    return config.copyWith(
      articleAdConfiguration: config.articleAdConfiguration.copyWith(
        interstitialAdConfiguration: config
            .articleAdConfiguration
            .interstitialAdConfiguration
            .copyWith(frequencyConfig: newFrequencyConfig),
      ),
    );
  }
}
