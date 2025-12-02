import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

class EngagementDetailsDialog extends StatelessWidget {
  const EngagementDetailsDialog({
    required this.engagement,
    super.key,
  });

  final Engagement engagement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);

    final hasComment = engagement.comment != null;
    final isPendingReview =
        hasComment &&
        engagement.comment!.status == ModerationStatus.pendingReview;

    return AlertDialog(
      title: Text(l10n.engagements),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${l10n.reaction}: ${engagement.reaction.reactionType.name}',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${l10n.user}: ${engagement.userId}',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                '${l10n.date}: ${DateFormat('dd-MM-yyyy HH:mm').format(engagement.createdAt.toLocal())}',
                style: theme.textTheme.bodySmall,
              ),
              const Divider(height: AppSpacing.lg),
              Text(
                l10n.comment,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                engagement.comment?.content ?? l10n.noReasonProvided,
                style: hasComment
                    ? theme.textTheme.bodyLarge
                    : theme.textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.closeButtonText),
        ),
        if (isPendingReview) ...[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () {
              context.read<CommunityManagementBloc>().add(
                RejectCommentRequested(engagement.id),
              );
              Navigator.of(context).pop();
            },
            child: Text(l10n.rejectComment),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CommunityManagementBloc>().add(
                ApproveCommentRequested(engagement.id),
              );
              Navigator.of(context).pop();
            },
            child: Text(l10n.approveComment),
          ),
        ],
      ],
    );
  }
}
