import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_source/create_source_bloc.dart';
import 'package:logging/logging.dart';

import '../../../helpers/helpers.dart';

void main() {
  setUpAll(registerFallbackValues);

  group('CreateSourceBloc', () {
    late MockDataRepository<Source> sourcesRepository;
    late MockMediaRepository mediaRepository;

    final languageFixture = Language(
      id: 'lang-1',
      code: 'en',
      name: 'English',
      nativeName: 'English',
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
      status: ContentStatus.active,
    );
    final countryFixture = Country(
      id: 'country-1',
      isoCode: 'US',
      name: 'United States',
      flagUrl: 'url',
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
      status: ContentStatus.active,
    );
    final sourceFixture = FakeSource();
    final imageBytes = Uint8List.fromList([1, 2, 3]);
    const imageFileName = 'logo.jpg';

    setUp(() {
      sourcesRepository = MockDataRepository<Source>();
      mediaRepository = MockMediaRepository();
    });

    CreateSourceBloc buildBloc() {
      return CreateSourceBloc(
        sourcesRepository: sourcesRepository,
        mediaRepository: mediaRepository,
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

    group('CreateSourceNameChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated name',
        build: buildBloc,
        act: (bloc) => bloc.add(const CreateSourceNameChanged('New Source')),
        expect: () => [const CreateSourceState(name: 'New Source')],
      );
    });

    group('CreateSourceDescriptionChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated description',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(const CreateSourceDescriptionChanged('Description')),
        expect: () => [const CreateSourceState(description: 'Description')],
      );
    });

    group('CreateSourceUrlChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated url',
        build: buildBloc,
        act: (bloc) => bloc.add(const CreateSourceUrlChanged('http://new.url')),
        expect: () => [const CreateSourceState(url: 'http://new.url')],
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
        act: (bloc) => bloc.add(CreateSourceLanguageChanged(languageFixture)),
        expect: () => [CreateSourceState(language: languageFixture)],
      );
    });

    group('CreateSourceHeadquartersChanged', () {
      blocTest<CreateSourceBloc, CreateSourceState>(
        'emits new state with updated headquarters',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(CreateSourceHeadquartersChanged(countryFixture)),
        expect: () => [CreateSourceState(headquarters: countryFixture)],
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
          name: 'New Source',
          description: 'Desc',
          url: 'http://url.com',
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          sourceType: SourceType.blog,
          language: languageFixture,
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
          name: 'New Source',
          description: 'Desc',
          url: 'http://url.com',
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          sourceType: SourceType.blog,
          language: languageFixture,
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
          name: 'New Source',
          description: 'Desc',
          url: 'http://url.com',
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          sourceType: SourceType.blog,
          language: languageFixture,
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
          name: 'New Source',
          description: 'Desc',
          url: 'http://url.com',
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          sourceType: SourceType.blog,
          language: languageFixture,
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
