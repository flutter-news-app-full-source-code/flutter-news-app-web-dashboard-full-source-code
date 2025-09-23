import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template interstitial_ad_settings_form}
/// A form widget for configuring global interstitial ad settings.
/// {@endtemplate}
class InterstitialAdSettingsForm extends StatefulWidget {
  /// {@macro interstitial_ad_settings_form}
  const InterstitialAdSettingsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<InterstitialAdSettingsForm> createState() =>
      _InterstitialAdSettingsFormState();
}

class _InterstitialAdSettingsFormState extends State<InterstitialAdSettingsForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final Map<AppUserRole, TextEditingController>
  _transitionsBeforeShowingInterstitialAdsControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppUserRole.values.length,
      vsync: this,
    );
    _initializeControllers();
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    final selectedRole = AppUserRole.values[_tabController.index];
    if (selectedRole == AppUserRole.premiumUser) {
      final adConfig = widget.remoteConfig.adConfig;
      final interstitialAdConfig = adConfig.interstitialAdConfiguration;

      // If the value for premium is not 0, update the config.
      // This enforces the business rule that premium users do not see ads.
      if (interstitialAdConfig
              .feedInterstitialAdFrequencyConfig
              .premiumUserTransitionsBeforeShowingInterstitialAds !=
          0) {
        final updatedFrequencyConfig = interstitialAdConfig
            .feedInterstitialAdFrequencyConfig
            .copyWith(
              premiumUserTransitionsBeforeShowingInterstitialAds: 0,
            );
        final updatedInterstitialAdConfig = interstitialAdConfig.copyWith(
          feedInterstitialAdFrequencyConfig: updatedFrequencyConfig,
        );
        widget.onConfigChanged(
          widget.remoteConfig.copyWith(
            adConfig: adConfig.copyWith(
              interstitialAdConfiguration: updatedInterstitialAdConfig,
            ),
          ),
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant InterstitialAdSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.adConfig.interstitialAdConfiguration !=
        oldWidget.remoteConfig.adConfig.interstitialAdConfiguration) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final interstitialConfig =
        widget.remoteConfig.adConfig.interstitialAdConfiguration;
    _transitionsBeforeShowingInterstitialAdsControllers = {
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text: _getTransitionsBeforeInterstitial(
                  interstitialConfig,
                  role,
                ).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: _getTransitionsBeforeInterstitial(
                  interstitialConfig,
                  role,
                ).toString().length,
              ),
    };
  }

  void _updateControllers() {
    final interstitialConfig =
        widget.remoteConfig.adConfig.interstitialAdConfiguration;
    for (final role in AppUserRole.values) {
      final newInterstitialValue = _getTransitionsBeforeInterstitial(
        interstitialConfig,
        role,
      ).toString();
      if (_transitionsBeforeShowingInterstitialAdsControllers[role]?.text !=
          newInterstitialValue) {
        _transitionsBeforeShowingInterstitialAdsControllers[role]?.text =
            newInterstitialValue;
        _transitionsBeforeShowingInterstitialAdsControllers[role]?.selection =
            TextSelection.collapsed(
              offset: newInterstitialValue.length,
            );
      }
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    for (final controller
        in _transitionsBeforeShowingInterstitialAdsControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final adConfig = widget.remoteConfig.adConfig;
    final interstitialAdConfig = adConfig.interstitialAdConfiguration;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableInterstitialAdsLabel),
          value: interstitialAdConfig.enabled,
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: adConfig.copyWith(
                  interstitialAdConfiguration: interstitialAdConfig.copyWith(
                    enabled: value,
                  ),
                ),
              ),
            );
          },
        ),
        ExpansionTile(
          title: Text(l10n.userRoleInterstitialFrequencyTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.userRoleInterstitialFrequencyDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.7),
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
              height: 250,
              child: TabBarView(
                controller: _tabController,
                children: AppUserRole.values
                    .map(
                      (role) => _buildInterstitialRoleSpecificFields(
                        context,
                        l10n,
                        role,
                        interstitialAdConfig,
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

  Widget _buildInterstitialRoleSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AppUserRole role,
    InterstitialAdConfiguration config,
  ) {
    // Premium users do not see ads, so their settings are disabled.
    final isEnabled = role != AppUserRole.premiumUser;

    return Column(
      children: [
        AppConfigIntField(
          label: l10n.transitionsBeforeInterstitialAdsLabel,
          description: l10n.transitionsBeforeInterstitialAdsDescription,
          value: _getTransitionsBeforeInterstitial(config, role),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: widget.remoteConfig.adConfig.copyWith(
                  interstitialAdConfiguration:
                      _updateTransitionsBeforeInterstitial(
                        config,
                        value,
                        role,
                      ),
                ),
              ),
            );
          },
          controller: _transitionsBeforeShowingInterstitialAdsControllers[role],
          enabled: isEnabled,
        ),
      ],
    );
  }

  int _getTransitionsBeforeInterstitial(
    InterstitialAdConfiguration config,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return config
            .feedInterstitialAdFrequencyConfig
            .guestTransitionsBeforeShowingInterstitialAds;
      case AppUserRole.standardUser:
        return config
            .feedInterstitialAdFrequencyConfig
            .standardUserTransitionsBeforeShowingInterstitialAds;
      case AppUserRole.premiumUser:
        return config
            .feedInterstitialAdFrequencyConfig
            .premiumUserTransitionsBeforeShowingInterstitialAds;
    }
  }

  InterstitialAdConfiguration _updateTransitionsBeforeInterstitial(
    InterstitialAdConfiguration config,
    int value,
    AppUserRole role,
  ) {
    final currentFrequencyConfig = config.feedInterstitialAdFrequencyConfig;

    InterstitialAdFrequencyConfig newFrequencyConfig;

    switch (role) {
      case AppUserRole.guestUser:
        newFrequencyConfig = currentFrequencyConfig.copyWith(
          guestTransitionsBeforeShowingInterstitialAds: value,
        );
      case AppUserRole.standardUser:
        newFrequencyConfig = currentFrequencyConfig.copyWith(
          standardUserTransitionsBeforeShowingInterstitialAds: value,
        );
      case AppUserRole.premiumUser:
        // Premium users should not see ads, so their frequency is always 0.
        // The UI field is disabled, but this is a safeguard.
        newFrequencyConfig = currentFrequencyConfig.copyWith(
          premiumUserTransitionsBeforeShowingInterstitialAds: 0,
        );
    }

    return config.copyWith(
      feedInterstitialAdFrequencyConfig: newFrequencyConfig,
    );
  }
}
