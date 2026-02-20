import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_headline/edit_headline_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/edit_headline_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart' as go_router;
import 'package:ui_kit/ui_kit.dart';

import '../../helpers/helpers.dart';
import '../../helpers/pump_app.dart';

class MockEditHeadlineBloc
    extends MockBloc<EditHeadlineEvent, EditHeadlineState>
    implements EditHeadlineBloc {}

class MockGoRouter extends Mock implements go_router.GoRouter {}

void main() {
  group('EditHeadlinePage', () {
    late EditHeadlineBloc editHeadlineBloc;
    late MockDataRepository<Headline> headlinesRepository;
    late MockDataRepository<Source> sourcesRepository;
    late MockDataRepository<Topic> topicsRepository;
    late MockDataRepository<Country> countriesRepository;
    late MockMediaRepository mediaRepository;
    late MockGoRouter goRouter;

    final headlineFixture = getHeadlinesFixturesData().first;
    final headlineId = headlineFixture.id;

    setUp(() {
      editHeadlineBloc = MockEditHeadlineBloc();
      headlinesRepository = MockDataRepository<Headline>();
      sourcesRepository = MockDataRepository<Source>();
      topicsRepository = MockDataRepository<Topic>();
      countriesRepository = MockDataRepository<Country>();
      mediaRepository = MockMediaRepository();
      goRouter = MockGoRouter();

      when(
        () => editHeadlineBloc.state,
      ).thenReturn(EditHeadlineState(headlineId: headlineId));
      when(
        () => editHeadlineBloc.add(const EditHeadlineLoaded()),
      ).thenAnswer((_) async {});
    });

    Widget buildSubject() {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<DataRepository<Headline>>.value(
            value: headlinesRepository,
          ),
          RepositoryProvider<DataRepository<Source>>.value(
            value: sourcesRepository,
          ),
          RepositoryProvider<DataRepository<Topic>>.value(
            value: topicsRepository,
          ),
          RepositoryProvider<DataRepository<Country>>.value(
            value: countriesRepository,
          ),
          RepositoryProvider<MediaRepository>.value(
            value: mediaRepository,
          ),
        ],
        child: BlocProvider.value(
          value: editHeadlineBloc,
          child: const EditHeadlineView(),
        ),
      );
    }

    testWidgets('renders EditHeadlineView', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      expect(find.byType(EditHeadlineView), findsOneWidget);
    });

    testWidgets('shows LoadingStateWidget when status is loading', (
      tester,
    ) async {
      when(() => editHeadlineBloc.state).thenReturn(
        EditHeadlineState(
          headlineId: headlineId,
          status: EditHeadlineStatus.loading,
        ),
      );
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      expect(find.byType(LoadingStateWidget), findsOneWidget);
    });

    testWidgets('shows FailureStateWidget when status is failure', (
      tester,
    ) async {
      when(() => editHeadlineBloc.state).thenReturn(
        EditHeadlineState(
          headlineId: headlineId,
          status: EditHeadlineStatus.failure,
          exception: const NetworkException(),
        ),
      );
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      expect(find.byType(FailureStateWidget), findsOneWidget);
    });

    group('with loaded data', () {
      setUp(() {
        when(() => editHeadlineBloc.state).thenReturn(
          EditHeadlineState(
            headlineId: headlineId,
            status: EditHeadlineStatus.initial,
            initialHeadline: headlineFixture,
            title: headlineFixture.title,
            url: headlineFixture.url,
            source: headlineFixture.source,
            topic: headlineFixture.topic,
            eventCountry: headlineFixture.eventCountry,
          ),
        );
      });

      testWidgets('populates form fields with initial data', (tester) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);

        expect(find.text(headlineFixture.title), findsOneWidget);
        expect(find.text(headlineFixture.url), findsOneWidget);
        expect(find.text(headlineFixture.source.name), findsOneWidget);
        expect(find.text(headlineFixture.topic.name), findsOneWidget);
        expect(find.text(headlineFixture.eventCountry.name), findsOneWidget);
      });

      testWidgets('adds EditHeadlineTitleChanged when title is changed', (
        tester,
      ) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.enterText(find.byType(TextFormField).first, 'New Title');
        verify(
          () =>
              editHeadlineBloc.add(const EditHeadlineTitleChanged('New Title')),
        ).called(1);
      });

      testWidgets('shows progress indicator when state is submitting', (
        tester,
      ) async {
        when(() => editHeadlineBloc.state).thenReturn(
          EditHeadlineState(
            headlineId: headlineId,
            status: EditHeadlineStatus.entitySubmitting,
            initialHeadline: headlineFixture,
            title: headlineFixture.title,
            url: headlineFixture.url,
            source: headlineFixture.source,
            topic: headlineFixture.topic,
            eventCountry: headlineFixture.eventCountry,
          ),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows snackbar and pops on success', (tester) async {
        whenListen(
          editHeadlineBloc,
          Stream.fromIterable([
            EditHeadlineState(
              headlineId: headlineId,
              status: EditHeadlineStatus.initial,
              initialHeadline: headlineFixture,
            ),
            EditHeadlineState(
              headlineId: headlineId,
              status: EditHeadlineStatus.success,
              updatedHeadline: headlineFixture,
            ),
          ]),
          initialState: EditHeadlineState(
            headlineId: headlineId,
            status: EditHeadlineStatus.initial,
            initialHeadline: headlineFixture,
          ),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pumpAndSettle();

        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        expect(find.text(l10n.headlineUpdatedSuccessfully), findsOneWidget);
        verify(() => goRouter.pop()).called(1);
      });
    });
  });
}
