import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/bloc/monetization/monetization_analytics_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_slot.dart';
import 'package:ui_kit/ui_kit.dart';

class MonetizationTabView extends StatefulWidget {
  const MonetizationTabView({super.key});

  @override
  State<MonetizationTabView> createState() => _MonetizationTabViewState();
}

class _MonetizationTabViewState extends State<MonetizationTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<MonetizationAnalyticsBloc>().add(
      const MonetizationAnalyticsSubscriptionRequested(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizationsX(context).l10n;

    return BlocBuilder<MonetizationAnalyticsBloc, MonetizationAnalyticsState>(
      builder: (context, state) {
        switch (state.status) {
          case MonetizationAnalyticsStatus.initial:
          case MonetizationAnalyticsStatus.loading:
            return LoadingStateWidget(
              icon: Icons.analytics_outlined,
              headline: l10n.loadingAnalytics,
              subheadline: l10n.pleaseWait,
            );

          case MonetizationAnalyticsStatus.failure:
            return FailureStateWidget(
              exception: UnknownException(state.error.toString()),
              onRetry: () => context.read<MonetizationAnalyticsBloc>().add(
                const MonetizationAnalyticsSubscriptionRequested(),
              ),
            );

          case MonetizationAnalyticsStatus.success:
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
                    cardIds: MonetizationAnalyticsBloc.kpiCards,
                    data: state.kpiData,
                  );

                  final chartSlot = AnalyticsCardSlot<ChartCardId>(
                    cardIds: MonetizationAnalyticsBloc.chartCards,
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
