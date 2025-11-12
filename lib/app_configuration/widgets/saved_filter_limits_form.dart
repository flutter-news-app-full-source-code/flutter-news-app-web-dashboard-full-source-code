import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/push_notification_subscription_delivery_type_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// Defines the type of filter being configured.
enum SavedFilterType { headline, source }

/// {@template saved_filter_limits_form}
/// A reusable form widget for configuring limits for saved filters.
///
/// This widget is designed to handle the configuration for both headline and
/// source filters by using the [filterType] parameter. It displays a tabbed
/// interface for different user roles and provides fields for setting total,
/// pinned, and (if applicable) notification subscription limits.
/// {@endtemplate}
class SavedFilterLimitsForm extends StatefulWidget {
  /// {@macro saved_filter_limits_form}
  const SavedFilterLimitsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    required this.filterType,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  /// The type of filter to configure (headline or source).
  final SavedFilterType filterType;

  @override
  State<SavedFilterLimitsForm> createState() => _SavedFilterLimitsFormState();
}

class _SavedFilterLimitsFormState extends State<SavedFilterLimitsForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // A nested map to hold controllers: Role -> Field -> Controller
  final Map<AppUserRole, Map<String, TextEditingController>> _controllers = {};

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
  void didUpdateWidget(covariant SavedFilterLimitsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.userPreferenceConfig !=
        oldWidget.remoteConfig.userPreferenceConfig) {
      _updateControllerValues();
    }
  }

  /// Initializes all TextEditingControllers based on the initial config.
  void _initializeControllers() {
    for (final role in AppUserRole.values) {
      _controllers[role] = {};
      final limits = _getLimitsForRole(role);

      _controllers[role]!['total'] = _createController(limits.total.toString());
      _controllers[role]!['pinned'] = _createController(
        limits.pinned.toString(),
      );

      if (widget.filterType == SavedFilterType.headline) {
        for (final type in PushNotificationSubscriptionDeliveryType.values) {
          final value = limits.notificationSubscriptions?[type] ?? 0;
          _controllers[role]![type.name] = _createController(value.toString());
        }
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
    for (final role in AppUserRole.values) {
      final limits = _getLimitsForRole(role);
      _updateControllerText(_controllers[role]!['total']!, limits.total);
      _updateControllerText(_controllers[role]!['pinned']!, limits.pinned);

      if (widget.filterType == SavedFilterType.headline) {
        for (final type in PushNotificationSubscriptionDeliveryType.values) {
          final value = limits.notificationSubscriptions?[type] ?? 0;
          _updateControllerText(_controllers[role]![type.name]!, value);
        }
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
    for (final roleControllers in _controllers.values) {
      for (final controller in roleControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  /// Retrieves the correct [SavedFilterLimits] for a given role.
  SavedFilterLimits _getLimitsForRole(AppUserRole role) {
    final config = widget.remoteConfig.userPreferenceConfig;
    final limitsMap = widget.filterType == SavedFilterType.headline
        ? config.savedHeadlineFiltersLimit
        : config.savedSourceFiltersLimit;
    return limitsMap[role]!;
  }

  /// Updates the remote config when a value changes.
  void _onValueChanged(AppUserRole role, String field, int value) {
    final config = widget.remoteConfig.userPreferenceConfig;
    final isHeadline = widget.filterType == SavedFilterType.headline;

    // Create a mutable copy of the role-to-limits map.
    final newLimitsMap = Map<AppUserRole, SavedFilterLimits>.from(
      isHeadline
          ? config.savedHeadlineFiltersLimit
          : config.savedSourceFiltersLimit,
    );

    // Get the current limits for the role and create a modified copy.
    final currentLimits = newLimitsMap[role]!;
    final SavedFilterLimits newLimits;

    if (field == 'total') {
      newLimits = currentLimits.copyWith(total: value);
    } else if (field == 'pinned') {
      newLimits = currentLimits.copyWith(pinned: value);
    } else {
      // This must be a notification subscription change.
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

    // Update the map with the new limits for the role.
    newLimitsMap[role] = newLimits;

    // Create the updated UserPreferenceConfig.
    final newUserPreferenceConfig = isHeadline
        ? config.copyWith(savedHeadlineFiltersLimit: newLimitsMap)
        : config.copyWith(savedSourceFiltersLimit: newLimitsMap);

    // Notify the parent widget.
    widget.onConfigChanged(
      widget.remoteConfig.copyWith(
        userPreferenceConfig: newUserPreferenceConfig,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final isHeadlineFilter = widget.filterType == SavedFilterType.headline;

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
          // Adjust height based on whether notification fields are shown.
          height: isHeadlineFilter ? 400 : 250,
          child: TabBarView(
            controller: _tabController,
            children: AppUserRole.values.map((role) {
              final limits = _getLimitsForRole(role);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    AppConfigIntField(
                      label: l10n.totalLimitLabel,
                      description: l10n.totalLimitDescription,
                      value: limits.total,
                      onChanged: (value) =>
                          _onValueChanged(role, 'total', value),
                      controller: _controllers[role]!['total'],
                    ),
                    AppConfigIntField(
                      label: l10n.pinnedLimitLabel,
                      description: l10n.pinnedLimitDescription,
                      value: limits.pinned,
                      onChanged: (value) =>
                          _onValueChanged(role, 'pinned', value),
                      controller: _controllers[role]!['pinned'],
                    ),
                    if (isHeadlineFilter)
                      ..._buildNotificationFields(l10n, role, limits),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Builds the list of input fields for notification subscription limits.
  List<Widget> _buildNotificationFields(
    AppLocalizations l10n,
    AppUserRole role,
    SavedFilterLimits limits,
  ) {
    return PushNotificationSubscriptionDeliveryType.values.map((type) {
      final value = limits.notificationSubscriptions?[type] ?? 0;
      return AppConfigIntField(
        label: type.l10n(context),
        description: l10n.notificationSubscriptionLimitDescription,
        value: value,
        onChanged: (newValue) => _onValueChanged(role, type.name, newValue),
        controller: _controllers[role]![type.name],
      );
    }).toList();
  }
}
