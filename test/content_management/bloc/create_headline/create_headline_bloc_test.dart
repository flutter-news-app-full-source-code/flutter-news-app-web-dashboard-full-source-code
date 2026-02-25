import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_headline/create_headline_bloc.dart';
import 'package:logging/logging.dart';

import '../../../helpers/helpers.dart';

void main() {
  setUpAll(registerFallbackValues);

  group('CreateHeadlineBloc', () {
    late MockDataRepository<Headline> headlinesRepository;
    late MockMediaRepository mediaRepository;

    final sourceFixture = getSourcesFixturesData().first;
    final topicFixture = getTopicsFixturesData().first;
    final countryFixture = countriesFixturesData.first;
    final headlineFixture = getHeadlinesFixturesData().first.copyWith(
      status: ContentStatus.draft,
    );
    final imageBytes = Uint8List.fromList([1, 2, 3]);
    const imageFileName = 'test.jpg';

    setUp(() {
      headlinesRepository = MockDataRepository<Headline>();
      mediaRepository = MockMediaRepository();
    });

    CreateHeadlineBloc buildBloc() {
      return CreateHeadlineBloc(
        headlinesRepository: headlinesRepository,
        mediaRepository: mediaRepository,
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

    group('CreateHeadlineTitleChanged', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated title',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const CreateHeadlineTitleChanged('New Title', SupportedLanguage.en),
        ),
        expect: () => [
          const CreateHeadlineState(title: {SupportedLanguage.en: 'New Title'}),
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
        const CreateHeadlineTitleChanged('Título', SupportedLanguage.es),
      ),
      expect: () => [
        const CreateHeadlineState(
          title: {
            SupportedLanguage.en: 'English Title',
            SupportedLanguage.es: 'Título',
          },
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
        'emits new state with updated topic',
        build: buildBloc,
        act: (bloc) => bloc.add(CreateHeadlineTopicChanged(topicFixture)),
        expect: () => [CreateHeadlineState(topic: topicFixture)],
      );
    });

    group('CreateHeadlineCountryChanged', () {
      blocTest<CreateHeadlineBloc, CreateHeadlineState>(
        'emits new state with updated country',
        build: buildBloc,
        act: (bloc) => bloc.add(CreateHeadlineCountryChanged(countryFixture)),
        expect: () => [CreateHeadlineState(eventCountry: countryFixture)],
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
          eventCountry: countryFixture,
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
          eventCountry: countryFixture,
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
            () => headlinesRepository.create(item: any(named: 'item')),
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
          eventCountry: countryFixture,
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
          eventCountry: countryFixture,
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
          eventCountry: countryFixture,
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
  });
}
