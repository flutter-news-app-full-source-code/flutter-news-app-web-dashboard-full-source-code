import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
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
///
/// This widget fetches all required data upfront. It shows a loading indicator
/// while fetching and hides itself entirely if the data fetch fails or if all
/// cards report empty data.
/// {@endtemplate}
class AnalyticsDashboardStrip extends StatefulWidget {
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
  State<AnalyticsDashboardStrip> createState() =>
      _AnalyticsDashboardStripState();
}

class _AnalyticsDashboardStripState extends State<AnalyticsDashboardStrip> {
  late final Future<List<dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final analyticsService = context.read<AnalyticsService>();
    final kpiFutures = widget.kpiCards.map((id) => analyticsService.getKpi(id));
    final chartFutures = widget.chartCards.map(
      (id) => analyticsService.getChart(id),
    );

    // Combine all futures into a single future that will complete when all
    // individual futures complete.
    _dataFuture = Future.wait([...kpiFutures, ...chartFutures]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        bottom: AppSpacing.md,
      ),
      child: FutureBuilder<List<dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          // While loading, show a placeholder with a fixed height to prevent
          // layout shifts.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // On error, hide the widget entirely.
          if (snapshot.hasError) {
            // TODO(papa): Log error to a monitoring service.
            return const SizedBox.shrink();
          }

          // On success, process the data.
          if (snapshot.hasData) {
            final allData = snapshot.data!;

            // Check if all returned cards have empty data.
            final isAllEmpty = allData.every((cardData) {
              if (cardData is KpiCardData) return cardData.timeFrames.isEmpty;
              if (cardData is ChartCardData) return cardData.timeFrames.isEmpty;
              return true; // Default to empty for unknown types.
            });

            // If all cards are empty, hide the widget.
            if (isAllEmpty) {
              return const SizedBox.shrink();
            }

            // Split the data back into KPI and Chart data lists.
            final kpiData = allData
                .sublist(0, widget.kpiCards.length)
                .cast<KpiCardData>();
            final chartData = allData
                .sublist(widget.kpiCards.length)
                .cast<ChartCardData>();

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide =
                    constraints.maxWidth >= AppConstants.kDesktopBreakpoint;

                final kpiSlot = AnalyticsCardSlot<KpiCardId>(
                  cardIds: widget.kpiCards,
                  data: kpiData,
                );

                final chartSlot = AnalyticsCardSlot<ChartCardId>(
                  cardIds: widget.chartCards,
                  data: chartData,
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
                        Expanded(child: chartSlot),
                      ],
                    ),
                  );
                } else {
                  // Mobile: Show KPI slot.
                  return SizedBox(
                    height: 150,
                    child: kpiSlot,
                  );
                }
              },
            );
          }

          // Fallback for any other state (e.g., none, done without data).
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
