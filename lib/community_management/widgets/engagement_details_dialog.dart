import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

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
      title: Text(l10n.commentDetails),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 300),
        child: SingleChildScrollView(
          child: Text(
            engagement.comment?.content ?? l10n.noReasonProvided,
            style: hasComment
                ? theme.textTheme.bodyLarge
                : theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
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
