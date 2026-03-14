import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:logging/logging.dart';
import 'package:veritai_dashboard/content_management/bloc/create_source/create_source_bloc.dart';
import 'package:veritai_dashboard/shared/data/enrichment_repository.dart';

import '../../../helpers/helpers.dart';

class MockEnrichmentRepository extends Mock implements EnrichmentRepository {}

void main() {
  setUpAll(registerFallbackValues);

  group('CreateSourceBloc', () {
    late MockDataRepository<Source> sourcesRepository;
    late MockMediaRepository mediaRepository;
    late MockEnrichmentRepository enrichmentRepository;

    const countryFixture = Country(
      id: 'country-1',
      isoCode: 'US',
      name: {SupportedLanguage.en: 'United States'},
      flagUrl: 'url',
    );
    final sourceFixture = Source(
      id: 'source-1',
      name: const {SupportedLanguage.en: 'New Source'},
      description: const {SupportedLanguage.en: 'Description'},
      url: 'http://new.url',
      sourceType: SourceType.newsAgency,
      language: SupportedLanguage.en,
      headquarters: countryFixture,
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
      status: ContentStatus.active,
      mediaAssetId: 'asset-id',
    );

    final imageBytes = Uint8List.fromList([1, 2, 3]);
    const imageFileName = 'logo.jpg';

    const languageFixture = Language(
      id: 'lang-1',
      code: 'en',
      name: {SupportedLanguage.en: 'English'},
      nativeName: 'English',
    );

    setUp(() {
      sourcesRepository = MockDataRepository<Source>();
      mediaRepository = MockMediaRepository();
      enrichmentRepository = MockEnrichmentRepository();
    });

    CreateSourceBloc buildBloc() {
      return CreateSourceBloc(
        sourcesRepository: sourcesRepository,
        mediaRepository: mediaRepository,
        enrichmentRepository: enrichmentRepository,
        logger: Logger('CreateSourceBloc'),
      );
    }

    group('constructor', () {
      test('works properly', () => expect(buildBloc, returnsNormally));

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const CreateSourceState()),
        );
      });
    });

    group('CreateSourceInitialized', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated languages',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const CreateSourceInitialized(
            enabledLanguages: [SupportedLanguage.en, SupportedLanguage.es],
            defaultLanguage: SupportedLanguage.en,
          ),
        ),
        expect: () => [
          const CreateSourceState(
            enabledLanguages: [SupportedLanguage.en, SupportedLanguage.es],
            defaultLanguage: SupportedLanguage.en,
            selectedLanguage: SupportedLanguage.en,
          ),
        ],
      );
    });

    group('CreateSourceNameChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated name',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const CreateSourceNameChanged({SupportedLanguage.en: 'New Source'}),
        ),
        expect: () => [
          const CreateSourceState(name: {SupportedLanguage.en: 'New Source'}),
        ],
      );
    });

    group('CreateSourceDescriptionChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated description',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const CreateSourceDescriptionChanged({
            SupportedLanguage.en: 'Description',
          }),
        ),
        expect: () => [
          const CreateSourceState(
            description: {SupportedLanguage.en: 'Description'},
          ),
        ],
      );
    });

    group('CreateSourceUrlChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated url',
        build: buildBloc,
        act: (bloc) => bloc.add(const CreateSourceUrlChanged('http://url.com')),
        expect: () => [const CreateSourceState(url: 'http://url.com')],
      );
    });

    group('CreateSourceTypeChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated source type',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(const CreateSourceTypeChanged(SourceType.newsAgency)),
        expect: () => [
          const CreateSourceState(sourceType: SourceType.newsAgency),
        ],
      );
    });

    group('CreateSourceLanguageChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated language',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(const CreateSourceLanguageChanged(languageFixture)),
        expect: () => [
          const CreateSourceState(
            language: SupportedLanguage.en,
            selectedLanguageEntity: languageFixture,
          ),
        ],
      );
    });

    group('CreateSourceHeadquartersChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated headquarters',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(const CreateSourceHeadquartersChanged(countryFixture)),
        expect: () => [const CreateSourceState(headquarters: countryFixture)],
      );
    });

    group('CreateSourceLanguageTabChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated selected language',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const CreateSourceLanguageTabChanged(SupportedLanguage.es),
        ),
        expect: () => [
          const CreateSourceState(selectedLanguage: SupportedLanguage.es),
        ],
      );
    });

    group('CreateSourceEnrichmentRequested', () {
      final enrichedSource = sourceFixture.copyWith(
        name: {SupportedLanguage.en: 'Enriched Name'},
        description: {SupportedLanguage.en: 'Enriched Description'},
      );

      setUp(() {
        registerFallbackValue(sourceFixture);
        when(
          () => enrichmentRepository.enrichSource(any<Source>()),
        ).thenAnswer((_) async => enrichedSource);
      });

      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits [enriching, initial] on success and updates state',
        build: buildBloc,
        seed: () => const CreateSourceState(
          name: {SupportedLanguage.en: 'Original Name'},
          url: 'http://example.com',
        ),
        act: (bloc) => bloc.add(const CreateSourceEnrichmentRequested()),
        expect: () => [
          const CreateSourceState(
            status: CreateSourceStatus.enriching,
            name: {SupportedLanguage.en: 'Original Name'},
            url: 'http://example.com',
          ),
          isA<CreateSourceState>()
              .having((s) => s.status, 'status', CreateSourceStatus.initial)
              .having((s) => s.name, 'name', enrichedSource.name)
              .having(
                (s) => s.description,
                'description',
                enrichedSource.description,
              )
              .having((s) => s.url, 'url', enrichedSource.url)
              .having(
                (s) => s.sourceType,
                'sourceType',
                enrichedSource.sourceType,
              )
              .having((s) => s.language, 'language', enrichedSource.language)
              .having(
                (s) => s.headquarters,
                'headquarters',
                enrichedSource.headquarters,
              )
              .having(
                (s) => s.isEnrichmentSuccessful,
                'isEnrichmentSuccessful',
                true,
              )
              .having((s) => s.wasNameEnriched, 'wasNameEnriched', true)
              .having(
                (s) => s.wasDescriptionEnriched,
                'wasDescriptionEnriched',
                true,
              )
              .having((s) => s.wasUrlEnriched, 'wasUrlEnriched', true)
              .having(
                (s) => s.wasSourceTypeEnriched,
                'wasSourceTypeEnriched',
                true,
              )
              .having((s) => s.wasLanguageEnriched, 'wasLanguageEnriched', true)
              .having(
                (s) => s.wasHeadquartersEnriched,
                'wasHeadquartersEnriched',
                true,
              )
              .having(
                (s) => s.selectedLanguageEntity,
                'selectedLanguageEntity',
                isA<Language>(),
              ),
        ],
        verify: (_) {
          verify(() => enrichmentRepository.enrichSource(any())).called(1);
        },
      );

      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits [enriching, enrichmentFailure] on failure',
        build: buildBloc,
        setUp: () {
          when(
            () => enrichmentRepository.enrichSource(any()),
          ).thenThrow(const NetworkException());
        },
        seed: () => const CreateSourceState(
          name: {SupportedLanguage.en: 'Original Name'},
          url: 'http://example.com',
        ),
        act: (bloc) => bloc.add(const CreateSourceEnrichmentRequested()),
        expect: () => [
          const CreateSourceState(
            status: CreateSourceStatus.enriching,
            name: {SupportedLanguage.en: 'Original Name'},
            url: 'http://example.com',
          ),
          isA<CreateSourceState>()
              .having(
                (s) => s.status,
                'status',
                CreateSourceStatus.enrichmentFailure,
              )
              .having(
                (s) => s.exception,
                'exception',
                isA<NetworkException>(),
              ),
        ],
      );
    });

    group('CreateSourceImageChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated image data',
        build: buildBloc,
        act: (bloc) => bloc.add(
          CreateSourceImageChanged(
            imageFileBytes: imageBytes,
            imageFileName: imageFileName,
          ),
        ),
        expect: () => [
          CreateSourceState(
            imageFileBytes: imageBytes,
            imageFileName: imageFileName,
          ),
        ],
      );
    });

    group('CreateSourceImageRemoved', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with null image data',
        build: buildBloc,
        seed: () => CreateSourceState(
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
        ),
        act: (bloc) => bloc.add(const CreateSourceImageRemoved()),
        expect: () => [const CreateSourceState()],
      );
    });

    group('CreateSourceSavedAsDraft', () {
      const mediaAssetId = 'new-media-asset-id';
      setUp(() {
        when(
          () => mediaRepository.uploadFile(
            fileBytes: any(named: 'fileBytes'),
            fileName: any(named: 'fileName'),
            purpose: any(named: 'purpose'),
          ),
        ).thenAnswer((_) async => mediaAssetId);

        when(
          () => sourcesRepository.create(item: any(named: 'item')),
        ).thenAnswer((_) async => sourceFixture);
      });

      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits [imageUploading, entitySubmitting, success] and creates draft source',
        build: buildBloc,
        seed: () => CreateSourceState(
          name: const {SupportedLanguage.en: 'New Source'},
          description: const {SupportedLanguage.en: 'Desc'},
          url: 'http://url.com',
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          sourceType: SourceType.blog,
          language: SupportedLanguage.en,
          headquarters: countryFixture,
        ),
        act: (bloc) => bloc.add(const CreateSourceSavedAsDraft()),
        expect: () => <dynamic>[
          isA<CreateSourceState>().having(
            (s) => s.status,
            'status',
            CreateSourceStatus.imageUploading,
          ),
          isA<CreateSourceState>().having(
            (s) => s.status,
            'status',
            CreateSourceStatus.entitySubmitting,
          ),
          isA<CreateSourceState>()
              .having((s) => s.status, 'status', CreateSourceStatus.success)
              .having((s) => s.createdSource, 'createdSource', isNotNull),
        ],
        verify: (bloc) {
          verify(
            () => mediaRepository.uploadFile(
              fileBytes: imageBytes,
              fileName: imageFileName,
              purpose: MediaAssetPurpose.sourceImage,
            ),
          ).called(1);
          verify(
            () => sourcesRepository.create(
              item: any(
                named: 'item',
                that: isA<Source>()
                    .having((s) => s.status, 'status', ContentStatus.draft)
                    .having(
                      (s) => s.mediaAssetId,
                      'mediaAssetId',
                      mediaAssetId,
                    ),
              ),
            ),
          ).called(1);
        },
      );

      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits [imageUploading, imageUploadFailure] on mediaRepository error',
        build: buildBloc,
        setUp: () {
          when(
            () => mediaRepository.uploadFile(
              fileBytes: any(named: 'fileBytes'),
              fileName: any(named: 'fileName'),
              purpose: any(named: 'purpose'),
            ),
          ).thenThrow(const NetworkException());
        },
        seed: () => CreateSourceState(
          name: const {SupportedLanguage.en: 'New Source'},
          description: const {SupportedLanguage.en: 'Desc'},
          url: 'http://url.com',
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          sourceType: SourceType.blog,
          language: SupportedLanguage.en,
          headquarters: countryFixture,
        ),
        act: (bloc) => bloc.add(const CreateSourceSavedAsDraft()),
        expect: () => <dynamic>[
          isA<CreateSourceState>().having(
            (s) => s.status,
            'status',
            CreateSourceStatus.imageUploading,
          ),
          isA<CreateSourceState>()
              .having(
                (s) => s.status,
                'status',
                CreateSourceStatus.imageUploadFailure,
              )
              .having((s) => s.exception, 'exception', isA<NetworkException>()),
        ],
        verify: (_) {
          verifyNever(
            () => sourcesRepository.create(item: any(named: 'item')),
          );
        },
      );

      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits [entitySubmitting, entitySubmitFailure] on sourcesRepository error',
        build: buildBloc,
        setUp: () {
          when(
            () => sourcesRepository.create(item: any(named: 'item')),
          ).thenThrow(const NetworkException());
        },
        seed: () => CreateSourceState(
          name: const {SupportedLanguage.en: 'New Source'},
          description: const {SupportedLanguage.en: 'Desc'},
          url: 'http://url.com',
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          sourceType: SourceType.blog,
          language: SupportedLanguage.en,
          headquarters: countryFixture,
        ),
        act: (bloc) => bloc.add(const CreateSourceSavedAsDraft()),
        expect: () => <dynamic>[
          isA<CreateSourceState>().having(
            (s) => s.status,
            'status',
            CreateSourceStatus.imageUploading,
          ),
          isA<CreateSourceState>().having(
            (s) => s.status,
            'status',
            CreateSourceStatus.entitySubmitting,
          ),
          isA<CreateSourceState>()
              .having(
                (s) => s.status,
                'status',
                CreateSourceStatus.entitySubmitFailure,
              )
              .having((s) => s.exception, 'exception', isA<NetworkException>()),
        ],
      );
    });

    group('CreateSourcePublished', () {
      setUp(() {
        when(
          () => mediaRepository.uploadFile(
            fileBytes: any(named: 'fileBytes'),
            fileName: any(named: 'fileName'),
            purpose: any(named: 'purpose'),
          ),
        ).thenAnswer((_) async => 'id');
        when(
          () => sourcesRepository.create(item: any(named: 'item')),
        ).thenAnswer((_) async => sourceFixture);
      });

      blocTest<CreateSourceBloc, CreateSourceState>(
        'creates source with active status',
        build: buildBloc,
        seed: () => CreateSourceState(
          name: const {SupportedLanguage.en: 'New Source'},
          description: const {SupportedLanguage.en: 'Desc'},
          url: 'http://url.com',
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          sourceType: SourceType.blog,
          language: SupportedLanguage.en,
          headquarters: countryFixture,
        ),
        act: (bloc) => bloc.add(const CreateSourcePublished()),
        verify: (bloc) {
          final source =
              verify(
                    () => sourcesRepository.create(
                      item: captureAny(named: 'item'),
                    ),
                  ).captured.first
                  as Source;
          expect(source.status, ContentStatus.active);
        },
      );
    });
  });
}
