import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:verity_dashboard/l10n/l10n.dart';
import 'package:verity_dashboard/overview/bloc/overview_bloc.dart';
import 'package:verity_dashboard/shared/constants/app_constants.dart';
import 'package:verity_dashboard/shared/widgets/analytics/chart_card.dart';
import 'package:verity_dashboard/shared/widgets/analytics/kpi_card.dart';

class OperationsTabView extends StatefulWidget {
  const OperationsTabView({super.key});

  @override
  State<OperationsTabView> createState() => _OperationsTabViewState();
}

class _OperationsTabViewState extends State<OperationsTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<OverviewBloc>().add(
      const AnalyticsDataRequested(tab: OverviewTab.operations),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizationsX(context).l10n;

    return BlocSelector<OverviewBloc, OverviewState, TabAnalyticsState?>(
      selector: (state) => state.tabStates[OverviewTab.operations],
      builder: (context, tabState) {
        if (tabState == null || tabState.status == TabAnalyticsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tabState.status == TabAnalyticsStatus.failure) {
          return Center(child: Text(l10n.overviewLoadFailure));
        }

        final kpis = tabState.kpiData;
        final charts = tabState.chartData;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: StaggeredGrid.count(
            crossAxisCount:
                MediaQuery.of(context).size.width <
                    AppConstants.kDesktopBreakpoint
                ? 2
                : 4,
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
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 2,
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
