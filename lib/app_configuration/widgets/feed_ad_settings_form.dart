import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/ad_type_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template feed_ad_settings_form}
/// A form widget for configuring feed ad settings.
/// {@endtemplate}
class FeedAdSettingsForm extends StatefulWidget {
  /// {@macro feed_ad_settings_form}
  const FeedAdSettingsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<FeedAdSettingsForm> createState() => _FeedAdSettingsFormState();
}

class _FeedAdSettingsFormState extends State<FeedAdSettingsForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// Controllers for ad frequency fields, mapped by user role.
  /// These are used to manage text input for each role's ad frequency.
  late final Map<AppUserRole, TextEditingController> _adFrequencyControllers;

  /// Controllers for ad placement interval fields, mapped by user role.
  /// These are used to manage text input for each role's ad placement interval.
  late final Map<AppUserRole, TextEditingController>
      _adPlacementIntervalControllers;

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
    final feedAdConfig = widget.remoteConfig.adConfig.feedAdConfiguration;
    _adFrequencyControllers = {
      for (final role in AppUserRole.values)
        role: TextEditingController(
          text: _getAdFrequency(feedAdConfig, role).toString(),
        )..selection = TextSelection.collapsed(
            offset: _getAdFrequency(feedAdConfig, role).toString().length,
          ),
    };
    _adPlacementIntervalControllers = {
      for (final role in AppUserRole.values)
        role: TextEditingController(
          text: _getAdPlacementInterval(feedAdConfig, role).toString(),
        )..selection = TextSelection.collapsed(
            offset:
                _getAdPlacementInterval(feedAdConfig, role).toString().length,
          ),
    };
  }

  /// Updates text editing controllers when the widget's remote config changes.
  /// This ensures the form fields reflect the latest configuration.
  void _updateControllers() {
    final feedAdConfig = widget.remoteConfig.adConfig.feedAdConfiguration;
    for (final role in AppUserRole.values) {
      final newFrequencyValue = _getAdFrequency(feedAdConfig, role).toString();
      if (_adFrequencyControllers[role]?.text != newFrequencyValue) {
        _adFrequencyControllers[role]?.text = newFrequencyValue;
        _adFrequencyControllers[role]?.selection = TextSelection.collapsed(
          offset: newFrequencyValue.length,
        );
      }

      final newPlacementIntervalValue =
          _getAdPlacementInterval(feedAdConfig, role).toString();
      if (_adPlacementIntervalControllers[role]?.text !=
          newPlacementIntervalValue) {
        _adPlacementIntervalControllers[role]?.text = newPlacementIntervalValue;
        _adPlacementIntervalControllers[role]?.selection =
            TextSelection.collapsed(
          offset: newPlacementIntervalValue.length,
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
      final feedAdConfig = adConfig.feedAdConfiguration;

      // If the values for premium are not 0, update the config.
      // This enforces the business rule that premium users do not see ads.
      final premiumRoleConfig = feedAdConfig.visibleTo[AppUserRole.premiumUser];
      if (premiumRoleConfig != null &&
          (premiumRoleConfig.adFrequency != 0 ||
              premiumRoleConfig.adPlacementInterval != 0)) {
        final updatedVisibleTo =
            Map<AppUserRole, FeedAdFrequencyConfig>.from(feedAdConfig.visibleTo)
              ..[AppUserRole.premiumUser] = const FeedAdFrequencyConfig(
                adFrequency: 0,
                adPlacementInterval: 0,
              );

        final updatedFeedAdConfig =
            feedAdConfig.copyWith(visibleTo: updatedVisibleTo);

        widget.onConfigChanged(
          widget.remoteConfig.copyWith(
            adConfig: adConfig.copyWith(
              feedAdConfiguration: updatedFeedAdConfig,
            ),
          ),
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant FeedAdSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.adConfig.feedAdConfiguration !=
        oldWidget.remoteConfig.adConfig.feedAdConfiguration) {
      _updateControllers();
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    for (final controller in _adFrequencyControllers.values) {
      controller.dispose();
    }
    for (final controller in _adPlacementIntervalControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final adConfig = widget.remoteConfig.adConfig;
    final feedAdConfig = adConfig.feedAdConfiguration;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableFeedAdsLabel),
          value: feedAdConfig.enabled,
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: adConfig.copyWith(
                  feedAdConfiguration: feedAdConfig.copyWith(enabled: value),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        ExpansionTile(
          title: Text(l10n.feedAdTypeSelectionTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.feedAdTypeSelectionDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SegmentedButton<AdType>(
                style: SegmentedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                segments: AdType.values
                    .where(
                      (type) => type == AdType.native || type == AdType.banner,
                    )
                    .map(
                      (type) => ButtonSegment<AdType>(
                        value: type,
                        label: Text(type.l10n(context)),
                      ),
                    )
                    .toList(),
                selected: {feedAdConfig.adType},
                onSelectionChanged: (newSelection) {
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      adConfig: adConfig.copyWith(
                        feedAdConfiguration: feedAdConfig.copyWith(
                          adType: newSelection.first,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ExpansionTile(
          title: Text(l10n.userRoleFrequencySettingsTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.userRoleFrequencySettingsDescription,
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
              height: 350, // Increased height for better spacing
              child: TabBarView(
                controller: _tabController,
                children: AppUserRole.values
                    .map(
                      (role) => _buildRoleSpecificFields(
                        context,
                        l10n,
                        role,
                        feedAdConfig,
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

  /// Builds role-specific configuration fields for feed ad frequency.
  ///
  /// This widget displays input fields for ad frequency and placement interval
  /// for a given [AppUserRole]. Premium users have these fields disabled
  /// as they should not see ads.
  Widget _buildRoleSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AppUserRole role,
    FeedAdConfiguration config,
  ) {
    final roleConfig = config.visibleTo[role];
    final isEnabled = role != AppUserRole.premiumUser;

    return Column(
      children: [
        SwitchListTile(
          // Changed from CheckboxListTile to SwitchListTile for consistency
          title: Text(l10n.enableInArticleAdsForRoleLabel(role.l10n(context))),
          value: roleConfig != null && isEnabled,
          onChanged: isEnabled
              ? (value) {
                  final newVisibleTo =
                      Map<AppUserRole, FeedAdFrequencyConfig>.from(
                    config.visibleTo,
                  );
                  if (value) {
                    // Default values when enabling for a role
                    newVisibleTo[role] = const FeedAdFrequencyConfig(
                      adFrequency: 5,
                      adPlacementInterval: 3,
                    );
                  } else {
                    newVisibleTo.remove(role);
                  }
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      adConfig: widget.remoteConfig.adConfig.copyWith(
                        feedAdConfiguration: config.copyWith(
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
            child: Column(
              children: [
                AppConfigIntField(
                  label: l10n.adFrequencyLabel,
                  description: l10n.adFrequencyDescription,
                  value: roleConfig.adFrequency,
                  onChanged: (value) {
                    final newRoleConfig =
                        roleConfig.copyWith(adFrequency: value);
                    final newVisibleTo =
                        Map<AppUserRole, FeedAdFrequencyConfig>.from(
                      config.visibleTo,
                    )..[role] = newRoleConfig;
                    widget.onConfigChanged(
                      widget.remoteConfig.copyWith(
                        adConfig: widget.remoteConfig.adConfig.copyWith(
                          feedAdConfiguration: config.copyWith(
                            visibleTo: newVisibleTo,
                          ),
                        ),
                      ),
                    );
                  },
                  controller: _adFrequencyControllers[role],
                  enabled: isEnabled,
                ),
                AppConfigIntField(
                  label: l10n.adPlacementIntervalLabel,
                  description: l10n.adPlacementIntervalDescription,
                  value: roleConfig.adPlacementInterval,
                  onChanged: (value) {
                    final newRoleConfig =
                        roleConfig.copyWith(adPlacementInterval: value);
                    final newVisibleTo =
                        Map<AppUserRole, FeedAdFrequencyConfig>.from(
                      config.visibleTo,
                    )..[role] = newRoleConfig;
                    widget.onConfigChanged(
                      widget.remoteConfig.copyWith(
                        adConfig: widget.remoteConfig.adConfig.copyWith(
                          feedAdConfiguration: config.copyWith(
                            visibleTo: newVisibleTo,
                          ),
                        ),
                      ),
                    );
                  },
                  controller: _adPlacementIntervalControllers[role],
                  enabled: isEnabled,
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Retrieves the ad frequency for a specific role from the configuration.
  int _getAdFrequency(FeedAdConfiguration config, AppUserRole role) {
    return config.visibleTo[role]?.adFrequency ?? 0;
  }

  /// Retrieves the ad placement interval for a specific role from the configuration.
  int _getAdPlacementInterval(FeedAdConfiguration config, AppUserRole role) {
    return config.visibleTo[role]?.adPlacementInterval ?? 0;
  }
}
