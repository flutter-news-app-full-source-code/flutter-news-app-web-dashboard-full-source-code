import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/saved_filter_limits_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/user_limits_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template limits_configuration_tab}
/// A widget representing the "User" tab in the App Configuration page.
///
/// This tab allows configuration of user-specific limits and settings.
/// {@endtemplate}
class LimitsConfigurationTab extends StatelessWidget {
  /// {@macro limits_configuration_tab}
  const LimitsConfigurationTab({
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

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ExpansionTile(
          leading: const Icon(Icons.rule_folder_outlined),
          title: Text(l10n.userContentLimitsTitle),
          subtitle: Text(
            l10n.userContentLimitsDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          children: [
            UserLimitsConfigForm(
              remoteConfig: remoteConfig,
              onConfigChanged: onConfigChanged,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ExpansionTile(
          leading: const Icon(Icons.filter_alt_outlined),
          title: Text(l10n.savedHeadlineFilterLimitsTitle),
          subtitle: Text(
            l10n.savedHeadlineFilterLimitsDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          children: [
            SavedFilterLimitsForm(
              remoteConfig: remoteConfig,
              onConfigChanged: onConfigChanged,
            ),
          ],
        ),
      ],
    );
  }
}
