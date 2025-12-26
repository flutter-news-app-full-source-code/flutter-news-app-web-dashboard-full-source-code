import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template subscription_config_form}
/// A form widget for configuring subscription settings.
/// {@endtemplate}
class SubscriptionConfigForm extends StatelessWidget {
  /// {@macro subscription_config_form}
  const SubscriptionConfigForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final features = remoteConfig.features;
    final subscriptionConfig = features.subscription;

    void handlePlanChange(SubscriptionConfig updatedSubscriptionConfig) {
      var finalConfig = updatedSubscriptionConfig;

      if (finalConfig.enabled &&
          !finalConfig.monthlyPlan.enabled &&
          !finalConfig.annualPlan.enabled) {
        finalConfig = finalConfig.copyWith(enabled: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.subscriptionFeatureDisabledNotification),
          ),
        );
      }

      onConfigChanged(
        remoteConfig.copyWith(
          features: features.copyWith(subscription: finalConfig),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableSubscriptionLabel),
          subtitle: Text(l10n.enableSubscriptionDescription),
          value: subscriptionConfig.enabled,
          onChanged: (value) {
            onConfigChanged(
              remoteConfig.copyWith(
                features: features.copyWith(
                  subscription: subscriptionConfig.copyWith(enabled: value),
                ),
              ),
            );
          },
        ),
        if (subscriptionConfig.enabled) ...[
          const SizedBox(height: AppSpacing.lg),
          _PlanDetailsForm(
            title: l10n.monthlyPlanTitle,
            planDetails: subscriptionConfig.monthlyPlan,
            onChanged: (updatedPlan) {
              handlePlanChange(
                subscriptionConfig.copyWith(
                  monthlyPlan: updatedPlan,
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          _PlanDetailsForm(
            title: l10n.annualPlanTitle,
            planDetails: subscriptionConfig.annualPlan,
            onChanged: (updatedPlan) {
              handlePlanChange(
                subscriptionConfig.copyWith(
                  annualPlan: updatedPlan,
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _PlanDetailsForm extends StatelessWidget {
  const _PlanDetailsForm({
    required this.title,
    required this.planDetails,
    required this.onChanged,
  });

  final String title;
  final PlanDetails planDetails;
  final ValueChanged<PlanDetails> onChanged;

  bool _hasValidProductId(String? appleId, String? googleId) {
    return (appleId != null && appleId.isNotEmpty) ||
        (googleId != null && googleId.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return ExpansionTile(
      title: Text(title),
      childrenPadding: const EdgeInsetsDirectional.only(
        start: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: AppSpacing.md,
        end: AppSpacing.md,
      ),
      children: [
        SwitchListTile(
          title: Text(l10n.planEnabledLabel),
          value: planDetails.enabled,
          onChanged: (value) {
            if (value &&
                !_hasValidProductId(
                  planDetails.appleProductId,
                  planDetails.googleProductId,
                )) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.subscriptionPlanEnablementError),
                ),
              );
              return;
            }
            onChanged(planDetails.copyWith(enabled: value));
          },
        ),
        CheckboxListTile(
          title: Text(l10n.planRecommendedLabel),
          subtitle: Text(l10n.planRecommendedDescription),
          value: planDetails.isRecommended,
          onChanged: (value) {
            onChanged(planDetails.copyWith(isRecommended: value ?? false));
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          decoration: InputDecoration(labelText: l10n.appleProductIdLabel),
          initialValue: planDetails.appleProductId,
          onChanged: (value) {
            final shouldDisable =
                planDetails.enabled &&
                !_hasValidProductId(value, planDetails.googleProductId);

            if (shouldDisable) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.subscriptionPlanDisabledNotification),
                ),
              );
            }
            onChanged(
              planDetails.copyWith(
                appleProductId: ValueWrapper(value),
                enabled: shouldDisable ? false : null,
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          decoration: InputDecoration(labelText: l10n.googleProductIdLabel),
          initialValue: planDetails.googleProductId,
          onChanged: (value) {
            final shouldDisable =
                planDetails.enabled &&
                !_hasValidProductId(planDetails.appleProductId, value);

            if (shouldDisable) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.subscriptionPlanDisabledNotification),
                ),
              );
            }
            onChanged(
              planDetails.copyWith(
                googleProductId: ValueWrapper(value),
                enabled: shouldDisable ? false : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
