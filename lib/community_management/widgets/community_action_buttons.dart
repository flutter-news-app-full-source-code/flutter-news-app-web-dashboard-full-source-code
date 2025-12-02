import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

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
    // Primary Action
    visibleActions.add(
      IconButton(
        visualDensity: VisualDensity.compact,
        iconSize: 20,
        icon: const Icon(Icons.visibility_outlined),
        tooltip: l10n.viewEngagedContent,
        onPressed: () {
          context.goNamed(
            Routes.editHeadlineName,
            pathParameters: {'id': engagement.entityId},
          );
        },
      ),
    );

    // Secondary Actions
    if (engagement.comment != null) {
      if (engagement.comment!.status != ModerationStatus.resolved) {
        overflowMenuItems.add(
          PopupMenuItem<String>(
            value: 'approveComment',
            child: Text(l10n.approveComment),
          ),
        );
      }
      if (engagement.comment != null) {
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
    visibleActions.add(
      IconButton(
        visualDensity: VisualDensity.compact,
        iconSize: 20,
        icon: const Icon(Icons.visibility_outlined),
        tooltip: switch (report.entityType) {
          ReportableEntity.headline => l10n.viewReportedHeadline,
          ReportableEntity.source => l10n.viewReportedSource,
          ReportableEntity.engagement => l10n.viewReportedComment,
        },
        onPressed: () {
          final String routeName;
          switch (report.entityType) {
            case ReportableEntity.headline:
              routeName = Routes.editHeadlineName;
            case ReportableEntity.source:
              routeName = Routes.editSourceName;
            case ReportableEntity.engagement:
              return;
          }
          context.goNamed(routeName, pathParameters: {'id': report.entityId});
        },
      ),
    );

    // Secondary Actions
    if (report.status != ModerationStatus.pendingReview) {
      overflowMenuItems.add(
        PopupMenuItem<String>(
          value: 'markAsInReview',
          child: Text(l10n.moderationStatusPendingReview),
        ),
      );
    }
    if (report.status != ModerationStatus.resolved) {
      overflowMenuItems.add(
        PopupMenuItem<String>(
          value: 'resolveReport',
          child: Text(l10n.resolveReport),
        ),
      );
    }
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
    final hasDetails =
        appReview.feedbackDetails != null &&
        appReview.feedbackDetails!.isNotEmpty;
    visibleActions.add(
      IconButton(
        visualDensity: VisualDensity.compact,
        iconSize: 20,
        icon: const Icon(Icons.comment_outlined),
        tooltip: l10n.viewFeedbackDetails,
        onPressed: hasDetails
            ? () => showDialog<void>(
                context: context,
                builder: (_) =>
                    _FeedbackDetailsDialog(appReview: appReview, l10n: l10n),
              )
            : null,
      ),
    );

    // Secondary Actions
    overflowMenuItems.add(
      PopupMenuItem<String>(value: 'copyUserId', child: Text(l10n.copyUserId)),
    );
  }

  void _onActionSelected(BuildContext context, String value, T item) {
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
    } else if (value == 'copyReportedItemId' && item is Report) {
      final reportedItemId = item.entityId;
      Clipboard.setData(ClipboardData(text: reportedItemId));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.idCopiedToClipboard(reportedItemId))),
        );
    } else if (value == 'approveComment' && item is Engagement) {
      final updatedEngagement = item.copyWith(
        comment: item.comment?.copyWith(status: ModerationStatus.resolved),
      );
      engagementsRepository.update(
        id: updatedEngagement.id,
        item: updatedEngagement,
      );
    } else if (value == 'rejectComment' && item is Engagement) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.rejectComment),
          content: Text(l10n.rejectCommentConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedEngagement = Engagement(
                  id: item.id,
                  userId: item.userId,
                  entityId: item.entityId,
                  entityType: item.entityType,
                  reaction: item.reaction,
                  comment: null,
                  createdAt: item.createdAt,
                  updatedAt: DateTime.now(),
                );
                engagementsRepository.update(
                  id: updatedEngagement.id,
                  item: updatedEngagement,
                );
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.reject),
            ),
          ],
        ),
      );
    } else if (value == 'markAsInReview' && item is Report) {
      final updatedReport = item.copyWith(
        status: ModerationStatus.pendingReview,
      );
      reportsRepository.update(
        id: updatedReport.id,
        item: updatedReport,
      );
    } else if (value == 'resolveReport' && item is Report) {
      final updatedReport = item.copyWith(status: ModerationStatus.resolved);
      reportsRepository.update(
        id: updatedReport.id,
        item: updatedReport,
      );
    }
  }
}

class _FeedbackDetailsDialog extends StatelessWidget {
  const _FeedbackDetailsDialog({
    required this.appReview,
    required this.l10n,
  });

  final AppReview appReview;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final details = appReview.feedbackDetails;

    return AlertDialog(
      title: Text(l10n.feedbackDetails),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.feedbackProvidedAt(
                  DateFormatter.formatRelativeTime(
                    context,
                    appReview.updatedAt,
                  ),
                ),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(details ?? l10n.noReasonProvided),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.closeButtonText),
        ),
      ],
    );
  }
}
