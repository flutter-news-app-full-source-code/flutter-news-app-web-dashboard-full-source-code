import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

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
      title: Text(l10n.reports),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${l10n.reportedItem}: ${report.entityType.l10n(context)}',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${l10n.reporter}: ${report.reporterUserId}',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                '${l10n.date}: ${DateFormat('dd-MM-yyyy HH:mm').format(report.createdAt.toLocal())}',
                style: theme.textTheme.bodySmall,
              ),
              const Divider(height: AppSpacing.lg),
              Text(
                '${l10n.reason}: ${report.reason.l10n(context)}',
                style: theme.textTheme.titleMedium,
              ),
              if (report.additionalComments != null &&
                  report.additionalComments!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.comment,
                  style: theme.textTheme.titleSmall,
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