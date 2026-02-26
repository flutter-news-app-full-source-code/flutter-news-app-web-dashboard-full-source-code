import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_topic/create_topic_bloc.dart';
import 'package:logging/logging.dart';

import '../../helpers/helpers.dart';

void main() {
  setUpAll(registerFallbackValues);

  group('CreateTopicBloc', () {
    late DataRepository<Topic> topicsRepository;
    late MediaRepository mediaRepository;

    final kTestImageBytes = Uint8List.fromList([1, 2, 3]);
    const kTestImageFileName = 'test.png';
    const kTestMediaAssetId = 'media-asset-id-123';

    setUp(() {
      topicsRepository = MockDataRepository<Topic>();
      mediaRepository = MockMediaRepository();
      Logger.root.level = Level.OFF;

      when(
        () => mediaRepository.uploadFile(
          fileBytes: any(named: 'fileBytes'),
          fileName: any(named: 'fileName'),
          purpose: any(named: 'purpose'),
        ),
      ).thenAnswer((_) async => kTestMediaAssetId);

      when(
        () => topicsRepository.create(item: any(named: 'item')),
      ).thenAnswer(
        (invocation) async => invocation.namedArguments[#item] as Topic,
      );
    });

    CreateTopicBloc buildBloc() {
      return CreateTopicBloc(
        topicsRepository: topicsRepository,
        mediaRepository: mediaRepository,
        logger: Logger('TestCreateTopicBloc'),
      );
    }

    test('initial state is correct', () {
      expect(buildBloc().state, const CreateTopicState());
    });

    group('event handlers', () {
      blocTest<CreateTopicBloc, CreateTopicState>(
        'emits new state when CreateTopicNameChanged is added',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const CreateTopicNameChanged({SupportedLanguage.en: 'New Name'}),
        ),
        expect: () => [
          const CreateTopicState(name: {SupportedLanguage.en: 'New Name'}),
        ],
      );

      blocTest<CreateTopicBloc, CreateTopicState>(
        'updates map when name for a language is cleared',
        build: buildBloc,
        seed: () => const CreateTopicState(
          name: {SupportedLanguage.en: 'Existing Name'},
        ),
        act: (bloc) => bloc.add(
          const CreateTopicNameChanged({}),
        ),
        expect: () => [
          const CreateTopicState(name: {}),
        ],
      );

      blocTest<CreateTopicBloc, CreateTopicState>(
        'emits new state when CreateTopicDescriptionChanged is added',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const CreateTopicDescriptionChanged(
            {SupportedLanguage.en: 'New Description'},
          ),
        ),
        expect: () => [
          const CreateTopicState(
            description: {SupportedLanguage.en: 'New Description'},
          ),
        ],
      );

      blocTest<CreateTopicBloc, CreateTopicState>(
        'updates map when description for a language is cleared',
        build: buildBloc,
        seed: () => const CreateTopicState(
          description: {SupportedLanguage.en: 'Existing Description'},
        ),
        act: (bloc) => bloc.add(
          const CreateTopicDescriptionChanged({}),
        ),
        expect: () => [
          const CreateTopicState(description: {}),
        ],
      );

      blocTest<CreateTopicBloc, CreateTopicState>(
        'emits new state when CreateTopicImageChanged is added',
        build: buildBloc,
        act: (bloc) => bloc.add(
          CreateTopicImageChanged(
            imageFileBytes: kTestImageBytes,
            imageFileName: kTestImageFileName,
          ),
        ),
        expect: () => [
          CreateTopicState(
            imageFileBytes: kTestImageBytes,
            imageFileName: kTestImageFileName,
          ),
        ],
      );

      blocTest<CreateTopicBloc, CreateTopicState>(
        'emits new state when CreateTopicImageRemoved is added',
        build: buildBloc,
        seed: () => CreateTopicState(
          imageFileBytes: kTestImageBytes,
          imageFileName: kTestImageFileName,
        ),
        act: (bloc) => bloc.add(const CreateTopicImageRemoved()),
        expect: () => [
          const CreateTopicState(
            imageFileBytes: null,
            imageFileName: null,
          ),
        ],
      );
    });

    group('submission', () {
      blocTest<CreateTopicBloc, CreateTopicState>(
        'handles successful publishing with image',
        build: buildBloc,
        seed: () => CreateTopicState(
          name: const {SupportedLanguage.en: 'Test Topic'},
          description: const {SupportedLanguage.en: 'Test Description'},
          imageFileBytes: kTestImageBytes,
          imageFileName: kTestImageFileName,
        ),
        act: (bloc) => bloc.add(const CreateTopicPublished()),
        expect: () => [
          isA<CreateTopicState>().having(
            (s) => s.status,
            'status',
            CreateTopicStatus.imageUploading,
          ),
          isA<CreateTopicState>().having(
            (s) => s.status,
            'status',
            CreateTopicStatus.entitySubmitting,
          ),
          isA<CreateTopicState>()
              .having((s) => s.status, 'status', CreateTopicStatus.success)
              .having((s) => s.createdTopic, 'createdTopic', isNotNull)
              .having(
                (s) => s.createdTopic!.mediaAssetId,
                'mediaAssetId',
                kTestMediaAssetId,
              )
              .having(
                (s) => s.createdTopic!.status,
                'contentStatus',
                ContentStatus.active,
              ),
        ],
        verify: (_) {
          verify(
            () => mediaRepository.uploadFile(
              fileBytes: kTestImageBytes,
              fileName: kTestImageFileName,
              purpose: MediaAssetPurpose.topicImage,
            ),
          ).called(1);
          verify(
            () => topicsRepository.create(item: any(named: 'item')),
          ).called(1);
        },
      );

      blocTest<CreateTopicBloc, CreateTopicState>(
        'handles successful saving as draft without image',
        build: buildBloc,
        seed: () => const CreateTopicState(
          name: {SupportedLanguage.en: 'Draft Topic'},
          description: {SupportedLanguage.en: 'Draft Description'},
        ),
        act: (bloc) => bloc.add(const CreateTopicSavedAsDraft()),
        expect: () => [
          isA<CreateTopicState>().having(
            (s) => s.status,
            'status',
            CreateTopicStatus.entitySubmitting,
          ),
          isA<CreateTopicState>()
              .having((s) => s.status, 'status', CreateTopicStatus.success)
              .having((s) => s.createdTopic, 'createdTopic', isNotNull)
              .having(
                (s) => s.createdTopic!.status,
                'contentStatus',
                ContentStatus.draft,
              ),
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
            () => topicsRepository.create(item: any(named: 'item')),
          ).called(1);
        },
      );

      blocTest<CreateTopicBloc, CreateTopicState>(
        'handles image upload failure',
        build: buildBloc,
        seed: () => CreateTopicState(
          name: const {SupportedLanguage.en: 'Test Topic'},
          description: const {SupportedLanguage.en: 'Test Description'},
          imageFileBytes: kTestImageBytes,
          imageFileName: kTestImageFileName,
        ),
        setUp: () {
          when(
            () => mediaRepository.uploadFile(
              fileBytes: any(named: 'fileBytes'),
              fileName: any(named: 'fileName'),
              purpose: any(named: 'purpose'),
            ),
          ).thenThrow(const NetworkException());
        },
        act: (bloc) => bloc.add(const CreateTopicPublished()),
        expect: () => [
          isA<CreateTopicState>().having(
            (s) => s.status,
            'status',
            CreateTopicStatus.imageUploading,
          ),
          isA<CreateTopicState>()
              .having(
                (s) => s.status,
                'status',
                CreateTopicStatus.imageUploadFailure,
              )
              .having((s) => s.exception, 'exception', isA<NetworkException>()),
        ],
        verify: (_) {
          verifyNever(() => topicsRepository.create(item: any(named: 'item')));
        },
      );

      blocTest<CreateTopicBloc, CreateTopicState>(
        'handles entity submission failure',
        build: buildBloc,
        seed: () => const CreateTopicState(
          name: {SupportedLanguage.en: 'Test Topic'},
          description: {SupportedLanguage.en: 'Test Description'},
        ),
        setUp: () {
          when(
            () => topicsRepository.create(item: any(named: 'item')),
          ).thenThrow(const NetworkException());
        },
        act: (bloc) => bloc.add(const CreateTopicPublished()),
        expect: () => [
          isA<CreateTopicState>().having(
            (s) => s.status,
            'status',
            CreateTopicStatus.entitySubmitting,
          ),
          isA<CreateTopicState>()
              .having(
                (s) => s.status,
                'status',
                CreateTopicStatus.entitySubmitFailure,
              )
              .having((s) => s.exception, 'exception', isA<NetworkException>()),
        ],
      );
    });
  });
}
