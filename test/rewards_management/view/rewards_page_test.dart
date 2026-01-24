import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_filter/rewards_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/view/rewards_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui_kit/ui_kit.dart';

class MockRewardsManagementBloc
    extends MockBloc<RewardsManagementEvent, RewardsManagementState>
    implements RewardsManagementBloc {}

class MockRewardsFilterBloc
    extends MockBloc<RewardsFilterEvent, RewardsFilterState>
    implements RewardsFilterBloc {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class FakeRewardsFilterState extends Fake implements RewardsFilterState {}

void main() {
  group('RewardsPage', () {
    late RewardsManagementBloc rewardsManagementBloc;
    late RewardsFilterBloc rewardsFilterBloc;
    late AnalyticsService analyticsService;

    setUpAll(() {
      registerFallbackValue(FakeRewardsFilterState());
      registerFallbackValue(KpiCardId.rewardsAdsWatchedTotal);
      registerFallbackValue(KpiCardId.rewardsGrantedTotal);
      registerFallbackValue(ChartCardId.rewardsAdsWatchedOverTime);
      registerFallbackValue(ChartCardId.rewardsGrantedOverTime);
    });

    setUp(() {
      rewardsManagementBloc = MockRewardsManagementBloc();
      rewardsFilterBloc = MockRewardsFilterBloc();
      analyticsService = MockAnalyticsService();

      when(() => rewardsManagementBloc.state).thenReturn(
        const RewardsManagementState(),
      );
      when(() => rewardsFilterBloc.state).thenReturn(
        const RewardsFilterState(),
      );
      when(
        () => rewardsManagementBloc.buildRewardsFilterMap(any()),
      ).thenReturn({});

      when(() => analyticsService.getKpi(any())).thenAnswer(
        (_) async => const KpiCardData(
          id: KpiCardId.rewardsAdsWatchedTotal,
          label: 'Total Ads Watched',
          timeFrames: {},
        ),
      );
      when(
        () => analyticsService.getKpi(KpiCardId.rewardsGrantedTotal),
      ).thenAnswer(
        (_) async => const KpiCardData(
          id: KpiCardId.rewardsGrantedTotal,
          label: 'Total Rewards Granted',
          timeFrames: {},
        ),
      );
      when(() => analyticsService.getChart(any())).thenAnswer(
        (_) async => const ChartCardData(
          id: ChartCardId.rewardsAdsWatchedOverTime,
          label: 'Ads Watched Over Time',
          type: ChartType.line,
          timeFrames: {},
        ),
      );
      when(
        () => analyticsService.getChart(ChartCardId.rewardsGrantedOverTime),
      ).thenAnswer(
        (_) async => const ChartCardData(
          id: ChartCardId.rewardsGrantedOverTime,
          label: 'Rewards Granted Over Time',
          type: ChartType.line,
          timeFrames: {},
        ),
      );
    });

    Widget buildSubject() {
      return MaterialApp(
        localizationsDelegates: const [
          UiKitLocalizations.delegate,
          ...AppLocalizations.localizationsDelegates,
        ],
        supportedLocales: UiKitLocalizations.supportedLocales,
        home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: analyticsService),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: rewardsManagementBloc),
              BlocProvider.value(value: rewardsFilterBloc),
            ],
            child: const Scaffold(body: RewardsPage()),
          ),
        ),
      );
    }

    testWidgets('shows loading indicator when loading for the first time', (
      tester,
    ) async {
      when(() => rewardsManagementBloc.state).thenReturn(
        const RewardsManagementState(status: RewardsManagementStatus.loading),
      );
      await tester.pumpWidget(buildSubject());
      expect(find.byType(LoadingStateWidget), findsOneWidget);
    });

    testWidgets('shows failure widget when loading fails', (tester) async {
      when(() => rewardsManagementBloc.state).thenReturn(
        const RewardsManagementState(
          status: RewardsManagementStatus.failure,
          exception: UnknownException('Test error'),
        ),
      );
      await tester.pumpWidget(buildSubject());
      expect(find.byType(FailureStateWidget), findsOneWidget);
    });

    testWidgets(
      'shows empty message when there are no rewards and no filters',
      (tester) async {
        when(() => rewardsManagementBloc.state).thenReturn(
          const RewardsManagementState(
            status: RewardsManagementStatus.success,
            rewards: [],
          ),
        );
        await tester.pumpWidget(buildSubject());
        final BuildContext context = tester.element(find.byType(Scaffold));
        expect(
          find.text(AppLocalizations.of(context).noRewardsFound),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows empty message with reset button when there are no rewards and filters are active',
      (tester) async {
        when(() => rewardsManagementBloc.state).thenReturn(
          const RewardsManagementState(
            status: RewardsManagementStatus.success,
            rewards: [],
          ),
        );
        when(() => rewardsFilterBloc.state).thenReturn(
          const RewardsFilterState(searchQuery: 'test'),
        );
        await tester.pumpWidget(buildSubject());
        final BuildContext context = tester.element(find.byType(Scaffold));
        expect(
          find.text(AppLocalizations.of(context).noResultsWithCurrentFilters),
          findsOneWidget,
        );
        expect(find.byType(ElevatedButton), findsOneWidget);
      },
    );

    testWidgets('shows table when rewards are loaded', (tester) async {
      when(() => rewardsManagementBloc.state).thenReturn(
        const RewardsManagementState(
          status: RewardsManagementStatus.success,
          rewards: [
            UserRewards(
              id: '1',
              userId: '1',
              activeRewards: {},
            ),
          ],
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester
          .pumpAndSettle(); // Ensure timers from fetchInBatches are cleared
      expect(find.byType(PaginatedDataTable2), findsOneWidget);
    });
  });
}
