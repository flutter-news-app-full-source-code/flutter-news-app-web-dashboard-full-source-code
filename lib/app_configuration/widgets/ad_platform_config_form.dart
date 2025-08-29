import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
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
    _selectedPlatform = widget.remoteConfig.adConfig.primaryAdPlatform;
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant AdPlatformConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.adConfig != oldWidget.remoteConfig.adConfig) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    _platformAdIdentifierControllers = {
      for (final platform in AdPlatformType.values)
        platform: {
          'feedNativeAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .adConfig
                    .platformAdIdentifiers[platform]
                    ?.feedNativeAdId ??
                '',
          ),
          'feedBannerAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .adConfig
                    .platformAdIdentifiers[platform]
                    ?.feedBannerAdId ??
                '',
          ),
          'articleInterstitialAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .adConfig
                    .platformAdIdentifiers[platform]
                    ?.articleInterstitialAdId ??
                '',
          ),
          'inArticleNativeAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .adConfig
                    .platformAdIdentifiers[platform]
                    ?.inArticleNativeAdId ??
                '',
          ),
          'inArticleBannerAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .adConfig
                    .platformAdIdentifiers[platform]
                    ?.inArticleBannerAdId ??
                '',
          ),
        },
    };
  }

  void _updateControllers() {
    for (final platform in AdPlatformType.values) {
      _platformAdIdentifierControllers[platform]!['feedNativeAdId']?.text =
          widget
              .remoteConfig
              .adConfig
              .platformAdIdentifiers[platform]
              ?.feedNativeAdId ??
          '';
      _platformAdIdentifierControllers[platform]!['feedBannerAdId']?.text =
          widget
              .remoteConfig
              .adConfig
              .platformAdIdentifiers[platform]
              ?.feedBannerAdId ??
          '';
      _platformAdIdentifierControllers[platform]!['articleInterstitialAdId']
              ?.text =
          widget
              .remoteConfig
              .adConfig
              .platformAdIdentifiers[platform]
              ?.articleInterstitialAdId ??
          '';
      _platformAdIdentifierControllers[platform]!['inArticleNativeAdId']?.text =
          widget
              .remoteConfig
              .adConfig
              .platformAdIdentifiers[platform]
              ?.inArticleNativeAdId ??
          '';
      _platformAdIdentifierControllers[platform]!['inArticleBannerAdId']?.text =
          widget
              .remoteConfig
              .adConfig
              .platformAdIdentifiers[platform]
              ?.inArticleBannerAdId ??
          '';
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
    final adConfig = widget.remoteConfig.adConfig;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary Ad Platform Selection
        ExpansionTile(
          title: Text(l10n.primaryAdPlatformTitle),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          children: [
            Text(
              l10n.primaryAdPlatformDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: SegmentedButton<AdPlatformType>(
                segments: AdPlatformType.values
                    .map(
                      (platform) => ButtonSegment<AdPlatformType>(
                        value: platform,
                        label: Text(platform.name),
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
                      adConfig: adConfig.copyWith(
                        primaryAdPlatform: newSelection.first,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Ad Unit Identifiers
        ExpansionTile(
          title: Text(l10n.adUnitIdentifiersTitle),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          children: [
            Text(
              l10n.adUnitIdentifiersDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildAdUnitIdentifierFields(
              context,
              l10n,
              _selectedPlatform,
              adConfig,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Local Ad Management (Non-functional as requested)
        if (_selectedPlatform == AdPlatformType.local)
          ExpansionTile(
            title: Text(l10n.localAdManagementTitle),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.md,
            ),
            children: [
              Text(
                l10n.localAdManagementDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: ElevatedButton(
                  onPressed: null,
                  child: Text(l10n.manageLocalAdsButton),
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
        case 'feedNativeAdId':
          newIdentifiers = platformIdentifiers.copyWith(feedNativeAdId: value);
        case 'feedBannerAdId':
          newIdentifiers = platformIdentifiers.copyWith(feedBannerAdId: value);
        case 'articleInterstitialAdId':
          newIdentifiers = platformIdentifiers.copyWith(
            articleInterstitialAdId: value,
          );
        case 'inArticleNativeAdId':
          newIdentifiers = platformIdentifiers.copyWith(
            inArticleNativeAdId: value,
          );
        case 'inArticleBannerAdId':
          newIdentifiers = platformIdentifiers.copyWith(
            inArticleBannerAdId: value,
          );
        default:
          return;
      }

      final newPlatformAdIdentifiers =
          Map<AdPlatformType, AdPlatformIdentifiers>.from(
            config.platformAdIdentifiers,
          )..[platform] = newIdentifiers;

      widget.onConfigChanged(
        widget.remoteConfig.copyWith(
          adConfig: config.copyWith(
            platformAdIdentifiers: newPlatformAdIdentifiers,
          ),
        ),
      );
    }

    return Column(
      children: [
        AppConfigTextField(
          label: l10n.feedNativeAdIdLabel,
          description: l10n.feedNativeAdIdDescription,
          value: platformIdentifiers.feedNativeAdId,
          onChanged: (value) =>
              updatePlatformIdentifiers('feedNativeAdId', value),
          controller: controllers['feedNativeAdId'],
        ),
        AppConfigTextField(
          label: l10n.feedBannerAdIdLabel,
          description: l10n.feedBannerAdIdDescription,
          value: platformIdentifiers.feedBannerAdId,
          onChanged: (value) =>
              updatePlatformIdentifiers('feedBannerAdId', value),
          controller: controllers['feedBannerAdId'],
        ),
        AppConfigTextField(
          label: l10n.articleInterstitialAdIdLabel,
          description: l10n.articleInterstitialAdIdDescription,
          value: platformIdentifiers.articleInterstitialAdId,
          onChanged: (value) =>
              updatePlatformIdentifiers('articleInterstitialAdId', value),
          controller: controllers['articleInterstitialAdId'],
        ),
        AppConfigTextField(
          label: l10n.inArticleNativeAdIdLabel,
          description: l10n.inArticleNativeAdIdDescription,
          value: platformIdentifiers.inArticleNativeAdId,
          onChanged: (value) =>
              updatePlatformIdentifiers('inArticleNativeAdId', value),
          controller: controllers['inArticleNativeAdId'],
        ),
        AppConfigTextField(
          label: l10n.inArticleBannerAdIdLabel,
          description: l10n.inArticleBannerAdIdDescription,
          value: platformIdentifiers.inArticleBannerAdId,
          onChanged: (value) =>
              updatePlatformIdentifiers('inArticleBannerAdId', value),
          controller: controllers['inArticleBannerAdId'],
        ),
      ],
    );
  }
}
