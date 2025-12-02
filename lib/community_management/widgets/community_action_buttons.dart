import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/widgets/app_review_details_dialog.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/widgets/engagement_details_dialog.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/widgets/report_details_dialog.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';

class CommunityActionButtons<T> extends StatelessWidget {
  const CommunityActionButtons({
    required this.item,
    required this.l10n,
    super.key,
  });

  final T item;
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
      _buildReportActions(
        context,
        report,
        visibleActions,
        overflowMenuItems,
      );
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
    final isPendingReview =
        engagement.comment != null &&
        engagement.comment!.status == ModerationStatus.pendingReview;

    visibleActions.add(
      Stack(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            icon: const Icon(Icons.comment_outlined),
            tooltip: l10n.viewFeedbackDetails,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => EngagementDetailsDialog(engagement: engagement),
            ),
          ),
          if (isPendingReview)
            Positioned(
              top: 8,
              right: 8,
              child: Tooltip(
                message: l10n.moderationStatusPendingReview,
                child: const Icon(
                  Icons.circle,
                  color: Colors.amber,
                  size: 10,
                ),
              ),
            ),
        ],
      ),
    );

    // Secondary Actions
    overflowMenuItems
      ..add(
        PopupMenuItem<String>(
          value: 'copyUserId',
          child: Text(l10n.copyUserId),
        ),
      )
      ..add(
        PopupMenuItem<String>(
          value: 'copyHeadlineId',
          child: Text(l10n.copyHeadlineId),
        ),
      );
  }

  void _buildReportActions(
    BuildContext context,
    Report report,
    List<Widget> visibleActions,
    List<PopupMenuEntry<String>> overflowMenuItems,
  ) {
    final isPendingReview = report.status == ModerationStatus.pendingReview;

    visibleActions.add(
      Stack(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            icon: const Icon(Icons.comment_outlined),
            tooltip: l10n.viewFeedbackDetails,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => ReportDetailsDialog(report: report),
            ),
          ),
          if (isPendingReview)
            Positioned(
              top: 8,
              right: 8,
              child: Tooltip(
                message: l10n.moderationStatusPendingReview,
                child: const Icon(
                  Icons.circle,
                  color: Colors.amber,
                  size: 10,
                ),
              ),
            ),
        ],
      ),
    );

    // Secondary Actions
    overflowMenuItems
      ..add(
        PopupMenuItem<String>(
          value: 'copyUserId',
          child: Text(l10n.copyUserId),
        ),
      )
      ..add(
        PopupMenuItem<String>(
          value: 'copyReportedItemId',
          child: Text(l10n.copyReportedItemId),
        ),
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
        icon: const Icon(Icons.comment_outlined),
        tooltip: l10n.viewFeedbackDetails,
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => AppReviewDetailsDialog(appReview: appReview),
        ),
      ),
    );

    // Secondary Actions
    overflowMenuItems.add(
      PopupMenuItem<String>(value: 'copyUserId', child: Text(l10n.copyUserId)),
    );
  }

  void _onActionSelected(BuildContext context, String value, T item) {
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
    } else if (value == 'copyReportedItemId' && item is Report) {
      final reportedItemId = item.entityId;
      Clipboard.setData(ClipboardData(text: reportedItemId));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.idCopiedToClipboard(reportedItemId))),
        );
    } else if (value == 'copyHeadlineId' && item is Engagement) {
      final headlineId = item.entityId;
      Clipboard.setData(ClipboardData(text: headlineId));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.idCopiedToClipboard(headlineId))),
        );
    }
  }
}
