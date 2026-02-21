import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/bloc/community/community_analytics_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_slot.dart';
import 'package:ui_kit/ui_kit.dart';

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
    context.read<CommunityAnalyticsBloc>().add(
      const CommunityAnalyticsSubscriptionRequested(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizationsX(context).l10n;

    return BlocBuilder<CommunityAnalyticsBloc, CommunityAnalyticsState>(
      builder: (context, state) {
        switch (state.status) {
          case CommunityAnalyticsStatus.initial:
          case CommunityAnalyticsStatus.loading:
            return LoadingStateWidget(
              icon: Icons.analytics_outlined,
              headline: l10n.loadingAnalytics,
              subheadline: l10n.pleaseWait,
            );

          case CommunityAnalyticsStatus.failure:
            return FailureStateWidget(
              exception: UnknownException(state.error.toString()),
              onRetry: () => context.read<CommunityAnalyticsBloc>().add(
                const CommunityAnalyticsSubscriptionRequested(),
              ),
            );

          case CommunityAnalyticsStatus.success:
            final isAllEmpty = [
              ...state.kpiData,
              ...state.chartData,
            ].every((d) => d == null);

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

                  final kpiSlot = AnalyticsCardSlot<KpiCardId>(
                    cardIds: CommunityAnalyticsBloc.kpiCards,
                    data: state.kpiData,
                  );

                  final chartSlot = AnalyticsCardSlot<ChartCardId>(
                    cardIds: CommunityAnalyticsBloc.chartCards,
                    data: state.chartData,
                  );

                  if (isWide) {
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
                    return Column(
                      children: [
                        SizedBox(height: 150, child: kpiSlot),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(height: 350, child: chartSlot),
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

  @override
  bool get wantKeepAlive => true;
}
