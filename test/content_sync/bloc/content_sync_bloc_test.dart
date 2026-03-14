import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:veritai_dashboard/content_sync/bloc/content_sync_bloc.dart';

class MockAutomationRepository extends Mock
    implements DataRepository<NewsAutomationTask> {}

class MockSourcesRepository extends Mock implements DataRepository<Source> {}

class FakeNewsAutomationTask extends Fake implements NewsAutomationTask {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeNewsAutomationTask());
    registerFallbackValue(
      const PaginationOptions(cursor: null, limit: null),
    );
    registerFallbackValue(
      const SortOption('updatedAt', SortOrder.desc),
    );
    registerFallbackValue(
      NewsAutomationTask(
        id: '',
        sourceId: '',
        fetchInterval: FetchInterval.daily,
        status: IngestionStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  });

  group('ContentSyncBloc', () {
    late MockAutomationRepository automationRepository;
    late MockSourcesRepository sourcesRepository;
    late ContentSyncBloc bloc;

    final task = NewsAutomationTask(
      id: '1',
      sourceId: 'src1',
      fetchInterval: FetchInterval.hourly,
      status: IngestionStatus.active,
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    );

    final source = Source(
      id: 'src1',
      name: const {SupportedLanguage.en: 'Source 1'},
      description: const {SupportedLanguage.en: 'Desc'},
      url: 'https://test.com',
      sourceType: SourceType.newsAgency,
      language: SupportedLanguage.en,
      headquarters: const Country(
        id: 'c1',
        isoCode: 'US',
        name: {SupportedLanguage.en: 'USA'},
        flagUrl: '',
      ),
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
      status: ContentStatus.active,
    );

    setUp(() {
      automationRepository = MockAutomationRepository();
      sourcesRepository = MockSourcesRepository();

      when(
        () => automationRepository.entityUpdated,
      ).thenAnswer((_) => const Stream.empty());

      bloc = ContentSyncBloc(
        automationRepository: automationRepository,
        sourcesRepository: sourcesRepository,
      );
    });

    tearDown(() => bloc.close());

    test('initial state is correct', () {
      expect(bloc.state, const ContentSyncState());
    });

    blocTest<ContentSyncBloc, ContentSyncState>(
      'emits [loading, success] when ContentSyncStarted succeeds',
      setUp: () {
        when(
          () => automationRepository.readAll(
            pagination: any(named: 'pagination'),
            sort: any(named: 'sort'),
          ),
        ).thenAnswer(
          (_) async => PaginatedResponse(
            items: [task],
            cursor: 'next',
            hasMore: true,
          ),
        );
        when(
          () => sourcesRepository.readAll(filter: any(named: 'filter')),
        ).thenAnswer(
          (_) async => PaginatedResponse(
            items: [source],
            cursor: null,
            hasMore: false,
          ),
        );
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const ContentSyncStarted()),
      expect: () => [
        const ContentSyncState(status: ContentSyncStatus.loading),
        ContentSyncState(
          status: ContentSyncStatus.success,
          tasks: [task],
          sources: {'src1': source},
          cursor: 'next',
          hasMore: true,
        ),
      ],
    );

    blocTest<ContentSyncBloc, ContentSyncState>(
      'emits [loading, failure] when ContentSyncStarted fails',
      setUp: () {
        when(
          () => automationRepository.readAll(
            pagination: any(named: 'pagination'),
            sort: any(named: 'sort'),
          ),
        ).thenThrow(const ServerException('Error'));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const ContentSyncStarted()),
      expect: () => [
        const ContentSyncState(status: ContentSyncStatus.loading),
        isA<ContentSyncState>().having(
          (s) => s.status,
          'status',
          ContentSyncStatus.failure,
        ),
      ],
    );

    blocTest<ContentSyncBloc, ContentSyncState>(
      'calls update when ContentSyncStatusToggled is added',
      setUp: () {
        // Seed state with a task
        when(
          () => automationRepository.update(
            id: any(named: 'id'),
            item: any(named: 'item'),
          ),
        ).thenAnswer((_) async => task);
      },
      build: () => bloc,
      seed: () => ContentSyncState(
        status: ContentSyncStatus.success,
        tasks: [task],
      ),
      act: (bloc) => bloc.add(
        const ContentSyncStatusToggled('1', IngestionStatus.paused),
      ),
      verify: (_) {
        verify(
          () => automationRepository.update(
            id: '1',
            item: any(named: 'item'),
          ),
        ).called(1);
      },
    );
  });
}
