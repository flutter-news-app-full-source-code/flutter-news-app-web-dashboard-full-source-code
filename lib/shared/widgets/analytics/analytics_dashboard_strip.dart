import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_slot.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template analytics_dashboard_strip}
/// A reusable widget that displays the standard "Dashboard Strip" configuration
/// for management pages.
///
/// It consists of two slots:
/// - **Left/Top Slot:** Displays a list of KPI cards.
/// - **Right/Bottom Slot:** Displays a list of Chart cards.
///
/// **Responsiveness:**
/// - On wide screens (>= [AppConstants.kDesktopBreakpoint]), it displays as a Row.
///   The KPI slot has a fixed width ([AppConstants.kAnalyticsKpiSidebarWidth]),
///   and the Chart slot takes the remaining space.
/// - On narrow screens, it displays as a Column, with both slots taking full width.
/// {@endtemplate}
class AnalyticsDashboardStrip extends StatelessWidget {
  /// {@macro analytics_dashboard_strip}
  const AnalyticsDashboardStrip({
    required this.kpiCards,
    required this.chartCards,
    super.key,
  });

  /// The list of KPI card IDs to display in the left/top slot.
  final List<KpiCardId> kpiCards;

  /// The list of Chart card IDs to display in the right/bottom slot.
  final List<ChartCardId> chartCards;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        bottom: AppSpacing.md,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide =
              constraints.maxWidth >= AppConstants.kDesktopBreakpoint;

          // Define the slots
          final kpiSlot = AnalyticsCardSlot<KpiCardId>(
            cardIds: kpiCards,
          );

          final chartSlot = AnalyticsCardSlot<ChartCardId>(
            cardIds: chartCards,
          );

          if (isWide) {
            // Desktop/Tablet: Row with fixed KPI width
            return SizedBox(
              height: 200,
              child: Row(
                children: [
                  SizedBox(
                    width: AppConstants.kAnalyticsKpiSidebarWidth,
                    child: kpiSlot,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: chartSlot,
                  ),
                ],
              ),
            );
          } else {
            // Mobile: Only show the chart slot to save vertical space for the table.
            return SizedBox(
              height: 150,
              child: kpiSlot,
            );
          }
        },
      ),
    );
  }
}
