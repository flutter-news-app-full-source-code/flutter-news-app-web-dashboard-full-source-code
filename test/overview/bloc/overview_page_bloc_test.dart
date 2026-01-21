import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/bloc/overview_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  group('OverviewPageBloc', () {
    late AnalyticsService analyticsService;

    const kpiData = KpiCardData(
      id: KpiCardId.usersTotalRegistered,
      label: 'Total Registered Users',
      timeFrames: {},
    );

    const chartData = ChartCardData(
      id: ChartCardId.usersRegistrationsOverTime,
      label: 'Registrations Trend',
      type: ChartType.line,
      timeFrames: {},
    );

    const rankedListData = RankedListCardData(
      id: RankedListCardId.overviewHeadlinesMostViewed,
      label: 'Top Headlines',
      timeFrames: {},
    );

    final testException = Exception('test-exception');

    setUpAll(() {
      registerFallbackValue(KpiCardId.usersTotalRegistered);
      registerFallbackValue(ChartCardId.usersRegistrationsOverTime);
      registerFallbackValue(RankedListCardId.overviewHeadlinesMostViewed);
    });

    setUp(() {
      analyticsService = MockAnalyticsService();
    });

    OverviewBloc buildBloc() {
      return OverviewBloc(analyticsService: analyticsService);
    }

    group('constructor', () {
      test('works properly', () => expect(buildBloc, returnsNormally));

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const OverviewState()),
        );
      });
    });

    group('OverviewPageSubscriptionRequested', () {
      blocTest<OverviewBloc, OverviewState>(
        'emits [loading, success] when data fetching succeeds',
        setUp: () {
          when(
            () => analyticsService.getKpi(any()),
          ).thenAnswer((_) async => kpiData);
          when(
            () => analyticsService.getChart(any()),
          ).thenAnswer((_) async => chartData);
          when(
            () => analyticsService.getRankedList(any()),
          ).thenAnswer((_) async => rankedListData);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const OverviewSubscriptionRequested()),
        wait: const Duration(milliseconds: 500),
        expect: () => <OverviewState>[
          const OverviewState(status: OverviewStatus.loading),
          OverviewState(
            status: OverviewStatus.success,
            kpiData: List.filled(OverviewBloc.kpiCards.length, kpiData),
            chartData: List.filled(
              OverviewBloc.chartCards.length,
              chartData,
            ),
            rankedListData: List.filled(
              OverviewBloc.rankedListCards.length,
              rankedListData,
            ),
          ),
        ],
        verify: (_) {
          verify(() => analyticsService.getKpi(any())).called(
            OverviewBloc.kpiCards.length,
          );
          verify(() => analyticsService.getChart(any())).called(
            OverviewBloc.chartCards.length,
          );
          verify(() => analyticsService.getRankedList(any())).called(
            OverviewBloc.rankedListCards.length,
          );
        },
      );

      blocTest<OverviewBloc, OverviewState>(
        'emits [loading, success] with nulls when data is not found',
        setUp: () {
          when(
            () => analyticsService.getKpi(any()),
          ).thenAnswer((_) async => null);
          when(
            () => analyticsService.getChart(any()),
          ).thenAnswer((_) async => null);
          when(
            () => analyticsService.getRankedList(any()),
          ).thenAnswer((_) async => null);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const OverviewSubscriptionRequested()),
        wait: const Duration(milliseconds: 500),
        expect: () => <OverviewState>[
          const OverviewState(status: OverviewStatus.loading),
          OverviewState(
            status: OverviewStatus.success,
            kpiData: List.filled(OverviewBloc.kpiCards.length, null),
            chartData: List.filled(OverviewBloc.chartCards.length, null),
            rankedListData: List.filled(
              OverviewBloc.rankedListCards.length,
              null,
            ),
          ),
        ],
      );

      blocTest<OverviewBloc, OverviewState>(
        'emits [loading, failure] when data fetching fails',
        setUp: () {
          when(() => analyticsService.getKpi(any())).thenThrow(testException);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const OverviewSubscriptionRequested()),
        wait: const Duration(milliseconds: 500),
        expect: () => <OverviewState>[
          const OverviewState(status: OverviewStatus.loading),
          OverviewState(
            status: OverviewStatus.failure,
            error: testException,
          ),
        ],
      );
    });
  });
}
