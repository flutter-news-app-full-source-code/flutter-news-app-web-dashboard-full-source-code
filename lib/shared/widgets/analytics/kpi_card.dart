import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_shell.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template kpi_card}
/// A widget that displays a Key Performance Indicator (KPI) with a value,
/// trend, and time frame toggles.
/// {@endtemplate}
class KpiCard extends StatefulWidget {
  /// {@macro kpi_card}
  const KpiCard({
    required this.data,
    required this.slotIndex,
    required this.totalSlots,
    required this.onSlotChanged,
    super.key,
  });

  /// The data object containing values for all time frames.
  final KpiCardData data;

  /// The index of this card in the parent slot.
  final int slotIndex;

  /// The total number of cards in the parent slot.
  final int totalSlots;

  /// Callback to change the active card in the slot.
  final ValueChanged<int> onSlotChanged;

  @override
  State<KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<KpiCard> {
  KpiTimeFrame _selectedTimeFrame = KpiTimeFrame.week;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsX(context).l10n;
    final currentData = widget.data.timeFrames[_selectedTimeFrame];

    return AnalyticsCardShell<KpiTimeFrame>(
      title: _getLocalizedTitle(widget.data.id, l10n),
      currentSlot: widget.slotIndex,
      totalSlots: widget.totalSlots,
      onSlotChanged: widget.onSlotChanged,
      timeFrames: KpiTimeFrame.values,
      selectedTimeFrame: _selectedTimeFrame,
      onTimeFrameChanged: (value) => setState(() => _selectedTimeFrame = value),
      timeFrameToString: (frame) => _timeFrameToLabel(frame, l10n),
      child: currentData == null
          ? Center(child: Text(l10n.noDataAvailable))
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    currentData.value.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _TrendIndicator(
                    trend: currentData.trend,
                    timeFrame: _selectedTimeFrame,
                    l10n: l10n,
                  ),
                ],
              ),
            ),
    );
  }

  String _getLocalizedTitle(KpiCardId id, AppLocalizations l10n) {
    switch (id) {
      case KpiCardId.usersTotalRegistered:
        return l10n.kpiUsersTotalRegistered;
      case KpiCardId.usersNewRegistrations:
        return l10n.kpiUsersNewRegistrations;
      case KpiCardId.usersActiveUsers:
        return l10n.kpiUsersActiveUsers;
      case KpiCardId.contentHeadlinesTotalPublished:
        return l10n.kpiContentHeadlinesTotalPublished;
      case KpiCardId.contentHeadlinesTotalViews:
        return l10n.kpiContentHeadlinesTotalViews;
      case KpiCardId.contentHeadlinesTotalLikes:
        return l10n.kpiContentHeadlinesTotalLikes;
      case KpiCardId.contentSourcesTotalSources:
        return l10n.kpiContentSourcesTotalSources;
      case KpiCardId.contentSourcesNewSources:
        return l10n.kpiContentSourcesNewSources;
      case KpiCardId.contentSourcesTotalFollowers:
        return l10n.kpiContentSourcesTotalFollowers;
      case KpiCardId.contentTopicsTotalTopics:
        return l10n.kpiContentTopicsTotalTopics;
      case KpiCardId.contentTopicsNewTopics:
        return l10n.kpiContentTopicsNewTopics;
      case KpiCardId.contentTopicsTotalFollowers:
        return l10n.kpiContentTopicsTotalFollowers;
      case KpiCardId.engagementsTotalReactions:
        return l10n.kpiEngagementsTotalReactions;
      case KpiCardId.engagementsTotalComments:
        return l10n.kpiEngagementsTotalComments;
      case KpiCardId.engagementsAverageEngagementRate:
        return l10n.kpiEngagementsAverageEngagementRate;
      case KpiCardId.engagementsReportsPending:
        return l10n.kpiEngagementsReportsPending;
      case KpiCardId.engagementsReportsResolved:
        return l10n.kpiEngagementsReportsResolved;
      case KpiCardId.engagementsReportsAverageResolutionTime:
        return l10n.kpiEngagementsReportsAverageResolutionTime;
      case KpiCardId.engagementsAppReviewsTotalFeedback:
        return l10n.kpiEngagementsAppReviewsTotalFeedback;
      case KpiCardId.engagementsAppReviewsPositiveFeedback:
        return l10n.kpiEngagementsAppReviewsPositiveFeedback;
      case KpiCardId.engagementsAppReviewsStoreRequests:
        return l10n.kpiEngagementsAppReviewsStoreRequests;
      case KpiCardId.rewardsAdsWatchedTotal:
        return l10n.kpiRewardsAdsWatchedTotal;
      case KpiCardId.rewardsGrantedTotal:
        return l10n.kpiRewardsGrantedTotal;
      case KpiCardId.rewardsActiveUsersCount:
        return l10n.kpiRewardsActiveUsersCount;
    }
  }
}

String _timeFrameToLabel(KpiTimeFrame frame, AppLocalizations l10n) {
  switch (frame) {
    case KpiTimeFrame.day:
      return l10n.timeFrameDay;
    case KpiTimeFrame.week:
      return l10n.timeFrameWeek;
    case KpiTimeFrame.month:
      return l10n.timeFrameMonth;
    case KpiTimeFrame.year:
      return l10n.timeFrameYear;
  }
}

class _TrendIndicator extends StatelessWidget {
  const _TrendIndicator({
    required this.trend,
    required this.timeFrame,
    required this.l10n,
  });

  final String trend;
  final KpiTimeFrame timeFrame;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = !trend.startsWith('-');
    final color = isPositive ? Colors.green : theme.colorScheme.error;
    final icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;

    return Tooltip(
      message: _getTooltipMessage(timeFrame, l10n),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 2),
            Text(
              trend,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTooltipMessage(KpiTimeFrame frame, AppLocalizations l10n) {
    switch (frame) {
      case KpiTimeFrame.day:
        return l10n.vsPreviousDay;
      case KpiTimeFrame.week:
        return l10n.vsPreviousWeek;
      case KpiTimeFrame.month:
        return l10n.vsPreviousMonth;
      case KpiTimeFrame.year:
        return l10n.vsPreviousYear;
    }
  }
}
