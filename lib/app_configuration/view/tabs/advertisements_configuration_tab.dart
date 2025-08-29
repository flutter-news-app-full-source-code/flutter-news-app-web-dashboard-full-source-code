import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/ad_platform_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/article_ad_settings_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/feed_ad_settings_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template advertisements_configuration_tab}
/// A widget representing the "Advertisements" tab in the App Configuration page.
///
/// This tab allows configuration of various ad settings.
/// {@endtemplate}
class AdvertisementsConfigurationTab extends StatefulWidget {
  /// {@macro advertisements_configuration_tab}
  const AdvertisementsConfigurationTab({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<AdvertisementsConfigurationTab> createState() =>
      _AdvertisementsConfigurationTabState();
}

class _AdvertisementsConfigurationTabState
    extends State<AdvertisementsConfigurationTab> {
  /// Notifier for the index of the currently expanded top-level ExpansionTile.
  ///
  /// A value of `null` means no tile is expanded.
  final ValueNotifier<int?> _expandedTileIndex = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _expandedTileIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Top-level ExpansionTile for Ad Platform Configuration
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 0;
            return ExpansionTile(
              key: ValueKey('adPlatformConfigTile_$expandedIndex'),
              title: Text(l10n.adPlatformConfigurationTitle),
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              children: [
                AdPlatformConfigForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        // Top-level ExpansionTile for Feed Ad Settings
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 1;
            return ExpansionTile(
              key: ValueKey('feedAdSettingsTile_$expandedIndex'),
              title: Text(l10n.feedAdSettingsTitle),
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              children: [
                FeedAdSettingsForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        // Top-level ExpansionTile for Article Ad Settings
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 2;
            return ExpansionTile(
              key: ValueKey('articleAdSettingsTile_$expandedIndex'),
              title: Text(l10n.articleAdSettingsTitle),
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.lg,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              children: [
                ArticleAdSettingsForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
