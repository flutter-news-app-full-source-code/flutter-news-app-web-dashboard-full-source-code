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

class _AdPlatformConfigFormState extends State<AdPlatformConfigForm> {
  late AdPlatformType _selectedPlatform;
  late Map<AdPlatformType, Map<String, TextEditingController>>
  _platformAdIdentifierControllers;

  @override
  void initState() {
    super.initState();
    _selectedPlatform = widget.remoteConfig.features.ads.primaryAdPlatform;
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

      final identifierGetters = <String, String?>{
        'androidNativeAdId': identifiers?.androidNativeAdId,
        'androidBannerAdId': identifiers?.androidBannerAdId,
        'androidInterstitialAdId': identifiers?.androidInterstitialAdId,
        'androidRewardedAdId': identifiers?.androidRewardedAdId,
        'iosNativeAdId': identifiers?.iosNativeAdId,
        'iosBannerAdId': identifiers?.iosBannerAdId,
        'iosInterstitialAdId': identifiers?.iosInterstitialAdId,
        'iosRewardedAdId': identifiers?.iosRewardedAdId,
      };

      for (final entry in identifierGetters.entries) {
        final controller =
            _platformAdIdentifierControllers[platform]![entry.key];
        final newValue = entry.value ?? '';
        if (controller != null && controller.text != newValue) {
          controller.text = newValue;
        }
      }
    }
  }

  @override
  void dispose() {
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
            SizedBox(
              height: 600, // Height for the tabbed content
              child: _buildAdUnitIdentifierFields(
                context,
                l10n,
                _selectedPlatform,
                adConfig,
              ),
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
      AdPlatformIdentifiers newIdentifiers;
      switch (key) {
        case 'androidNativeAdId':
          newIdentifiers =
              platformIdentifiers.copyWith(androidNativeAdId: value);
        case 'androidBannerAdId':
          newIdentifiers =
              platformIdentifiers.copyWith(androidBannerAdId: value);
        case 'androidInterstitialAdId':
          newIdentifiers =
              platformIdentifiers.copyWith(androidInterstitialAdId: value);
        case 'androidRewardedAdId':
          newIdentifiers =
              platformIdentifiers.copyWith(androidRewardedAdId: value);
        case 'iosNativeAdId':
          newIdentifiers = platformIdentifiers.copyWith(iosNativeAdId: value);
        case 'iosBannerAdId':
          newIdentifiers = platformIdentifiers.copyWith(iosBannerAdId: value);
        case 'iosInterstitialAdId':
          newIdentifiers =
              platformIdentifiers.copyWith(iosInterstitialAdId: value);
        case 'iosRewardedAdId':
          newIdentifiers = platformIdentifiers.copyWith(iosRewardedAdId: value);
        default:
          newIdentifiers = platformIdentifiers;
      }

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

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
            tabs: [
              Tab(text: l10n.android, icon: const Icon(Icons.android)),
              Tab(text: l10n.ios, icon: const Icon(Icons.apple)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: TabBarView(
              children: [
                // Android Fields
                SingleChildScrollView(
                  child: Column(
                    children: _buildPlatformFields(
                      l10n: l10n,
                      platformPrefix: 'android',
                      identifiers: platformIdentifiers,
                      controllers: controllers,
                      onChanged: updatePlatformIdentifiers,
                    ),
                  ),
                ),
                // iOS Fields
                SingleChildScrollView(
                  child: Column(
                    children: _buildPlatformFields(
                      l10n: l10n,
                      platformPrefix: 'ios',
                      identifiers: platformIdentifiers,
                      controllers: controllers,
                      onChanged: updatePlatformIdentifiers,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPlatformFields({
    required AppLocalizations l10n,
    required String platformPrefix,
    required AdPlatformIdentifiers identifiers,
    required Map<String, TextEditingController> controllers,
    required void Function(String, String?) onChanged,
  }) {
    // Helper to get value dynamically based on prefix
    String? getValue(String suffix) {
      if (platformPrefix == 'android') {
        if (suffix == 'NativeAdId') return identifiers.androidNativeAdId;
        if (suffix == 'BannerAdId') return identifiers.androidBannerAdId;
        if (suffix == 'InterstitialAdId') {
          return identifiers.androidInterstitialAdId;
        }
        if (suffix == 'RewardedAdId') return identifiers.androidRewardedAdId;
      } else {
        if (suffix == 'NativeAdId') return identifiers.iosNativeAdId;
        if (suffix == 'BannerAdId') return identifiers.iosBannerAdId;
        if (suffix == 'InterstitialAdId') return identifiers.iosInterstitialAdId;
        if (suffix == 'RewardedAdId') return identifiers.iosRewardedAdId;
      }
      return null;
    }

    return [
      AppConfigTextField(
        label: l10n.nativeAdIdLabel,
        description: l10n.nativeAdIdDescription,
        value: getValue('NativeAdId'),
        onChanged: (value) => onChanged('${platformPrefix}NativeAdId', value),
        controller: controllers['${platformPrefix}NativeAdId'],
      ),
      AppConfigTextField(
        label: l10n.bannerAdIdLabel,
        description: l10n.bannerAdIdDescription,
        value: getValue('BannerAdId'),
        onChanged: (value) => onChanged('${platformPrefix}BannerAdId', value),
        controller: controllers['${platformPrefix}BannerAdId'],
      ),
      AppConfigTextField(
        label: l10n.interstitialAdIdLabel,
        description: l10n.interstitialAdIdDescription,
        value: getValue('InterstitialAdId'),
        onChanged: (value) =>
            onChanged('${platformPrefix}InterstitialAdId', value),
        controller: controllers['${platformPrefix}InterstitialAdId'],
      ),
      AppConfigTextField(
        label: l10n.rewardedAdIdLabel,
        description: l10n.rewardedAdIdDescription,
        value: getValue('RewardedAdId'),
        onChanged: (value) => onChanged('${platformPrefix}RewardedAdId', value),
        controller: controllers['${platformPrefix}RewardedAdId'],
      ),
    ];
  }
}
