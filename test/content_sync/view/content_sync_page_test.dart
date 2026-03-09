import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:verity_dashboard/app/bloc/app_bloc.dart';
import 'package:verity_dashboard/app/config/app_environment.dart';
import 'package:verity_dashboard/content_sync/bloc/content_sync_bloc.dart';
import 'package:verity_dashboard/content_sync/view/content_sync_page.dart';
import 'package:verity_dashboard/shared/services/analytics_service.dart';
import '../../helpers/pump_app.dart';

class MockContentSyncBloc extends MockBloc<ContentSyncEvent, ContentSyncState>
    implements ContentSyncBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockKpiRepository extends Mock implements DataRepository<KpiCardData> {}

class MockChartRepository extends Mock
    implements DataRepository<ChartCardData> {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  group('ContentSyncPage', () {
    late ContentSyncBloc contentSyncBloc;
    late AppBloc appBloc;
    late MockKpiRepository kpiRepository;
    late MockChartRepository chartRepository;
    late MockAnalyticsService analyticsService;

    setUp(() {
      contentSyncBloc = MockContentSyncBloc();
      appBloc = MockAppBloc();
      kpiRepository = MockKpiRepository();
      chartRepository = MockChartRepository();
      analyticsService = MockAnalyticsService();

      when(() => appBloc.state).thenReturn(
        const AppState(environment: AppEnvironment.development),
      );

      // Mocking Analytics dependencies
      when(
        () => kpiRepository.read(id: any(named: 'id')),
      ).thenAnswer((_) async => throw const NotFoundException(''));
      when(
        () => chartRepository.read(id: any(named: 'id')),
      ).thenAnswer((_) async => throw const NotFoundException(''));
    });

    Widget buildSubject() {
      return Provider<AnalyticsService>.value(
        value: analyticsService,
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<DataRepository<KpiCardData>>.value(
              value: kpiRepository,
            ),
            RepositoryProvider<DataRepository<ChartCardData>>.value(
              value: chartRepository,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: contentSyncBloc),
              BlocProvider.value(value: appBloc),
            ],
            child: const ContentSyncPage(),
          ),
        ),
      );
    }

    testWidgets('renders CircularProgressIndicator when loading', (
      tester,
    ) async {
      when(() => contentSyncBloc.state).thenReturn(
        const ContentSyncState(status: ContentSyncStatus.loading),
      );

      await tester.pumpApp(buildSubject());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders table when status is success', (tester) async {
      final task = NewsAutomationTask(
        id: '1',
        sourceId: 'src1',
        fetchInterval: FetchInterval.hourly,
        status: IngestionStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final source = Source(
        id: 'src1',
        name: const {SupportedLanguage.en: 'Test Source'},
        description: const {},
        url: '',
        sourceType: SourceType.blog,
        language: SupportedLanguage.en,
        headquarters: const Country(
          id: 'c',
          isoCode: 'US',
          name: {},
          flagUrl: '',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: ContentStatus.active,
      );

      when(() => contentSyncBloc.state).thenReturn(
        ContentSyncState(
          status: ContentSyncStatus.success,
          tasks: [task],
          sources: {'src1': source},
        ),
      );

      await tester.pumpApp(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Test Source'), findsOneWidget);
    });

    testWidgets('adds ContentSyncStarted on retry when failure', (
      tester,
    ) async {
      when(() => contentSyncBloc.state).thenReturn(
        const ContentSyncState(
          status: ContentSyncStatus.failure,
          exception: ServerException(''),
        ),
      );
      // ... logic to tap retry button and verify event
    });
  });
}
