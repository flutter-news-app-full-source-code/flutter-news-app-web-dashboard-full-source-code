import 'package:core/core.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockKpiRepository extends Mock implements DataRepository<KpiCardData> {}

class MockChartRepository extends Mock
    implements DataRepository<ChartCardData> {}

class MockRankedListRepository extends Mock
    implements DataRepository<RankedListCardData> {}

void main() {
  group('AnalyticsService', () {
    late DataRepository<KpiCardData> kpiRepository;
    late DataRepository<ChartCardData> chartRepository;
    late DataRepository<RankedListCardData> rankedListRepository;
    late AnalyticsService analyticsService;

    const kpiId = KpiCardId.usersTotalRegistered;
    const kpiData = KpiCardData(
      id: 'test-id',
      cardId: kpiId,
      label: {SupportedLanguage.en: 'Total Users'},
      timeFrames: {},
    );

    const chartId = ChartCardId.usersRegistrationsOverTime;
    const chartData = ChartCardData(
      id: 'test-id',
      cardId: chartId,
      label: {SupportedLanguage.en: 'Registrations'},
      type: ChartType.line,
      timeFrames: {},
    );

    const rankedListId = RankedListCardId.overviewHeadlinesMostViewed;
    const rankedListData = RankedListCardData(
      id: 'test-id',
      cardId: rankedListId,
      label: {SupportedLanguage.en: 'Top Headlines'},
      timeFrames: {},
    );

    setUp(() {
      kpiRepository = MockKpiRepository();
      chartRepository = MockChartRepository();
      rankedListRepository = MockRankedListRepository();
      analyticsService = AnalyticsService(
        kpiRepository: kpiRepository,
        chartRepository: chartRepository,
        rankedListRepository: rankedListRepository,
      );

      // Setup default successful responses
      when(
        () => kpiRepository.readAll(filter: any(named: 'filter')),
      ).thenAnswer(
        (_) async => const PaginatedResponse(
          items: [kpiData],
          cursor: null,
          hasMore: false,
        ),
      );

      when(
        () => chartRepository.readAll(filter: any(named: 'filter')),
      ).thenAnswer(
        (_) async => const PaginatedResponse(
          items: [chartData],
          cursor: null,
          hasMore: false,
        ),
      );

      when(
        () => rankedListRepository.readAll(filter: any(named: 'filter')),
      ).thenAnswer(
        (_) async => const PaginatedResponse(
          items: [rankedListData],
          cursor: null,
          hasMore: false,
        ),
      );
    });

    group('getKpi', () {
      test('returns data from repository on first call', () async {
        final result = await analyticsService.getKpi(kpiId);
        expect(result, kpiData);
        verify(
          () => kpiRepository.readAll(filter: {'cardId': kpiId.name}),
        ).called(1);
      });

      test('returns cached data on second call', () async {
        await analyticsService.getKpi(kpiId);
        final result = await analyticsService.getKpi(kpiId);
        expect(result, kpiData);
        verify(
          () => kpiRepository.readAll(filter: {'cardId': kpiId.name}),
        ).called(1);
      });

      test('returns null when repository returns empty list', () async {
        when(
          () => kpiRepository.readAll(filter: any(named: 'filter')),
        ).thenAnswer(
          (_) async =>
              const PaginatedResponse(items: [], cursor: null, hasMore: false),
        );

        final result = await analyticsService.getKpi(kpiId);
        expect(result, isNull);
      });

      test('bypasses cache when forceRefresh is true', () async {
        await analyticsService.getKpi(kpiId);
        await analyticsService.getKpi(kpiId, forceRefresh: true);
        verify(
          () => kpiRepository.readAll(filter: {'cardId': kpiId.name}),
        ).called(2);
      });

      test('deduplicates in-flight requests', () async {
        final futures = [
          analyticsService.getKpi(kpiId),
          analyticsService.getKpi(kpiId),
        ];
        await Future.wait(futures);
        verify(
          () => kpiRepository.readAll(filter: {'cardId': kpiId.name}),
        ).called(1);
      });
    });

    group('getChart', () {
      test('returns data from repository on first call', () async {
        final result = await analyticsService.getChart(chartId);
        expect(result, chartData);
        verify(
          () => chartRepository.readAll(filter: {'cardId': chartId.name}),
        ).called(1);
      });

      test('returns null when repository returns empty list', () async {
        when(
          () => chartRepository.readAll(filter: any(named: 'filter')),
        ).thenAnswer(
          (_) async =>
              const PaginatedResponse(items: [], cursor: null, hasMore: false),
        );

        final result = await analyticsService.getChart(chartId);
        expect(result, isNull);
      });
    });

    group('getRankedList', () {
      test('returns data from repository on first call', () async {
        final result = await analyticsService.getRankedList(rankedListId);
        expect(result, rankedListData);
        verify(
          () => rankedListRepository.readAll(
            filter: {'cardId': rankedListId.name},
          ),
        ).called(1);
      });

      test('returns null when repository returns empty list', () async {
        when(
          () => rankedListRepository.readAll(filter: any(named: 'filter')),
        ).thenAnswer(
          (_) async =>
              const PaginatedResponse(items: [], cursor: null, hasMore: false),
        );

        final result = await analyticsService.getRankedList(rankedListId);
        expect(result, isNull);
      });
    });

    test('clearCache clears all caches', () async {
      // Populate caches
      await analyticsService.getKpi(kpiId);
      await analyticsService.getChart(chartId);
      await analyticsService.getRankedList(rankedListId);

      // Clear cache
      analyticsService.clearCache();

      // Fetch again, should call repositories
      await analyticsService.getKpi(kpiId);
      await analyticsService.getChart(chartId);
      await analyticsService.getRankedList(rankedListId);

      verify(
        () => kpiRepository.readAll(filter: any(named: 'filter')),
      ).called(2);
      verify(
        () => chartRepository.readAll(filter: any(named: 'filter')),
      ).called(2);
      verify(
        () => rankedListRepository.readAll(filter: any(named: 'filter')),
      ).called(2);
    });
  });
}
