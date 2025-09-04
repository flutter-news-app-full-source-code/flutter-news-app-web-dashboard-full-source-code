import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/in_article_ad_slot_type_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template article_ad_settings_form}
/// A form widget for configuring article ad settings.
/// {@endtemplate}
class ArticleAdSettingsForm extends StatefulWidget {
  /// {@macro article_ad_settings_form}
  const ArticleAdSettingsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<ArticleAdSettingsForm> createState() => _ArticleAdSettingsFormState();
}

class _ArticleAdSettingsFormState extends State<ArticleAdSettingsForm>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ArticleAdSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final adConfig = widget.remoteConfig.adConfig;
    final articleAdConfig = adConfig.articleAdConfiguration;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableArticleAdsLabel),
          value: articleAdConfig.enabled,
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: adConfig.copyWith(
                  articleAdConfiguration: articleAdConfig.copyWith(
                    enabled: value,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        ExpansionTile(
          title: Text(l10n.defaultInArticleAdTypeSelectionTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg, // Adjusted padding for hierarchy
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment:
              CrossAxisAlignment.start, // Align content to start
          children: [
            Text(
              l10n.defaultInArticleAdTypeSelectionDescription,
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
                        label: Text(type.name),
                      ),
                    )
                    .toList(),
                selected: {articleAdConfig.defaultInArticleAdType},
                onSelectionChanged: (newSelection) {
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      adConfig: adConfig.copyWith(
                        articleAdConfiguration: articleAdConfig.copyWith(
                          defaultInArticleAdType: newSelection.first,
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
          title: Text(l10n.inArticleAdSlotPlacementsTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg, // Adjusted padding for hierarchy
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment:
              CrossAxisAlignment.start, // Align content to start
          children: [
            Text(
              l10n.inArticleAdSlotPlacementsDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.start, // Ensure text aligns to start
            ),
            const SizedBox(height: AppSpacing.lg),
            ...articleAdConfig.inArticleAdSlotConfigurations.map(
              (slotConfig) => SwitchListTile(
                title: Text(slotConfig.slotType.l10n(context)),
                value: slotConfig.enabled,
                onChanged: (value) {
                  final updatedSlots = articleAdConfig
                      .inArticleAdSlotConfigurations
                      .map(
                        (e) => e.slotType == slotConfig.slotType
                            ? e.copyWith(enabled: value)
                            : e,
                      )
                      .toList();
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      adConfig: adConfig.copyWith(
                        articleAdConfiguration: articleAdConfig.copyWith(
                          inArticleAdSlotConfigurations: updatedSlots,
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
    );
  }
}
