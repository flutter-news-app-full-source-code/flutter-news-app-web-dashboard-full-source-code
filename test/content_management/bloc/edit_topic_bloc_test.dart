import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_topic/edit_topic_bloc.dart';
import 'package:logging/logging.dart';

import '../../helpers/helpers.dart';

void main() {
  setUpAll(registerFallbackValues);

  group('EditTopicBloc', () {
    late DataRepository<Topic> topicsRepository;
    late MediaRepository mediaRepository;

    const kTestTopicId = 'topic-id-123';
    final kTestImageBytes = Uint8List.fromList([1, 2, 3]);
    const kTestImageFileName = 'test.png';
    const kTestMediaAssetId = 'media-asset-id-456';
    final kNow = DateTime.now();
    final kInitialTopic = Topic(
      id: kTestTopicId,
      name: const {SupportedLanguage.en: 'Initial Name'},
      description: const {SupportedLanguage.en: 'Initial Description'},
      createdAt: kNow,
      updatedAt: kNow,
      status: ContentStatus.draft,
      iconUrl: 'http://initial.url/image.png',
      mediaAssetId: 'initial-media-id',
    );

    setUp(() {
      topicsRepository = MockDataRepository<Topic>();
      mediaRepository = MockMediaRepository();
      Logger.root.level = Level.OFF;

      when(
        () => topicsRepository.read(id: any(named: 'id')),
      ).thenAnswer((_) async => kInitialTopic);

      when(
        () => topicsRepository.update(
          id: any(named: 'id'),
          item: any(named: 'item'),
        ),
      ).thenAnswer(
        (invocation) async => invocation.namedArguments[#item] as Topic,
      );

      when(
        () => mediaRepository.uploadFile(
          fileBytes: any(named: 'fileBytes'),
          fileName: any(named: 'fileName'),
          purpose: any(named: 'purpose'),
        ),
      ).thenAnswer((_) async => kTestMediaAssetId);
    });

    EditTopicBloc buildBloc() {
      return EditTopicBloc(
        topicsRepository: topicsRepository,
        mediaRepository: mediaRepository,
        topicId: kTestTopicId,
      );
    }

    group('constructor and initial loading', () {
      test('has correct initial synchronous state', () {
        // The constructor is synchronous and should set the initial state
        // before any async operations.
        final bloc = EditTopicBloc(
          topicsRepository: topicsRepository,
          mediaRepository: mediaRepository,
          topicId: kTestTopicId,
        );
        expect(
          bloc.state,
          const EditTopicState(
            topicId: kTestTopicId,
            status: EditTopicStatus.loading,
          ),
        );
      });

      blocTest<EditTopicBloc, EditTopicState>(
        'emits [loading, initial] when EditTopicLoaded is successful',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const EditTopicLoaded(
            enabledLanguages: [SupportedLanguage.en],
            defaultLanguage: SupportedLanguage.en,
          ),
        ),
        expect: () => [
          const EditTopicState(
            topicId: kTestTopicId,
            status: EditTopicStatus.loading,
          ),
          EditTopicState(
            topicId: kTestTopicId,
            enabledLanguages: const [SupportedLanguage.en],
            defaultLanguage: SupportedLanguage.en,
            status: EditTopicStatus.initial,
            initialTopic: kInitialTopic,
            name: kInitialTopic.name,
            description: kInitialTopic.description,
            iconUrl: kInitialTopic.iconUrl,
          ),
        ],
        verify: (_) {
          verify(() => topicsRepository.read(id: kTestTopicId)).called(1);
        },
      );

      blocTest<EditTopicBloc, EditTopicState>(
        'emits [loading, failure] when topicsRepository.read throws',
        setUp: () {
          when(
            () => topicsRepository.read(id: any(named: 'id')),
          ).thenThrow(const NetworkException());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const EditTopicLoaded(
            enabledLanguages: [SupportedLanguage.en],
            defaultLanguage: SupportedLanguage.en,
          ),
        ),
        expect: () => [
          const EditTopicState(
            topicId: kTestTopicId,
            status: EditTopicStatus.loading,
          ),
          const EditTopicState(
            topicId: kTestTopicId,
            status: EditTopicStatus.failure,
            exception: NetworkException(),
          ),
        ],
      );
    });

    group('event handlers', () {
      blocTest<EditTopicBloc, EditTopicState>(
        'emits new state when EditTopicNameChanged is added',
        build: buildBloc,
        seed: () => EditTopicState(
          topicId: kTestTopicId,
          initialTopic: kInitialTopic,
          name: kInitialTopic.name,
          description: kInitialTopic.description,
          iconUrl: kInitialTopic.iconUrl,
          status: EditTopicStatus.initial,
        ),
        act: (bloc) => bloc.add(
          const EditTopicNameChanged('New Name', SupportedLanguage.en),
        ),
        expect: () => [
          EditTopicState(
            topicId: kTestTopicId,
            initialTopic: kInitialTopic,
            name: const {
              SupportedLanguage.en: 'New Name',
            },
            description: kInitialTopic.description,
            iconUrl: kInitialTopic.iconUrl,
            status: EditTopicStatus.initial,
          ),
        ],
      );

      blocTest<EditTopicBloc, EditTopicState>(
        'emits new state when EditTopicDescriptionChanged is added',
        build: buildBloc,
        seed: () => EditTopicState(
          topicId: kTestTopicId,
          initialTopic: kInitialTopic,
          name: kInitialTopic.name,
          description: kInitialTopic.description,
          iconUrl: kInitialTopic.iconUrl,
          status: EditTopicStatus.initial,
        ),
        act: (bloc) => bloc.add(
          const EditTopicDescriptionChanged(
            'New Description',
            SupportedLanguage.en,
          ),
        ),
        expect: () => [
          EditTopicState(
            topicId: kTestTopicId,
            initialTopic: kInitialTopic,
            name: kInitialTopic.name,
            description: const {SupportedLanguage.en: 'New Description'},
            iconUrl: kInitialTopic.iconUrl,
            status: EditTopicStatus.initial,
          ),
        ],
      );

      blocTest<EditTopicBloc, EditTopicState>(
        'emits new state when EditTopicImageChanged is added',
        build: buildBloc,
        seed: () => EditTopicState(
          topicId: kTestTopicId,
          initialTopic: kInitialTopic,
          name: kInitialTopic.name,
          description: kInitialTopic.description,
          iconUrl: kInitialTopic.iconUrl,
          status: EditTopicStatus.initial,
        ),
        act: (bloc) => bloc.add(
          EditTopicImageChanged(
            imageFileBytes: kTestImageBytes,
            imageFileName: kTestImageFileName,
          ),
        ),
        expect: () => [
          EditTopicState(
            topicId: kTestTopicId,
            initialTopic: kInitialTopic,
            name: kInitialTopic.name,
            description: kInitialTopic.description,
            iconUrl: kInitialTopic.iconUrl,
            imageFileBytes: kTestImageBytes,
            imageFileName: kTestImageFileName,
            imageRemoved: false,
            status: EditTopicStatus.initial,
          ),
        ],
      );

      blocTest<EditTopicBloc, EditTopicState>(
        'emits new state when EditTopicImageRemoved is added',
        build: buildBloc,
        seed: () => EditTopicState(
          topicId: kTestTopicId,
          initialTopic: kInitialTopic,
          name: kInitialTopic.name,
          description: kInitialTopic.description,
          iconUrl: kInitialTopic.iconUrl,
          imageFileBytes: kTestImageBytes,
          imageFileName: kTestImageFileName,
          status: EditTopicStatus.initial,
        ),
        act: (bloc) => bloc.add(const EditTopicImageRemoved()),
        expect: () => [
          EditTopicState(
            topicId: kTestTopicId,
            initialTopic: kInitialTopic,
            name: kInitialTopic.name,
            description: kInitialTopic.description,
            iconUrl: null,
            imageFileBytes: null,
            imageFileName: null,
            imageRemoved: true,
            status: EditTopicStatus.initial,
          ),
        ],
      );
    });

    group('submission', () {
      blocTest<EditTopicBloc, EditTopicState>(
        'handles successful publishing with image update',
        build: buildBloc,
        seed: () => EditTopicState(
          topicId: kTestTopicId,
          initialTopic: kInitialTopic,
          name: const {SupportedLanguage.en: 'Updated Name'},
          description: const {SupportedLanguage.en: 'Updated Description'},
          imageFileBytes: kTestImageBytes,
          imageFileName: kTestImageFileName,
          status: EditTopicStatus.initial,
        ),
        act: (bloc) => bloc.add(const EditTopicPublished()),
        expect: () => [
          isA<EditTopicState>().having(
            (s) => s.status,
            'status',
            EditTopicStatus.imageUploading,
          ),
          isA<EditTopicState>().having(
            (s) => s.status,
            'status',
            EditTopicStatus.entitySubmitting,
          ),
          isA<EditTopicState>()
              .having((s) => s.status, 'status', EditTopicStatus.success)
              .having((s) => s.updatedTopic, 'updatedTopic', isNotNull)
              .having(
                (s) => s.updatedTopic!.name[SupportedLanguage.en],
                'name',
                'Updated Name',
              )
              .having(
                (s) => s.updatedTopic!.mediaAssetId,
                'mediaAssetId',
                kTestMediaAssetId,
              )
              .having((s) => s.updatedTopic!.iconUrl, 'iconUrl', isNull)
              .having(
                (s) => s.updatedTopic!.status,
                'status',
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
            () => topicsRepository.update(
              id: kTestTopicId,
              item: any(named: 'item'),
            ),
          ).called(1);
        },
      );
    });
  });
}
