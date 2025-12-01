import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template app_review_settings_form}
/// A form widget for configuring app review funnel settings.
/// {@endtemplate}
class AppReviewSettingsForm extends StatefulWidget {
  /// {@macro app_review_settings_form}
  const AppReviewSettingsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<AppReviewSettingsForm> createState() => _AppReviewSettingsFormState();
}

class _AppReviewSettingsFormState extends State<AppReviewSettingsForm> {
  late final TextEditingController _positiveInteractionThresholdController;
  late final TextEditingController _initialPromptCooldownController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant AppReviewSettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.features.community.appReview !=
        oldWidget.remoteConfig.features.community.appReview) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final appReviewConfig = widget.remoteConfig.features.community.appReview;
    _positiveInteractionThresholdController = TextEditingController(
      text: appReviewConfig.positiveInteractionThreshold.toString(),
    );
    _initialPromptCooldownController = TextEditingController(
      text: appReviewConfig.initialPromptCooldownDays.toString(),
    );
  }

  void _updateControllers() {
    final appReviewConfig = widget.remoteConfig.features.community.appReview;
    _positiveInteractionThresholdController.text = appReviewConfig
        .positiveInteractionThreshold
        .toString();
    _initialPromptCooldownController.text = appReviewConfig
        .initialPromptCooldownDays
        .toString();
  }

  @override
  void dispose() {
    _positiveInteractionThresholdController.dispose();
    _initialPromptCooldownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final communityConfig = widget.remoteConfig.features.community;
    final appReviewConfig = communityConfig.appReview;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: Text(l10n.enableAppFeedbackSystemLabel),
                subtitle: Text(l10n.enableAppFeedbackSystemDescription),
                value: appReviewConfig.enabled,
                onChanged: (value) {
                  final newConfig = communityConfig.copyWith(
                    appReview: appReviewConfig.copyWith(enabled: value),
                  );
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      features: widget.remoteConfig.features.copyWith(
                        community: newConfig,
                      ),
                    ),
                  );
                },
              ),
              if (appReviewConfig.enabled) ...[
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      ExpansionTile(
                        title: Text(l10n.internalPromptLogicTitle),
                        childrenPadding: const EdgeInsetsDirectional.only(
                          start: AppSpacing.lg,
                          top: AppSpacing.md,
                          bottom: AppSpacing.md,
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppConfigIntField(
                            label: l10n.positiveInteractionThresholdLabel,
                            description:
                                l10n.positiveInteractionThresholdDescription,
                            value: appReviewConfig.positiveInteractionThreshold,
                            onChanged: (value) {
                              final newConfig = communityConfig.copyWith(
                                appReview: appReviewConfig.copyWith(
                                  positiveInteractionThreshold: value,
                                ),
                              );
                              widget.onConfigChanged(
                                widget.remoteConfig.copyWith(
                                  features: widget.remoteConfig.features
                                      .copyWith(
                                        community: newConfig,
                                      ),
                                ),
                              );
                            },
                            controller: _positiveInteractionThresholdController,
                          ),
                          AppConfigIntField(
                            label: l10n.initialPromptCooldownLabel,
                            description: l10n.initialPromptCooldownDescription,
                            value: appReviewConfig.initialPromptCooldownDays,
                            onChanged: (value) {
                              final newConfig = communityConfig.copyWith(
                                appReview: appReviewConfig.copyWith(
                                  initialPromptCooldownDays: value,
                                ),
                              );
                              widget.onConfigChanged(
                                widget.remoteConfig.copyWith(
                                  features: widget.remoteConfig.features
                                      .copyWith(
                                        community: newConfig,
                                      ),
                                ),
                              );
                            },
                            controller: _initialPromptCooldownController,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ExpansionTile(
                        title: Text(l10n.followUpActionsTitle),
                        childrenPadding: const EdgeInsetsDirectional.only(
                          start: AppSpacing.lg,
                          top: AppSpacing.md,
                          bottom: AppSpacing.md,
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            title: Text(l10n.requestStoreReviewLabel),
                            subtitle: Text(l10n.requestStoreReviewDescription),
                            value: appReviewConfig
                                .isPositiveFeedbackFollowUpEnabled,
                            onChanged: (value) {
                              final newAppReviewConfig = appReviewConfig
                                  .copyWith(
                                    isPositiveFeedbackFollowUpEnabled: value,
                                  );
                              widget.onConfigChanged(
                                widget.remoteConfig.copyWith(
                                  features: widget.remoteConfig.features
                                      .copyWith(
                                        community: communityConfig.copyWith(
                                          appReview: newAppReviewConfig,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                          SwitchListTile(
                            title: Text(l10n.requestWrittenFeedbackLabel),
                            subtitle: Text(
                              l10n.requestWrittenFeedbackDescription,
                            ),
                            value: appReviewConfig
                                .isNegativeFeedbackFollowUpEnabled,
                            onChanged: (value) {
                              final newAppReviewConfig = appReviewConfig
                                  .copyWith(
                                    isNegativeFeedbackFollowUpEnabled: value,
                                  );
                              widget.onConfigChanged(
                                widget.remoteConfig.copyWith(
                                  features: widget.remoteConfig.features
                                      .copyWith(
                                        community: communityConfig.copyWith(
                                          appReview: newAppReviewConfig,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
