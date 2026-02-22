import 'package:core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_shell.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:ui_kit/ui_kit.dart';

/// {@template chart_card}
/// A widget that displays a chart (Bar or Line) with time frame toggles.
/// {@endtemplate}
class ChartCard extends StatefulWidget {
  /// {@macro chart_card}
  const ChartCard({
    required this.data,
    this.slotIndex,
    this.totalSlots,
    this.onSlotChanged,
    super.key,
  });

  final ChartCardData data;
  final int? slotIndex;
  final int? totalSlots;
  final ValueChanged<int>? onSlotChanged;

  String _getLocalizedTitle(ChartCardId id, AppLocalizations l10n) {
    switch (id) {
      case ChartCardId.overviewAppTourFunnel:
        return l10n.chartOverviewAppTourFunnel;
      case ChartCardId.overviewInitialPersonalizationFunnel:
        return l10n.chartOverviewInitialPersonalizationFunnel;
      case ChartCardId.usersRegistrationsOverTime:
        return l10n.chartUsersRegistrationsOverTime;
      case ChartCardId.usersActiveUsersOverTime:
        return l10n.chartUsersActiveUsersOverTime;
      case ChartCardId.usersTierDistribution:
        return l10n.chartUsersRoleDistribution;
      case ChartCardId.contentHeadlinesViewsOverTime:
        return l10n.chartContentHeadlinesViewsOverTime;
      case ChartCardId.contentHeadlinesLikesOverTime:
        return l10n.chartContentHeadlinesLikesOverTime;
      case ChartCardId.contentHeadlinesViewsByTopic:
        return l10n.chartContentHeadlinesViewsByTopic;
      case ChartCardId.contentSourcesHeadlinesPublishedOverTime:
        return l10n.chartContentSourcesHeadlinesPublishedOverTime;
      case ChartCardId.contentSourcesStatusDistribution:
        return l10n.chartContentSourcesStatusDistribution;
      case ChartCardId.contentSourcesEngagementByType:
        return l10n.chartContentSourcesEngagementByType;
      case ChartCardId.contentHeadlinesBreakingNewsDistribution:
        return l10n.chartContentHeadlinesBreakingNewsDistribution;
      case ChartCardId.contentTopicsHeadlinesPublishedOverTime:
        return l10n.chartContentTopicsHeadlinesPublishedOverTime;
      case ChartCardId.contentTopicsEngagementByTopic:
        return l10n.chartContentTopicsEngagementByTopic;
      case ChartCardId.engagementsReactionsOverTime:
        return l10n.chartEngagementsReactionsOverTime;
      case ChartCardId.engagementsCommentsOverTime:
        return l10n.chartEngagementsCommentsOverTime;
      case ChartCardId.engagementsReactionsByType:
        return l10n.chartEngagementsReactionsByType;
      case ChartCardId.engagementsReportsSubmittedOverTime:
        return l10n.chartEngagementsReportsSubmittedOverTime;
      case ChartCardId.engagementsReportsResolutionTimeOverTime:
        return l10n.chartEngagementsReportsResolutionTimeOverTime;
      case ChartCardId.engagementsReportsByReason:
        return l10n.chartEngagementsReportsByReason;
      case ChartCardId.engagementsAppReviewsFeedbackOverTime:
        return l10n.chartEngagementsAppReviewsFeedbackOverTime;
      case ChartCardId.engagementsAppReviewsPositiveVsNegative:
        return l10n.chartEngagementsAppReviewsPositiveVsNegative;
      case ChartCardId.engagementsAppReviewsStoreRequestsOverTime:
        return l10n.chartEngagementsAppReviewsStoreRequestsOverTime;
      case ChartCardId.rewardsAdsWatchedOverTime:
        return l10n.chartRewardsAdsWatchedOverTime;
      case ChartCardId.rewardsGrantedOverTime:
        return l10n.chartRewardsGrantedOverTime;
      case ChartCardId.rewardsActiveByType:
        return l10n.chartRewardsActiveByType;
      case ChartCardId.mediaUploadsOverTime:
        return l10n.chartMediaUploadsOverTime;
      case ChartCardId.mediaUploadsByPurpose:
        return l10n.chartMediaUploadsByPurpose;
      case ChartCardId.mediaUploadsSuccessVsFailure:
        return l10n.chartMediaUploadsSuccessVsFailure;
    }
  }

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  ChartTimeFrame _selectedTimeFrame = ChartTimeFrame.week;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final currentPoints = widget.data.timeFrames[_selectedTimeFrame];

    return AnalyticsCardShell<ChartTimeFrame>(
      title: widget._getLocalizedTitle(widget.data.cardId, l10n),
      currentSlot: widget.slotIndex,
      totalSlots: widget.totalSlots,
      onSlotChanged: widget.onSlotChanged,
      timeFrames: ChartTimeFrame.values,
      selectedTimeFrame: _selectedTimeFrame,
      onTimeFrameChanged: (value) => setState(() => _selectedTimeFrame = value),
      timeFrameToString: (frame) => _timeFrameToLabel(frame, l10n),
      child: (currentPoints == null || currentPoints.isEmpty)
          ? Center(child: Text(l10n.noDataAvailable))
          : Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.sm,
                bottom: AppSpacing.xs,
                left: AppSpacing.sm,
                right: AppSpacing.sm,
              ),
              child: widget.data.type == ChartType.line
                  ? _LineChart(
                      points: currentPoints,
                      timeFrame: _selectedTimeFrame,
                    )
                  : _BarChart(
                      points: currentPoints,
                      timeFrame: _selectedTimeFrame,
                    ),
            ),
    );
  }

  String _timeFrameToLabel(ChartTimeFrame frame, AppLocalizations l10n) {
    switch (frame) {
      case ChartTimeFrame.week:
        return l10n.timeFrameWeek;
      case ChartTimeFrame.month:
        return l10n.timeFrameMonth;
      case ChartTimeFrame.year:
        return l10n.timeFrameYear;
    }
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.points, required this.timeFrame});

  final List<DataPoint> points;
  final ChartTimeFrame timeFrame;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final spots = points.asMap().entries.map((entry) {
      final x = isRtl
          ? (points.length - 1 - entry.key).toDouble()
          : entry.key.toDouble();
      return FlSpot(x, entry.value.value.toDouble());
    }).toList();

    final maxY = points.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => _BottomTitle(
                value: value,
                meta: meta,
                points: points,
                timeFrame: timeFrame,
                isRtl: isRtl,
              ),
              reservedSize: 20,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: primaryColor,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: primaryColor.withOpacity(0.1),
            ),
          ),
        ],
        minY: 0,
        maxY: maxY.toDouble() * 1.1, // Add some headroom
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.points, required this.timeFrame});

  final List<DataPoint> points;
  final ChartTimeFrame timeFrame;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final barGroups =
        points.asMap().entries.map((entry) {
            final x = isRtl ? points.length - 1 - entry.key : entry.key;
            return BarChartGroupData(
              x: x,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value.toDouble(),
                  color: primaryColor,
                  width: 12,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList()
          // Ensure groups are sorted by X to render correctly in RTL
          ..sort((a, b) => a.x.compareTo(b.x));

    final maxY = points.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => _BottomTitle(
                value: value,
                meta: meta,
                points: points,
                timeFrame: timeFrame,
                isRtl: isRtl,
              ),
              reservedSize: 20,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
        minY: 0,
        maxY: maxY.toDouble() * 1.1,
      ),
    );
  }
}

class _BottomTitle extends StatelessWidget {
  const _BottomTitle({
    required this.value,
    required this.points,
    required this.timeFrame,
    required this.meta,
    required this.isRtl,
  });

  final double value;
  final List<DataPoint> points;
  final ChartTimeFrame timeFrame;
  final TitleMeta meta;
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    final index = isRtl ? (points.length - 1) - value.toInt() : value.toInt();

    if (index < 0 || index >= points.length) return const SizedBox.shrink();

    final point = points[index];
    final theme = Theme.of(context);
    String text;

    if (point.label != null) {
      text = point.label!;
      // Truncate long labels
      if (text.length > 3) text = text.substring(0, 3);
    } else if (point.timestamp != null) {
      switch (timeFrame) {
        case ChartTimeFrame.week:
          text = DateFormat.E().format(point.timestamp!).substring(0, 1); // M
        case ChartTimeFrame.month:
          // Show every 5th day to avoid crowding
          if (index % 5 != 0) return const SizedBox.shrink();
          text = DateFormat.d().format(point.timestamp!);
        case ChartTimeFrame.year:
          text = DateFormat.MMM().format(point.timestamp!).substring(0, 1); // J
      }
    } else {
      text = '';
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
      ),
    );
  }
}
