import 'dart:async';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/sources_filter/sources_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/topics_filter/topics_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart';

import '../../helpers/helpers.dart';

class MockHeadlinesFilterBloc
    extends MockBloc<HeadlinesFilterEvent, HeadlinesFilterState>
    implements HeadlinesFilterBloc {}

class MockTopicsFilterBloc
    extends MockBloc<TopicsFilterEvent, TopicsFilterState>
    implements TopicsFilterBloc {}

class MockSourcesFilterBloc
    extends MockBloc<SourcesFilterEvent, SourcesFilterState>
    implements SourcesFilterBloc {}

class MockPendingDeletionsService extends Mock
    implements PendingDeletionsService {}

void main() {
  setUpAll(registerFallbackValues);

  group('ContentManagementBloc', () {
    late MockDataRepository<Headline> headlinesRepository;
    late MockDataRepository<Topic> topicsRepository;
    late MockDataRepository<Source> sourcesRepository;
    late MockHeadlinesFilterBloc headlinesFilterBloc;
    late MockTopicsFilterBloc topicsFilterBloc;
    late MockSourcesFilterBloc sourcesFilterBloc;
    late MockPendingDeletionsService pendingDeletionsService;
    late MockDataRepository<RemoteConfig> remoteConfigRepository;

    final headlineFixture = Headline(
      id: 'headline-1',
      title: const {SupportedLanguage.en: 'Test Headline'},
      source: FakeSource(),
      eventCountry: FakeCountry(),
      topic: FakeTopic(),
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
      status: ContentStatus.active,
      isBreaking: false,
      url: 'http://example.com',
      imageUrl: 'http://example.com/image.jpg',
    );

    final topicFixture = FakeTopic();
    final sourceFixture = FakeSource();

    final remoteConfigFixture = RemoteConfig(
      id: 'config-1',
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
      app: const AppConfig(
        maintenance: MaintenanceConfig(isUnderMaintenance: false),
        update: UpdateConfig(
          latestAppVersion: '1.0.0',
          isLatestVersionOnly: false,
          iosUpdateUrl: '',
          androidUpdateUrl: '',
        ),
        general: GeneralAppConfig(
          termsOfServiceUrl: '',
          privacyPolicyUrl: '',
        ),
        localization: LocalizationConfig(
          enabledLanguages: [SupportedLanguage.en],
          defaultLanguage: SupportedLanguage.en,
        ),
      ),
      features: const FeaturesConfig(
        analytics: AnalyticsConfig(
          enabled: true,
          activeProvider: AnalyticsProviders.firebase,
          disabledEvents: {},
          eventSamplingRates: {},
        ),
        ads: AdConfig(
          enabled: true,
          primaryAdPlatform: AdPlatformType.admob,
          platformAdIdentifiers: {},
          feedAdConfiguration: FeedAdConfiguration(
            enabled: true,
            adType: AdType.native,
            visibleTo: {},
          ),
          navigationAdConfiguration: NavigationAdConfiguration(
            enabled: true,
            visibleTo: {},
          ),
        ),
        pushNotifications: PushNotificationConfig(
          enabled: true,
          primaryProvider: PushNotificationProviders.firebase,
          deliveryConfigs: {},
        ),
        feed: FeedConfig(
          itemClickBehavior: FeedItemClickBehavior.defaultBehavior,
          decorators: {},
        ),
        community: CommunityConfig(
          enabled: true,
          engagement: EngagementConfig(
            enabled: true,
            engagementMode: EngagementMode.reactionsAndComments,
          ),
          reporting: ReportingConfig(
            enabled: true,
            headlineReportingEnabled: true,
            sourceReportingEnabled: true,
            commentReportingEnabled: true,
          ),
          appReview: AppReviewConfig(
            enabled: true,
            interactionCycleThreshold: 5,
            initialPromptCooldownDays: 7,
            eligiblePositiveInteractions: [],
            isNegativeFeedbackFollowUpEnabled: true,
            isPositiveFeedbackFollowUpEnabled: true,
          ),
        ),
        rewards: RewardsConfig(enabled: true, rewards: {}),
        onboarding: OnboardingConfig(
          isEnabled: true,
          appTour: AppTourConfig(isEnabled: true, isSkippable: true),
          initialPersonalization: InitialPersonalizationConfig(
            isEnabled: true,
            isSkippable: true,
            isCountrySelectionEnabled: true,
            isTopicSelectionEnabled: true,
            isSourceSelectionEnabled: true,
          ),
        ),
      ),
      user: const UserConfig(
        limits: UserLimitsConfig(
          followedItems: {},
          savedHeadlines: {},
          savedHeadlineFilters: {},
          reactionsPerDay: {},
          commentsPerDay: {},
          reportsPerDay: {},
        ),
      ),
    );

    setUp(() {
      headlinesRepository = MockDataRepository<Headline>();
      topicsRepository = MockDataRepository<Topic>();
      sourcesRepository = MockDataRepository<Source>();
      headlinesFilterBloc = MockHeadlinesFilterBloc();
      topicsFilterBloc = MockTopicsFilterBloc();
      sourcesFilterBloc = MockSourcesFilterBloc();
      pendingDeletionsService = MockPendingDeletionsService();
      remoteConfigRepository = MockDataRepository<RemoteConfig>();

      // Default stream stubs
      when(
        () => headlinesRepository.entityUpdated,
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => topicsRepository.entityUpdated,
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => sourcesRepository.entityUpdated,
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => pendingDeletionsService.deletionEvents,
      ).thenAnswer((_) => const Stream.empty());

      // Default filter states
      when(
        () => headlinesFilterBloc.state,
      ).thenReturn(const HeadlinesFilterState());
      when(() => topicsFilterBloc.state).thenReturn(const TopicsFilterState());
      when(
        () => sourcesFilterBloc.state,
      ).thenReturn(const SourcesFilterState());

      // Default filter building stubs
      when(
        () => headlinesFilterBloc.buildFilterMap(
          languageCode: any(named: 'languageCode'),
        ),
      ).thenReturn({});
      when(() => topicsFilterBloc.buildFilterMap()).thenReturn({});
      when(() => sourcesFilterBloc.buildFilterMap()).thenReturn({});

      // Default remote config stub
      when(
        () => remoteConfigRepository.read(id: any(named: 'id')),
      ).thenAnswer((_) async => remoteConfigFixture);
    });

    ContentManagementBloc buildBloc() {
      return ContentManagementBloc(
        headlinesRepository: headlinesRepository,
        topicsRepository: topicsRepository,
        sourcesRepository: sourcesRepository,
        headlinesFilterBloc: headlinesFilterBloc,
        topicsFilterBloc: topicsFilterBloc,
        sourcesFilterBloc: sourcesFilterBloc,
        pendingDeletionsService: pendingDeletionsService,
        remoteConfigRepository: remoteConfigRepository,
      );
    }

    test('initial state is correct', () {
      expect(buildBloc().state, const ContentManagementState());
    });

    group('ContentManagementTabChanged', () {
      blocTest<ContentManagementBloc, ContentManagementState>(
        'emits state with new active tab',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const ContentManagementTabChanged(ContentManagementTab.topics),
        ),
        expect: () => [
          const ContentManagementState(
            activeTab: ContentManagementTab.topics,
          ),
        ],
      );
    });

    group('LoadHeadlinesRequested', () {
      blocTest<ContentManagementBloc, ContentManagementState>(
        'emits loading and success when readAll succeeds',
        build: () {
          when(
            () => headlinesRepository.readAll(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).thenAnswer(
            (_) async => PaginatedResponse(
              items: [headlineFixture],
              cursor: null,
              hasMore: false,
            ),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoadHeadlinesRequested()),
        expect: () => [
          const ContentManagementState(
            headlinesStatus: ContentManagementStatus.loading,
          ),
          ContentManagementState(
            headlinesStatus: ContentManagementStatus.success,
            headlines: [headlineFixture],
          ),
        ],
      );

      blocTest<ContentManagementBloc, ContentManagementState>(
        'emits failure when readAll throws HttpException',
        build: () {
          when(
            () => headlinesRepository.readAll(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).thenThrow(const NetworkException());
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoadHeadlinesRequested()),
        expect: () => [
          const ContentManagementState(
            headlinesStatus: ContentManagementStatus.loading,
          ),
          const ContentManagementState(
            headlinesStatus: ContentManagementStatus.failure,
            exception: NetworkException(),
          ),
        ],
      );
    });

    group('ArchiveHeadlineRequested', () {
      setUp(() {
        when(
          () => headlinesRepository.readAll(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer(
          (_) async => PaginatedResponse(
            items: [headlineFixture],
            cursor: null,
            hasMore: false,
          ),
        );
      });

      blocTest<ContentManagementBloc, ContentManagementState>(
        'calls update with archived status and reloads',
        build: () {
          when(
            () => headlinesRepository.update(
              id: any<String>(named: 'id'),
              item: any(named: 'item'),
            ),
          ).thenAnswer((_) async => headlineFixture);
          return buildBloc();
        },
        seed: () => ContentManagementState(
          headlinesStatus: ContentManagementStatus.success,
          headlines: [headlineFixture],
        ),
        act: (bloc) => bloc.add(ArchiveHeadlineRequested(headlineFixture.id)),
        verify: (_) {
          verify(
            () => headlinesRepository.update(
              id: headlineFixture.id,
              item: any(
                named: 'item',
                that: isA<Headline>().having(
                  (h) => h.status,
                  'status',
                  ContentStatus.archived,
                ),
              ),
            ),
          ).called(1);
          verify(
            () => headlinesRepository.readAll(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).called(1);
        },
      );
    });

    group('DeleteHeadlineForeverRequested', () {
      blocTest<ContentManagementBloc, ContentManagementState>(
        'optimistically removes item and requests deletion service',
        build: () {
          when(
            () => pendingDeletionsService.requestDeletion(
              item: any<Headline>(named: 'item'),
              repository: any<DataRepository<Headline>>(named: 'repository'),
              undoDuration: any<Duration>(named: 'undoDuration'),
            ),
          ).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => ContentManagementState(
          headlinesStatus: ContentManagementStatus.success,
          headlines: [headlineFixture],
        ),
        act: (bloc) =>
            bloc.add(DeleteHeadlineForeverRequested(headlineFixture.id)),
        expect: () => [
          ContentManagementState(
            headlinesStatus: ContentManagementStatus.success,
            headlines: const [],
            lastPendingDeletionId: headlineFixture.id,
            itemPendingDeletion: headlineFixture,
          ),
        ],
        verify: (_) {
          verify(
            () => pendingDeletionsService.requestDeletion(
              item: headlineFixture,
              repository: any<DataRepository<Headline>>(named: 'repository'),
              undoDuration: any<Duration>(named: 'undoDuration'),
            ),
          ).called(1);
        },
      );
    });

    group('DeletionEventReceived', () {
      blocTest<ContentManagementBloc, ContentManagementState>(
        'handles confirmed deletion',
        build: buildBloc,
        seed: () => ContentManagementState(
          headlines: const [],
          lastPendingDeletionId: '1',
          itemPendingDeletion: headlineFixture,
        ),
        act: (bloc) => bloc.add(
          DeletionEventReceived(
            DeletionEvent(
              '1',
              DeletionStatus.confirmed,
              item: headlineFixture,
            ),
          ),
        ),
        expect: () => [
          const ContentManagementState(
            headlines: [],
            lastPendingDeletionId: null,
            itemPendingDeletion: null,
          ),
        ],
      );

      blocTest<ContentManagementBloc, ContentManagementState>(
        'handles undone deletion for headline',
        build: buildBloc,
        seed: () => ContentManagementState(
          headlines: const [],
          lastPendingDeletionId: '1',
          itemPendingDeletion: headlineFixture,
        ),
        act: (bloc) => bloc.add(
          DeletionEventReceived(
            DeletionEvent(
              '1',
              DeletionStatus.undone,
              item: headlineFixture,
            ),
          ),
        ),
        expect: () => [
          ContentManagementState(
            headlines: [headlineFixture],
            lastPendingDeletionId: null,
            itemPendingDeletion: null,
          ),
        ],
      );
    });

    group('Repository Updates', () {
      test('reloads headlines when repository emits update', () async {
        final controller = StreamController<Type>.broadcast();
        when(
          () => headlinesRepository.entityUpdated,
        ).thenAnswer((_) => controller.stream);
        when(
          () => headlinesRepository.readAll(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer(
          (_) async => PaginatedResponse(
            items: [headlineFixture],
            cursor: null,
            hasMore: false,
          ),
        );

        final bloc = buildBloc();
        // Trigger the listener
        controller.add(Headline);

        await expectLater(
          bloc.stream,
          emitsInOrder([
            const ContentManagementState(
              headlinesStatus: ContentManagementStatus.loading,
            ),
            ContentManagementState(
              headlinesStatus: ContentManagementStatus.success,
              headlines: [headlineFixture],
            ),
          ]),
        );
        await bloc.close();
      });
    });

    group('LoadTopicsRequested', () {
      blocTest<ContentManagementBloc, ContentManagementState>(
        'emits loading and success when readAll succeeds',
        build: () {
          when(
            () => topicsRepository.readAll(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).thenAnswer(
            (_) async => PaginatedResponse(
              items: [topicFixture],
              cursor: null,
              hasMore: false,
            ),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoadTopicsRequested()),
        expect: () => [
          const ContentManagementState(
            topicsStatus: ContentManagementStatus.loading,
          ),
          ContentManagementState(
            topicsStatus: ContentManagementStatus.success,
            topics: [topicFixture],
          ),
        ],
      );
    });

    group('LoadSourcesRequested', () {
      blocTest<ContentManagementBloc, ContentManagementState>(
        'emits loading and success when readAll succeeds',
        build: () {
          when(
            () => sourcesRepository.readAll(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).thenAnswer(
            (_) async => PaginatedResponse(
              items: [sourceFixture],
              cursor: null,
              hasMore: false,
            ),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoadSourcesRequested()),
        expect: () => [
          const ContentManagementState(
            sourcesStatus: ContentManagementStatus.loading,
          ),
          ContentManagementState(
            sourcesStatus: ContentManagementStatus.success,
            sources: [sourceFixture],
          ),
        ],
      );
    });

    group('UndoDeleteHeadlineRequested', () {
      blocTest<ContentManagementBloc, ContentManagementState>(
        'calls undoDeletion on service',
        build: () {
          when(
            () => pendingDeletionsService.undoDeletion(any()),
          ).thenAnswer((_) {});
          return buildBloc();
        },
        act: (bloc) => bloc.add(const UndoDeleteHeadlineRequested('id')),
        verify: (_) {
          verify(() => pendingDeletionsService.undoDeletion('id')).called(1);
        },
      );
    });

    group('PublishHeadlineRequested', () {
      setUp(() {
        when(
          () => headlinesRepository.readAll(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer(
          (_) async => PaginatedResponse(
            items: [headlineFixture],
            cursor: null,
            hasMore: false,
          ),
        );
      });

      blocTest<ContentManagementBloc, ContentManagementState>(
        'calls update with active status and reloads',
        build: () {
          when(
            () => headlinesRepository.update(
              id: any<String>(named: 'id'),
              item: any(named: 'item'),
            ),
          ).thenAnswer((_) async => headlineFixture);
          return buildBloc();
        },
        seed: () => ContentManagementState(
          headlinesStatus: ContentManagementStatus.success,
          headlines: [headlineFixture],
        ),
        act: (bloc) => bloc.add(PublishHeadlineRequested(headlineFixture.id)),
        verify: (_) {
          verify(
            () => headlinesRepository.update(
              id: headlineFixture.id,
              item: any(
                named: 'item',
                that: isA<Headline>().having(
                  (h) => h.status,
                  'status',
                  ContentStatus.active,
                ),
              ),
            ),
          ).called(1);
        },
      );
    });

    group('RestoreHeadlineRequested', () {
      setUp(() {
        when(
          () => headlinesRepository.readAll(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer(
          (_) async => PaginatedResponse(
            items: [headlineFixture],
            cursor: null,
            hasMore: false,
          ),
        );
      });

      blocTest<ContentManagementBloc, ContentManagementState>(
        'calls update with active status and reloads',
        build: () {
          when(
            () => headlinesRepository.update(
              id: any<String>(named: 'id'),
              item: any(named: 'item'),
            ),
          ).thenAnswer((_) async => headlineFixture);
          return buildBloc();
        },
        seed: () => ContentManagementState(
          headlinesStatus: ContentManagementStatus.success,
          headlines: [headlineFixture],
        ),
        act: (bloc) => bloc.add(RestoreHeadlineRequested(headlineFixture.id)),
        verify: (_) {
          verify(
            () => headlinesRepository.update(
              id: headlineFixture.id,
              item: any(
                named: 'item',
                that: isA<Headline>().having(
                  (h) => h.status,
                  'status',
                  ContentStatus.active,
                ),
              ),
            ),
          ).called(1);
        },
      );
    });
  });
}
