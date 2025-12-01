import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';

class CommunityActionButtons extends StatelessWidget {
  const CommunityActionButtons({
    required this.item,
    required this.l10n,
    super.key,
  });

  final Object item;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final visibleActions = <Widget>[];
    final overflowMenuItems = <PopupMenuEntry<String>>[];

    if (item is Engagement) {
      final engagement = item as Engagement;
      _buildEngagementActions(
        context,
        engagement,
        visibleActions,
        overflowMenuItems,
      );
    } else if (item is Report) {
      final report = item as Report;
      _buildReportActions(context, report, visibleActions, overflowMenuItems);
    } else if (item is AppReview) {
      final appReview = item as AppReview;
      _buildAppReviewActions(
        context,
        appReview,
        visibleActions,
        overflowMenuItems,
      );
    }

    if (overflowMenuItems.isNotEmpty) {
      visibleActions.add(
        SizedBox(
          width: 32,
          child: PopupMenuButton<String>(
            iconSize: 20,
            icon: const Icon(Icons.more_vert),
            tooltip: l10n.moreActions,
            onSelected: (value) => _onActionSelected(context, value, item),
            itemBuilder: (context) => overflowMenuItems,
          ),
        ),
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: visibleActions);
  }

  void _buildEngagementActions(
    BuildContext context,
    Engagement engagement,
    List<Widget> visibleActions,
    List<PopupMenuEntry<String>> overflowMenuItems,
  ) {
    // Primary Action
    visibleActions.add(
      IconButton(
        visualDensity: VisualDensity.compact,
        iconSize: 20,
        icon: const Icon(Icons.visibility_outlined),
        tooltip: l10n.viewEngagedContent,
        onPressed: () {
          // TODO(fulleni): Implement navigation to content
        },
      ),
    );

    // Secondary Actions
    if (engagement.comment != null) {
      if (engagement.comment!.status != CommentStatus.approved) {
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'approveComment',
            child: Text(l10n.approveComment),
          ),
        );
      }
      if (engagement.comment!.status != CommentStatus.rejected) {
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'rejectComment',
            child: Text(l10n.rejectComment),
          ),
        );
      }
    }
    overflowMenuItems.add(
      PopupMenuItem<String>(value: 'copyUserId', child: Text(l10n.copyUserId)),
    );
  }

  void _buildReportActions(
    BuildContext context,
    Report report,
    List<Widget> visibleActions,
    List<PopupMenuEntry<String>> overflowMenuItems,
  ) {
    // Primary Action
    visibleActions.add(
      IconButton(
        visualDensity: VisualDensity.compact,
        iconSize: 20,
        icon: const Icon(Icons.visibility_outlined),
        tooltip: l10n.viewReportedItem,
        onPressed: () {
          // TODO(fulleni): Implement navigation to reported item
        },
      ),
    );

    // Secondary Actions
    if (report.status != ReportStatus.inReview) {
      overflowMenuItems.add(
        PopupMenuItem<String>(
          value: 'markAsInReview',
          child: Text(l10n.markAsInReview),
        ),
      );
    }
    if (report.status != ReportStatus.resolved) {
      overflowMenuItems.add(
        PopupMenuItem<String>(
          value: 'resolveReport',
          child: Text(l10n.resolveReport),
        ),
      );
    }
    overflowMenuItems.add(
      PopupMenuItem<String>(value: 'copyUserId', child: Text(l10n.copyUserId)),
    );
  }

  void _buildAppReviewActions(
    BuildContext context,
    AppReview appReview,
    List<Widget> visibleActions,
    List<PopupMenuEntry<String>> overflowMenuItems,
  ) {
    // Primary Action
    visibleActions.add(
      IconButton(
        visualDensity: VisualDensity.compact,
        iconSize: 20,
        icon: const Icon(Icons.history),
        tooltip: l10n.viewFeedbackHistory,
        onPressed: () {
          // TODO(fulleni): Implement dialog to show feedback history
        },
      ),
    );

    // Secondary Actions
    overflowMenuItems.add(
      PopupMenuItem<String>(value: 'copyUserId', child: Text(l10n.copyUserId)),
    );
  }

  void _onActionSelected(BuildContext context, String value, Object item) {
    final engagementsRepository = context.read<DataRepository<Engagement>>();
    final reportsRepository = context.read<DataRepository<Report>>();

    if (value == 'copyUserId') {
      String userId;
      if (item is Engagement) {
        userId = item.userId;
      } else if (item is Report) {
        userId = item.reporterUserId;
      } else if (item is AppReview) {
        userId = item.userId;
      } else {
        return;
      }
      Clipboard.setData(ClipboardData(text: userId));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.userIdCopied)));
    } else if (value == 'approveComment' && item is Engagement) {
      final updatedEngagement = item.copyWith(
        comment: item.comment?.copyWith(status: CommentStatus.approved),
      );
      engagementsRepository.update(
        id: updatedEngagement.id,
        item: updatedEngagement,
      );
    } else if (value == 'rejectComment' && item is Engagement) {
      final updatedEngagement = item.copyWith(
        comment: item.comment?.copyWith(status: CommentStatus.rejected),
      );
      engagementsRepository.update(
        id: updatedEngagement.id,
        item: updatedEngagement,
      );
    } else if (value == 'markAsInReview' && item is Report) {
      final updatedReport = item.copyWith(status: ReportStatus.inReview);
      reportsRepository.update(
        id: updatedReport.id,
        item: updatedReport,
      );
    } else if (value == 'resolveReport' && item is Report) {
      final updatedReport = item.copyWith(status: ReportStatus.resolved);
      reportsRepository.update(
        id: updatedReport.id,
        item: updatedReport,
      );
    }
  }
}
