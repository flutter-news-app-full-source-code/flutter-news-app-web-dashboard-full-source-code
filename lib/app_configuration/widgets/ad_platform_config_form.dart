import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/ad_platform_type_l10n.dart';
import 'package:go_router/go_router.dart';
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
          'feedToArticleInterstitialAdId': TextEditingController(
            text:
                widget
                    .remoteConfig
                    .adConfig
                    .platformAdIdentifiers[platform]
                    ?.feedToArticleInterstitialAdId ??
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
      final feedNativeAdId =
          widget
              .remoteConfig
              .adConfig
              .platformAdIdentifiers[platform]
              ?.feedNativeAdId ??
          '';
      if (_platformAdIdentifierControllers[platform]!['feedNativeAdId']?.text !=
          feedNativeAdId) {
        _platformAdIdentifierControllers[platform]!['feedNativeAdId']?.text =
            feedNativeAdId;
        _platformAdIdentifierControllers[platform]!['feedNativeAdId']
            ?.selection = TextSelection.collapsed(
          offset: feedNativeAdId.length,
        );
      }

      final feedBannerAdId =
          widget
              .remoteConfig
              .adConfig
              .platformAdIdentifiers[platform]
              ?.feedBannerAdId ??
          '';
      if (_platformAdIdentifierControllers[platform]!['feedBannerAdId']?.text !=
          feedBannerAdId) {
        _platformAdIdentifierControllers[platform]!['feedBannerAdId']?.text =
            feedBannerAdId;
        _platformAdIdentifierControllers[platform]!['feedBannerAdId']
            ?.selection = TextSelection.collapsed(
          offset: feedBannerAdId.length,
        );
      }

      final feedToArticleInterstitialAdId =
          widget
              .remoteConfig
              .adConfig
              .platformAdIdentifiers[platform]
              ?.feedToArticleInterstitialAdId ??
          '';
      if (_platformAdIdentifierControllers[platform]!['feedToArticleInterstitialAdId']
              ?.text !=
          feedToArticleInterstitialAdId) {
        _platformAdIdentifierControllers[platform]!['feedToArticleInterstitialAdId']
                ?.text =
            feedToArticleInterstitialAdId;
        _platformAdIdentifierControllers[platform]!['feedToArticleInterstitialAdId']
            ?.selection = TextSelection.collapsed(
          offset: feedToArticleInterstitialAdId.length,
        );
      }

      final inArticleNativeAdId =
          widget
              .remoteConfig
              .adConfig
              .platformAdIdentifiers[platform]
              ?.inArticleNativeAdId ??
          '';
      if (_platformAdIdentifierControllers[platform]!['inArticleNativeAdId']
              ?.text !=
          inArticleNativeAdId) {
        _platformAdIdentifierControllers[platform]!['inArticleNativeAdId']
                ?.text =
            inArticleNativeAdId;
        _platformAdIdentifierControllers[platform]!['inArticleNativeAdId']
            ?.selection = TextSelection.collapsed(
          offset: inArticleNativeAdId.length,
        );
      }

      final inArticleBannerAdId =
          widget
              .remoteConfig
              .adConfig
              .platformAdIdentifiers[platform]
              ?.inArticleBannerAdId ??
          '';
      if (_platformAdIdentifierControllers[platform]!['inArticleBannerAdId']
              ?.text !=
          inArticleBannerAdId) {
        _platformAdIdentifierControllers[platform]!['inArticleBannerAdId']
                ?.text =
            inArticleBannerAdId;
        _platformAdIdentifierControllers[platform]!['inArticleBannerAdId']
            ?.selection = TextSelection.collapsed(
          offset: inArticleBannerAdId.length,
        );
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
    final adConfig = widget.remoteConfig.adConfig;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary Ad Platform Selection
        ExpansionTile(
          title: Text(l10n.primaryAdPlatformTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg, // Adjusted padding for hierarchy
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment:
              CrossAxisAlignment.start, // Align content to start
          children: [
            Text(
              l10n.primaryAdPlatformDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.start, // Ensure text aligns to start
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
                    .where(
                      (type) =>
                          type !=
                          AdPlatformType
                              .demo, // Ignore demo ad platform for dashboard
                    )
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
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg, // Adjusted padding for hierarchy
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment:
              CrossAxisAlignment.start, // Align content to start
          children: [
            Text(
              l10n.adUnitIdentifiersDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.start, // Ensure text aligns to start
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

        // Local Ad Management
        if (_selectedPlatform == AdPlatformType.local)
          ExpansionTile(
            title: Text(l10n.localAdManagementTitle),
            childrenPadding: const EdgeInsetsDirectional.only(
              start: AppSpacing.lg, // Adjusted padding for hierarchy
              top: AppSpacing.md,
              bottom: AppSpacing.md,
            ),
            expandedCrossAxisAlignment:
                CrossAxisAlignment.start, // Align content to start
            children: [
              Text(
                l10n.localAdManagementDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.start, // Ensure text aligns to start
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: ElevatedButton(
                  onPressed: () =>
                      context.goNamed(Routes.localAdsManagementName),
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
        case 'feedToArticleInterstitialAdId':
          newIdentifiers = platformIdentifiers.copyWith(
            feedToArticleInterstitialAdId: value,
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
          label: l10n.feedToArticleInterstitialAdIdLabel,
          description: l10n.feedToArticleInterstitialAdIdDescription,
          value: platformIdentifiers.feedToArticleInterstitialAdId,
          onChanged: (value) =>
              updatePlatformIdentifiers('feedToArticleInterstitialAdId', value),
          controller: controllers['feedToArticleInterstitialAdId'],
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
