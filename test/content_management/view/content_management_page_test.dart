import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/config/config.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/sources_filter/sources_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/topics_filter/topics_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/content_management_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:go_router/go_router.dart' as go_router;

import '../../helpers/helpers.dart';
import '../../helpers/pump_app.dart';

class MockContentManagementBloc
    extends MockBloc<ContentManagementEvent, ContentManagementState>
    implements ContentManagementBloc {}

class MockHeadlinesFilterBloc
    extends MockBloc<HeadlinesFilterEvent, HeadlinesFilterState>
    implements HeadlinesFilterBloc {}

class MockTopicsFilterBloc
    extends MockBloc<TopicsFilterEvent, TopicsFilterState>
    implements TopicsFilterBloc {}

class MockSourcesFilterBloc
    extends MockBloc<SourcesFilterEvent, SourcesFilterState>
    implements SourcesFilterBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockGoRouter extends Mock implements go_router.GoRouter {}

void main() {
  setUpAll(() {
    registerFallbackValues();
    registerFallbackValue(const HeadlinesFilterState());
    registerFallbackValue(const TopicsFilterState());
    registerFallbackValue(const SourcesFilterState());
    registerFallbackValue(const LoadHeadlinesRequested());
  });

  group('ContentManagementPage', () {
    late MockContentManagementBloc contentManagementBloc;
    late MockHeadlinesFilterBloc headlinesFilterBloc;
    late MockTopicsFilterBloc topicsFilterBloc;
    late MockSourcesFilterBloc sourcesFilterBloc;
    late MockAppBloc appBloc;
    late MockDataRepository<Headline> headlinesRepository;
    late MockDataRepository<Topic> topicsRepository;
    late MockDataRepository<Source> sourcesRepository;
    late MockDataRepository<Country> countriesRepository;
    late MockDataRepository<Language> languagesRepository;
    late MockGoRouter goRouter;

    setUp(() {
      contentManagementBloc = MockContentManagementBloc();
      headlinesFilterBloc = MockHeadlinesFilterBloc();
      topicsFilterBloc = MockTopicsFilterBloc();
      sourcesFilterBloc = MockSourcesFilterBloc();
      appBloc = MockAppBloc();
      headlinesRepository = MockDataRepository<Headline>();
      topicsRepository = MockDataRepository<Topic>();
      sourcesRepository = MockDataRepository<Source>();
      countriesRepository = MockDataRepository<Country>();
      languagesRepository = MockDataRepository<Language>();
      goRouter = MockGoRouter();

      reset(contentManagementBloc);
      reset(headlinesFilterBloc);
      reset(topicsFilterBloc);
      reset(sourcesFilterBloc);
      reset(appBloc);

      when(() => contentManagementBloc.state).thenReturn(
        const ContentManagementState(),
      );

      when(
        () => headlinesFilterBloc.state,
      ).thenReturn(const HeadlinesFilterState());
      when(() => topicsFilterBloc.state).thenReturn(const TopicsFilterState());
      when(
        () => sourcesFilterBloc.state,
      ).thenReturn(const SourcesFilterState());

      // Stub buildFilterMap methods
      when(
        () => headlinesFilterBloc.buildFilterMap(
          languageCode: any(named: 'languageCode'),
        ),
      ).thenReturn({});
      when(() => topicsFilterBloc.buildFilterMap()).thenReturn({});
      when(() => sourcesFilterBloc.buildFilterMap()).thenReturn({});

      // Stub streams to prevent null pointer errors in BlocListener
      when(
        () => headlinesFilterBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([]));
      when(
        () => topicsFilterBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([]));
      when(
        () => sourcesFilterBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([]));
      when(
        () => contentManagementBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([]));

      // Stub AppBloc state
      when(() => appBloc.state).thenReturn(
        const AppState(environment: AppEnvironment.development),
      );

      when(
        () => goRouter.pushNamed(
          any(),
          pathParameters: any(named: 'pathParameters'),
          queryParameters: any(named: 'queryParameters'),
          extra: any(named: 'extra'),
        ),
      ).thenAnswer((_) async => null);
    });

    Widget buildSubject() {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<DataRepository<Headline>>.value(
            value: headlinesRepository,
          ),
          RepositoryProvider<DataRepository<Topic>>.value(
            value: topicsRepository,
          ),
          RepositoryProvider<DataRepository<Source>>.value(
            value: sourcesRepository,
          ),
          RepositoryProvider<DataRepository<Country>>.value(
            value: countriesRepository,
          ),
          RepositoryProvider<DataRepository<Language>>.value(
            value: languagesRepository,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>.value(value: appBloc),
            BlocProvider<ContentManagementBloc>.value(
              value: contentManagementBloc,
            ),
            BlocProvider<HeadlinesFilterBloc>.value(
              value: headlinesFilterBloc,
            ),
            BlocProvider<TopicsFilterBloc>.value(
              value: topicsFilterBloc,
            ),
            BlocProvider<SourcesFilterBloc>.value(
              value: sourcesFilterBloc,
            ),
          ],
          child: const ContentManagementPage(),
        ),
      );
    }

    testWidgets('renders TabBar with correct tabs', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));

      expect(find.text(l10n.headlines), findsOneWidget);
      expect(find.text(l10n.topics), findsOneWidget);
      expect(find.text(l10n.sources), findsOneWidget);
    });

    testWidgets('updates active tab on tap', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));

      await tester.tap(find.text(l10n.topics));
      await tester.pumpAndSettle();

      verify(
        () => contentManagementBloc.add(
          const ContentManagementTabChanged(ContentManagementTab.topics),
        ),
      ).called(1);
    });

    group('FloatingActionButton', () {
      testWidgets('navigates to create headline when headlines tab is active', (
        tester,
      ) async {
        when(() => contentManagementBloc.state).thenReturn(
          const ContentManagementState(
            activeTab: ContentManagementTab.headlines,
          ),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);

        await tester.tap(find.byType(FloatingActionButton));

        verify(() => goRouter.pushNamed(Routes.createHeadlineName)).called(1);
      });

      testWidgets('navigates to create topic when topics tab is active', (
        tester,
      ) async {
        when(() => contentManagementBloc.state).thenReturn(
          const ContentManagementState(
            activeTab: ContentManagementTab.topics,
          ),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);

        await tester.tap(find.byType(FloatingActionButton));

        verify(() => goRouter.pushNamed(Routes.createTopicName)).called(1);
      });

      testWidgets('navigates to create source when sources tab is active', (
        tester,
      ) async {
        when(() => contentManagementBloc.state).thenReturn(
          const ContentManagementState(
            activeTab: ContentManagementTab.sources,
          ),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);

        await tester.tap(find.byType(FloatingActionButton));

        verify(() => goRouter.pushNamed(Routes.createSourceName)).called(1);
      });
    });

    testWidgets('navigates to filter dialog on filter button tap', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);

      await tester.tap(find.byIcon(Icons.filter_list));

      verify(
        () => goRouter.pushNamed(
          Routes.filterDialogName,
          extra: any(named: 'extra'),
        ),
      ).called(1);
    });

    group('Filter Listeners', () {
      testWidgets('loads headlines when headlines filter changes', (
        tester,
      ) async {
        whenListen(
          headlinesFilterBloc,
          Stream.fromIterable([
            const HeadlinesFilterState(searchQuery: 'test'),
          ]),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pump();

        final verification = verify(
          () => contentManagementBloc.add(captureAny()),
        )..called(greaterThan(0));
        expect(verification.captured.last, isA<LoadHeadlinesRequested>());
      });

      testWidgets('loads topics when topics filter changes', (tester) async {
        whenListen(
          topicsFilterBloc,
          Stream.fromIterable([
            const TopicsFilterState(searchQuery: 'test'),
          ]),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pump();

        final verification = verify(
          () => contentManagementBloc.add(captureAny()),
        )..called(greaterThan(0));
        expect(verification.captured.last, isA<LoadTopicsRequested>());
      });

      testWidgets('loads sources when sources filter changes', (tester) async {
        whenListen(
          sourcesFilterBloc,
          Stream.fromIterable([
            const SourcesFilterState(searchQuery: 'test'),
          ]),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pump();

        final verification = verify(
          () => contentManagementBloc.add(captureAny()),
        )..called(greaterThan(0));
        expect(verification.captured.last, isA<LoadSourcesRequested>());
      });
    });

    group('Deletion Snackbar', () {
      final headline = Headline(
        id: '1',
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

      testWidgets('shows snackbar when itemPendingDeletion changes', (
        tester,
      ) async {
        whenListen(
          contentManagementBloc,
          Stream.fromIterable([
            ContentManagementState(
              itemPendingDeletion: headline,
              lastPendingDeletionId: '1',
            ),
          ]),
          initialState: const ContentManagementState(),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Undo'), findsOneWidget);
      });

      testWidgets('undo action triggers UndoDeleteHeadlineRequested', (
        tester,
      ) async {
        whenListen(
          contentManagementBloc,
          Stream.fromIterable([
            ContentManagementState(
              activeTab: ContentManagementTab.headlines,
              itemPendingDeletion: headline,
              lastPendingDeletionId: '1',
            ),
          ]),
          initialState: const ContentManagementState(),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pump();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Undo'));

        verify(
          () => contentManagementBloc.add(
            const UndoDeleteHeadlineRequested('1'),
          ),
        ).called(1);
      });

      testWidgets('undo action triggers UndoDeleteTopicRequested', (
        tester,
      ) async {
        final topic = Topic(
          id: '2',
          name: const {SupportedLanguage.en: 'Test Topic'},
          description: const {SupportedLanguage.en: 'Description'},
          createdAt: DateTime(2023),
          updatedAt: DateTime(2023),
          status: ContentStatus.active,
        );
        whenListen(
          contentManagementBloc,
          Stream.fromIterable([
            ContentManagementState(
              activeTab: ContentManagementTab.topics,
              itemPendingDeletion: topic,
              lastPendingDeletionId: '2',
            ),
          ]),
          initialState: const ContentManagementState(),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pump();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Undo'));

        verify(
          () => contentManagementBloc.add(const UndoDeleteTopicRequested('2')),
        ).called(1);
      });

      testWidgets('undo action triggers UndoDeleteSourceRequested', (
        tester,
      ) async {
        final source = Source(
          id: '3',
          name: const {SupportedLanguage.en: 'Test Source'},
          description: const {SupportedLanguage.en: 'Description'},
          url: 'http://example.com',
          sourceType: SourceType.blog,
          language: SupportedLanguage.en,
          headquarters: FakeCountry(),
          createdAt: DateTime(2023),
          updatedAt: DateTime(2023),
          status: ContentStatus.active,
        );

        whenListen(
          contentManagementBloc,
          Stream.fromIterable([
            ContentManagementState(
              activeTab: ContentManagementTab.sources,
              itemPendingDeletion: source,
              lastPendingDeletionId: '3',
            ),
          ]),
          initialState: const ContentManagementState(),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pump();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Undo'));

        verify(
          () => contentManagementBloc.add(const UndoDeleteSourceRequested('3')),
        ).called(1);
      });
    });
  });
}
