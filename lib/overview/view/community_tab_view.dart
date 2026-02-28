import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/bloc/overview_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/chart_card.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/kpi_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CommunityTabView extends StatefulWidget {
  const CommunityTabView({super.key});

  @override
  State<CommunityTabView> createState() => _CommunityTabViewState();
}

class _CommunityTabViewState extends State<CommunityTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<OverviewBloc>().add(
      const AnalyticsDataRequested(tab: OverviewTab.community),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizationsX(context).l10n;

    return BlocSelector<OverviewBloc, OverviewState, TabAnalyticsState?>(
      selector: (state) => state.tabStates[OverviewTab.community],
      builder: (context, tabState) {
        if (tabState == null || tabState.status == TabAnalyticsStatus.initial) {
          return const SizedBox.shrink();
        }

        if (tabState.status == TabAnalyticsStatus.loading) {
          return LoadingStateWidget(
            icon: Icons.analytics_outlined,
            headline: l10n.loadingAnalytics,
            subheadline: l10n.pleaseWait,
          );
        }

        if (tabState.status == TabAnalyticsStatus.failure) {
          return FailureStateWidget(
            exception: UnknownException(tabState.error.toString()),
            onRetry: () => context.read<OverviewBloc>().add(
              const AnalyticsDataRequested(
                tab: OverviewTab.community,
                forceRefresh: true,
              ),
            ),
          );
        }

        final kpis = tabState.kpiData;
        final charts = tabState.chartData;

        if (kpis.every((d) => d == null) && charts.every((d) => d == null)) {
          return InitialStateWidget(
            icon: Icons.analytics_outlined,
            headline: l10n.noAnalyticsDataHeadline,
            subheadline: l10n.noAnalyticsDataSubheadline,
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: StaggeredGrid.count(
            crossAxisCount:
                MediaQuery.of(context).size.width <
                    AppConstants.kDesktopBreakpoint
                ? 2
                : 3,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            children: [
              ...kpis.whereType<KpiCardData>().map(
                (d) => StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: KpiCard(data: d),
                ),
              ),
              ...charts.whereType<ChartCardData>().map(
                (d) => StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1.2,
                  child: ChartCard(data: d),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
