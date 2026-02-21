import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/bloc/overview_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/view/audience_tab_view.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/view/community_tab_view.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/view/configuration_tab_view.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/view/content_tab_view.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/view/monetization_tab_view.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_slot.dart';
import 'package:ui_kit/ui_kit.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return BlocProvider(
      create: (context) => OverviewBloc(
        analyticsService: context.read<AnalyticsService>(),
      )..add(const OverviewSubscriptionRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.dashboard),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(text: l10n.overview),
              Tab(text: l10n.audience),
              Tab(text: l10n.content),
              Tab(text: l10n.community),
              Tab(text: l10n.monetization),
              Tab(text: l10n.configuration),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            _OverviewTabView(),
            AudienceTabView(),
            ContentTabView(),
            CommunityTabView(),
            MonetizationTabView(),
            ConfigurationTabView(),
          ],
        ),
      ),
    );
  }
}

class _OverviewTabView extends StatelessWidget {
  const _OverviewTabView();

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
            final isAllEmpty = state.rankedListData.every((cardData) {
              if (cardData == null) return true;
              return cardData.timeFrames.isEmpty;
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
                  final isWide =
                      constraints.maxWidth >= AppConstants.kDesktopBreakpoint;
                  const chartHeight = 350.0;
                  const rankedListCards = OverviewBloc.rankedListCards;

                  if (isWide) {
                    return SizedBox(
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
                    );
                  } else {
                    return Column(
                      children: [
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
