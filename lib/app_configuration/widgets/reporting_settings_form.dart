import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enableReportingSystemLabel),
          subtitle: Text(l10n.enableReportingSystemDescription),
          value: reportingConfig.enabled,
          onChanged: (value) {
            final newConfig = communityConfig.copyWith(
              reporting: reportingConfig.copyWith(enabled: value),
            );
            onConfigChanged(
              remoteConfig.copyWith(
                features: remoteConfig.features.copyWith(community: newConfig),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.lg),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(l10n.enableHeadlineReportingLabel),
                value: reportingConfig.headlineReportingEnabled,
                onChanged: (value) {
                  final newConfig = reportingConfig.copyWith(
                    headlineReportingEnabled: value,
                  );
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
                value: reportingConfig.sourceReportingEnabled,
                onChanged: (value) {
                  final newConfig = reportingConfig.copyWith(
                    sourceReportingEnabled: value,
                  );
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
                value: reportingConfig.commentReportingEnabled,
                onChanged: (value) {
                  final newConfig = reportingConfig.copyWith(
                    commentReportingEnabled: value,
                  );
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
          ),
        ),
      ],
    );
  }
}
