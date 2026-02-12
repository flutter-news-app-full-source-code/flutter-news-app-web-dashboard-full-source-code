import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/bloc/overview_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_slot.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template overview_page}
/// The main dashboard overview page, displaying key statistics and quick actions.
///
/// This page uses a responsive grid layout to display high-level KPIs, trends,
/// and ranked lists, adapting to different screen sizes.
///
/// It acts as the central data orchestrator, fetching all required analytics
/// data upfront to ensure a unified loading state.
/// {@endtemplate}
class OverviewPage extends StatelessWidget {
  /// {@macro overview_page}
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return BlocProvider(
      create: (context) => OverviewBloc(
        analyticsService: context.read<AnalyticsService>(),
      )..add(const OverviewSubscriptionRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.overview),
        ),
        body: const OverviewView(),
      ),
    );
  }
}

class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return BlocBuilder<OverviewBloc, OverviewState>(
      builder: (context, state) {
        switch (state.status) {
          case OverviewStatus.initial:
          case OverviewStatus.loading:
            return LoadingStateWidget(
              icon: Icons.analytics_outlined,
              headline: l10n.loadingAnalytics,
              subheadline: l10n.pleaseWait,
            );

          case OverviewStatus.failure:
            return FailureStateWidget(
              exception: UnknownException(state.error.toString()),
              onRetry: () => context.read<OverviewBloc>().add(
                const OverviewSubscriptionRequested(),
              ),
            );

          case OverviewStatus.success:
            // Check if all data is empty to show a generic empty state
            final isAllEmpty =
                [
                  ...state.kpiData,
                  ...state.chartData,
                  ...state.rankedListData,
                ].every((cardData) {
                  if (cardData == null) return true;
                  if (cardData is KpiCardData) {
                    return cardData.timeFrames.isEmpty;
                  }
                  if (cardData is ChartCardData) {
                    return cardData.timeFrames.isEmpty;
                  }
                  if (cardData is RankedListCardData) {
                    return cardData.timeFrames.isEmpty;
                  }
                  return true;
                });

            if (isAllEmpty) {
              return InitialStateWidget(
                icon: Icons.analytics_outlined,
                headline: l10n.noAnalyticsDataHeadline,
                subheadline: l10n.noAnalyticsDataSubheadline,
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final isWide = width >= AppConstants.kDesktopBreakpoint;

                  const kpiHeight = 160.0;
                  const chartHeight = 350.0;

                  const kpiCards = OverviewBloc.kpiCards;
                  const chartCards = OverviewBloc.chartCards;
                  const rankedListCards = OverviewBloc.rankedListCards;

                  if (isWide) {
                    // Wide Layout (Desktop/Tablet):
                    // - Row of 3 KPIs
                    // - 2 Full-width Charts
                    // - Row of 2 Ranked Lists
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: kpiHeight,
                          child: Row(
                            children: [
                              Expanded(
                                child: AnalyticsCardSlot<KpiCardId>(
                                  cardIds: [kpiCards[0]],
                                  data: [state.kpiData[0]],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AnalyticsCardSlot<KpiCardId>(
                                  cardIds: [kpiCards[1]],
                                  data: [state.kpiData[1]],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AnalyticsCardSlot<KpiCardId>(
                                  cardIds: [kpiCards[2]],
                                  data: [state.kpiData[2]],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: chartHeight,
                                child: AnalyticsCardSlot<ChartCardId>(
                                  cardIds: [chartCards[0]],
                                  data: [state.chartData[0]],
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: SizedBox(
                                height: chartHeight,
                                child: AnalyticsCardSlot<ChartCardId>(
                                  cardIds: [chartCards[1]],
                                  data: [state.chartData[1]],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: chartHeight,
                                child: AnalyticsCardSlot<ChartCardId>(
                                  cardIds: [chartCards[2]],
                                  data: [state.chartData[2]],
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: SizedBox(
                                height: chartHeight,
                                child: AnalyticsCardSlot<ChartCardId>(
                                  cardIds: [chartCards[3]],
                                  data: [state.chartData[3]],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          height: chartHeight,
                          child: Row(
                            children: [
                              Expanded(
                                child: AnalyticsCardSlot<RankedListCardId>(
                                  cardIds: [rankedListCards[0]],
                                  data: [state.rankedListData[0]],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AnalyticsCardSlot<RankedListCardId>(
                                  cardIds: [rankedListCards[1]],
                                  data: [state.rankedListData[1]],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Narrow Layout (Mobile):
                    // - Single column for everything
                    return Column(
                      children: [
                        SizedBox(
                          height: kpiHeight,
                          child: AnalyticsCardSlot<KpiCardId>(
                            cardIds: [kpiCards[0]],
                            data: [state.kpiData[0]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: kpiHeight,
                          child: AnalyticsCardSlot<KpiCardId>(
                            cardIds: [kpiCards[1]],
                            data: [state.kpiData[1]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: kpiHeight,
                          child: AnalyticsCardSlot<KpiCardId>(
                            cardIds: [kpiCards[2]],
                            data: [state.kpiData[2]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<ChartCardId>(
                            cardIds: [chartCards[0]],
                            data: [state.chartData[0]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<ChartCardId>(
                            cardIds: [chartCards[1]],
                            data: [state.chartData[1]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<ChartCardId>(
                            cardIds: [chartCards[2]],
                            data: [state.chartData[2]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<ChartCardId>(
                            cardIds: [chartCards[3]],
                            data: [state.chartData[3]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<RankedListCardId>(
                            cardIds: [rankedListCards[0]],
                            data: [state.rankedListData[0]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<RankedListCardId>(
                            cardIds: [rankedListCards[1]],
                            data: [state.rankedListData[1]],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            );
        }
      },
    );
  }
}
