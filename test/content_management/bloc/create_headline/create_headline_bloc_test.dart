import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:verity_dashboard/content_management/bloc/create_headline/create_headline_bloc.dart';
import 'package:verity_dashboard/shared/data/enrichment_repository.dart';

import '../../../helpers/helpers.dart';

class MockEnrichmentRepository extends Mock implements EnrichmentRepository {}

void main() {
  const testException = UnknownException('Something went wrong');

  setUpAll(registerFallbackValues);

  group('CreateHeadlineBloc', () {
    late MockDataRepository<Headline> headlinesRepository;
    late MockMediaRepository mediaRepository;
    late MockEnrichmentRepository enrichmentRepository;

    final sourceFixture = getSourcesFixturesData().first;
    final topicFixture = getTopicsFixturesData().first;
    final countryFixture = countriesFixturesData.first;
    final personFixture = getPersonsFixturesData().first;
    final headlineFixture = getHeadlinesFixturesData().first.copyWith(
      status: ContentStatus.draft,
    );
    final imageBytes = Uint8List.fromList([1, 2, 3]);
    const imageFileName = 'test.jpg';

    setUp(() {
      headlinesRepository = MockDataRepository<Headline>();
      mediaRepository = MockMediaRepository();
      enrichmentRepository = MockEnrichmentRepository();
    });

    CreateHeadlineBloc buildBloc() {
      return CreateHeadlineBloc(
        headlinesRepository: headlinesRepository,
        mediaRepository: mediaRepository,
        enrichmentRepository: enrichmentRepository,
        logger: Logger('CreateHeadlineBloc'),
      );
    }

    group('constructor', () {
      test('works properly', () => expect(buildBloc, returnsNormally));

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const CreateHeadlineState()),
        );
      });
    });

    group('CreateHeadlineInitialized', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated languages',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const CreateHeadlineInitialized(
            enabledLanguages: [SupportedLanguage.en, SupportedLanguage.es],
            defaultLanguage: SupportedLanguage.en,
          ),
        ),
        expect: () => [
          const CreateHeadlineState(
            enabledLanguages: [SupportedLanguage.en, SupportedLanguage.es],
            defaultLanguage: SupportedLanguage.en,
            selectedLanguage: SupportedLanguage.en,
          ),
        ],
      );
    });

    group('CreateHeadlineTitleChanged', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated title and resets enrichment flag',
        build: buildBloc,
        seed: () => const CreateHeadlineState(wasTitleEnriched: true),
        act: (bloc) => bloc.add(
          const CreateHeadlineTitleChanged({SupportedLanguage.en: 'New Title'}),
        ),
        expect: () => [
          const CreateHeadlineState(
            title: {SupportedLanguage.en: 'New Title'},
            wasTitleEnriched: false,
          ),
        ],
      );
    });

    blocTest<CreateHeadlineBloc, CreateHeadlineState>(
      'emits new state with merged titles when adding a secondary language',
      build: buildBloc,
      seed: () => const CreateHeadlineState(
        title: {SupportedLanguage.en: 'English Title'},
      ),
      act: (bloc) => bloc.add(
        const CreateHeadlineTitleChanged({
          SupportedLanguage.en: 'English Title',
          SupportedLanguage.es: 'Título',
        }),
      ),
      expect: () => [
        const CreateHeadlineState(
          title: {
            SupportedLanguage.en: 'English Title',
            SupportedLanguage.es: 'Título',
          },
          wasTitleEnriched: false,
        ),
      ],
    );

    group('CreateHeadlineUrlChanged', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated url',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(const CreateHeadlineUrlChanged('http://new.url')),
        expect: () => [const CreateHeadlineState(url: 'http://new.url')],
      );
    });

    group('CreateHeadlineImageChanged', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated image data',
        build: buildBloc,
        act: (bloc) => bloc.add(
          CreateHeadlineImageChanged(
            imageFileBytes: imageBytes,
            imageFileName: imageFileName,
          ),
        ),
        expect: () => [
          CreateHeadlineState(
            imageFileBytes: imageBytes,
            imageFileName: imageFileName,
          ),
        ],
      );
    });

    group('CreateHeadlineImageRemoved', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with null image data',
        build: buildBloc,
        seed: () => CreateHeadlineState(
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
        ),
        act: (bloc) => bloc.add(const CreateHeadlineImageRemoved()),
        expect: () => [const CreateHeadlineState()],
      );
    });

    group('CreateHeadlineSourceChanged', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated source',
        build: buildBloc,
        act: (bloc) => bloc.add(CreateHeadlineSourceChanged(sourceFixture)),
        expect: () => [CreateHeadlineState(source: sourceFixture)],
      );
    });

    group('CreateHeadlineTopicChanged', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated topic and resets enrichment flag',
        build: buildBloc,
        seed: () => const CreateHeadlineState(wasTopicEnriched: true),
        act: (bloc) => bloc.add(CreateHeadlineTopicChanged(topicFixture)),
        expect: () => [
          CreateHeadlineState(
            topic: topicFixture,
            wasTopicEnriched: false,
          ),
        ],
      );
    });

    group('CreateHeadlineCountriesChanged', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated countries and resets enrichment flag',
        build: buildBloc,
        seed: () => const CreateHeadlineState(wereCountriesEnriched: true),
        act: (bloc) => bloc.add(
          CreateHeadlineCountriesChanged([countryFixture]),
        ),
        expect: () => [
          CreateHeadlineState(
            mentionedCountries: [countryFixture],
            wereCountriesEnriched: false,
          ),
        ],
      );
    });

    group('CreateHeadlinePersonsChanged', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated persons and resets enrichment flag',
        build: buildBloc,
        seed: () => const CreateHeadlineState(werePersonsEnriched: true),
        act: (bloc) => bloc.add(
          CreateHeadlinePersonsChanged([personFixture]),
        ),
        expect: () => [
          CreateHeadlineState(
            mentionedPersons: [personFixture],
            werePersonsEnriched: false,
          ),
        ],
      );
    });

    group('CreateHeadlineLanguageTabChanged', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated selected language',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const CreateHeadlineLanguageTabChanged(SupportedLanguage.es),
        ),
        expect: () => [
          const CreateHeadlineState(selectedLanguage: SupportedLanguage.es),
        ],
      );
    });
    group('CreateHeadlineIsBreakingChanged', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated isBreaking status',
        build: buildBloc,
        act: (bloc) => bloc.add(const CreateHeadlineIsBreakingChanged(true)),
        expect: () => [const CreateHeadlineState(isBreaking: true)],
      );
    });

    group('CreateHeadlineSavedAsDraft', () {
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
          () => headlinesRepository.create(item: any(named: 'item')),
        ).thenAnswer((_) async => headlineFixture);
      });

      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits [submitting, success] and creates draft headline',
        build: buildBloc,
        seed: () => CreateHeadlineState(
          title: const {SupportedLanguage.en: 'New Headline'},
          url: headlineFixture.url,
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          source: sourceFixture,
          topic: topicFixture,
          mentionedCountries: [countryFixture],
        ),
        act: (bloc) => bloc.add(const CreateHeadlineSavedAsDraft()),
        expect: () => <dynamic>[
          isA<CreateHeadlineState>().having(
            (s) => s.status,
            'status',
            CreateHeadlineStatus.imageUploading,
          ),
          isA<CreateHeadlineState>().having(
            (s) => s.status,
            'status',
            CreateHeadlineStatus.entitySubmitting,
          ),
          isA<CreateHeadlineState>()
              .having((s) => s.status, 'status', CreateHeadlineStatus.success)
              .having((s) => s.createdHeadline, 'createdHeadline', isNotNull),
        ],
        verify: (bloc) {
          verify(
            () => mediaRepository.uploadFile(
              fileBytes: imageBytes,
              fileName: imageFileName,
              purpose: MediaAssetPurpose.headlineImage,
            ),
          ).called(1);
          verify(
            () => headlinesRepository.create(
              item: any(
                named: 'item',
                that: isA<Headline>()
                    .having((h) => h.status, 'status', ContentStatus.draft)
                    .having(
                      (h) => h.mediaAssetId,
                      'mediaAssetId',
                      mediaAssetId,
                    ),
              ),
            ),
          ).called(1);
        },
      );

      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
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
        seed: () => CreateHeadlineState(
          title: const {SupportedLanguage.en: 'New Headline'},
          url: headlineFixture.url,
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          source: sourceFixture,
          topic: topicFixture,
          mentionedCountries: [countryFixture],
        ),
        act: (bloc) => bloc.add(const CreateHeadlineSavedAsDraft()),
        expect: () => <dynamic>[
          isA<CreateHeadlineState>().having(
            (s) => s.status,
            'status',
            CreateHeadlineStatus.imageUploading,
          ),
          isA<CreateHeadlineState>()
              .having(
                (s) => s.status,
                'status',
                CreateHeadlineStatus.imageUploadFailure,
              )
              .having((s) => s.exception, 'exception', isA<NetworkException>()),
        ],
        verify: (_) {
          verifyNever(
            () =>
                headlinesRepository.create(item: any<Headline>(named: 'item')),
          );
        },
      );

      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits [entitySubmitting, entitySubmitFailure] on headlinesRepository error',
        build: buildBloc,
        setUp: () {
          when(
            () => headlinesRepository.create(item: any(named: 'item')),
          ).thenThrow(const NetworkException());
        },
        seed: () => CreateHeadlineState(
          title: const {SupportedLanguage.en: 'New Headline'},
          url: headlineFixture.url,
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          source: sourceFixture,
          topic: topicFixture,
          mentionedCountries: [countryFixture],
        ),
        act: (bloc) => bloc.add(const CreateHeadlineSavedAsDraft()),
        expect: () => <dynamic>[
          isA<CreateHeadlineState>().having(
            (s) => s.status,
            'status',
            CreateHeadlineStatus.imageUploading,
          ),
          isA<CreateHeadlineState>().having(
            (s) => s.status,
            'status',
            CreateHeadlineStatus.entitySubmitting,
          ),
          isA<CreateHeadlineState>()
              .having(
                (s) => s.status,
                'status',
                CreateHeadlineStatus.entitySubmitFailure,
              )
              .having((s) => s.exception, 'exception', isA<NetworkException>()),
        ],
      );

      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'creates draft headline without an image',
        build: buildBloc,
        seed: () => CreateHeadlineState(
          title: const {SupportedLanguage.en: 'New Headline'},
          url: headlineFixture.url,
          source: sourceFixture,
          topic: topicFixture,
          mentionedCountries: [countryFixture],
        ),
        act: (bloc) => bloc.add(const CreateHeadlineSavedAsDraft()),
        expect: () => <dynamic>[
          isA<CreateHeadlineState>().having(
            (s) => s.status,
            'status',
            CreateHeadlineStatus.entitySubmitting,
          ),
          isA<CreateHeadlineState>()
              .having((s) => s.status, 'status', CreateHeadlineStatus.success)
              .having((s) => s.createdHeadline, 'createdHeadline', isNotNull),
        ],
        verify: (bloc) {
          verifyNever(
            () => mediaRepository.uploadFile(
              fileBytes: any(named: 'fileBytes'),
              fileName: any(named: 'fileName'),
              purpose: any(named: 'purpose'),
            ),
          );
          verify(
            () => headlinesRepository.create(
              item: any(
                named: 'item',
                that: isA<Headline>()
                    .having((h) => h.status, 'status', ContentStatus.draft)
                    .having((h) => h.mediaAssetId, 'mediaAssetId', isNull),
              ),
            ),
          ).called(1);
        },
      );
    });

    group('CreateHeadlinePublished', () {
      setUp(() {
        when(
          () => mediaRepository.uploadFile(
            fileBytes: any(named: 'fileBytes'),
            fileName: any(named: 'fileName'),
            purpose: any(named: 'purpose'),
          ),
        ).thenAnswer((_) async => 'id');
        when(
          () => headlinesRepository.create(item: any(named: 'item')),
        ).thenAnswer((_) async => headlineFixture);
      });

      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'creates headline with active status',
        build: buildBloc,
        seed: () => CreateHeadlineState(
          title: const {SupportedLanguage.en: 'New Headline'},
          url: headlineFixture.url,
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          source: sourceFixture,
          topic: topicFixture,
          mentionedCountries: [countryFixture],
        ),
        act: (bloc) => bloc.add(const CreateHeadlinePublished()),
        verify: (bloc) {
          final headline =
              verify(
                    () => headlinesRepository.create(
                      item: captureAny(named: 'item'),
                    ),
                  ).captured.first
                  as Headline;
          expect(headline.status, ContentStatus.active);
        },
      );
    });

    group('CreateHeadlineEnrichmentRequested', () {
      final enrichedHeadline = headlineFixture.copyWith(
        title: const {SupportedLanguage.en: 'Enriched Title'},
        topic: topicFixture,
        mentionedCountries: [countryFixture],
        mentionedPersons: [personFixture],
      );

      setUp(() {
        when(
          () => enrichmentRepository.enrichHeadline(any<Headline>()),
        ).thenAnswer((_) async => enrichedHeadline);
      });

      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits [enriching, initial] on success and updates state',
        build: buildBloc,
        seed: () => const CreateHeadlineState(
          title: {SupportedLanguage.en: 'Original Title'},
          url: 'http://example.com',
        ),
        act: (bloc) => bloc.add(const CreateHeadlineEnrichmentRequested()),
        expect: () => [
          const CreateHeadlineState(
            status: CreateHeadlineStatus.enriching,
            title: {SupportedLanguage.en: 'Original Title'},
            url: 'http://example.com',
          ),
          CreateHeadlineState(
            status: CreateHeadlineStatus.initial,
            title: enrichedHeadline.title,
            url: 'http://example.com',
            topic: topicFixture,
            mentionedCountries: enrichedHeadline.mentionedCountries,
            mentionedPersons: enrichedHeadline.mentionedPersons,
            isEnrichmentSuccessful: true,
            wasTitleEnriched: true,
            wasTopicEnriched: true,
            wereCountriesEnriched: true,
            werePersonsEnriched: true,
          ),
        ],
        verify: (_) {
          verify(
            () => enrichmentRepository.enrichHeadline(any<Headline>()),
          ).called(1);
        },
      );

      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits [enriching, enrichmentFailure] on failure',
        build: buildBloc,
        setUp: () {
          when(
            () => enrichmentRepository.enrichHeadline(any<Headline>()),
          ).thenThrow(testException);
        },
        seed: () => const CreateHeadlineState(
          title: {SupportedLanguage.en: 'Original Title'},
          url: 'http://example.com',
        ),
        act: (bloc) => bloc.add(const CreateHeadlineEnrichmentRequested()),
        expect: () => [
          const CreateHeadlineState(
            status: CreateHeadlineStatus.enriching,
            title: {SupportedLanguage.en: 'Original Title'},
            url: 'http://example.com',
          ),
          CreateHeadlineState(
            status: CreateHeadlineStatus.enrichmentFailure,
            title: {SupportedLanguage.en: 'Original Title'},
            url: 'http://example.com',
            exception: testException,
          ),
        ],
      );
    });
  });
}
