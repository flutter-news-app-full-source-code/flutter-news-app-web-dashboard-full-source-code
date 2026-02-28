import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/access_tier_l10n.dart';

/// {@template user_limits_config_form}
/// A form widget for configuring user content limits based on role.
///
/// This widget uses a [TabBar] to allow selection of an [AccessTier]
/// and then renders input fields for that role's limits.
/// {@endtemplate}
class UserLimitsConfigForm extends StatefulWidget {
  /// {@macro user_limits_config_form}
  const UserLimitsConfigForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<UserLimitsConfigForm> createState() => _UserLimitsConfigFormState();
}

class _UserLimitsConfigFormState extends State<UserLimitsConfigForm>
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
  void didUpdateWidget(covariant UserLimitsConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.user.limits != oldWidget.remoteConfig.user.limits) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final limits = widget.remoteConfig.user.limits;
    _followedItemsLimitControllers = {
      for (final tier in AccessTier.values)
        tier: TextEditingController(
          text: (limits.followedItems[tier] ?? 0).toString(),
        ),
    };
    _savedHeadlinesLimitControllers = {
      for (final tier in AccessTier.values)
        tier: TextEditingController(
          text: (limits.savedHeadlines[tier] ?? 0).toString(),
        ),
    };
  }

  void _updateControllers() {
    final limits = widget.remoteConfig.user.limits;
    for (final tier in AccessTier.values) {
      final newFollowedItemsLimit = (limits.followedItems[tier] ?? 0)
          .toString();
      if (_followedItemsLimitControllers[tier]?.text != newFollowedItemsLimit) {
        _followedItemsLimitControllers[tier]?.text = newFollowedItemsLimit;
      }

      final newSavedHeadlinesLimit = (limits.savedHeadlines[tier] ?? 0)
          .toString();
      if (_savedHeadlinesLimitControllers[tier]?.text !=
          newSavedHeadlinesLimit) {
        _savedHeadlinesLimitControllers[tier]?.text = newSavedHeadlinesLimit;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in _followedItemsLimitControllers.values) {
      c.dispose();
    }
    for (final c in _savedHeadlinesLimitControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    widget.remoteConfig.user.limits,
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
    UserLimitsConfig limits,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        children: [
          AppConfigIntField(
            label: _getFollowedItemsLimitLabel(l10n, tier),
            description: _getFollowedItemsLimitDescription(l10n, tier),
            value: limits.followedItems[tier] ?? 0,
            onChanged: (value) {
              final newLimits = Map<AccessTier, int>.from(limits.followedItems)
                ..[tier] = value;
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  user: widget.remoteConfig.user.copyWith(
                    limits: limits.copyWith(followedItems: newLimits),
                  ),
                ),
              );
            },
            controller: _followedItemsLimitControllers[tier],
          ),
          AppConfigIntField(
            label: _getSavedHeadlinesLimitLabel(l10n, tier),
            description: _getSavedHeadlinesLimitDescription(l10n, tier),
            value: limits.savedHeadlines[tier] ?? 0,
            onChanged: (value) {
              final newLimits = Map<AccessTier, int>.from(
                limits.savedHeadlines,
              )..[tier] = value;
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  user: widget.remoteConfig.user.copyWith(
                    limits: limits.copyWith(savedHeadlines: newLimits),
                  ),
                ),
              );
            },
            controller: _savedHeadlinesLimitControllers[tier],
          ),
        ],
      ),
    );
  }

  String _getFollowedItemsLimitLabel(AppLocalizations l10n, AccessTier tier) {
    switch (tier) {
      case AccessTier.guest:
        return l10n.guestFollowedItemsLimitLabel;
      case AccessTier.standard:
        return l10n.standardUserFollowedItemsLimitLabel;
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
    }
  }

  String _getSavedHeadlinesLimitLabel(AppLocalizations l10n, AccessTier tier) {
    switch (tier) {
      case AccessTier.guest:
        return l10n.guestSavedHeadlinesLimitLabel;
      case AccessTier.standard:
        return l10n.standardUserSavedHeadlinesLimitLabel;
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
    }
  }
}
