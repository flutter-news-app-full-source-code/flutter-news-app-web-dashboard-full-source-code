import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_shell.dart';

/// {@template chart_card}
/// A widget that displays a chart (Bar or Line) with time frame toggles.
///
/// Note: Since no external chart library is available, this uses a custom
/// visual representation using standard Flutter widgets.
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Find max value to normalize heights
          final maxValue = currentPoints
              .map((e) => e.value)
              .reduce((a, b) => a > b ? a : b)
              .toDouble();

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: currentPoints.map((point) {
              final heightFactor =
                  maxValue > 0 ? (point.value / maxValue) : 0.0;
              // Ensure a minimum height so the bar is visible
              final barHeight = (constraints.maxHeight - 20) * heightFactor;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Tooltip behavior could be added here
                      Tooltip(
                        message: '${point.label}: ${point.value}',
                        child: Container(
                          height: barHeight < 4 ? 4 : barHeight,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        point.label ?? '',
                        style: Theme.of(context).textTheme.labelSmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
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
