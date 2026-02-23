import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/access_tier_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/push_notification_subscription_delivery_type_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template saved_filter_limits_form}
/// A reusable form widget for configuring limits for saved filters.
///
/// This widget displays a tabbed interface for different user roles and
/// provides fields for setting total, pinned, and notification subscription
/// limits for headline filters.
/// {@endtemplate}
class SavedFilterLimitsForm extends StatefulWidget {
  /// {@macro saved_filter_limits_form}
  const SavedFilterLimitsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<SavedFilterLimitsForm> createState() => _SavedFilterLimitsFormState();
}

class _SavedFilterLimitsFormState extends State<SavedFilterLimitsForm>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // A nested map to hold controllers: Tier -> Field -> Controller
  final Map<AccessTier, Map<String, TextEditingController>> _controllers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AccessTier.values.length,
      vsync: this,
    );
    _notificationTabController = TabController(
      length: PushNotificationSubscriptionDeliveryType.values.length,
      vsync: this,
    );
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant SavedFilterLimitsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.user.limits != oldWidget.remoteConfig.user.limits) {
      _updateControllerValues();
    }
  }

  /// Initializes all TextEditingControllers based on the initial config.
  void _initializeControllers() {
    for (final tier in AccessTier.values) {
      _controllers[tier] = {};
      final limits = _getLimitsForTier(tier);

      _controllers[tier]!['total'] = _createController(limits.total.toString());
      _controllers[tier]!['pinned'] = _createController(
        limits.pinned.toString(),
      );

      for (final type in PushNotificationSubscriptionDeliveryType.values) {
        final value = limits.notificationSubscriptions?[type] ?? 0;
        _controllers[tier]!['notification_${type.name}'] = _createController(
          value.toString(),
        );
      }
    }
  }

  /// Creates a single TextEditingController with appropriate selection.
  TextEditingController _createController(String text) {
    return TextEditingController(text: text)
      ..selection = TextSelection.collapsed(offset: text.length);
  }

  /// Updates controller values if the remote config has changed.
  void _updateControllerValues() {
    for (final tier in AccessTier.values) {
      final limits = _getLimitsForTier(tier);
      _updateControllerText(_controllers[tier]!['total']!, limits.total);
      _updateControllerText(_controllers[tier]!['pinned']!, limits.pinned);

      for (final type in PushNotificationSubscriptionDeliveryType.values) {
        final value = limits.notificationSubscriptions?[type] ?? 0;
        _updateControllerText(
          _controllers[tier]!['notification_${type.name}']!,
          value,
        );
      }
    }
  }

  /// Safely updates a controller's text and selection.
  void _updateControllerText(TextEditingController controller, int value) {
    final text = value.toString();
    if (controller.text != text) {
      controller
        ..text = text
        ..selection = TextSelection.collapsed(offset: text.length);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notificationTabController.dispose();
    for (final roleControllers in _controllers.values) {
      for (final controller in roleControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  /// Retrieves the correct [SavedFilterLimits] for a given tier.
  SavedFilterLimits _getLimitsForTier(AccessTier tier) {
    final limitsConfig = widget.remoteConfig.user.limits;
    return limitsConfig.savedHeadlineFilters[tier]!;
  }

  /// Updates the remote config when a value changes.
  void _onValueChanged(AccessTier tier, String field, int value) {
    final userConfig = widget.remoteConfig.user;
    final limitsConfig = userConfig.limits;

    final currentLimitsMap = limitsConfig.savedHeadlineFilters;

    final newLimitsMap = Map<AccessTier, SavedFilterLimits>.from(
      currentLimitsMap,
    );

    final currentLimits = newLimitsMap[tier]!;
    SavedFilterLimits newLimits;

    if (field == 'total') {
      newLimits = currentLimits.copyWith(total: value);
    } else if (field == 'pinned') {
      newLimits = currentLimits.copyWith(pinned: value);
    } else {
      final deliveryType = PushNotificationSubscriptionDeliveryType.values
          .byName(field);
      final newSubscriptions =
          Map<PushNotificationSubscriptionDeliveryType, int>.from(
            currentLimits.notificationSubscriptions ?? {},
          );
      newSubscriptions[deliveryType] = value;
      newLimits = currentLimits.copyWith(
        notificationSubscriptions: newSubscriptions,
      );
    }

    newLimitsMap[tier] = newLimits;

    final newUserLimitsConfig = limitsConfig.copyWith(
      savedHeadlineFilters: newLimitsMap,
    );

    widget.onConfigChanged(
      widget.remoteConfig.copyWith(
        user: userConfig.copyWith(
          limits: newUserLimitsConfig,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return ExpansionTile(
      title: Text(
        l10n.savedHeadlineFilterLimitsTitle,
      ),
      subtitle: Text(
        l10n.savedHeadlineFilterLimitsDescription,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: AccessTier.values.map((tier) {
              final limits = _getLimitsForTier(tier);
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  children: [
                    AppConfigIntField(
                      label: l10n.totalLimitLabel,
                      description: l10n.totalLimitDescription,
                      value: limits.total,
                      onChanged: (value) =>
                          _onValueChanged(tier, 'total', value),
                      controller: _controllers[tier]!['total'],
                    ),
                    AppConfigIntField(
                      label: l10n.pinnedLimitLabel,
                      description: l10n.pinnedLimitDescription,
                      value: limits.pinned,
                      onChanged: (value) =>
                          _onValueChanged(tier, 'pinned', value),
                      controller: _controllers[tier]!['pinned'],
                    ),
                    _buildNotificationFields(l10n, tier, limits),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _getNotificationDescription(
    BuildContext context,
    PushNotificationSubscriptionDeliveryType type,
  ) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (type) {
      case PushNotificationSubscriptionDeliveryType.breakingOnly:
        return l10n.notificationSubscriptionBreakingOnlyDescription;
    }
  }

  late final TabController _notificationTabController;

  Widget _buildNotificationFields(
    AppLocalizations l10n,
    AccessTier tier,
    SavedFilterLimits limits,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.notificationSubscriptionLimitLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.notificationSubscriptionLimitDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            height: kTextTabBarHeight,
            child: TabBar(
              controller: _notificationTabController,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              tabs: PushNotificationSubscriptionDeliveryType.values
                  .map((type) => Tab(text: type.l10n(context)))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 150,
          child: TabBarView(
            controller: _notificationTabController,
            children: PushNotificationSubscriptionDeliveryType.values.map(
              (type) {
                final value = limits.notificationSubscriptions?[type] ?? 0;
                return AppConfigIntField(
                  label: type.l10n(context),
                  description: _getNotificationDescription(context, type),
                  value: value,
                  onChanged: (newValue) =>
                      _onValueChanged(tier, type.name, newValue),
                  controller: _controllers[tier]!['notification_${type.name}'],
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
