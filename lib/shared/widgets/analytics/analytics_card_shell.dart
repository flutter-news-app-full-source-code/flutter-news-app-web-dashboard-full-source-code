import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// Defines the position of the time frame selector in the card.
enum TimeFramePosition {
  /// Vertical list on the right edge.
  right,

  /// Horizontal list at the bottom.
  bottom,
}

/// {@template analytics_card_shell}
/// A consistent container for all analytics cards (KPI, Chart, Ranked List).
///
/// Implements the "Balanced Vertical Edges" design pattern:
/// - **Left Edge:** Vertical slot navigation (dots) to switch between cards.
/// - **Center:** The main content (Header + Body).
/// - **Right/Bottom Edge:** Time frame selector (textual), positioned based on
///   [timeFramePosition].
///
/// This layout ensures controls are always accessible (even in "No Data" states)
/// and maximizes vertical space for the content.
/// {@endtemplate}
class AnalyticsCardShell<T> extends StatelessWidget {
  /// {@macro analytics_card_shell}
  const AnalyticsCardShell({
    required this.title,
    required this.child,
    required this.timeFrames,
    required this.selectedTimeFrame,
    required this.onTimeFrameChanged,
    required this.timeFrameToString,
    this.currentSlot,
    this.totalSlots,
    this.onSlotChanged,
    this.timeFramePosition = TimeFramePosition.right,
    super.key,
  });

  /// The title of the card.
  final String title;

  /// The main content of the card.
  final Widget child;

  /// The index of the currently active card in the slot.
  final int? currentSlot;

  /// The total number of cards in this slot.
  final int? totalSlots;

  /// Callback when a slot dot is clicked.
  final ValueChanged<int>? onSlotChanged;

  /// The list of available time frames (e.g., Day, Week, Month).
  final List<T> timeFrames;

  /// The currently selected time frame.
  final T selectedTimeFrame;

  /// Callback when a time frame is selected.
  final ValueChanged<T> onTimeFrameChanged;

  /// Function to convert the time frame enum to a display string (e.g., "7D").
  final String Function(T) timeFrameToString;

  /// Determines where the time frame selector is placed.
  final TimeFramePosition timeFramePosition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Left Edge: Slot Navigation ---
                  if (totalSlots != null &&
                      totalSlots! > 1 &&
                      currentSlot != null &&
                      onSlotChanged != null)
                    _VerticalSlotIndicator(
                      currentSlot: currentSlot!,
                      totalSlots: totalSlots!,
                      onSlotChanged: onSlotChanged!,
                    ),
                  if (totalSlots != null && totalSlots! > 1)
                    const SizedBox(width: AppSpacing.sm),

                  // --- Center: Content ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Body
                        Expanded(child: child),
                      ],
                    ),
                  ),

                  // --- Right Edge: Time Frame Selector (Conditional) ---
                  if (timeFramePosition == TimeFramePosition.right) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Center(
                      child: _VerticalTimeFrameSelector<T>(
                        timeFrames: timeFrames,
                        selectedTimeFrame: selectedTimeFrame,
                        onChanged: onTimeFrameChanged,
                        labelBuilder: timeFrameToString,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // --- Bottom Edge: Time Frame Selector (Conditional) ---
            if (timeFramePosition == TimeFramePosition.bottom) ...[
              const SizedBox(height: AppSpacing.sm),
              _HorizontalTimeFrameSelector<T>(
                timeFrames: timeFrames,
                selectedTimeFrame: selectedTimeFrame,
                onChanged: onTimeFrameChanged,
                labelBuilder: timeFrameToString,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VerticalSlotIndicator extends StatelessWidget {
  const _VerticalSlotIndicator({
    required this.currentSlot,
    required this.totalSlots,
    required this.onSlotChanged,
  });

  final int currentSlot;
  final int totalSlots;
  final ValueChanged<int> onSlotChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSlots, (index) {
        final isSelected = index == currentSlot;
        return GestureDetector(
          onTap: () => onSlotChanged(index),
          behavior: HitTestBehavior.opaque,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        );
      }),
    );
  }
}

class _VerticalTimeFrameSelector<T> extends StatelessWidget {
  const _VerticalTimeFrameSelector({
    required this.timeFrames,
    required this.selectedTimeFrame,
    required this.onChanged,
    required this.labelBuilder,
  });

  final List<T> timeFrames;
  final T selectedTimeFrame;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: timeFrames.map((frame) {
        final isSelected = frame == selectedTimeFrame;
        return InkWell(
          onTap: () => onChanged(frame),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 4,
            ),
            child: Text(
              labelBuilder(frame),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HorizontalTimeFrameSelector<T> extends StatelessWidget {
  const _HorizontalTimeFrameSelector({
    required this.timeFrames,
    required this.selectedTimeFrame,
    required this.onChanged,
    required this.labelBuilder,
  });

  final List<T> timeFrames;
  final T selectedTimeFrame;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: timeFrames.map((frame) {
        final isSelected = frame == selectedTimeFrame;
        return InkWell(
          onTap: () => onChanged(frame),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Text(
              labelBuilder(frame),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
