import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_shell.dart';

/// {@template ranked_list_card}
/// A widget that displays a ranked list of items (e.g., Top 5 Headlines)
/// with time frame toggles.
/// {@endtemplate}
class RankedListCard extends StatefulWidget {
  /// {@macro ranked_list_card}
  const RankedListCard({
    required this.data,
    super.key,
  });

  /// The data object containing ranked lists for all time frames.
  final RankedListCardData data;

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

    if (currentList == null || currentList.isEmpty) {
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
      child: ListView.separated(
        itemCount: currentList.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = currentList[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              radius: 12,
              child: Text(
                '${index + 1}',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
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
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
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

  final RankedListTimeFrame selected;
  final ValueChanged<RankedListTimeFrame> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<RankedListTimeFrame>(
      segments: [
        ButtonSegment(
          value: RankedListTimeFrame.day,
          label: Text(l10n.timeFrameDay),
        ),
        ButtonSegment(
          value: RankedListTimeFrame.week,
          label: Text(l10n.timeFrameWeek),
        ),
        ButtonSegment(
          value: RankedListTimeFrame.month,
          label: Text(l10n.timeFrameMonth),
        ),
        ButtonSegment(
          value: RankedListTimeFrame.year,
          label: Text(l10n.timeFrameYear),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (Set<RankedListTimeFrame> newSelection) {
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
