import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/utils/future_utils.dart';
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
class OverviewPage extends StatefulWidget {
  /// {@macro overview_page}
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  late Future<List<dynamic>> _dataFuture;

  // Define the cards used on this page to ensure consistent ordering
  // and easy maintenance.
  final List<KpiCardId> _kpiCards = const [
    KpiCardId.usersTotalRegistered,
    KpiCardId.contentHeadlinesTotalViews,
    KpiCardId.rewardsActiveUsersCount,
  ];

  final List<ChartCardId> _chartCards = const [
    ChartCardId.usersRegistrationsOverTime,
    ChartCardId.contentHeadlinesViewsOverTime,
  ];

  final List<RankedListCardId> _rankedListCards = const [
    RankedListCardId.overviewHeadlinesMostViewed,
    RankedListCardId.overviewSourcesMostFollowed,
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      final analyticsService = context.read<AnalyticsService>();
      // Create a list of future providers to be executed in batches.
      // The order here MUST match the order used when unpacking the data.
      final futureProviders = <Future<dynamic> Function()>[
        ..._kpiCards.map(
          (id) =>
              () => analyticsService.getKpi(id),
        ),
        ..._chartCards.map(
          (id) =>
              () => analyticsService.getChart(id),
        ),
        ..._rankedListCards.map(
          (id) =>
              () => analyticsService.getRankedList(id),
        ),
      ];

      // Use the utility to fetch data in controlled batches.
      _dataFuture = FutureUtils.fetchInBatches(futureProviders);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.overview),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingStateWidget(
              icon: Icons.analytics_outlined,
              headline: l10n.loadingAnalytics,
              subheadline: l10n.pleaseWait,
            );
          }

          // 2. Error State
          if (snapshot.hasError) {
            return FailureStateWidget(
              exception: UnknownException(snapshot.error.toString()),
              onRetry: _fetchData,
            );
          }

          // 3. Success State
          if (snapshot.hasData) {
            final allData = snapshot.data!;

            // Check if all data is empty to show a generic empty state
            final isAllEmpty = allData.every((cardData) {
              if (cardData is KpiCardData) return cardData.timeFrames.isEmpty;
              if (cardData is ChartCardData) return cardData.timeFrames.isEmpty;
              if (cardData is RankedListCardData) {
                return cardData.timeFrames.isEmpty;
              }
              return true;
            });

            if (isAllEmpty) {
              return LoadingStateWidget(
                icon: Icons.analytics_outlined,
                headline: l10n.noAnalyticsDataHeadline,
                subheadline: l10n.noAnalyticsDataSubheadline,
              );
            }

            // Unpack the flat list back into specific data lists.
            // We use a running index to slice the list safely.
            var currentIndex = 0;

            final kpiData = allData
                .sublist(currentIndex, currentIndex + _kpiCards.length)
                .cast<KpiCardData>();
            currentIndex += _kpiCards.length;

            final chartData = allData
                .sublist(currentIndex, currentIndex + _chartCards.length)
                .cast<ChartCardData>();
            currentIndex += _chartCards.length;

            final rankedListData = allData
                .sublist(currentIndex, currentIndex + _rankedListCards.length)
                .cast<RankedListCardData>();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final isWide = width >= AppConstants.kDesktopBreakpoint;

                  const kpiHeight = 160.0;
                  const chartHeight = 350.0;

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
                                  cardIds: [_kpiCards[0]],
                                  data: [kpiData[0]],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AnalyticsCardSlot<KpiCardId>(
                                  cardIds: [_kpiCards[1]],
                                  data: [kpiData[1]],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AnalyticsCardSlot<KpiCardId>(
                                  cardIds: [_kpiCards[2]],
                                  data: [kpiData[2]],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<ChartCardId>(
                            cardIds: [_chartCards[0]],
                            data: [chartData[0]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<ChartCardId>(
                            cardIds: [_chartCards[1]],
                            data: [chartData[1]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          height: chartHeight,
                          child: Row(
                            children: [
                              Expanded(
                                child: AnalyticsCardSlot<RankedListCardId>(
                                  cardIds: [_rankedListCards[0]],
                                  data: [rankedListData[0]],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AnalyticsCardSlot<RankedListCardId>(
                                  cardIds: [_rankedListCards[1]],
                                  data: [rankedListData[1]],
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
                            cardIds: [_kpiCards[0]],
                            data: [kpiData[0]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: kpiHeight,
                          child: AnalyticsCardSlot<KpiCardId>(
                            cardIds: [_kpiCards[1]],
                            data: [kpiData[1]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: kpiHeight,
                          child: AnalyticsCardSlot<KpiCardId>(
                            cardIds: [_kpiCards[2]],
                            data: [kpiData[2]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<ChartCardId>(
                            cardIds: [_chartCards[0]],
                            data: [chartData[0]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<ChartCardId>(
                            cardIds: [_chartCards[1]],
                            data: [chartData[1]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<RankedListCardId>(
                            cardIds: [_rankedListCards[0]],
                            data: [rankedListData[0]],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: chartHeight,
                          child: AnalyticsCardSlot<RankedListCardId>(
                            cardIds: [_rankedListCards[1]],
                            data: [rankedListData[1]],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            );
          }

          // Fallback for any other state
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
