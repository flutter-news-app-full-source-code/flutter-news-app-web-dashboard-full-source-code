import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template feed_ad_settings_form}
/// A form widget for configuring feed ad settings.
/// {@endtemplate}
class FeedAdSettingsForm extends StatefulWidget {
  /// {@macro feed_ad_settings_form}
  const FeedAdSettingsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<FeedAdSettingsForm> createState() => _FeedAdSettingsFormState();
}

class _FeedAdSettingsFormState extends State<FeedAdSettingsForm> {
  AppUserRole _selectedUserRole = AppUserRole.guestUser;
  late final Map<AppUserRole, TextEditingController> _adFrequencyControllers;
  late final Map<AppUserRole, TextEditingController>
      _adPlacementIntervalControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant FeedAdSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.adConfig.feedAdConfiguration !=
        oldWidget.remoteConfig.adConfig.feedAdConfiguration) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final feedAdConfig = widget.remoteConfig.adConfig.feedAdConfiguration;
    _adFrequencyControllers = {
      for (final role in AppUserRole.values)
        role: TextEditingController(
          text: _getAdFrequency(feedAdConfig, role).toString(),
        )..selection = TextSelection.collapsed(
            offset: _getAdFrequency(feedAdConfig, role).toString().length,
          ),
    };
    _adPlacementIntervalControllers = {
      for (final role in AppUserRole.values)
        role: TextEditingController(
          text: _getAdPlacementInterval(feedAdConfig, role).toString(),
        )..selection = TextSelection.collapsed(
            offset:
                _getAdPlacementInterval(feedAdConfig, role).toString().length,
          ),
    };
  }

  void _updateControllers() {
    final feedAdConfig = widget.remoteConfig.adConfig.feedAdConfiguration;
    for (final role in AppUserRole.values) {
      _adFrequencyControllers[role]?.text =
          _getAdFrequency(feedAdConfig, role).toString();
      _adFrequencyControllers[role]?.selection = TextSelection.collapsed(
        offset: _adFrequencyControllers[role]!.text.length,
      );
      _adPlacementIntervalControllers[role]?.text =
          _getAdPlacementInterval(feedAdConfig, role).toString();
      _adPlacementIntervalControllers[role]?.selection =
          TextSelection.collapsed(
            offset: _adPlacementIntervalControllers[role]!.text.length,
          );
    }
  }

  @override
  void dispose() {
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
    final l10n = AppLocalizationsX(context).l10n;
    final adConfig = widget.remoteConfig.adConfig;
    final feedAdConfig = adConfig.feedAdConfiguration;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableFeedAdsLabel),
          value: feedAdConfig.enabled,
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: adConfig.copyWith(
                  feedAdConfiguration: feedAdConfig.copyWith(enabled: value),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        ExpansionTile(
          title: Text(l10n.feedAdTypeSelectionTitle),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          children: [
            Text(
              l10n.feedAdTypeSelectionDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: SegmentedButton<AdType>(
                segments: AdType.values
                    .where((type) => type == AdType.native || type == AdType.banner)
                    .map(
                      (type) => ButtonSegment<AdType>(
                        value: type,
                        label: Text(type.name),
                      ),
                    )
                    .toList(),
                selected: {feedAdConfig.adType},
                onSelectionChanged: (newSelection) {
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      adConfig: adConfig.copyWith(
                        feedAdConfiguration:
                            feedAdConfig.copyWith(adType: newSelection.first),
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
          title: Text(l10n.userRoleFrequencySettingsTitle),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          children: [
            Text(
              l10n.userRoleFrequencySettingsDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: SegmentedButton<AppUserRole>(
                segments: AppUserRole.values
                    .map(
                      (role) => ButtonSegment<AppUserRole>(
                        value: role,
                        label: Text(role.l10n(context)),
                      ),
                    )
                    .toList(),
                selected: {_selectedUserRole},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedUserRole = newSelection.first;
                  });
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildRoleSpecificFields(
              context,
              l10n,
              _selectedUserRole,
              feedAdConfig,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AppUserRole role,
    FeedAdConfiguration config,
  ) {
    return Column(
      children: [
        AppConfigIntField(
          label: l10n.adFrequencyLabel,
          description: l10n.adFrequencyDescription,
          value: _getAdFrequency(config, role),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: widget.remoteConfig.adConfig.copyWith(
                  feedAdConfiguration: _updateAdFrequency(config, value, role),
                ),
              ),
            );
          },
          controller: _adFrequencyControllers[role],
        ),
        AppConfigIntField(
          label: l10n.adPlacementIntervalLabel,
          description: l10n.adPlacementIntervalDescription,
          value: _getAdPlacementInterval(config, role),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                adConfig: widget.remoteConfig.adConfig.copyWith(
                  feedAdConfiguration:
                      _updateAdPlacementInterval(config, value, role),
                ),
              ),
            );
          },
          controller: _adPlacementIntervalControllers[role],
        ),
      ],
    );
  }

  int _getAdFrequency(FeedAdConfiguration config, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.frequencyConfig.guestAdFrequency;
      case AppUserRole.standardUser:
        return config.frequencyConfig.authenticatedAdFrequency;
      case AppUserRole.premiumUser:
        return config.frequencyConfig.premiumAdFrequency;
    }
  }

  int _getAdPlacementInterval(FeedAdConfiguration config, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.frequencyConfig.guestAdPlacementInterval;
      case AppUserRole.standardUser:
        return config.frequencyConfig.authenticatedAdPlacementInterval;
      case AppUserRole.premiumUser:
        return config.frequencyConfig.premiumAdPlacementInterval;
    }
  }

  FeedAdConfiguration _updateAdFrequency(
    FeedAdConfiguration config,
    int value,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.copyWith(
          frequencyConfig:
              config.frequencyConfig.copyWith(guestAdFrequency: value),
        );
      case AppUserRole.standardUser:
        return config.copyWith(
          frequencyConfig:
              config.frequencyConfig.copyWith(authenticatedAdFrequency: value),
        );
      case AppUserRole.premiumUser:
        return config.copyWith(
          frequencyConfig:
              config.frequencyConfig.copyWith(premiumAdFrequency: value),
        );
    }
  }

  FeedAdConfiguration _updateAdPlacementInterval(
    FeedAdConfiguration config,
    int value,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.copyWith(
          frequencyConfig:
              config.frequencyConfig.copyWith(guestAdPlacementInterval: value),
        );
      case AppUserRole.standardUser:
        return config.copyWith(
          frequencyConfig: config.frequencyConfig
              .copyWith(authenticatedAdPlacementInterval: value),
        );
      case AppUserRole.premiumUser:
        return config.copyWith(
          frequencyConfig: config.frequencyConfig
              .copyWith(premiumAdPlacementInterval: value),
        );
    }
  }
}
