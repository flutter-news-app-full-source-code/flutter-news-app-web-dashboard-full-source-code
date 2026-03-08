import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:verity_dashboard/l10n/app_localizations.dart';
import 'package:verity_dashboard/l10n/l10n.dart';
import 'package:verity_dashboard/shared/extensions/fetch_interval_extension.dart';

/// {@template source_automation_form_section}
/// A shared form section for configuring [NewsAutomationTask] settings.
///
/// Used in both Create and Edit Source pages to ensure consistent UI for
/// ingestion automation configuration.
/// {@endtemplate}
class SourceAutomationFormSection extends StatelessWidget {
  /// {@macro source_automation_form_section}
  const SourceAutomationFormSection({
    required this.isEnabled,
    required this.fetchInterval,
    required this.onEnabledChanged,
    required this.onIntervalChanged,
    this.lastRun,
    this.nextRun,
    this.status,
    this.errorMessage,
    super.key,
  });

  /// Whether automation is currently enabled (Active) or disabled (Paused).
  final bool isEnabled;

  /// The current fetch interval setting.
  final FetchInterval fetchInterval;

  /// Callback when the enabled switch is toggled.
  final ValueChanged<bool> onEnabledChanged;

  /// Callback when the fetch interval is changed.
  final ValueChanged<FetchInterval> onIntervalChanged;

  /// Optional timestamp of the last run (Edit mode only).
  final DateTime? lastRun;

  /// Optional timestamp of the next scheduled run (Edit mode only).
  final DateTime? nextRun;

  /// The specific status enum (Edit mode only), useful for showing error states.
  final IngestionStatus? status;

  /// Error message from the last run, if any.
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.contentSyncScheduleTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      l10n.contentSyncScheduleDescription,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (status == IngestionStatus.error)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          l10n.ingestionStatusError,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Switch(
                  value: isEnabled,
                  onChanged: onEnabledChanged,
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Frequency Selection
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.syncFrequencyLabel,
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<FetchInterval>(
                    segments: FetchInterval.values.map((interval) {
                      return ButtonSegment<FetchInterval>(
                        value: interval,
                        label: Text(interval.shortName),
                        tooltip: interval.localizedName(l10n),
                      );
                    }).toList(),
                    selected: {fetchInterval},
                    onSelectionChanged: isEnabled
                        ? (Set<FetchInterval> newSelection) {
                            onIntervalChanged(newSelection.first);
                          }
                        : null, // Disable if switch is off
                  ),
                ),
              ],
            ),
          ),

          // Status Footer (Only if active/error or has history)
          if (lastRun != null ||
              nextRun != null ||
              (status == IngestionStatus.error && errorMessage != null)) ...[
            const Divider(height: 1),
            _buildStatusFooter(context, l10n, colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusFooter(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (status == IngestionStatus.error && errorMessage != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            color: colorScheme.errorContainer,
            child: Row(
              children: [
                Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: colorScheme.onErrorContainer),
                  ),
                ),
              ],
            ),
          ),
        if (lastRun != null || nextRun != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                if (lastRun != null) ...[
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n.lastSyncedLabel}: ${timeago.format(lastRun!)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                ],
                if (nextRun != null && isEnabled) ...[
                  Icon(Icons.schedule, size: 16, color: colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n.nextSyncLabel}: ${timeago.format(nextRun!, allowFromNow: true)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
