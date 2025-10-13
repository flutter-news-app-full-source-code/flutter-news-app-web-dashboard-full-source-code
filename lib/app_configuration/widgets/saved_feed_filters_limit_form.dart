import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template saved_headlines_filters_limit_form}
/// A form for configuring saved headlines filter limits within the
/// [RemoteConfig].
///
/// This form provides fields to set the maximum number of saved filters
/// for guest, authenticated, and premium users.
/// {@endtemplate}
class SavedHeadlinesFiltersLimitForm extends StatefulWidget {
  /// {@macro saved_headlines_filters_limit_form}
  const SavedHeadlinesFiltersLimitForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<SavedHeadlinesFiltersLimitForm> createState() =>
      _SavedHeadlinesFiltersLimitFormState();
}

class _SavedHeadlinesFiltersLimitFormState
    extends State<SavedHeadlinesFiltersLimitForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final Map<AppUserRole, TextEditingController> _controllers;

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
  void didUpdateWidget(covariant SavedHeadlinesFiltersLimitForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.userPreferenceConfig !=
        oldWidget.remoteConfig.userPreferenceConfig) {
      _updateControllerValues();
    }
  }

  void _initializeControllers() {
    _controllers = {
      for (final role in AppUserRole.values)
        role: () {
          final limitText = _getSavedFiltersLimit(
            widget.remoteConfig.userPreferenceConfig,
            role,
          ).toString();
          return TextEditingController(text: limitText)
            ..selection = TextSelection.collapsed(offset: limitText.length);
        }(),
    };
  }

  void _updateControllerValues() {
    for (final role in AppUserRole.values) {
      final newLimit = _getSavedFiltersLimit(
        widget.remoteConfig.userPreferenceConfig,
        role,
      ).toString();
      final controller = _controllers[role];
      if (controller != null && controller.text != newLimit) {
        controller
          ..text = newLimit
          ..selection = TextSelection.collapsed(
            offset: newLimit.length,
          );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
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
              tabs: AppUserRole.values
                  .map((role) => Tab(text: role.l10n(context)))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 120,
          child: TabBarView(
            controller: _tabController,
            children: AppUserRole.values.map((role) {
              final config = widget.remoteConfig.userPreferenceConfig;
              return AppConfigIntField(
                label: l10n.savedHeadlinesLimitLabel,
                description: l10n.savedHeadlinesLimitDescription,
                value: _getSavedFiltersLimit(config, role),
                onChanged: (value) {
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      userPreferenceConfig: _updateSavedFiltersLimit(
                        config,
                        value,
                        role,
                      ),
                    ),
                  );
                },
                controller: _controllers[role],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Retrieves the saved filters limit for a given [AppUserRole].
  ///
  /// This helper method abstracts the logic for accessing the correct limit
  /// from the [UserPreferenceConfig] based on the provided [role].
  int _getSavedFiltersLimit(UserPreferenceConfig config, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.guestSavedFiltersLimit;
      case AppUserRole.standardUser:
        return config.authenticatedSavedFiltersLimit;
      case AppUserRole.premiumUser:
        return config.premiumSavedFiltersLimit;
    }
  }

  /// Updates the saved filters limit for a given [AppUserRole].
  ///
  /// This helper method abstracts the logic for updating the correct limit
  /// within the [UserPreferenceConfig] based on the provided [role] and [value].
  UserPreferenceConfig _updateSavedFiltersLimit(
    UserPreferenceConfig config,
    int value,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.copyWith(guestSavedFiltersLimit: value);
      case AppUserRole.standardUser:
        return config.copyWith(authenticatedSavedFiltersLimit: value);
      case AppUserRole.premiumUser:
        return config.copyWith(premiumSavedFiltersLimit: value);
    }
  }
}
