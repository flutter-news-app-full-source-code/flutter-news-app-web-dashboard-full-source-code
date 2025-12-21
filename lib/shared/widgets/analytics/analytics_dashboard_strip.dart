import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_slot.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template analytics_dashboard_strip}
/// A reusable widget that displays the standard "Dashboard Strip" configuration
/// for management pages.
///
/// It consists of two side-by-side [AnalyticsCardSlot]s:
/// - **Left Slot:** Displays a list of KPI cards.
/// - **Right Slot:** Displays a list of Chart cards.
///
/// This ensures a consistent layout and behavior across Users, Content, and
/// Community management pages.
/// {@endtemplate}
class AnalyticsDashboardStrip extends StatelessWidget {
  /// {@macro analytics_dashboard_strip}
  const AnalyticsDashboardStrip({
    required this.kpiCards,
    required this.chartCards,
    super.key,
  });

  /// The list of KPI card IDs to display in the left slot.
  final List<KpiCardId> kpiCards;

  /// The list of Chart card IDs to display in the right slot.
  final List<ChartCardId> chartCards;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        bottom: AppSpacing.md,
      ),
      child: SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(
              child: AnalyticsCardSlot<KpiCardId>(
                cardIds: kpiCards,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AnalyticsCardSlot<ChartCardId>(
                cardIds: chartCards,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
