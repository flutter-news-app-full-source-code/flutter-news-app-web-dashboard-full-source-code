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
          'nativeAdId': TextEditingController(
            text: widget.remoteConfig.features.ads
                    .platformAdIdentifiers[platform]?.nativeAdId ??
                '',
          ),
          'bannerAdId': TextEditingController(
            text: widget.remoteConfig.features.ads
                    .platformAdIdentifiers[platform]?.bannerAdId ??
                '',
          ),
          'interstitialAdId': TextEditingController(
            text: widget.remoteConfig.features.ads
                    .platformAdIdentifiers[platform]?.interstitialAdId ??
                '',
          ),
        },
    };
  }

  void _updateControllers() {
    for (final platform in AdPlatformType.values) {
      final identifiers =
          widget.remoteConfig.features.ads.platformAdIdentifiers[platform];

      final nativeAdId = identifiers?.nativeAdId ?? '';
      if (_platformAdIdentifierControllers[platform]!['nativeAdId']?.text !=
          nativeAdId) {
        _platformAdIdentifierControllers[platform]!['nativeAdId']?.text =
            nativeAdId;
      }

      final bannerAdId = identifiers?.bannerAdId ?? '';
      if (_platformAdIdentifierControllers[platform]!['bannerAdId']?.text !=
          bannerAdId) {
        _platformAdIdentifierControllers[platform]!['bannerAdId']?.text =
            bannerAdId;
      }

      final interstitialAdId = identifiers?.interstitialAdId ?? '';
      if (_platformAdIdentifierControllers[platform]!['interstitialAdId']
              ?.text !=
          interstitialAdId) {
        _platformAdIdentifierControllers[platform]!['interstitialAdId']?.text =
            interstitialAdId;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.primaryAdPlatformTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.primaryAdPlatformDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: AppSpacing.lg),
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
                _tabController.index =
                    AdPlatformType.values.indexOf(_selectedPlatform);
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
        const SizedBox(height: AppSpacing.lg),
        ExpansionTile(
          title: Text(l10n.adUnitIdentifiersTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
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
            Text(
              l10n.adUnitIdentifiersDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 300, // Adjust height as needed for the content
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
        nativeAdId:
            key == 'nativeAdId' ? value : platformIdentifiers.nativeAdId,
        bannerAdId:
            key == 'bannerAdId' ? value : platformIdentifiers.bannerAdId,
        interstitialAdId: key == 'interstitialAdId'
            ? value
            : platformIdentifiers.interstitialAdId,
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
        children: [
          AppConfigTextField(
            label: l10n.nativeAdIdLabel,
            description: l10n.nativeAdIdDescription,
            value: platformIdentifiers.nativeAdId,
            onChanged: (value) =>
                updatePlatformIdentifiers('nativeAdId', value),
            controller: controllers['nativeAdId'],
          ),
          AppConfigTextField(
            label: l10n.bannerAdIdLabel,
            description: l10n.bannerAdIdDescription,
            value: platformIdentifiers.bannerAdId,
            onChanged: (value) =>
                updatePlatformIdentifiers('bannerAdId', value),
            controller: controllers['bannerAdId'],
          ),
          AppConfigTextField(
            label: l10n.interstitialAdIdLabel,
            description: l10n.interstitialAdIdDescription,
            value: platformIdentifiers.interstitialAdId,
            onChanged: (value) =>
                updatePlatformIdentifiers('interstitialAdId', value),
            controller: controllers['interstitialAdId'],
          ),
        ],
      ),
    );
  }
}
