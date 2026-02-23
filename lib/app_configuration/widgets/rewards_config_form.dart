import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template rewards_config_form}
/// A form widget for configuring the rewards system.
///
/// Allows enabling/disabling the system globally and configuring individual
/// reward types (duration and status).
/// {@endtemplate}
class RewardsConfigForm extends StatefulWidget {
  /// {@macro rewards_config_form}
  const RewardsConfigForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<RewardsConfigForm> createState() => _RewardsConfigFormState();
}

class _RewardsConfigFormState extends State<RewardsConfigForm> {
  late Map<RewardType, TextEditingController> _durationControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant RewardsConfigForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.features.rewards !=
        oldWidget.remoteConfig.features.rewards) {
      _updateControllers();
    }
  }

  @override
  void dispose() {
    for (final controller in _durationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    final rewards = widget.remoteConfig.features.rewards.rewards;
    _durationControllers = {
      for (final type in RewardType.values)
        type: TextEditingController(
          text: (rewards[type]?.durationDays ?? 0).toString(),
        ),
    };
  }

  void _updateControllers() {
    final rewards = widget.remoteConfig.features.rewards.rewards;
    for (final type in RewardType.values) {
      final duration = (rewards[type]?.durationDays ?? 0).toString();
      if (_durationControllers[type]?.text != duration) {
        _durationControllers[type]?.text = duration;
      }
    }
  }

  String _getRewardLabel(BuildContext context, RewardType type) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (type) {
      case RewardType.adFree:
        return l10n.rewardTypeAdFree;
    }
  }

  void _updateRewardDetails(RewardType type, RewardDetails newDetails) {
    final features = widget.remoteConfig.features;
    final rewardsConfig = features.rewards;
    final newRewards = Map<RewardType, RewardDetails>.from(
      rewardsConfig.rewards,
    );
    newRewards[type] = newDetails;

    widget.onConfigChanged(
      widget.remoteConfig.copyWith(
        features: features.copyWith(
          rewards: rewardsConfig.copyWith(rewards: newRewards),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final features = widget.remoteConfig.features;
    final rewardsConfig = features.rewards;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableRewardsLabel),
          subtitle: Text(l10n.enableRewardsDescription),
          value: rewardsConfig.enabled,
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                features: features.copyWith(
                  rewards: rewardsConfig.copyWith(enabled: value),
                ),
              ),
            );
          },
        ),
        if (rewardsConfig.enabled) ...[
          const SizedBox(height: AppSpacing.lg),
          ...RewardType.values.map((type) {
            final details =
                rewardsConfig.rewards[type] ??
                const RewardDetails(enabled: false, durationDays: 0);
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _getRewardLabel(context, type),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Switch(
                          value: details.enabled,
                          onChanged: (value) {
                            _updateRewardDetails(
                              type,
                              details.copyWith(enabled: value),
                            );
                          },
                        ),
                      ],
                    ),
                    if (details.enabled) ...[
                      const SizedBox(height: AppSpacing.sm),
                      AppConfigIntField(
                        label: l10n.rewardDurationDaysLabel,
                        description: l10n.rewardDurationDaysDescription,
                        value: details.durationDays,
                        controller: _durationControllers[type],
                        onChanged: (value) {
                          _updateRewardDetails(
                            type,
                            details.copyWith(durationDays: value),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}
