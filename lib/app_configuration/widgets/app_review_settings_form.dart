import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

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
  late final TextEditingController _interactionCycleThresholdController;
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
    _interactionCycleThresholdController = TextEditingController(
      text: appReviewConfig.interactionCycleThreshold.toString(),
    );
    _initialPromptCooldownController = TextEditingController(
      text: appReviewConfig.initialPromptCooldownDays.toString(),
    );
  }

  void _updateControllers() {
    final appReviewConfig = widget.remoteConfig.features.community.appReview;
    _interactionCycleThresholdController.text = appReviewConfig
        .interactionCycleThreshold
        .toString();
    _initialPromptCooldownController.text = appReviewConfig
        .initialPromptCooldownDays
        .toString();
  }

  @override
  void dispose() {
    _interactionCycleThresholdController.dispose();
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
                  final newInteractions = value
                      ? PositiveInteractionType.values.toList()
                      : appReviewConfig.eligiblePositiveInteractions;
                  final newConfig = communityConfig.copyWith(
                    appReview: appReviewConfig.copyWith(
                      enabled: value,
                      eligiblePositiveInteractions: newInteractions,
                    ),
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ExpansionTile(
                        title: Text(l10n.internalPromptLogicTitle),
                        subtitle: Text(
                          l10n.internalPromptLogicDescription,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                              ),
                        ),
                        initiallyExpanded: false,
                        childrenPadding: const EdgeInsetsDirectional.only(
                          start: AppSpacing.lg,
                          top: AppSpacing.md,
                          bottom: AppSpacing.md,
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppConfigIntField(
                            label: l10n.interactionCycleThresholdLabel,
                            description:
                                l10n.interactionCycleThresholdDescription,
                            value: appReviewConfig.interactionCycleThreshold,
                            onChanged: (value) {
                              final newConfig = communityConfig.copyWith(
                                appReview: appReviewConfig.copyWith(
                                  interactionCycleThreshold: value,
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
                            controller: _interactionCycleThresholdController,
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
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.lg,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ExpansionTile(
                        title: Text(l10n.eligiblePositiveInteractionsTitle),
                        subtitle: Text(
                          l10n.eligiblePositiveInteractionsDescription,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                              ),
                        ),
                        initiallyExpanded: false,
                        childrenPadding: const EdgeInsetsDirectional.only(
                          start: AppSpacing.lg,
                          top: AppSpacing.md,
                          bottom: AppSpacing.md,
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...PositiveInteractionType.values.map(
                            (interactionType) => SwitchListTile(
                              subtitle: Text(
                                interactionType.l10nDescription(context),
                              ),
                              title: Text(interactionType.l10n(context)),
                              value: appReviewConfig
                                  .eligiblePositiveInteractions
                                  .contains(interactionType),
                              onChanged: (value) {
                                final currentInteractions =
                                    List<PositiveInteractionType>.from(
                                      appReviewConfig
                                          .eligiblePositiveInteractions,
                                    );
                                if (value) {
                                  currentInteractions.add(interactionType);
                                } else {
                                  currentInteractions.remove(interactionType);
                                }

                                var newEnabled = appReviewConfig.enabled;
                                if (currentInteractions.isEmpty) {
                                  newEnabled = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.appReviewFeatureDisabledNotification,
                                      ),
                                    ),
                                  );
                                }

                                final newAppReviewConfig = appReviewConfig
                                    .copyWith(
                                      enabled: newEnabled,
                                      eligiblePositiveInteractions:
                                          currentInteractions,
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
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.lg,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ExpansionTile(
                        title: Text(l10n.followUpActionsTitle),
                        subtitle: Text(
                          l10n.followUpActionsDescription,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                              ),
                        ),
                        initiallyExpanded: false,
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
                      );
                    },
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

extension on PositiveInteractionType {
  String l10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case PositiveInteractionType.saveItem:
        return l10n.positiveInteractionTypeSaveItem;
      case PositiveInteractionType.followItem:
        return l10n.positiveInteractionTypeFollowItem;
      case PositiveInteractionType.shareContent:
        return l10n.positiveInteractionTypeShareContent;
      case PositiveInteractionType.saveFilter:
        return l10n.positiveInteractionTypeSaveFilter;
    }
  }
}

extension on PositiveInteractionType {
  String l10nDescription(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case PositiveInteractionType.saveItem:
        return l10n.positiveInteractionTypeSaveItemDescription;
      case PositiveInteractionType.followItem:
        return l10n.positiveInteractionTypeFollowItemDescription;
      case PositiveInteractionType.shareContent:
        return l10n.positiveInteractionTypeShareContentDescription;
      case PositiveInteractionType.saveFilter:
        return l10n.positiveInteractionTypeSaveFilterDescription;
    }
  }
}
