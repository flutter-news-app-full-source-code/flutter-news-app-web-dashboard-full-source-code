import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
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
  late final Map<AppUserRole, TextEditingController>
      _articlesToReadBeforeShowingInterstitialAdsControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: AppUserRole.values.length, vsync: this);
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant ArticleAdSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.adConfig.articleAdConfiguration !=
        oldWidget.remoteConfig.adConfig.articleAdConfiguration) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final articleAdConfig = widget.remoteConfig.adConfig.articleAdConfiguration;
    final interstitialConfig = articleAdConfig.interstitialAdConfiguration;
    _articlesToReadBeforeShowingInterstitialAdsControllers = {
      for (final role in AppUserRole.values)
        role: TextEditingController(
          text: _getArticlesBeforeInterstitial(
            interstitialConfig,
            role,
          ).toString(),
        )..selection = TextSelection.collapsed(
            offset: _getArticlesBeforeInterstitial(
              interstitialConfig,
              role,
            ).toString().length,
          ),
    };
  }

  void _updateControllers() {
    final articleAdConfig = widget.remoteConfig.adConfig.articleAdConfiguration;
    final interstitialConfig = articleAdConfig.interstitialAdConfiguration;
    for (final role in AppUserRole.values) {
      final newInterstitialValue =
          _getArticlesBeforeInterstitial(interstitialConfig, role).toString();
      if (_articlesToReadBeforeShowingInterstitialAdsControllers[role]?.text !=
          newInterstitialValue) {
        _articlesToReadBeforeShowingInterstitialAdsControllers[role]?.text =
            newInterstitialValue;
        _articlesToReadBeforeShowingInterstitialAdsControllers[role]
                ?.selection =
            TextSelection.collapsed(offset: newInterstitialValue.length);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final controller
        in _articlesToReadBeforeShowingInterstitialAdsControllers.values) {
      controller.dispose();
    }
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
          title: Text(l10n.defaultInArticleAdTypeSelectionTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg, // Adjusted padding for hierarchy
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start, // Align content to start
          children: [
            Text(
              l10n.defaultInArticleAdTypeSelectionDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
          title: Text(l10n.interstitialAdSettingsTitle),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg, // Adjusted padding for hierarchy
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start, // Align content to start
          children: [
            SwitchListTile(
              title: Text(l10n.enableInterstitialAdsLabel),
              value: articleAdConfig.interstitialAdConfiguration.enabled,
              onChanged: (value) {
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    adConfig: adConfig.copyWith(
                      articleAdConfiguration: articleAdConfig.copyWith(
                        interstitialAdConfiguration: articleAdConfig
                            .interstitialAdConfiguration
                            .copyWith(enabled: value),
                      ),
                    ),
                  ),
                );
              },
            ),
            ExpansionTile(
              title: Text(l10n.userRoleInterstitialFrequencyTitle),
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.xl, // Further adjusted padding for nested hierarchy
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start, // Align content to start
              children: [
                Text(
                  l10n.userRoleInterstitialFrequencyDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.start, // Ensure text aligns to start
                ),
                const SizedBox(height: AppSpacing.lg),
                // Replaced SegmentedButton with TabBar for role selection
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
                // TabBarView to display role-specific fields
                SizedBox(
                  height: 250, // Fixed height for TabBarView within a ListView
                  child: TabBarView(
                    controller: _tabController,
                    children: AppUserRole.values
                        .map(
                          (role) => _buildInterstitialRoleSpecificFields(
                            context,
                            l10n,
                            role,
                            articleAdConfig.interstitialAdConfiguration,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
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
          expandedCrossAxisAlignment: CrossAxisAlignment.start, // Align content to start
          children: [
            Text(
              l10n.inArticleAdSlotPlacementsDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.start, // Ensure text aligns to start
            ),
            const SizedBox(height: AppSpacing.lg),
            ...articleAdConfig.inArticleAdSlotConfigurations.map(
              (slotConfig) => SwitchListTile(
                title: Text(slotConfig.slotType.name),
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

  Widget _buildInterstitialRoleSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AppUserRole role,
    ArticleInterstitialAdConfiguration config,
  ) {
    return Column(
      children: [
        AppConfigIntField(
          label: l10n.articlesBeforeInterstitialAdsLabel,
          description: l10n.articlesBeforeInterstitialAdsDescription,
          value: _getArticlesBeforeInterstitial(config, role),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: widget.remoteConfig.adConfig.copyWith(
                  articleAdConfiguration: widget
                      .remoteConfig
                      .adConfig
                      .articleAdConfiguration
                      .copyWith(
                        interstitialAdConfiguration:
                            _updateArticlesBeforeInterstitial(
                              config,
                              value,
                              role,
                            ),
                      ),
                ),
              ),
            );
          },
          controller:
              _articlesToReadBeforeShowingInterstitialAdsControllers[role],
        ),
      ],
    );
  }

  int _getArticlesBeforeInterstitial(
    ArticleInterstitialAdConfiguration config,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return config
            .frequencyConfig
            .guestArticlesToReadBeforeShowingInterstitialAds;
      case AppUserRole.standardUser:
        return config
            .frequencyConfig
            .standardUserArticlesToReadBeforeShowingInterstitialAds;
      case AppUserRole.premiumUser:
        return config
            .frequencyConfig
            .premiumUserArticlesToReadBeforeShowingInterstitialAds;
    }
  }

  ArticleInterstitialAdConfiguration _updateArticlesBeforeInterstitial(
    ArticleInterstitialAdConfiguration config,
    int value,
    AppUserRole role,
  ) {
    final currentFrequencyConfig = config.frequencyConfig;

    ArticleInterstitialAdFrequencyConfig newFrequencyConfig;

    switch (role) {
      case AppUserRole.guestUser:
        newFrequencyConfig = currentFrequencyConfig.copyWith(
          guestArticlesToReadBeforeShowingInterstitialAds: value,
        );
      case AppUserRole.standardUser:
        newFrequencyConfig = currentFrequencyConfig.copyWith(
          standardUserArticlesToReadBeforeShowingInterstitialAds: value,
        );
      case AppUserRole.premiumUser:
        newFrequencyConfig = currentFrequencyConfig.copyWith(
          premiumUserArticlesToReadBeforeShowingInterstitialAds: value,
        );
    }

    return config.copyWith(frequencyConfig: newFrequencyConfig);
  }
}
