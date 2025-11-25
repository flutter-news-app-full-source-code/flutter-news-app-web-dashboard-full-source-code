import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
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
  late final Map<AppUserRole, TextEditingController>
  _followedItemsLimitControllers;
  late final Map<AppUserRole, TextEditingController>
  _savedHeadlinesLimitControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppUserRole.values.length,
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
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text: (limitsConfig.followedItems[role] ?? 0).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: (limitsConfig.followedItems[role] ?? 0)
                    .toString()
                    .length,
              ),
    };
    _savedHeadlinesLimitControllers = {
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text: (limitsConfig.savedHeadlines[role] ?? 0).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: (limitsConfig.savedHeadlines[role] ?? 0)
                    .toString()
                    .length,
              ),
    };
  }

  void _updateControllers() {
    final limitsConfig = widget.remoteConfig.user.limits;
    for (final role in AppUserRole.values) {
      final newFollowedItemsLimit = (limitsConfig.followedItems[role] ?? 0)
          .toString();
      if (_followedItemsLimitControllers[role]?.text != newFollowedItemsLimit) {
        _followedItemsLimitControllers[role]?.text = newFollowedItemsLimit;
        _followedItemsLimitControllers[role]?.selection =
            TextSelection.collapsed(
              offset: newFollowedItemsLimit.length,
            );
      }

      final newSavedHeadlinesLimit = (limitsConfig.savedHeadlines[role] ?? 0)
          .toString();
      if (_savedHeadlinesLimitControllers[role]?.text !=
          newSavedHeadlinesLimit) {
        _savedHeadlinesLimitControllers[role]?.text = newSavedHeadlinesLimit;
        _savedHeadlinesLimitControllers[role]?.selection =
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
              tabs: AppUserRole.values
                  .map((role) => Tab(text: role.l10n(context)))
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
            children: AppUserRole.values
                .map(
                  (role) => _buildRoleSpecificFields(
                    context,
                    l10n,
                    role,
                    limitsConfig,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AppUserRole role,
    UserLimitsConfig config,
  ) {
    return Column(
      children: [
        AppConfigIntField(
          label: _getFollowedItemsLimitLabel(l10n, role),
          description: _getFollowedItemsLimitDescription(l10n, role),
          value: config.followedItems[role] ?? 0,
          onChanged: (value) {
            final newLimits = Map<AppUserRole, int>.from(config.followedItems);
            newLimits[role] = value;
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                user: widget.remoteConfig.user.copyWith(
                  limits: config.copyWith(followedItems: newLimits),
                ),
              ),
            );
          },
          controller: _followedItemsLimitControllers[role],
        ),
        AppConfigIntField(
          label: _getSavedHeadlinesLimitLabel(l10n, role),
          description: _getSavedHeadlinesLimitDescription(l10n, role),
          value: config.savedHeadlines[role] ?? 0,
          onChanged: (value) {
            final newLimits = Map<AppUserRole, int>.from(config.savedHeadlines);
            newLimits[role] = value;
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                user: widget.remoteConfig.user.copyWith(
                  limits: config.copyWith(savedHeadlines: newLimits),
                ),
              ),
            );
          },
          controller: _savedHeadlinesLimitControllers[role],
        ),
      ],
    );
  }

  String _getFollowedItemsLimitLabel(AppLocalizations l10n, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return l10n.guestFollowedItemsLimitLabel;
      case AppUserRole.standardUser:
        return l10n.standardUserFollowedItemsLimitLabel;
      case AppUserRole.premiumUser:
        return l10n.premiumFollowedItemsLimitLabel;
    }
  }

  String _getFollowedItemsLimitDescription(
    AppLocalizations l10n,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return l10n.guestFollowedItemsLimitDescription;
      case AppUserRole.standardUser:
        return l10n.standardUserFollowedItemsLimitDescription;
      case AppUserRole.premiumUser:
        return l10n.premiumFollowedItemsLimitDescription;
    }
  }

  String _getSavedHeadlinesLimitLabel(AppLocalizations l10n, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return l10n.guestSavedHeadlinesLimitLabel;
      case AppUserRole.standardUser:
        return l10n.standardUserSavedHeadlinesLimitLabel;
      case AppUserRole.premiumUser:
        return l10n.premiumSavedHeadlinesLimitLabel;
    }
  }

  String _getSavedHeadlinesLimitDescription(
    AppLocalizations l10n,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return l10n.guestSavedHeadlinesLimitDescription;
      case AppUserRole.standardUser:
        return l10n.standardUserSavedHeadlinesLimitDescription;
      case AppUserRole.premiumUser:
        return l10n.premiumSavedHeadlinesLimitDescription;
    }
  }
}
