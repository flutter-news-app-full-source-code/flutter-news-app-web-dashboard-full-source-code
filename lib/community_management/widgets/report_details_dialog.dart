import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:core_ui/core_ui.dart';

class ReportDetailsDialog extends StatelessWidget {
  const ReportDetailsDialog({
    required this.report,
    super.key,
  });

  final Report report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);

    final isPendingReview = report.status == ModerationStatus.pendingReview;

    return AlertDialog(
      title: Text(l10n.reportDetails),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 300),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${l10n.reason}: ${ReportReasonX(report.reason).l10n(context)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (report.additionalComments != null &&
                  report.additionalComments!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.comment,
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  report.additionalComments!,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.closeButtonText),
        ),
        if (isPendingReview)
          ElevatedButton(
            onPressed: () {
              context.read<CommunityManagementBloc>().add(
                ResolveReportRequested(report.id),
              );
              Navigator.of(context).pop();
            },
            child: Text(l10n.resolveReport),
          ),
      ],
    );
  }
}
