import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/ad_platform_type_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template ad_platform_config_form}
/// A form widget for configuring the primary ad platform and ad unit identifiers.
/// {@endtemplate}
class AdPlatformConfigForm extends StatefulWidget {
  /// {@macro ad_platform_config_form}
  const AdPlatformConfigForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<AdPlatformConfigForm> createState() => _AdPlatformConfigFormState();
}

class _AdPlatformConfigFormState extends State<AdPlatformConfigForm>
    with SingleTickerProviderStateMixin {
  late AdPlatformType _selectedPlatform;
  late Map<AdPlatformType, Map<String, TextEditingController>>
  _platformAdIdentifierControllers;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _selectedPlatform = widget.remoteConfig.features.ads.primaryAdPlatform;
    _tabController = TabController(
      length: AdPlatformType.values.length,
      vsync: this,
    );
    _tabController.index = AdPlatformType.values.indexOf(_selectedPlatform);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(
          () => _selectedPlatform = AdPlatformType.values[_tabController.index],
        );
      }
    });
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant AdPlatformConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.features.ads !=
        oldWidget.remoteConfig.features.ads) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    _platformAdIdentifierControllers = {
      for (final platform in AdPlatformType.values)
        platform: {
          'androidNativeAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .features
                    .ads
                    .platformAdIdentifiers[platform]
                    ?.androidNativeAdId ??
                '',
          ),
          'androidBannerAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .features
                    .ads
                    .platformAdIdentifiers[platform]
                    ?.androidBannerAdId ??
                '',
          ),
          'androidInterstitialAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .features
                    .ads
                    .platformAdIdentifiers[platform]
                    ?.androidInterstitialAdId ??
                '',
          ),
          'androidRewardedAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .features
                    .ads
                    .platformAdIdentifiers[platform]
                    ?.androidRewardedAdId ??
                '',
          ),
          'iosNativeAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .features
                    .ads
                    .platformAdIdentifiers[platform]
                    ?.iosNativeAdId ??
                '',
          ),
          'iosBannerAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .features
                    .ads
                    .platformAdIdentifiers[platform]
                    ?.iosBannerAdId ??
                '',
          ),
          'iosInterstitialAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .features
                    .ads
                    .platformAdIdentifiers[platform]
                    ?.iosInterstitialAdId ??
                '',
          ),
          'iosRewardedAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .features
                    .ads
                    .platformAdIdentifiers[platform]
                    ?.iosRewardedAdId ??
                '',
          ),
        },
    };
  }

  void _updateControllers() {
    for (final platform in AdPlatformType.values) {
      final identifiers =
          widget.remoteConfig.features.ads.platformAdIdentifiers[platform];

      final androidNativeAdId = identifiers?.androidNativeAdId ?? '';
      if (_platformAdIdentifierControllers[platform]!['androidNativeAdId']
              ?.text !=
          androidNativeAdId) {
        _platformAdIdentifierControllers[platform]!['androidNativeAdId']?.text =
            androidNativeAdId;
      }

      final androidBannerAdId = identifiers?.androidBannerAdId ?? '';
      if (_platformAdIdentifierControllers[platform]!['androidBannerAdId']
              ?.text !=
          androidBannerAdId) {
        _platformAdIdentifierControllers[platform]!['androidBannerAdId']?.text =
            androidBannerAdId;
      }

      final androidInterstitialAdId =
          identifiers?.androidInterstitialAdId ?? '';
      if (_platformAdIdentifierControllers[platform]!['androidInterstitialAdId']
              ?.text !=
          androidInterstitialAdId) {
        _platformAdIdentifierControllers[platform]!['androidInterstitialAdId']
                ?.text =
            androidInterstitialAdId;
      }

      final androidRewardedAdId = identifiers?.androidRewardedAdId ?? '';
      if (_platformAdIdentifierControllers[platform]!['androidRewardedAdId']
              ?.text !=
          androidRewardedAdId) {
        _platformAdIdentifierControllers[platform]!['androidRewardedAdId']
                ?.text =
            androidRewardedAdId;
      }

      final iosNativeAdId = identifiers?.iosNativeAdId ?? '';
      if (_platformAdIdentifierControllers[platform]!['iosNativeAdId']?.text !=
          iosNativeAdId) {
        _platformAdIdentifierControllers[platform]!['iosNativeAdId']?.text =
            iosNativeAdId;
      }

      final iosBannerAdId = identifiers?.iosBannerAdId ?? '';
      if (_platformAdIdentifierControllers[platform]!['iosBannerAdId']?.text !=
          iosBannerAdId) {
        _platformAdIdentifierControllers[platform]!['iosBannerAdId']?.text =
            iosBannerAdId;
      }

      final iosInterstitialAdId = identifiers?.iosInterstitialAdId ?? '';
      if (_platformAdIdentifierControllers[platform]!['iosInterstitialAdId']
              ?.text !=
          iosInterstitialAdId) {
        _platformAdIdentifierControllers[platform]!['iosInterstitialAdId']
                ?.text =
            iosInterstitialAdId;
      }

      final iosRewardedAdId = identifiers?.iosRewardedAdId ?? '';
      if (_platformAdIdentifierControllers[platform]!['iosRewardedAdId']
              ?.text !=
          iosRewardedAdId) {
        _platformAdIdentifierControllers[platform]!['iosRewardedAdId']?.text =
            iosRewardedAdId;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final platformControllers in _platformAdIdentifierControllers.values) {
      for (final controller in platformControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final adConfig = widget.remoteConfig.features.ads;

    return ExpansionTile(
      title: Text(l10n.adPlatformConfigurationTitle),
      subtitle: Text(
        l10n.adPlatformConfigurationDescription,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      children: [
        ExpansionTile(
          title: Text(l10n.primaryAdPlatformTitle),
          subtitle: Text(
            l10n.primaryAdPlatformDescription,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: SegmentedButton<AdPlatformType>(
                    style: SegmentedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    segments: AdPlatformType.values
                        .map(
                          (type) => ButtonSegment<AdPlatformType>(
                            value: type,
                            label: Text(type.l10n(context)),
                          ),
                        )
                        .toList(),
                    selected: {_selectedPlatform},
                    onSelectionChanged: (newSelection) {
                      setState(() {
                        _selectedPlatform = newSelection.first;
                        _tabController.index = AdPlatformType.values.indexOf(
                          _selectedPlatform,
                        );
                      });
                      widget.onConfigChanged(
                        widget.remoteConfig.copyWith(
                          features: widget.remoteConfig.features.copyWith(
                            ads: adConfig.copyWith(
                              primaryAdPlatform: newSelection.first,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ExpansionTile(
          title: Text(l10n.adUnitIdentifiersTitle),
          subtitle: Text(
            l10n.adUnitIdentifiersDescription,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: SizedBox(
                    height: kTextTabBarHeight,
                    child: TabBar(
                      controller: _tabController,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      tabs: AdPlatformType.values
                          .map((platform) => Tab(text: platform.l10n(context)))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 600, // Increased height for more fields
                  child: TabBarView(
                    controller: _tabController,
                    children: AdPlatformType.values
                        .map(
                          (platform) => _buildAdUnitIdentifierFields(
                            context,
                            l10n,
                            platform,
                            adConfig,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdUnitIdentifierFields(
    BuildContext context,
    AppLocalizations l10n,
    AdPlatformType platform,
    AdConfig config,
  ) {
    final platformIdentifiers =
        config.platformAdIdentifiers[platform] ?? const AdPlatformIdentifiers();
    final controllers = _platformAdIdentifierControllers[platform]!;

    void updatePlatformIdentifiers(String key, String? value) {
      final newIdentifiers = platformIdentifiers.copyWith(
        androidNativeAdId: key == 'androidNativeAdId'
            ? value
            : platformIdentifiers.androidNativeAdId,
        androidBannerAdId: key == 'androidBannerAdId'
            ? value
            : platformIdentifiers.androidBannerAdId,
        androidInterstitialAdId: key == 'androidInterstitialAdId'
            ? value
            : platformIdentifiers.androidInterstitialAdId,
        androidRewardedAdId: key == 'androidRewardedAdId'
            ? value
            : platformIdentifiers.androidRewardedAdId,
        iosNativeAdId: key == 'iosNativeAdId'
            ? value
            : platformIdentifiers.iosNativeAdId,
        iosBannerAdId: key == 'iosBannerAdId'
            ? value
            : platformIdentifiers.iosBannerAdId,
        iosInterstitialAdId: key == 'iosInterstitialAdId'
            ? value
            : platformIdentifiers.iosInterstitialAdId,
        iosRewardedAdId: key == 'iosRewardedAdId'
            ? value
            : platformIdentifiers.iosRewardedAdId,
      );

      final newPlatformAdIdentifiers =
          Map<AdPlatformType, AdPlatformIdentifiers>.from(
            config.platformAdIdentifiers,
          )..update(
            platform,
            (_) => newIdentifiers,
            ifAbsent: () => newIdentifiers,
          );

      widget.onConfigChanged(
        widget.remoteConfig.copyWith(
          features: widget.remoteConfig.features.copyWith(
            ads: config.copyWith(
              platformAdIdentifiers: newPlatformAdIdentifiers,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Android Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(
              l10n.androidAdUnitsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          AppConfigTextField(
            label: l10n.nativeAdIdLabel,
            description: l10n.nativeAdIdDescription,
            value: platformIdentifiers.androidNativeAdId,
            onChanged: (value) =>
                updatePlatformIdentifiers('androidNativeAdId', value),
            controller: controllers['androidNativeAdId'],
          ),
          AppConfigTextField(
            label: l10n.bannerAdIdLabel,
            description: l10n.bannerAdIdDescription,
            value: platformIdentifiers.androidBannerAdId,
            onChanged: (value) =>
                updatePlatformIdentifiers('androidBannerAdId', value),
            controller: controllers['androidBannerAdId'],
          ),
          AppConfigTextField(
            label: l10n.interstitialAdIdLabel,
            description: l10n.interstitialAdIdDescription,
            value: platformIdentifiers.androidInterstitialAdId,
            onChanged: (value) =>
                updatePlatformIdentifiers('androidInterstitialAdId', value),
            controller: controllers['androidInterstitialAdId'],
          ),
          AppConfigTextField(
            label: l10n.rewardedAdIdLabel,
            description: l10n.rewardedAdIdDescription,
            value: platformIdentifiers.androidRewardedAdId,
            onChanged: (value) =>
                updatePlatformIdentifiers('androidRewardedAdId', value),
            controller: controllers['androidRewardedAdId'],
          ),
          const SizedBox(height: AppSpacing.lg),

          // iOS Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(
              l10n.iosAdUnitsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          AppConfigTextField(
            label: l10n.nativeAdIdLabel,
            description: l10n.nativeAdIdDescription,
            value: platformIdentifiers.iosNativeAdId,
            onChanged: (value) =>
                updatePlatformIdentifiers('iosNativeAdId', value),
            controller: controllers['iosNativeAdId'],
          ),
          AppConfigTextField(
            label: l10n.bannerAdIdLabel,
            description: l10n.bannerAdIdDescription,
            value: platformIdentifiers.iosBannerAdId,
            onChanged: (value) =>
                updatePlatformIdentifiers('iosBannerAdId', value),
            controller: controllers['iosBannerAdId'],
          ),
          AppConfigTextField(
            label: l10n.interstitialAdIdLabel,
            description: l10n.interstitialAdIdDescription,
            value: platformIdentifiers.iosInterstitialAdId,
            onChanged: (value) =>
                updatePlatformIdentifiers('iosInterstitialAdId', value),
            controller: controllers['iosInterstitialAdId'],
          ),
          AppConfigTextField(
            label: l10n.rewardedAdIdLabel,
            description: l10n.rewardedAdIdDescription,
            value: platformIdentifiers.iosRewardedAdId,
            onChanged: (value) =>
                updatePlatformIdentifiers('iosRewardedAdId', value),
            controller: controllers['iosRewardedAdId'],
          ),
        ],
      ),
    );
  }
}
