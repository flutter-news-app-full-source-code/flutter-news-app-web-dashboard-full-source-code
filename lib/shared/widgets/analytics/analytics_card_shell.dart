import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template analytics_card_shell}
/// A consistent container for all analytics cards (KPI, Chart, Ranked List).
///
/// Provides standard styling, padding, and a header with a title and optional
/// action widgets (like time frame toggles).
/// {@endtemplate}
class AnalyticsCardShell extends StatelessWidget {
  /// {@macro analytics_card_shell}
  const AnalyticsCardShell({
    required this.title,
    required this.child,
    this.action,
    super.key,
  });

  /// The title of the card.
  final String title;

  /// An optional action widget to display in the header (e.g., toggles).
  final Widget? action;

  /// The main content of the card.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (action != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  action!,
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
