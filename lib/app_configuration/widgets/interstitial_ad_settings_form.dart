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

  /// Controllers for transitions before showing interstitial ads, mapped by user role.
  /// These are used to manage text input for each role's interstitial ad frequency.
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

  /// Initializes text editing controllers for each user role based on current
  /// remote config values.
  void _initializeControllers() {
    final interstitialConfig =
        widget.remoteConfig.adConfig.interstitialAdConfiguration;
    _transitionsBeforeShowingInterstitialAdsControllers = {
      for (final role in AppUserRole.values)
        role: TextEditingController(
          text: _getTransitionsBeforeInterstitial(
            interstitialConfig,
            role,
          ).toString(),
        )..selection = TextSelection.collapsed(
            offset: _getTransitionsBeforeInterstitial(
              interstitialConfig,
              role,
            ).toString().length,
          ),
    };
  }

  /// Updates text editing controllers when the widget's remote config changes.
  /// This ensures the form fields reflect the latest configuration.
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

  /// Listener for tab changes to enforce business rules, specifically for
  /// premium users who should not see ads.
  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    final selectedRole = AppUserRole.values[_tabController.index];
    if (selectedRole == AppUserRole.premiumUser) {
      final adConfig = widget.remoteConfig.adConfig;
      final interstitialAdConfig = adConfig.interstitialAdConfiguration;

      // If the value for premium is not 0, update the config.
      // This enforces the business rule that premium users do not see ads.
      final premiumRoleConfig =
          interstitialAdConfig.visibleTo[AppUserRole.premiumUser];
      if (premiumRoleConfig != null &&
          premiumRoleConfig.transitionsBeforeShowingInterstitialAds != 0) {
        final updatedVisibleTo = Map<AppUserRole, InterstitialAdFrequencyConfig>.from(
          interstitialAdConfig.visibleTo,
        )..[AppUserRole.premiumUser] = const InterstitialAdFrequencyConfig(
            transitionsBeforeShowingInterstitialAds: 0,
          );

        final updatedInterstitialAdConfig =
            interstitialAdConfig.copyWith(visibleTo: updatedVisibleTo);

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

  /// Builds role-specific configuration fields for interstitial ad frequency.
  ///
  /// This widget displays an input field for `transitionsBeforeShowingInterstitialAds`
  /// for a given [AppUserRole]. Premium users have this field disabled
  /// as they should not see ads.
  Widget _buildInterstitialRoleSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AppUserRole role,
    InterstitialAdConfiguration config,
  ) {
    final roleConfig = config.visibleTo[role];
    final isEnabled = role != AppUserRole.premiumUser;

    return Column(
      children: [
        CheckboxListTile(
          title: Text(l10n.visibleToRoleLabel(role.l10n(context))),
          value: roleConfig != null && isEnabled,
          onChanged: isEnabled
              ? (value) {
                  final newVisibleTo =
                      Map<AppUserRole, InterstitialAdFrequencyConfig>.from(
                    config.visibleTo,
                  );
                  if (value ?? false) {
                    // Default value when enabling for a role
                    newVisibleTo[role] = const InterstitialAdFrequencyConfig(
                      transitionsBeforeShowingInterstitialAds: 5,
                    );
                  } else {
                    newVisibleTo.remove(role);
                  }
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      adConfig: widget.remoteConfig.adConfig.copyWith(
                        interstitialAdConfiguration: config.copyWith(
                          visibleTo: newVisibleTo,
                        ),
                      ),
                    ),
                  );
                }
              : null,
        ),
        if (roleConfig != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: AppConfigIntField(
              label: l10n.transitionsBeforeInterstitialAdsLabel,
              description: l10n.transitionsBeforeInterstitialAdsDescription,
              value: roleConfig.transitionsBeforeShowingInterstitialAds,
              onChanged: (value) {
                final newRoleConfig =
                    roleConfig.copyWith(transitionsBeforeShowingInterstitialAds: value);
                final newVisibleTo =
                    Map<AppUserRole, InterstitialAdFrequencyConfig>.from(
                  config.visibleTo,
                )..[role] = newRoleConfig;
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    adConfig: widget.remoteConfig.adConfig.copyWith(
                      interstitialAdConfiguration: config.copyWith(
                        visibleTo: newVisibleTo,
                      ),
                    ),
                  ),
                );
              },
              controller: _transitionsBeforeShowingInterstitialAdsControllers[role],
              enabled: isEnabled,
            ),
          ),
      ],
    );
  }

  /// Retrieves the number of transitions before showing an interstitial ad
  /// for a specific role from the configuration.
  int _getTransitionsBeforeInterstitial(
    InterstitialAdConfiguration config,
    AppUserRole role,
  ) {
    return config.visibleTo[role]?.transitionsBeforeShowingInterstitialAds ?? 0;
  }
}
