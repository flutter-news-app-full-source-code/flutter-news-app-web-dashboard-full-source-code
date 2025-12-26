import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/access_tier_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template user_preference_limits_form}
/// A form widget for configuring user content preference limits based on role.
///
/// This widget uses a [TabBar] to allow selection of an [AppUserRole]
/// and then conditionally renders the relevant input fields for that role.
/// {@endtemplate}
class UserPreferenceLimitsForm extends StatefulWidget {
  /// {@macro user_preference_limits_form}
  const UserPreferenceLimitsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<UserPreferenceLimitsForm> createState() =>
      _UserPreferenceLimitsFormState();
}

class _UserPreferenceLimitsFormState extends State<UserPreferenceLimitsForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final Map<AccessTier, TextEditingController>
  _followedItemsLimitControllers;
  late final Map<AccessTier, TextEditingController>
  _savedHeadlinesLimitControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AccessTier.values.length,
      vsync: this,
    );
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant UserPreferenceLimitsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.user.limits != oldWidget.remoteConfig.user.limits) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final limitsConfig = widget.remoteConfig.user.limits;
    _followedItemsLimitControllers = {
      for (final tier in AccessTier.values)
        tier:
            TextEditingController(
                text: (limitsConfig.followedItems[tier] ?? 0).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: (limitsConfig.followedItems[tier] ?? 0)
                    .toString()
                    .length,
              ),
    };
    _savedHeadlinesLimitControllers = {
      for (final tier in AccessTier.values)
        tier:
            TextEditingController(
                text: (limitsConfig.savedHeadlines[tier] ?? 0).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: (limitsConfig.savedHeadlines[tier] ?? 0)
                    .toString()
                    .length,
              ),
    };
  }

  void _updateControllers() {
    final limitsConfig = widget.remoteConfig.user.limits;
    for (final tier in AccessTier.values) {
      final newFollowedItemsLimit = (limitsConfig.followedItems[tier] ?? 0)
          .toString();
      if (_followedItemsLimitControllers[tier]?.text != newFollowedItemsLimit) {
        _followedItemsLimitControllers[tier]?.text = newFollowedItemsLimit;
        _followedItemsLimitControllers[tier]?.selection =
            TextSelection.collapsed(
              offset: newFollowedItemsLimit.length,
            );
      }

      final newSavedHeadlinesLimit = (limitsConfig.savedHeadlines[tier] ?? 0)
          .toString();
      if (_savedHeadlinesLimitControllers[tier]?.text !=
          newSavedHeadlinesLimit) {
        _savedHeadlinesLimitControllers[tier]?.text = newSavedHeadlinesLimit;
        _savedHeadlinesLimitControllers[tier]?.selection =
            TextSelection.collapsed(
              offset: newSavedHeadlinesLimit.length,
            );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final controller in _followedItemsLimitControllers.values) {
      controller.dispose();
    }
    for (final controller in _savedHeadlinesLimitControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final limitsConfig = widget.remoteConfig.user.limits;
    final l10n = AppLocalizationsX(context).l10n;

    return Column(
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
              tabs: AccessTier.values
                  .map((tier) => Tab(text: tier.l10n(context)))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // TabBarView to display role-specific fields
        SizedBox(
          height: 250,
          child: TabBarView(
            controller: _tabController,
            children: AccessTier.values
                .map(
                  (tier) => _buildTierSpecificFields(
                    context,
                    l10n,
                    tier,
                    limitsConfig,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTierSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AccessTier tier,
    UserLimitsConfig config,
  ) {
    return Column(
      children: [
        AppConfigIntField(
          label: _getFollowedItemsLimitLabel(l10n, tier),
          description: _getFollowedItemsLimitDescription(l10n, tier),
          value: config.followedItems[tier] ?? 0,
          onChanged: (value) {
            final newLimits = Map<AccessTier, int>.from(config.followedItems);
            newLimits[tier] = value;
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                user: widget.remoteConfig.user.copyWith(
                  limits: config.copyWith(followedItems: newLimits),
                ),
              ),
            );
          },
          controller: _followedItemsLimitControllers[tier],
        ),
        AppConfigIntField(
          label: _getSavedHeadlinesLimitLabel(l10n, tier),
          description: _getSavedHeadlinesLimitDescription(l10n, tier),
          value: config.savedHeadlines[tier] ?? 0,
          onChanged: (value) {
            final newLimits = Map<AccessTier, int>.from(config.savedHeadlines);
            newLimits[tier] = value;
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                user: widget.remoteConfig.user.copyWith(
                  limits: config.copyWith(savedHeadlines: newLimits),
                ),
              ),
            );
          },
          controller: _savedHeadlinesLimitControllers[tier],
        ),
      ],
    );
  }

  String _getFollowedItemsLimitLabel(AppLocalizations l10n, AccessTier tier) {
    switch (tier) {
      case AccessTier.guest:
        return l10n.guestFollowedItemsLimitLabel;
      case AccessTier.standard:
        return l10n.standardUserFollowedItemsLimitLabel;
      case AccessTier.premium:
        return l10n.premiumFollowedItemsLimitLabel;
    }
  }

  String _getFollowedItemsLimitDescription(
    AppLocalizations l10n,
    AccessTier tier,
  ) {
    switch (tier) {
      case AccessTier.guest:
        return l10n.guestFollowedItemsLimitDescription;
      case AccessTier.standard:
        return l10n.standardUserFollowedItemsLimitDescription;
      case AccessTier.premium:
        return l10n.premiumFollowedItemsLimitDescription;
    }
  }

  String _getSavedHeadlinesLimitLabel(AppLocalizations l10n, AccessTier tier) {
    switch (tier) {
      case AccessTier.guest:
        return l10n.guestSavedHeadlinesLimitLabel;
      case AccessTier.standard:
        return l10n.standardUserSavedHeadlinesLimitLabel;
      case AccessTier.premium:
        return l10n.premiumSavedHeadlinesLimitLabel;
    }
  }

  String _getSavedHeadlinesLimitDescription(
    AppLocalizations l10n,
    AccessTier tier,
  ) {
    switch (tier) {
      case AccessTier.guest:
        return l10n.guestSavedHeadlinesLimitDescription;
      case AccessTier.standard:
        return l10n.standardUserSavedHeadlinesLimitDescription;
      case AccessTier.premium:
        return l10n.premiumSavedHeadlinesLimitDescription;
    }
  }
}
