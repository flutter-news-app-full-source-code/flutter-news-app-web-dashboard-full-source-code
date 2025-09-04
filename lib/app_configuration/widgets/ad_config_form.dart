import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template ad_config_form}
/// A form widget for configuring ad settings based on user role.
///
/// This widget uses a [TabBar] to allow selection of an [AppUserRole]
/// and then conditionally renders the relevant input fields for that role.
/// {@endtemplate}
class AdConfigForm extends StatefulWidget {
  /// {@macro ad_config_form}
  const AdConfigForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<AdConfigForm> createState() => _AdConfigFormState();
}

class _AdConfigFormState extends State<AdConfigForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final Map<AppUserRole, TextEditingController> _adFrequencyControllers;
  late final Map<AppUserRole, TextEditingController>
  _adPlacementIntervalControllers;

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
  void didUpdateWidget(covariant AdConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.adConfig != oldWidget.remoteConfig.adConfig) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final adConfig = widget.remoteConfig.adConfig;
    _adFrequencyControllers = {
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text: _getAdFrequency(adConfig, role).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: _getAdFrequency(adConfig, role).toString().length,
              ),
    };
    _adPlacementIntervalControllers = {
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text: _getAdPlacementInterval(adConfig, role).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: _getAdPlacementInterval(
                  adConfig,
                  role,
                ).toString().length,
              ),
    };
  }

  void _updateControllers() {
    final adConfig = widget.remoteConfig.adConfig;
    for (final role in AppUserRole.values) {
      final newFrequencyValue = _getAdFrequency(adConfig, role).toString();
      if (_adFrequencyControllers[role]?.text != newFrequencyValue) {
        _adFrequencyControllers[role]?.text = newFrequencyValue;
        _adFrequencyControllers[role]?.selection = TextSelection.collapsed(
          offset: newFrequencyValue.length,
        );
      }

      final newPlacementIntervalValue = _getAdPlacementInterval(
        adConfig,
        role,
      ).toString();
      if (_adPlacementIntervalControllers[role]?.text !=
          newPlacementIntervalValue) {
        _adPlacementIntervalControllers[role]?.text = newPlacementIntervalValue;
        _adPlacementIntervalControllers[role]?.selection =
            TextSelection.collapsed(
              offset: newPlacementIntervalValue.length,
            );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final controller in _adFrequencyControllers.values) {
      controller.dispose();
    }
    for (final controller in _adPlacementIntervalControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adConfig = widget.remoteConfig.adConfig;
    final l10n = AppLocalizationsX(context).l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableGlobalAdsLabel),
          value: adConfig.enabled,
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: adConfig.copyWith(enabled: value),
              ),
            );
          },
        ),
      ],
    );
  }

  int _getAdFrequency(AdConfig config, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.feedAdConfiguration.frequencyConfig.guestAdFrequency;
      case AppUserRole.standardUser:
        return config
            .feedAdConfiguration
            .frequencyConfig
            .authenticatedAdFrequency;
      case AppUserRole.premiumUser:
        return config.feedAdConfiguration.frequencyConfig.premiumAdFrequency;
    }
  }

  int _getAdPlacementInterval(AdConfig config, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return config
            .feedAdConfiguration
            .frequencyConfig
            .guestAdPlacementInterval;
      case AppUserRole.standardUser:
        return config
            .feedAdConfiguration
            .frequencyConfig
            .authenticatedAdPlacementInterval;
      case AppUserRole.premiumUser:
        return config
            .feedAdConfiguration
            .frequencyConfig
            .premiumAdPlacementInterval;
    }
  }
}
