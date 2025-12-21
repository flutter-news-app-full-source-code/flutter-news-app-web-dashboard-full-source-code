import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_shell.dart';
import 'package:go_router/go_router.dart';

/// {@template ranked_list_card}
/// A widget that displays a ranked list of items (e.g., Top 5 Headlines)
/// with time frame toggles.
/// {@endtemplate}
class RankedListCard extends StatefulWidget {
  /// {@macro ranked_list_card}
  const RankedListCard({
    required this.data,
    required this.slotIndex,
    required this.totalSlots,
    required this.onSlotChanged,
    super.key,
  });

  final RankedListCardData data;
  final int slotIndex;
  final int totalSlots;
  final ValueChanged<int> onSlotChanged;

  @override
  State<RankedListCard> createState() => _RankedListCardState();
}

class _RankedListCardState extends State<RankedListCard> {
  RankedListTimeFrame _selectedTimeFrame = RankedListTimeFrame.week;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);
    final currentList = widget.data.timeFrames[_selectedTimeFrame];

    return AnalyticsCardShell<RankedListTimeFrame>(
      title: _getLocalizedTitle(widget.data.id, l10n),
      currentSlot: widget.slotIndex,
      totalSlots: widget.totalSlots,
      onSlotChanged: widget.onSlotChanged,
      timeFrames: RankedListTimeFrame.values,
      selectedTimeFrame: _selectedTimeFrame,
      onTimeFrameChanged: (value) => setState(() => _selectedTimeFrame = value),
      timeFrameToString: (frame) => _timeFrameToLabel(frame, l10n),
      timeFramePosition: TimeFramePosition.bottom,
      child: (currentList == null || currentList.isEmpty)
          ? Center(child: Text(l10n.noDataAvailable))
          : ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: currentList.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = currentList[index];
                return ListTile(
                  onTap: () => _onItemTapped(context, widget.data.id, item),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                    radius: 10,
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  title: Text(
                    item.displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  trailing: Text(
                    item.metricValue.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _onItemTapped(
    BuildContext context,
    RankedListCardId cardId,
    RankedListItem item,
  ) {
    final entityId = item.entityId;
    switch (cardId) {
      case RankedListCardId.overviewHeadlinesMostViewed:
      case RankedListCardId.overviewHeadlinesMostLiked:
        context.goNamed(
          Routes.editHeadlineName,
          pathParameters: {'id': entityId},
        );
      case RankedListCardId.overviewSourcesMostFollowed:
        context.goNamed(
          Routes.editSourceName,
          pathParameters: {'id': entityId},
        );
      case RankedListCardId.overviewTopicsMostFollowed:
        context.goNamed(Routes.editTopicName, pathParameters: {'id': entityId});
    }
  }

  String _getLocalizedTitle(RankedListCardId id, AppLocalizations l10n) {
    switch (id) {
      case RankedListCardId.overviewHeadlinesMostViewed:
        return l10n.rankedListOverviewHeadlinesMostViewed;
      case RankedListCardId.overviewHeadlinesMostLiked:
        return l10n.rankedListOverviewHeadlinesMostLiked;
      case RankedListCardId.overviewSourcesMostFollowed:
        return l10n.rankedListOverviewSourcesMostFollowed;
      case RankedListCardId.overviewTopicsMostFollowed:
        return l10n.rankedListOverviewTopicsMostFollowed;
    }
  }

  String _timeFrameToLabel(RankedListTimeFrame frame, AppLocalizations l10n) {
    switch (frame) {
      case RankedListTimeFrame.day:
        return l10n.timeFrameDay;
      case RankedListTimeFrame.week:
        return l10n.timeFrameWeek;
      case RankedListTimeFrame.month:
        return l10n.timeFrameMonth;
      case RankedListTimeFrame.year:
        return l10n.timeFrameYear;
    }
  }
}
