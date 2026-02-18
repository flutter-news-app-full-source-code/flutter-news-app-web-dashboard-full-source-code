import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_source/edit_source_bloc.dart';
import 'package:logging/logging.dart';

import '../../../helpers/helpers.dart';

void main() {
  setUpAll(registerFallbackValues);

  group('EditSourceBloc', () {
    late MockDataRepository<Source> sourcesRepository;
    late MockMediaRepository mediaRepository;
    late MockOptimisticImageCacheService optimisticImageCacheService;

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
    final sourceFixture = Source(
      id: 'source-1',
      name: 'Original Name',
      description: 'Original Desc',
      url: 'http://original.com',
      sourceType: SourceType.blog,
      language: languageFixture,
      headquarters: countryFixture,
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
      status: ContentStatus.active,
      logoUrl: 'http://logo.url',
      mediaAssetId: 'asset-1',
    );

    final imageBytes = Uint8List.fromList([1, 2, 3]);
    const imageFileName = 'new_logo.jpg';
    const sourceId = 'source-1';

    setUp(() {
      sourcesRepository = MockDataRepository<Source>();
      mediaRepository = MockMediaRepository();
      optimisticImageCacheService = MockOptimisticImageCacheService();
    });

    EditSourceBloc buildBloc() {
      return EditSourceBloc(
        sourcesRepository: sourcesRepository,
        mediaRepository: mediaRepository,
        optimisticImageCacheService: optimisticImageCacheService,
        sourceId: sourceId,
        logger: Logger('EditSourceBloc'),
      );
    }

    group('constructor', () {
      test('works properly', () => expect(buildBloc, returnsNormally));

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const EditSourceState(sourceId: sourceId)),
        );
      });
    });

    group('EditSourceLoaded', () {
      blocTest<EditSourceBloc, EditSourceState>(
        'emits [initial] with populated data on success',
        setUp: () {
          when(
            () => sourcesRepository.read(id: sourceId),
          ).thenAnswer((_) async => sourceFixture);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const EditSourceLoaded()),
        expect: () => [
          const EditSourceState(
            sourceId: sourceId,
            status: EditSourceStatus.loading,
          ),
          EditSourceState(
            sourceId: sourceId,
            status: EditSourceStatus.initial,
            name: sourceFixture.name,
            description: sourceFixture.description,
            url: sourceFixture.url,
            logoUrl: sourceFixture.logoUrl,
            sourceType: sourceFixture.sourceType,
            language: sourceFixture.language,
            headquarters: sourceFixture.headquarters,
            initialSource: sourceFixture,
          ),
        ],
      );

      blocTest<EditSourceBloc, EditSourceState>(
        'emits [failure] on repository error',
        setUp: () {
          when(
            () => sourcesRepository.read(id: sourceId),
          ).thenThrow(const NetworkException());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const EditSourceLoaded()),
        expect: () => [
          isA<EditSourceState>().having(
            (s) => s.status,
            'status',
            EditSourceStatus.loading,
          ),
          isA<EditSourceState>()
              .having((s) => s.status, 'status', EditSourceStatus.failure)
              .having((s) => s.exception, 'exception', isA<NetworkException>()),
        ],
      );
    });

    group('Field Changes', () {
      blocTest<EditSourceBloc, EditSourceState>(
        'emits new state with updated name',
        build: buildBloc,
        act: (bloc) => bloc.add(const EditSourceNameChanged('New Name')),
        expect: () => [
          const EditSourceState(
            sourceId: sourceId,
            status: EditSourceStatus.initial, // Reset status
            name: 'New Name',
          ),
        ],
      );

      // ... other simple field tests omitted for brevity as they follow same pattern ...

      blocTest<EditSourceBloc, EditSourceState>(
        'emits new state with updated image data',
        build: buildBloc,
        act: (bloc) => bloc.add(
          EditSourceImageChanged(
            imageFileBytes: imageBytes,
            imageFileName: imageFileName,
          ),
        ),
        expect: () => [
          EditSourceState(
            sourceId: sourceId,
            status: EditSourceStatus.initial,
            imageFileBytes: imageBytes,
            imageFileName: imageFileName,
            imageRemoved: false,
          ),
        ],
      );
    });

    group('EditSourceSavedAsDraft', () {
      const newMediaAssetId = 'new-asset-id';

      setUp(() {
        when(
          () => mediaRepository.uploadFile(
            fileBytes: any(named: 'fileBytes'),
            fileName: any(named: 'fileName'),
            purpose: any(named: 'purpose'),
          ),
        ).thenAnswer((_) async => newMediaAssetId);

        when(
          () => sourcesRepository.update(
            id: any(named: 'id'),
            item: any(named: 'item'),
          ),
        ).thenAnswer((_) async => sourceFixture);

        when(
          () => optimisticImageCacheService.cacheImage(any(), any()),
        ).thenAnswer((_) {});
      });

      blocTest<EditSourceBloc, EditSourceState>(
        'uploads image and updates source as draft',
        build: buildBloc,
        seed: () => EditSourceState(
          sourceId: sourceId,
          initialSource: sourceFixture,
          name: 'Updated Name',
          description: 'Updated Desc',
          url: 'http://updated.com',
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          sourceType: SourceType.newsAgency,
          language: languageFixture,
          headquarters: countryFixture,
        ),
        act: (bloc) => bloc.add(const EditSourceSavedAsDraft()),
        expect: () => [
          isA<EditSourceState>().having(
            (s) => s.status,
            'status',
            EditSourceStatus.imageUploading,
          ),
          isA<EditSourceState>().having(
            (s) => s.status,
            'status',
            EditSourceStatus.entitySubmitting,
          ),
          isA<EditSourceState>()
              .having((s) => s.status, 'status', EditSourceStatus.success)
              .having((s) => s.updatedSource, 'updatedSource', isNotNull),
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
            () => sourcesRepository.update(
              id: sourceId,
              item: any(
                named: 'item',
                that: isA<Source>()
                    .having((s) => s.name, 'name', 'Updated Name')
                    .having((s) => s.status, 'status', ContentStatus.draft)
                    .having(
                      (s) => s.mediaAssetId,
                      'mediaAssetId',
                      newMediaAssetId,
                    ),
              ),
            ),
          ).called(1);
        },
      );
    });

    group('EditSourcePublished', () {
      setUp(() {
        when(
          () => sourcesRepository.update(
            id: any(named: 'id'),
            item: any(named: 'item'),
          ),
        ).thenAnswer((_) async => sourceFixture);
      });

      blocTest<EditSourceBloc, EditSourceState>(
        'updates source as active without image upload if no image changed',
        build: buildBloc,
        seed: () => EditSourceState(
          sourceId: sourceId,
          initialSource: sourceFixture,
          name: 'Updated Name',
          description: 'Updated Desc',
          url: 'http://updated.com',
          // No image bytes
          sourceType: SourceType.newsAgency,
          language: languageFixture,
          headquarters: countryFixture,
        ),
        act: (bloc) => bloc.add(const EditSourcePublished()),
        expect: () => [
          isA<EditSourceState>().having(
            (s) => s.status,
            'status',
            EditSourceStatus.entitySubmitting,
          ),
          isA<EditSourceState>()
              .having((s) => s.status, 'status', EditSourceStatus.success)
              .having(
                (s) => s.updatedSource!.status,
                'status',
                ContentStatus.active,
              ),
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
            () => sourcesRepository.update(
              id: sourceId,
              item: any(
                named: 'item',
                that: isA<Source>().having(
                  (s) => s.mediaAssetId,
                  'mediaAssetId',
                  sourceFixture.mediaAssetId, // Should retain old ID
                ),
              ),
            ),
          ).called(1);
        },
      );

      blocTest<EditSourceBloc, EditSourceState>(
        'fails if initialSource is missing',
        build: buildBloc,
        seed: () => const EditSourceState(
          sourceId: sourceId,
          initialSource: null, // Missing
        ),
        act: (bloc) => bloc.add(const EditSourcePublished()),
        expect: () => [
          isA<EditSourceState>().having(
            (s) => s.status,
            'status',
            EditSourceStatus.entitySubmitting,
          ),
          isA<EditSourceState>().having(
            (s) => s.status,
            'status',
            EditSourceStatus.entitySubmitFailure,
          ),
        ],
      );
    });
  });
}
