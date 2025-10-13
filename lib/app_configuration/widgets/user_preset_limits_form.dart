import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template user_preset_limits_form}
/// A form for configuring user preset limits within the [RemoteConfig].
///
/// This form provides fields to set the maximum number of saved filters
/// for guest, authenticated, and premium users.
/// {@endtemplate}
class UserPresetLimitsForm extends StatefulWidget {
  /// {@macro user_preset_limits_form}
  const UserPresetLimitsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<UserPresetLimitsForm> createState() => _UserPresetLimitsFormState();
}

class _UserPresetLimitsFormState extends State<UserPresetLimitsForm> {
  late final TextEditingController _guestController;
  late final TextEditingController _standardController;
  late final TextEditingController _premiumController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant UserPresetLimitsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.userPreferenceConfig !=
        oldWidget.remoteConfig.userPreferenceConfig) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final config = widget.remoteConfig.userPreferenceConfig;
    _guestController =
        TextEditingController(
            text: config.guestSavedFiltersLimit.toString(),
          )
          ..selection = TextSelection.collapsed(
            offset: config.guestSavedFiltersLimit.toString().length,
          );
    _standardController =
        TextEditingController(
            text: config.authenticatedSavedFiltersLimit.toString(),
          )
          ..selection = TextSelection.collapsed(
            offset: config.authenticatedSavedFiltersLimit.toString().length,
          );
    _premiumController =
        TextEditingController(
            text: config.premiumSavedFiltersLimit.toString(),
          )
          ..selection = TextSelection.collapsed(
            offset: config.premiumSavedFiltersLimit.toString().length,
          );
  }

  void _updateControllers() {
    final config = widget.remoteConfig.userPreferenceConfig;

    final newGuestValue = config.guestSavedFiltersLimit.toString();
    if (_guestController.text != newGuestValue) {
      _guestController.text = newGuestValue;
      _guestController.selection = TextSelection.collapsed(
        offset: newGuestValue.length,
      );
    }

    final newStandardValue = config.authenticatedSavedFiltersLimit.toString();
    if (_standardController.text != newStandardValue) {
      _standardController.text = newStandardValue;
      _standardController.selection = TextSelection.collapsed(
        offset: newStandardValue.length,
      );
    }

    final newPremiumValue = config.premiumSavedFiltersLimit.toString();
    if (_premiumController.text != newPremiumValue) {
      _premiumController.text = newPremiumValue;
      _premiumController.selection = TextSelection.collapsed(
        offset: newPremiumValue.length,
      );
    }
  }

  @override
  void dispose() {
    _guestController.dispose();
    _standardController.dispose();
    _premiumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final userPreferenceConfig = widget.remoteConfig.userPreferenceConfig;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppConfigIntField(
          label: l10n.guestUserRole,
          description: l10n.savedHeadlinesFiltersLimitDescription,
          value: userPreferenceConfig.guestSavedFiltersLimit,
          onChanged: (newLimit) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                userPreferenceConfig: userPreferenceConfig.copyWith(
                  guestSavedFiltersLimit: newLimit,
                ),
              ),
            );
          },
          controller: _guestController,
        ),
        AppConfigIntField(
          label: l10n.standardUserRole,
          description: l10n.savedHeadlinesFiltersLimitDescription,
          value: userPreferenceConfig.authenticatedSavedFiltersLimit,
          onChanged: (newLimit) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                userPreferenceConfig: userPreferenceConfig.copyWith(
                  authenticatedSavedFiltersLimit: newLimit,
                ),
              ),
            );
          },
          controller: _standardController,
        ),
        AppConfigIntField(
          label: l10n.premiumUserRole,
          description: l10n.savedHeadlinesFiltersLimitDescription,
          value: userPreferenceConfig.premiumSavedFiltersLimit,
          onChanged: (newLimit) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                userPreferenceConfig: userPreferenceConfig.copyWith(
                  premiumSavedFiltersLimit: newLimit,
                ),
              ),
            );
          },
          controller: _premiumController,
        ),
      ],
    );
  }
}
