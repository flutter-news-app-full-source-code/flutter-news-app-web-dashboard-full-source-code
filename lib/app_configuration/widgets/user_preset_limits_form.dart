import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template user_preset_limits_form}
/// A form for configuring user preset limits within the [RemoteConfig].
///
/// This form provides fields to set the maximum number of saved filters
/// for guest, authenticated, and premium users.
/// {@endtemplate}
class UserPresetLimitsForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final userPreferenceConfig = remoteConfig.userPreferenceConfig;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormFieldWithDescription(
          label: l10n.guestUserRole,
          description: l10n.savedFiltersLimitDescription,
          initialValue: userPreferenceConfig.guestSavedFiltersLimit.toString(),
          onChanged: (value) {
            final newLimit = int.tryParse(value);
            if (newLimit != null) {
              onConfigChanged(
                remoteConfig.copyWith(
                  userPreferenceConfig: userPreferenceConfig.copyWith(
                    guestSavedFiltersLimit: newLimit,
                  ),
                ),
              );
            }
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        TextFormFieldWithDescription(
          label: l10n.standardUserRole,
          description: l10n.savedFiltersLimitDescription,
          initialValue: userPreferenceConfig.authenticatedSavedFiltersLimit
              .toString(),
          onChanged: (value) {
            final newLimit = int.tryParse(value);
            if (newLimit != null) {
              onConfigChanged(
                remoteConfig.copyWith(
                  userPreferenceConfig: userPreferenceConfig.copyWith(
                    authenticatedSavedFiltersLimit: newLimit,
                  ),
                ),
              );
            }
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        TextFormFieldWithDescription(
          label: l10n.premiumUserRole,
          description: l10n.savedFiltersLimitDescription,
          initialValue: userPreferenceConfig.premiumSavedFiltersLimit
              .toString(),
          onChanged: (value) {
            final newLimit = int.tryParse(value);
            if (newLimit != null) {
              onConfigChanged(
                remoteConfig.copyWith(
                  userPreferenceConfig: userPreferenceConfig.copyWith(
                    premiumSavedFiltersLimit: newLimit,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
