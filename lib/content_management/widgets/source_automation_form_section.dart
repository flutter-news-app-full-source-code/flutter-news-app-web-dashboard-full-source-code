import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verity_dashboard/l10n/app_localizations.dart';
import 'package:verity_dashboard/l10n/l10n.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.ingestAutomation, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // Status Switch
                SwitchListTile(
                  title: Text(l10n.automation),
                  subtitle: Text(
                    isEnabled
                        ? l10n.ingestionStatusActive
                        : l10n.ingestionStatusPaused,
                  ),
                  value: isEnabled,
                  onChanged: onEnabledChanged,
                  secondary: Icon(
                    isEnabled ? Icons.autorenew : Icons.pause_circle_outline,
                    color: isEnabled ? theme.colorScheme.primary : null,
                  ),
                ),
                const Divider(),

                // Fetch Interval Dropdown
                ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: Text(l10n.fetchInterval),
                  trailing: DropdownButton<FetchInterval>(
                    value: fetchInterval,
                    underline: const SizedBox.shrink(),
                    onChanged: isEnabled
                        ? (value) {
                            if (value != null) onIntervalChanged(value);
                          }
                        : null,
                    items: FetchInterval.values.map((interval) {
                      return DropdownMenuItem(
                        value: interval,
                        child: Text(interval.name),
                      );
                    }).toList(),
                  ),
                ),

                // Read-only Info (Edit Mode)
                if (lastRun != null || nextRun != null || errorMessage != null)
                  ..._buildStatusInfo(context, l10n, theme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildStatusInfo(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return [
      const Divider(),
      if (lastRun != null)
        ListTile(
          dense: true,
          leading: const Icon(Icons.history, size: 20),
          title: Text(l10n.lastRun),
          trailing: Text(DateFormat('MMM dd, HH:mm').format(lastRun!)),
        ),
      if (nextRun != null)
        ListTile(
          dense: true,
          leading: const Icon(Icons.update, size: 20),
          title: Text(l10n.nextRun),
          trailing: Text(DateFormat('MMM dd, HH:mm').format(nextRun!)),
        ),
      if (status == IngestionStatus.error && errorMessage != null)
        ListTile(
          dense: true,
          leading: Icon(Icons.error_outline, color: theme.colorScheme.error),
          title: Text(
            l10n.ingestionStatusError,
            style: TextStyle(color: theme.colorScheme.error),
          ),
          subtitle: Text(
            errorMessage!,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
    ];
  }
}
