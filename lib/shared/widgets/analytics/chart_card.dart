import 'package:core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_shell.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template chart_card}
/// A widget that displays a chart (Bar or Line) with time frame toggles.
///
/// Uses the `fl_chart` package for rendering.
/// {@endtemplate}
class ChartCard extends StatefulWidget {
  /// {@macro chart_card}
  const ChartCard({
    required this.data,
    super.key,
  });

  /// The data object containing chart points for all time frames.
  final ChartCardData data;

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  ChartTimeFrame _selectedTimeFrame = ChartTimeFrame.week;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final currentPoints = widget.data.timeFrames[_selectedTimeFrame];

    if (currentPoints == null || currentPoints.isEmpty) {
      return AnalyticsCardShell(
        title: widget.data.label,
        child: Center(child: Text(l10n.noDataAvailable)),
      );
    }

    return AnalyticsCardShell(
      title: widget.data.label,
      action: _TimeFrameToggle(
        selected: _selectedTimeFrame,
        onChanged: (value) => setState(() => _selectedTimeFrame = value),
        l10n: l10n,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: AppSpacing.xs,
        ),
        child: widget.data.type == ChartType.line
            ? _LineChart(points: currentPoints, timeFrame: _selectedTimeFrame)
            : _BarChart(points: currentPoints, timeFrame: _selectedTimeFrame),
      ),
    );
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

    // Map points to FlSpots
    final spots = points.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
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
              ),
              reservedSize: 24,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0 || value == maxY) return const SizedBox.shrink();
                return Text(
                  NumberFormat.compact().format(value),
                  style: theme.textTheme.labelSmall,
                );
              },
            ),
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
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: primaryColor.withOpacity(0.1),
            ),
          ),
        ],
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

    final barGroups = points.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value.toDouble(),
            color: primaryColor,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

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
              ),
              reservedSize: 24,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0 || value == maxY) return const SizedBox.shrink();
                return Text(
                  NumberFormat.compact().format(value),
                  style: theme.textTheme.labelSmall,
                );
              },
            ),
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
  });

  final double value;
  final List<DataPoint> points;
  final ChartTimeFrame timeFrame;
  final TitleMeta meta;

  @override
  Widget build(BuildContext context) {
    final index = value.toInt();
    if (index < 0 || index >= points.length) return const SizedBox.shrink();

    final point = points[index];
    final theme = Theme.of(context);
    String text;

    if (point.label != null) {
      text = point.label!;
    } else if (point.timestamp != null) {
      switch (timeFrame) {
        case ChartTimeFrame.week:
          text = DateFormat.E().format(point.timestamp!); // Mon, Tue
        case ChartTimeFrame.month:
          text = DateFormat.d().format(point.timestamp!); // 1, 2, 3
        case ChartTimeFrame.year:
          text = DateFormat.MMM().format(point.timestamp!); // Jan, Feb
      }
    } else {
      text = '';
    }

    // Simple logic to skip labels if too crowded (e.g., show every 2nd or 5th)
    if (points.length > 10 && index % 2 != 0) return const SizedBox.shrink();
    if (points.length > 20 && index % 5 != 0) return const SizedBox.shrink();

    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: theme.textTheme.labelSmall),
    );
  }
}

class _TimeFrameToggle extends StatelessWidget {
  const _TimeFrameToggle({
    required this.selected,
    required this.onChanged,
    required this.l10n,
  });

  final ChartTimeFrame selected;
  final ValueChanged<ChartTimeFrame> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ChartTimeFrame>(
      segments: [
        ButtonSegment(
          value: ChartTimeFrame.week,
          label: Text(l10n.timeFrameWeek),
        ),
        ButtonSegment(
          value: ChartTimeFrame.month,
          label: Text(l10n.timeFrameMonth),
        ),
        ButtonSegment(
          value: ChartTimeFrame.year,
          label: Text(l10n.timeFrameYear),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (Set<ChartTimeFrame> newSelection) {
        onChanged(newSelection.first);
      },
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
