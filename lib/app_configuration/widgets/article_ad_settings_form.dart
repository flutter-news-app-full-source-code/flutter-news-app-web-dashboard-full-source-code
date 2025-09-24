import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/banner_ad_shape_l10n.dart';
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppUserRole.values.length,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant ArticleAdSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // No specific controller updates needed here as the UI rebuilds based on
    // the remoteConfig directly.
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          title: Text(l10n.bannerAdShapeSelectionTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.bannerAdShapeSelectionDescription,
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
              child: SegmentedButton<BannerAdShape>(
                style: SegmentedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                segments: BannerAdShape.values
                    .map(
                      (type) => ButtonSegment<BannerAdShape>(
                        value: type,
                        label: Text(type.l10n(context)),
                      ),
                    )
                    .toList(),
                selected: {articleAdConfig.bannerAdShape},
                onSelectionChanged: (newSelection) {
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      adConfig: adConfig.copyWith(
                        articleAdConfiguration: articleAdConfig.copyWith(
                          bannerAdShape: newSelection.first,
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
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.inArticleAdSlotPlacementsDescription,
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
                      (role) => _buildRoleSpecificFields(
                        context,
                        l10n,
                        role,
                        articleAdConfig,
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

  /// Builds role-specific configuration fields for in-article ad slots.
  ///
  /// This widget displays checkboxes for each [InArticleAdSlotType] for a
  /// given [AppUserRole], allowing to enable/disable specific ad slots.
  Widget _buildRoleSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AppUserRole role,
    ArticleAdConfiguration config,
  ) {
    final roleSlots = config.visibleTo[role];

    return Column(
      children: [
        SwitchListTile(
          title: Text(l10n.enableInArticleAdsForRoleLabel(role.l10n(context))),
          value: roleSlots != null,
          onChanged: (value) {
            final newVisibleTo =
                Map<AppUserRole, Map<InArticleAdSlotType, bool>>.from(
                  config.visibleTo,
                );
            if (value) {
              // Default values when enabling for a role
              newVisibleTo[role] = {
                InArticleAdSlotType.aboveArticleContinueReadingButton: true,
                InArticleAdSlotType.belowArticleContinueReadingButton: true,
              };
            } else {
              newVisibleTo.remove(role);
            }

            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: widget.remoteConfig.adConfig.copyWith(
                  articleAdConfiguration: config.copyWith(
                    visibleTo: newVisibleTo,
                  ),
                ),
              ),
            );
          },
        ),
        if (roleSlots != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: [
                // SwitchListTile for each InArticleAdSlotType
                for (final slotType in InArticleAdSlotType.values)
                  CheckboxListTile(
                    title: Text(slotType.l10n(context)),
                    value: roleSlots[slotType] ?? false,
                    onChanged: (value) {
                      final newRoleSlots = Map<InArticleAdSlotType, bool>.from(
                        roleSlots,
                      );
                      if (value ?? false) {
                        newRoleSlots[slotType] = true;
                      } else {
                        newRoleSlots.remove(slotType);
                      }

                      final newVisibleTo =
                          Map<AppUserRole, Map<InArticleAdSlotType, bool>>.from(
                            config.visibleTo,
                          )..[role] = newRoleSlots;

                      widget.onConfigChanged(
                        widget.remoteConfig.copyWith(
                          adConfig: widget.remoteConfig.adConfig.copyWith(
                            articleAdConfiguration: config.copyWith(
                              visibleTo: newVisibleTo,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
