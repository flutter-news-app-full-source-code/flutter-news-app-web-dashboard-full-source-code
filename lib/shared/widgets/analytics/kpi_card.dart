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
    super.key,
  });

  /// The data object containing values for all time frames.
  final KpiCardData data;

  @override
  State<KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<KpiCard> {
  // Default to 'week' as a reasonable starting point.
  KpiTimeFrame _selectedTimeFrame = KpiTimeFrame.week;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsX(context).l10n;
    final currentData = widget.data.timeFrames[_selectedTimeFrame];

    // Fallback if data for the selected time frame is missing.
    if (currentData == null) {
      return AnalyticsCardShell(
        title: widget.data.label,
        child: Center(child: Text(l10n.noDataAvailable)),
      );
    }

    final isPositiveTrend = !currentData.trend.startsWith('-');
    final trendColor =
        isPositiveTrend ? theme.colorScheme.primary : theme.colorScheme.error;
    final trendIcon =
        isPositiveTrend ? Icons.arrow_upward : Icons.arrow_downward;

    return AnalyticsCardShell(
      title: widget.data.label,
      action: _TimeFrameToggle(
        selected: _selectedTimeFrame,
        onChanged: (value) => setState(() => _selectedTimeFrame = value),
        l10n: l10n,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            // Format numbers nicely (e.g., 1,234).
            // For simplicity, using toString here, but NumberFormat is better.
            currentData.value.toString(),
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(trendIcon, size: 16, color: trendColor),
              const SizedBox(width: 4),
              Text(
                currentData.trend,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: trendColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                l10n.vsPreviousPeriod,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
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

  final KpiTimeFrame selected;
  final ValueChanged<KpiTimeFrame> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<KpiTimeFrame>(
      segments: [
        ButtonSegment(
          value: KpiTimeFrame.day,
          label: Text(l10n.timeFrameDay),
        ),
        ButtonSegment(
          value: KpiTimeFrame.week,
          label: Text(l10n.timeFrameWeek),
        ),
        ButtonSegment(
          value: KpiTimeFrame.month,
          label: Text(l10n.timeFrameMonth),
        ),
        ButtonSegment(
          value: KpiTimeFrame.year,
          label: Text(l10n.timeFrameYear),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (Set<KpiTimeFrame> newSelection) {
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
