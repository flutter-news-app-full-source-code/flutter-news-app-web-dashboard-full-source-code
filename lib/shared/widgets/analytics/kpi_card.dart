import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_shell.dart';
import 'package:core_ui/core_ui.dart';

/// {@template kpi_card}
/// A widget that displays a Key Performance Indicator (KPI) with a value,
/// trend, and time frame toggles.
/// {@endtemplate}
class KpiCard extends StatefulWidget {
  /// {@macro kpi_card}
  const KpiCard({
    required this.data,
    this.slotIndex,
    this.totalSlots,
    this.onSlotChanged,
    super.key,
  });

  /// The data object containing values for all time frames.
  final KpiCardData data;

  /// The index of this card in the parent slot.
  final int? slotIndex;

  /// The total number of cards in the parent slot.
  final int? totalSlots;

  /// Callback to change the active card in the slot.
  final ValueChanged<int>? onSlotChanged;

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
      title: widget.data.label.values.firstOrNull ?? '',
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
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
            ),
    );
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
            Flexible(
              child: Text(
                trend,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
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
