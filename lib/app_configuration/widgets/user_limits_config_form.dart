import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template user_limits_config_form}
/// A form widget for configuring user content limits based on role.
///
/// This widget uses a [TabBar] to allow selection of an [AppUserRole]
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
  void didUpdateWidget(covariant UserLimitsConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.user.limits != oldWidget.remoteConfig.user.limits) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final limits = widget.remoteConfig.user.limits;
    _followedItemsLimitControllers = {
      for (final role in AppUserRole.values)
        role: TextEditingController(
          text: (limits.followedItems[role] ?? 0).toString(),
        ),
    };
    _savedHeadlinesLimitControllers = {
      for (final role in AppUserRole.values)
        role: TextEditingController(
          text: (limits.savedHeadlines[role] ?? 0).toString(),
        ),
    };
  }

  void _updateControllers() {
    final limits = widget.remoteConfig.user.limits;
    for (final role in AppUserRole.values) {
      final newFollowedItemsLimit = (limits.followedItems[role] ?? 0).toString();
      if (_followedItemsLimitControllers[role]?.text != newFollowedItemsLimit) {
        _followedItemsLimitControllers[role]?.text = newFollowedItemsLimit;
      }

      final newSavedHeadlinesLimit = (limits.savedHeadlines[role] ?? 0).toString();
      if (_savedHeadlinesLimitControllers[role]?.text !=
          newSavedHeadlinesLimit) {
        _savedHeadlinesLimitControllers[role]?.text = newSavedHeadlinesLimit;
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
        Text(
          l10n.userContentLimitsDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
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
                    widget.remoteConfig.user.limits,
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
    UserLimitsConfig limits,
  ) {
    return Column(
      children: [
        AppConfigIntField(
          label: l10n.followedItemsLimitLabel,
          description: l10n.followedItemsLimitDescription,
          value: limits.followedItems[role] ?? 0,
          onChanged: (value) {
            final newLimits = Map<AppUserRole, int>.from(limits.followedItems)
              ..[role] = value;
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                user: widget.remoteConfig.user.copyWith(
                  limits: limits.copyWith(followedItems: newLimits),
                ),
              ),
            );
          },
          controller: _followedItemsLimitControllers[role],
        ),
        AppConfigIntField(
          label: l10n.savedHeadlinesLimitLabel,
          description: l10n.savedHeadlinesLimitDescription,
          value: limits.savedHeadlines[role] ?? 0,
          onChanged: (value) {
            final newLimits = Map<AppUserRole, int>.from(limits.savedHeadlines)
              ..[role] = value;
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                user: widget.remoteConfig.user.copyWith(
                  limits: limits.copyWith(savedHeadlines: newLimits),
                ),
              ),
            );
          },
          controller: _savedHeadlinesLimitControllers[role],
        ),
      ],
    );
  }
}
