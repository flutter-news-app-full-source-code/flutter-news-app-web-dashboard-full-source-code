import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template reporting_settings_form}
/// A form widget for configuring content reporting settings.
/// {@endtemplate}
class ReportingSettingsForm extends StatelessWidget {
  /// {@macro reporting_settings_form}
  const ReportingSettingsForm({
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
    final communityConfig = remoteConfig.features.community;
    final reportingConfig = communityConfig.reporting;

    final isSystemEnabled =
        reportingConfig.headlineReportingEnabled ||
        reportingConfig.sourceReportingEnabled ||
        reportingConfig.commentReportingEnabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableReportingSystemLabel),
          subtitle: Text(l10n.enableReportingSystemDescription),
          value: isSystemEnabled,
          onChanged: (value) {
            final newConfig = communityConfig.copyWith(
              reporting: reportingConfig.copyWith(
                headlineReportingEnabled: value,
                sourceReportingEnabled: value,
                commentReportingEnabled: value,
              ),
            );
            onConfigChanged(
              remoteConfig.copyWith(
                features: remoteConfig.features.copyWith(community: newConfig),
              ),
            );
          },
        ),
        if (isSystemEnabled) ...[
          const SizedBox(height: AppSpacing.lg),
          SwitchListTile(
            title: Text(l10n.enableHeadlineReportingLabel),
            subtitle: Text(l10n.enableHeadlineReportingDescription),
            value: reportingConfig.headlineReportingEnabled,
            onChanged: (value) {
              final newConfig = reportingConfig.copyWith(
                headlineReportingEnabled: value,
              );
              _checkReportingConstraints(context, l10n, newConfig);
              onConfigChanged(
                remoteConfig.copyWith(
                  features: remoteConfig.features.copyWith(
                    community: communityConfig.copyWith(
                      reporting: newConfig,
                    ),
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text(l10n.enableSourceReportingLabel),
            subtitle: Text(l10n.enableSourceReportingDescription),
            value: reportingConfig.sourceReportingEnabled,
            onChanged: (value) {
              final newConfig = reportingConfig.copyWith(
                sourceReportingEnabled: value,
              );
              _checkReportingConstraints(context, l10n, newConfig);
              onConfigChanged(
                remoteConfig.copyWith(
                  features: remoteConfig.features.copyWith(
                    community: communityConfig.copyWith(
                      reporting: newConfig,
                    ),
                  ),
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text(l10n.enableCommentReportingLabel),
            subtitle: Text(l10n.enableCommentReportingDescription),
            value: reportingConfig.commentReportingEnabled,
            onChanged: (value) {
              final newConfig = reportingConfig.copyWith(
                commentReportingEnabled: value,
              );
              _checkReportingConstraints(context, l10n, newConfig);
              onConfigChanged(
                remoteConfig.copyWith(
                  features: remoteConfig.features.copyWith(
                    community: communityConfig.copyWith(
                      reporting: newConfig,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  void _checkReportingConstraints(
    BuildContext context,
    AppLocalizations l10n,
    ReportingConfig config,
  ) {
    final isAnyEnabled =
        config.headlineReportingEnabled ||
        config.sourceReportingEnabled ||
        config.commentReportingEnabled;

    if (!isAnyEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.reportingFeatureDisabledNotification)),
      );
    }
  }
}
