import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/bloc/app_configuration_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/bloc/overview_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/view/audience_tab_view.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/view/community_tab_view.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/view/content_tab_view.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/view/monetization_tab_view.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/about_icon.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/kpi_card.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/ranked_list_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
    _tabController = TabController(length: 5, vsync: this);
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
      create: (context) =>
          OverviewBloc(analyticsService: context.read<AnalyticsService>()),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.overview),
              const SizedBox(width: AppSpacing.xs),
              AboutIcon(
                dialogTitle: l10n.aboutOverviewPageTitle,
                dialogDescription: l10n.aboutOverviewPageDescription,
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(text: l10n.summary),
              Tab(text: l10n.audience),
              Tab(text: l10n.content),
              Tab(text: l10n.community),
              Tab(text: l10n.monetization),
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
          ],
        ),
      ),
    );
  }
}

class _OverviewTabView extends StatefulWidget {
  const _OverviewTabView();

  @override
  State<_OverviewTabView> createState() => _OverviewTabViewState();
}

class _OverviewTabViewState extends State<_OverviewTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<OverviewBloc>().add(
      const AnalyticsDataRequested(tab: OverviewTab.overview),
    );
    context.read<AppConfigurationBloc>().add(
      const AppConfigurationLoaded(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AppStatusView(),
          SizedBox(height: AppSpacing.lg),
          _AnalyticsView(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _AppStatusView extends StatelessWidget {
  const _AppStatusView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);

    return BlocBuilder<AppConfigurationBloc, AppConfigurationState>(
      builder: (context, appConfigState) {
        final config = appConfigState.remoteConfig;
        if (config == null) {
          return const SizedBox.shrink();
        }

        final isMaintenance = config.app.maintenance.isUnderMaintenance;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.appOperationalStatusLabel,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(width: AppSpacing.md),
                _BlinkingDot(isLive: !isMaintenance),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  isMaintenance
                      ? l10n.appStatusMaintenance
                      : l10n.appStatusOperational,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isMaintenance
                        ? theme.colorScheme.error
                        : Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      '${l10n.monetization}: ${config.features.ads.enabled ? l10n.contentStatusActive : l10n.contentStatusDraft} (${config.features.ads.primaryAdPlatform.name})',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Chip(
                    label: Text(
                      '${l10n.notificationsTab}: ${config.features.pushNotifications.enabled ? l10n.contentStatusActive : l10n.contentStatusDraft} (${config.features.pushNotifications.primaryProvider.name})',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Chip(
                    label: Text(
                      '${l10n.analyticsTab}: ${config.features.analytics.enabled ? l10n.contentStatusActive : l10n.contentStatusDraft} (${config.features.analytics.activeProvider.name})',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BlinkingDot extends StatefulWidget {
  const _BlinkingDot({required this.isLive});
  final bool isLive;

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isLive
        ? Colors.green.shade600
        : Theme.of(context).colorScheme.error;
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsView extends StatelessWidget {
  const _AnalyticsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return BlocSelector<OverviewBloc, OverviewState, TabAnalyticsState?>(
      selector: (state) => state.tabStates[OverviewTab.overview],
      builder: (context, tabState) {
        if (tabState == null || tabState.status == TabAnalyticsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tabState.status == TabAnalyticsStatus.failure) {
          return Center(child: Text(l10n.overviewLoadFailure));
        }

        final kpis = tabState.kpiData;
        final rankedLists = tabState.rankedListData;

        if (kpis.every((d) => d == null) &&
            rankedLists.every((d) => d == null)) {
          return InitialStateWidget(
            icon: Icons.analytics_outlined,
            headline: l10n.noAnalyticsDataHeadline,
            subheadline: l10n.noAnalyticsDataSubheadline,
          );
        }

        return StaggeredGrid.count(
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
            ...rankedLists.whereType<RankedListCardData>().map(
              (d) => StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: RankedListCard(data: d),
              ),
            ),
          ],
        );
      },
    );
  }
}
