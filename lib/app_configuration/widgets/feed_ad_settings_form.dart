import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/ad_type_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/access_tier_l10n.dart';
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

  /// Controllers for ad frequency fields, mapped by access tier.
  /// These are used to manage text input for each tier's ad frequency.
  late final Map<AccessTier, TextEditingController> _adFrequencyControllers;

  /// Controllers for ad placement interval fields, mapped by access tier.
  /// These are used to manage text input for each tier's ad placement interval.
  late final Map<AccessTier, TextEditingController>
  _adPlacementIntervalControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AccessTier.values.length,
      vsync: this,
    );
    _initializeControllers();
  }

  /// Initializes text editing controllers for each access tier based on current
  /// remote config values.
  void _initializeControllers() {
    final feedAdConfig = widget.remoteConfig.features.ads.feedAdConfiguration;
    _adFrequencyControllers = {
      for (final tier in AccessTier.values)
        tier:
            TextEditingController(
                text: _getAdFrequency(feedAdConfig, tier).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: _getAdFrequency(feedAdConfig, tier).toString().length,
              ),
    };
    _adPlacementIntervalControllers = {
      for (final tier in AccessTier.values)
        tier:
            TextEditingController(
                text: _getAdPlacementInterval(feedAdConfig, tier).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: _getAdPlacementInterval(
                  feedAdConfig,
                  tier,
                ).toString().length,
              ),
    };
  }

  /// Updates text editing controllers when the widget's remote config changes.
  /// This ensures the form fields reflect the latest configuration.
  void _updateControllers() {
    final feedAdConfig = widget.remoteConfig.features.ads.feedAdConfiguration;
    for (final tier in AccessTier.values) {
      final newFrequencyValue = _getAdFrequency(feedAdConfig, tier).toString();
      if (_adFrequencyControllers[tier]?.text != newFrequencyValue) {
        _adFrequencyControllers[tier]?.text = newFrequencyValue;
        _adFrequencyControllers[tier]?.selection = TextSelection.collapsed(
          offset: newFrequencyValue.length,
        );
      }

      final newPlacementIntervalValue = _getAdPlacementInterval(
        feedAdConfig,
        tier,
      ).toString();
      if (_adPlacementIntervalControllers[tier]?.text !=
          newPlacementIntervalValue) {
        _adPlacementIntervalControllers[tier]?.text = newPlacementIntervalValue;
        _adPlacementIntervalControllers[tier]?.selection =
            TextSelection.collapsed(
              offset: newPlacementIntervalValue.length,
            );
      }
    }
  }

  @override
  void didUpdateWidget(covariant FeedAdSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.features.ads.feedAdConfiguration !=
        oldWidget.remoteConfig.features.ads.feedAdConfiguration) {
      _updateControllers();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final features = widget.remoteConfig.features;
    final adConfig = features.ads;
    final feedAdConfig = adConfig.feedAdConfiguration;

    return ExpansionTile(
      title: Text(l10n.feedAdSettingsTitle),
      subtitle: Text(
        l10n.feedAdSettingsDescription,
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
          title: Text(l10n.enableFeedAdsLabel),
          subtitle: Text(l10n.enableFeedAdsDescription),
          value: feedAdConfig.enabled,
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                features: features.copyWith(
                  ads: adConfig.copyWith(
                    feedAdConfiguration: feedAdConfig.copyWith(enabled: value),
                  ),
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
                      features: features.copyWith(
                        ads: adConfig.copyWith(
                          feedAdConfiguration: feedAdConfig.copyWith(
                            adType: newSelection.first,
                          ),
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

  /// Builds tier-specific configuration fields for feed ad frequency.
  ///
  /// This widget displays input fields for ad frequency and placement interval
  /// for a given [AccessTier].
  Widget _buildTierSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AccessTier tier,
    FeedAdConfiguration config,
  ) {
    final tierConfig = config.visibleTo[tier];

    return Column(
      children: [
        SwitchListTile(
          title: Text(l10n.visibleToRoleLabel(tier.l10n(context))),
          subtitle: Text(l10n.visibleToRoleDescription(tier.l10n(context))),
          value: tierConfig != null,
          onChanged: (value) {
            final newVisibleTo = Map<AccessTier, FeedAdFrequencyConfig>.from(
              config.visibleTo,
            );
            if (value) {
              // Default values when enabling for a tier
              newVisibleTo[tier] = const FeedAdFrequencyConfig(
                adFrequency: 5,
                adPlacementInterval: 3,
              );
            } else {
              newVisibleTo.remove(tier);
            }
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                features: widget.remoteConfig.features.copyWith(
                  ads: widget.remoteConfig.features.ads.copyWith(
                    feedAdConfiguration: config.copyWith(
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
                  label: l10n.adFrequencyLabel,
                  description: l10n.adFrequencyDescription,
                  value: tierConfig.adFrequency,
                  onChanged: (value) {
                    final newTierConfig = tierConfig.copyWith(
                      adFrequency: value,
                    );
                    final newVisibleTo =
                        Map<AccessTier, FeedAdFrequencyConfig>.from(
                          config.visibleTo,
                        )..[tier] = newTierConfig;
                    widget.onConfigChanged(
                      widget.remoteConfig.copyWith(
                        features: widget.remoteConfig.features.copyWith(
                          ads: widget.remoteConfig.features.ads.copyWith(
                            feedAdConfiguration: config.copyWith(
                              visibleTo: newVisibleTo,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  controller: _adFrequencyControllers[tier],
                ),
                AppConfigIntField(
                  label: l10n.adPlacementIntervalLabel,
                  description: l10n.adPlacementIntervalDescription,
                  value: tierConfig.adPlacementInterval,
                  onChanged: (value) {
                    final newTierConfig = tierConfig.copyWith(
                      adPlacementInterval: value,
                    );
                    final newVisibleTo =
                        Map<AccessTier, FeedAdFrequencyConfig>.from(
                          config.visibleTo,
                        )..[tier] = newTierConfig;
                    widget.onConfigChanged(
                      widget.remoteConfig.copyWith(
                        features: widget.remoteConfig.features.copyWith(
                          ads: widget.remoteConfig.features.ads.copyWith(
                            feedAdConfiguration: config.copyWith(
                              visibleTo: newVisibleTo,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  controller: _adPlacementIntervalControllers[tier],
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Retrieves the ad frequency for a specific tier from the configuration.
  int _getAdFrequency(FeedAdConfiguration config, AccessTier tier) {
    return config.visibleTo[tier]?.adFrequency ?? 0;
  }

  /// Retrieves the ad placement interval for a specific tier from the configuration.
  int _getAdPlacementInterval(FeedAdConfiguration config, AccessTier tier) {
    return config.visibleTo[tier]?.adPlacementInterval ?? 0;
  }
}
