import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_slot.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template overview_page}
/// The main dashboard overview page, displaying key statistics and quick actions.
///
/// This page uses a responsive grid layout to display high-level KPIs, trends,
/// and ranked lists, adapting to different screen sizes.
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            // Use the configurable breakpoint from AppConstants.
            final isWide = width >= AppConstants.kDesktopBreakpoint;

            // Define card heights
            const kpiHeight = 160.0;
            const chartHeight = 350.0;

            if (isWide) {
              // Wide Layout (Desktop/Tablet): 3 columns for KPIs, 2 columns for Charts/Lists
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kpiHeight,
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
                            cardIds: const [
                              KpiCardId.contentHeadlinesTotalViews,
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AnalyticsCardSlot<KpiCardId>(
                            cardIds: const [
                              KpiCardId.engagementsReportsPending,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: chartHeight,
                    child: AnalyticsCardSlot<ChartCardId>(
                      cardIds: const [
                        ChartCardId.usersRegistrationsOverTime,
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: chartHeight,
                    child: AnalyticsCardSlot<ChartCardId>(
                      cardIds: const [
                        ChartCardId.contentHeadlinesViewsOverTime,
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: chartHeight,
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
              );
            } else {
              // Narrow Layout (Mobile): 1 column for everything
              return Column(
                children: [
                  SizedBox(
                    height: kpiHeight,
                    child: AnalyticsCardSlot<KpiCardId>(
                      cardIds: const [KpiCardId.usersTotalRegistered],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: kpiHeight,
                    child: AnalyticsCardSlot<KpiCardId>(
                      cardIds: const [KpiCardId.contentHeadlinesTotalViews],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: kpiHeight,
                    child: AnalyticsCardSlot<KpiCardId>(
                      cardIds: const [KpiCardId.engagementsReportsPending],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: chartHeight,
                    child: AnalyticsCardSlot<ChartCardId>(
                      cardIds: const [ChartCardId.usersRegistrationsOverTime],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: chartHeight,
                    child: AnalyticsCardSlot<ChartCardId>(
                      cardIds: const [
                        ChartCardId.contentHeadlinesViewsOverTime,
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: chartHeight,
                    child: AnalyticsCardSlot<RankedListCardId>(
                      cardIds: const [
                        RankedListCardId.overviewHeadlinesMostViewed,
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: chartHeight,
                    child: AnalyticsCardSlot<RankedListCardId>(
                      cardIds: const [
                        RankedListCardId.overviewSourcesMostFollowed,
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
