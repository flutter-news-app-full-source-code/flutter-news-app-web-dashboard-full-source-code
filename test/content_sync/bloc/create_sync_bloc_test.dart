import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:verity_dashboard/content_sync/bloc/create_sync/create_sync_bloc.dart';

class MockAutomationRepository extends Mock
    implements DataRepository<NewsAutomationTask> {}

class FakeNewsAutomationTask extends Fake implements NewsAutomationTask {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeNewsAutomationTask());
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

  group('CreateSyncBloc', () {
    late MockAutomationRepository automationRepository;
    late CreateSyncBloc bloc;

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
      bloc = CreateSyncBloc(automationRepository: automationRepository);
    });

    tearDown(() => bloc.close());

    test('initial state is correct', () {
      expect(bloc.state, const CreateSyncState());
    });

    blocTest<CreateSyncBloc, CreateSyncState>(
      'emits updated source when CreateSyncSourceChanged is added',
      build: () => bloc,
      act: (bloc) => bloc.add(CreateSyncSourceChanged(source)),
      expect: () => [
        CreateSyncState(source: source),
      ],
    );

    blocTest<CreateSyncBloc, CreateSyncState>(
      'emits [submitting, success] when CreateSyncSubmitted succeeds',
      setUp: () {
        when(
          () => automationRepository.create(item: any(named: 'item')),
        ).thenAnswer(
          (_) async => NewsAutomationTask(
            id: '1',
            sourceId: 'src1',
            fetchInterval: FetchInterval.hourly,
            status: IngestionStatus.active,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      },
      build: () => bloc,
      seed: () => CreateSyncState(source: source),
      act: (bloc) => bloc.add(const CreateSyncSubmitted()),
      expect: () => [
        CreateSyncState(source: source, status: CreateSyncStatus.submitting),
        CreateSyncState(source: source, status: CreateSyncStatus.success),
      ],
    );

    blocTest<CreateSyncBloc, CreateSyncState>(
      'emits [submitting, failure] when CreateSyncSubmitted fails',
      setUp: () {
        when(
          () => automationRepository.create(item: any(named: 'item')),
        ).thenThrow(const ServerException('Failed'));
      },
      build: () => bloc,
      seed: () => CreateSyncState(source: source),
      act: (bloc) => bloc.add(const CreateSyncSubmitted()),
      expect: () => [
        CreateSyncState(source: source, status: CreateSyncStatus.submitting),
        isA<CreateSyncState>().having(
          (s) => s.status,
          'status',
          CreateSyncStatus.failure,
        ),
      ],
    );
  });
}
