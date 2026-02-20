import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_headline/edit_headline_bloc.dart';
import 'package:logging/logging.dart';

import '../../../helpers/helpers.dart';

void main() {
  setUpAll(registerFallbackValues);

  group('EditHeadlineBloc', () {
    late MockDataRepository<Headline> headlinesRepository;
    late MockMediaRepository mediaRepository;

    final headlineFixture = getHeadlinesFixturesData().first;

    final updatedHeadlineFixture = headlineFixture.copyWith(
      title: 'Updated Title',
    );
    final headlineId = headlineFixture.id;
    final imageBytes = Uint8List.fromList([1, 2, 3]);
    const imageFileName = 'new_test.jpg';

    setUp(() {
      headlinesRepository = MockDataRepository<Headline>();
      mediaRepository = MockMediaRepository();

      when(
        () => headlinesRepository.read(id: headlineId),
      ).thenAnswer((_) async => headlineFixture);
    });

    EditHeadlineBloc buildBloc() {
      return EditHeadlineBloc(
        headlinesRepository: headlinesRepository,
        mediaRepository: mediaRepository,
        logger: Logger('TestEditHeadlineBloc'),
        headlineId: headlineId,
      );
    }

    group('constructor and EditHeadlineLoaded', () {
      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'emits [loading, initial] with headline data on successful load',
        act: (bloc) => bloc.add(const EditHeadlineLoaded()),
        build: buildBloc,
        expect: () => <EditHeadlineState>[
          EditHeadlineState(
            headlineId: headlineId,
            status: EditHeadlineStatus.loading,
          ),
          EditHeadlineState(
            headlineId: headlineId,
            status: EditHeadlineStatus.initial,
            title: headlineFixture.title,
            url: headlineFixture.url,
            imageUrl: headlineFixture.imageUrl,
            source: headlineFixture.source,
            topic: headlineFixture.topic,
            eventCountry: headlineFixture.eventCountry,
            isBreaking: headlineFixture.isBreaking,
            initialHeadline: headlineFixture,
          ),
        ],
        verify: (_) {
          verify(() => headlinesRepository.read(id: headlineId)).called(1);
        },
      );

      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'emits [loading, failure] on repository error',
        build: () {
          when(
            () => headlinesRepository.read(id: headlineId),
          ).thenThrow(const NotFoundException('Not found'));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const EditHeadlineLoaded()),
        expect: () => <dynamic>[
          isA<EditHeadlineState>().having(
            (s) => s.status,
            'status',
            EditHeadlineStatus.loading,
          ),
          isA<EditHeadlineState>()
              .having((s) => s.status, 'status', EditHeadlineStatus.failure)
              .having(
                (s) => s.exception,
                'exception',
                isA<NotFoundException>(),
              ),
        ],
      );
    });

    group('EditHeadlineTitleChanged', () {
      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'emits new state with updated title',
        build: buildBloc,
        seed: () => EditHeadlineState(
          headlineId: headlineId,
          status: EditHeadlineStatus.initial,
          title: headlineFixture.title,
          url: headlineFixture.url,
          imageUrl: headlineFixture.imageUrl,
          source: headlineFixture.source,
          topic: headlineFixture.topic,
          eventCountry: headlineFixture.eventCountry,
          isBreaking: headlineFixture.isBreaking,
          initialHeadline: headlineFixture,
        ),
        act: (bloc) => bloc.add(const EditHeadlineTitleChanged('New Title')),
        expect: () => <EditHeadlineState>[
          EditHeadlineState(
            headlineId: headlineId,
            title: 'New Title',
            status: EditHeadlineStatus.initial,
            url: headlineFixture.url,
            imageUrl: headlineFixture.imageUrl,
            source: headlineFixture.source,
            topic: headlineFixture.topic,
            eventCountry: headlineFixture.eventCountry,
            isBreaking: headlineFixture.isBreaking,
            initialHeadline: headlineFixture,
          ),
        ],
      );
    });

    group('EditHeadlineUrlChanged', () {
      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'emits new state with updated url',
        build: buildBloc,
        seed: () => EditHeadlineState(
          headlineId: headlineId,
          initialHeadline: headlineFixture,
          status: EditHeadlineStatus.initial,
          title: headlineFixture.title,
          url: headlineFixture.url,
        ),
        act: (bloc) => bloc.add(const EditHeadlineUrlChanged('http://new.url')),
        expect: () => <dynamic>[
          isA<EditHeadlineState>()
              .having((s) => s.url, 'url', 'http://new.url')
              .having((s) => s.status, 'status', EditHeadlineStatus.initial),
        ],
      );
    });

    group('EditHeadlineImageChanged', () {
      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'emits new state with updated image data',
        build: buildBloc,
        seed: () => EditHeadlineState(
          headlineId: headlineId,
          status: EditHeadlineStatus.initial,
          title: headlineFixture.title,
          url: headlineFixture.url,
          imageUrl: headlineFixture.imageUrl,
          source: headlineFixture.source,
          topic: headlineFixture.topic,
          eventCountry: headlineFixture.eventCountry,
          isBreaking: headlineFixture.isBreaking,
          initialHeadline: headlineFixture,
        ),
        act: (bloc) => bloc.add(
          EditHeadlineImageChanged(
            imageFileBytes: imageBytes,
            imageFileName: imageFileName,
          ),
        ),
        expect: () => <EditHeadlineState>[
          EditHeadlineState(
            headlineId: headlineId,
            imageFileBytes: imageBytes,
            imageFileName: imageFileName,
            status: EditHeadlineStatus.initial,
            title: headlineFixture.title,
            url: headlineFixture.url,
            imageUrl: headlineFixture.imageUrl,
            source: headlineFixture.source,
            topic: headlineFixture.topic,
            eventCountry: headlineFixture.eventCountry,
            isBreaking: headlineFixture.isBreaking,
            initialHeadline: headlineFixture,
          ),
        ],
      );
    });

    group('EditHeadlineImageRemoved', () {
      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'emits new state with imageRemoved set to true',
        build: buildBloc,
        seed: () => EditHeadlineState(
          headlineId: headlineId,
          initialHeadline: headlineFixture,
          status: EditHeadlineStatus.initial,
          imageUrl: headlineFixture.imageUrl,
        ),
        act: (bloc) => bloc.add(const EditHeadlineImageRemoved()),
        expect: () => <dynamic>[
          isA<EditHeadlineState>()
              .having((s) => s.imageFileBytes, 'imageFileBytes', isNull)
              .having((s) => s.imageFileName, 'imageFileName', isNull)
              .having((s) => s.imageRemoved, 'imageRemoved', isTrue)
              .having((s) => s.status, 'status', EditHeadlineStatus.initial),
        ],
      );
    });

    group('EditHeadlineSavedAsDraft', () {
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
          () => headlinesRepository.update(
            id: any(named: 'id'),
            item: any(named: 'item'),
          ),
        ).thenAnswer(
          (_) async =>
              updatedHeadlineFixture.copyWith(status: ContentStatus.draft),
        );
      });

      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'updates without new image successfully',
        build: buildBloc,
        seed: () => EditHeadlineState(
          headlineId: headlineId,
          initialHeadline: headlineFixture,
          title: 'Updated Title',
          url: headlineFixture.url,
          source: headlineFixture.source,
          topic: headlineFixture.topic,
          eventCountry: headlineFixture.eventCountry,
        ),
        act: (bloc) => bloc.add(const EditHeadlineSavedAsDraft()),
        expect: () => <dynamic>[
          isA<EditHeadlineState>().having(
            (s) => s.status,
            'status',
            EditHeadlineStatus.entitySubmitting,
          ),
          isA<EditHeadlineState>()
              .having((s) => s.status, 'status', EditHeadlineStatus.success)
              .having((s) => s.updatedHeadline, 'updatedHeadline', isNotNull),
        ],
        verify: (_) {
          verifyNever(
            () => mediaRepository.uploadFile(
              fileBytes: any(named: 'fileBytes'),
              fileName: any(named: 'fileName'),
              purpose: any(named: 'purpose'),
            ),
          );
          verify(
            () => headlinesRepository.update(
              id: headlineId,
              item: any(
                named: 'item',
                that: isA<Headline>()
                    .having((h) => h.title, 'title', 'Updated Title')
                    .having((h) => h.status, 'status', ContentStatus.draft),
              ),
            ),
          ).called(1);
        },
      );

      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'updates with new image successfully',
        build: buildBloc,
        seed: () => EditHeadlineState(
          headlineId: headlineId,
          initialHeadline: headlineFixture,
          title: 'Updated Title',
          url: headlineFixture.url,
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          source: headlineFixture.source,
          topic: headlineFixture.topic,
          eventCountry: headlineFixture.eventCountry,
        ),
        act: (bloc) => bloc.add(const EditHeadlineSavedAsDraft()),
        expect: () => <dynamic>[
          isA<EditHeadlineState>().having(
            (s) => s.status,
            'status',
            EditHeadlineStatus.imageUploading,
          ),
          isA<EditHeadlineState>().having(
            (s) => s.status,
            'status',
            EditHeadlineStatus.entitySubmitting,
          ),
          isA<EditHeadlineState>()
              .having((s) => s.status, 'status', EditHeadlineStatus.success)
              .having((s) => s.updatedHeadline, 'updatedHeadline', isNotNull),
        ],
        verify: (_) {
          verify(
            () => mediaRepository.uploadFile(
              fileBytes: imageBytes,
              fileName: imageFileName,
              purpose: MediaAssetPurpose.headlineImage,
            ),
          ).called(1);
          verify(
            () => headlinesRepository.update(
              id: headlineId,
              item: any(
                named: 'item',
                that: isA<Headline>()
                    .having(
                      (h) => h.mediaAssetId,
                      'mediaAssetId',
                      mediaAssetId,
                    ) // new image
                    .having((h) => h.status, 'status', ContentStatus.draft)
                    .having((h) => h.imageUrl, 'imageUrl', isNull),
              ),
            ),
          ).called(1);
        },
      );

      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'emits [imageUploading, imageUploadFailure] on upload error',
        build: buildBloc,
        setUp: () {
          when(
            () => mediaRepository.uploadFile(
              fileBytes: any(named: 'fileBytes'),
              fileName: any(named: 'fileName'),
              purpose: any(named: 'purpose'),
            ),
          ).thenThrow(const BadRequestException('File is too large.'));
        },
        seed: () => EditHeadlineState(
          headlineId: headlineId,
          initialHeadline: headlineFixture,
          title: 'Updated Title',
          url: headlineFixture.url,
          imageFileBytes: imageBytes,
          imageFileName: imageFileName,
          source: headlineFixture.source,
          topic: headlineFixture.topic,
          eventCountry: headlineFixture.eventCountry,
        ),
        act: (bloc) => bloc.add(const EditHeadlineSavedAsDraft()),
        expect: () => <dynamic>[
          isA<EditHeadlineState>().having(
            (s) => s.status,
            'status',
            EditHeadlineStatus.imageUploading,
          ),
          isA<EditHeadlineState>()
              .having(
                (s) => s.status,
                'status',
                EditHeadlineStatus.imageUploadFailure,
              )
              .having(
                (s) => s.exception,
                'exception',
                isA<BadRequestException>(),
              ),
        ],
        verify: (_) {
          verifyNever(
            () => headlinesRepository.update(
              id: any(named: 'id'),
              item: any(named: 'item'),
            ),
          );
        },
      );

      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'emits [entitySubmitting, entitySubmitFailure] on repository error',
        build: buildBloc,
        setUp: () {
          when(
            () => headlinesRepository.update(
              id: any(named: 'id'),
              item: any(named: 'item'),
            ),
          ).thenThrow(const NetworkException());
        },
        seed: () => EditHeadlineState(
          headlineId: headlineId,
          initialHeadline: headlineFixture,
          title: 'Updated Title',
          url: headlineFixture.url,
          source: headlineFixture.source,
          topic: headlineFixture.topic,
          eventCountry: headlineFixture.eventCountry,
        ),
        act: (bloc) => bloc.add(const EditHeadlineSavedAsDraft()),
        expect: () => <dynamic>[
          isA<EditHeadlineState>().having(
            (s) => s.status,
            'status',
            EditHeadlineStatus.entitySubmitting,
          ),
          isA<EditHeadlineState>()
              .having(
                (s) => s.status,
                'status',
                EditHeadlineStatus.entitySubmitFailure,
              )
              .having(
                (s) => s.exception,
                'exception',
                isA<NetworkException>(),
              ),
        ],
      );

      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'throws exception if initialHeadline is null on submit',
        build: buildBloc,
        seed: () => EditHeadlineState(
          headlineId: headlineId,
          initialHeadline: null, // This is the key part of the test
          title: 'Updated Title',
        ),
        act: (bloc) => bloc.add(const EditHeadlineSavedAsDraft()),
        expect: () => <dynamic>[
          isA<EditHeadlineState>().having(
            (s) => s.status,
            'status',
            EditHeadlineStatus.entitySubmitting,
          ),
          isA<EditHeadlineState>()
              .having(
                (s) => s.status,
                'status',
                EditHeadlineStatus.entitySubmitFailure,
              )
              .having(
                (s) => s.exception,
                'exception',
                isA<OperationFailedException>(),
              ),
        ],
      );
    });

    group('EditHeadlinePublished', () {
      setUp(() {
        when(
          () => headlinesRepository.update(
            id: any(named: 'id'),
            item: any(named: 'item'),
          ),
        ).thenAnswer((_) async => updatedHeadlineFixture);
      });

      blocTest<EditHeadlineBloc, EditHeadlineState>(
        'updates headline with active status',
        build: buildBloc,
        seed: () => EditHeadlineState(
          headlineId: headlineId,
          initialHeadline: headlineFixture,
          title: 'Updated Title',
          url: headlineFixture.url,
          source: headlineFixture.source,
          topic: headlineFixture.topic,
          eventCountry: headlineFixture.eventCountry,
        ),
        act: (bloc) => bloc.add(const EditHeadlinePublished()),
        verify: (_) {
          final headline =
              verify(
                    () => headlinesRepository.update(
                      id: headlineId,
                      item: captureAny(named: 'item'),
                    ),
                  ).captured.first
                  as Headline;
          expect(headline.status, ContentStatus.active);
          expect(headline.title, 'Updated Title');
        },
      );
    });
  });
}
