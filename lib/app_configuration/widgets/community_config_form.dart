import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_review_settings_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/engagement_settings_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/reporting_settings_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template community_config_form}
/// A form widget for configuring all community-related settings.
///
/// This widget acts as a container for more specific forms like
/// [EngagementSettingsForm], [ReportingSettingsForm], and
/// [AppReviewSettingsForm], organizing them into nested [ExpansionTile]s.
/// {@endtemplate}
class CommunityConfigForm extends StatelessWidget {
  /// {@macro community_config_form}
  const CommunityConfigForm({
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: Text(l10n.userEngagementTitle),
          subtitle: Text(l10n.userEngagementDescription),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EngagementSettingsForm(
              remoteConfig: remoteConfig,
              onConfigChanged: onConfigChanged,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ExpansionTile(
          title: Text(l10n.contentReportingTitle),
          subtitle: Text(l10n.contentReportingDescription),
          childrenPadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReportingSettingsForm(
              remoteConfig: remoteConfig,
              onConfigChanged: onConfigChanged,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ExpansionTile(
          title: Text(l10n.appFeedbackFunnelTitle),
          subtitle: Text(l10n.appFeedbackFunnelDescription),
          children: [
            AppReviewSettingsForm(
              remoteConfig: remoteConfig,
              onConfigChanged: onConfigChanged,
            ),
          ],
        ),
      ],
    );
  }
}
