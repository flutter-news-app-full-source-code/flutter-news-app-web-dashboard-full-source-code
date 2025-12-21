import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_slot.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template overview_page}
/// The main dashboard overview page, displaying key statistics and quick actions.
///
/// This page uses a fixed grid layout to display high-level KPIs, trends, and
/// ranked lists, providing a "Mission Control" view of the application.
/// {@endtemplate}
class OverviewPage extends StatelessWidget {
  /// {@macro overview_page}
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.overview),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: High-Level KPIs
            SizedBox(
              height: 160,
              child: Row(
                children: [
                  Expanded(
                    child: AnalyticsCardSlot<KpiCardId>(
                      cardIds: const [KpiCardId.usersTotalRegistered],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AnalyticsCardSlot<KpiCardId>(
                      cardIds: const [KpiCardId.contentHeadlinesTotalViews],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AnalyticsCardSlot<KpiCardId>(
                      cardIds: const [KpiCardId.engagementsReportsPending],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Row 2: Primary Trends (Charts)
            SizedBox(
              height: 350,
              child: Row(
                children: [
                  Expanded(
                    child: AnalyticsCardSlot<ChartCardId>(
                      cardIds: const [ChartCardId.usersRegistrationsOverTime],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AnalyticsCardSlot<ChartCardId>(
                      cardIds: const [
                        ChartCardId.contentHeadlinesViewsOverTime,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Row 3: Top Performers (Ranked Lists)
            SizedBox(
              height: 350,
              child: Row(
                children: [
                  Expanded(
                    child: AnalyticsCardSlot<RankedListCardId>(
                      cardIds: const [
                        RankedListCardId.overviewHeadlinesMostViewed,
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AnalyticsCardSlot<RankedListCardId>(
                      cardIds: const [
                        RankedListCardId.overviewSourcesMostFollowed,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
