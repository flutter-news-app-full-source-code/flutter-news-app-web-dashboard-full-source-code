import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_headline/create_headline_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/create_headline_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';

import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:go_router/go_router.dart' as go_router;
import 'package:logging/logging.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../helpers/helpers.dart';
import '../../helpers/pump_app.dart';

class MockCreateHeadlineBloc
    extends MockBloc<CreateHeadlineEvent, CreateHeadlineState>
    implements CreateHeadlineBloc {}

class MockGoRouter extends Mock implements go_router.GoRouter {}

class MockFilePicker extends Mock
    with MockPlatformInterfaceMixin
    implements FilePicker {}

// Mock data for tests
final testSource = Source(
  id: 'source-1',
  name: 'Test Source',
  description: 'desc',
  url: 'http://example.com',
  sourceType: SourceType.blog,
  language: Language(
    id: 'lang-1',
    code: 'en',
    name: 'English',
    nativeName: 'English',
    createdAt: DateTime(2023),
    updatedAt: DateTime(2023),
    status: ContentStatus.active,
  ),
  headquarters: Country(
    isoCode: 'US',
    name: 'USA',
    flagUrl: '',
    id: 'country-1',
    createdAt: DateTime(2023),
    updatedAt: DateTime(2023),
    status: ContentStatus.active,
  ),
  createdAt: DateTime(2023),
  updatedAt: DateTime(2023),
  status: ContentStatus.active,
);

final testTopic = Topic(
  id: 'topic-1',
  name: 'Test Topic',
  description: 'desc',
  createdAt: DateTime(2023),
  updatedAt: DateTime(2023),
  status: ContentStatus.active,
);

final testCountry = Country(
  id: 'country-1',
  isoCode: 'US',
  name: 'United States',
  flagUrl: 'url',
  createdAt: DateTime(2023),
  updatedAt: DateTime(2023),
  status: ContentStatus.active,
);

final testHeadline = Headline(
  id: 'headline-1',
  title: 'Test Headline',
  source: testSource,
  eventCountry: testCountry,
  topic: testTopic,
  createdAt: DateTime(2023),
  updatedAt: DateTime(2023),
  status: ContentStatus.active,
  isBreaking: false,
  url: 'http://example.com',
);

// A 1x1 transparent PNG
final kTestImageBytes = Uint8List.fromList([
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  8,
  6,
  0,
  0,
  0,
  31,
  21,
  196,
  137,
  0,
  0,
  0,
  10,
  73,
  68,
  65,
  84,
  120,
  156,
  99,
  0,
  1,
  0,
  0,
  5,
  0,
  1,
  13,
  10,
  45,
  180,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130,
]);

void main() {
  group('CreateHeadlinePage', () {
    late CreateHeadlineBloc createHeadlineBloc;
    late MockDataRepository<Headline> headlinesRepository;
    late MockDataRepository<Source> sourcesRepository;
    late MockDataRepository<Topic> topicsRepository;
    late MockDataRepository<Country> countriesRepository;
    late MockMediaRepository mediaRepository;
    late MockGoRouter goRouter;
    late FilePicker filePicker;

    setUp(() {
      createHeadlineBloc = MockCreateHeadlineBloc();
      headlinesRepository = MockDataRepository<Headline>();
      sourcesRepository = MockDataRepository<Source>();
      topicsRepository = MockDataRepository<Topic>();
      countriesRepository = MockDataRepository<Country>();
      mediaRepository = MockMediaRepository();
      goRouter = MockGoRouter();
      filePicker = MockFilePicker();
      FilePicker.platform = filePicker;
      Logger.root.level = Level.OFF;

      when(
        () => createHeadlineBloc.state,
      ).thenReturn(const CreateHeadlineState());
      when(() => goRouter.pop()).thenAnswer((_) async {});
      when(
        () => goRouter.pushNamed<List<Object>?>(
          Routes.searchableSelectionName,
          extra: any(named: 'extra'),
        ),
      ).thenAnswer((_) async => null);
      when(
        () => goRouter.pushNamed<List<Object>?>(
          Routes.searchableSelectionName,
          extra: any(named: 'extra'),
        ),
      ).thenAnswer((_) async => null);
      when(
        () => goRouter.pushNamed<List<Object>?>(
          Routes.searchableSelectionName,
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
          value: createHeadlineBloc,
          child: const CreateHeadlineView(),
        ),
      );
    }

    testWidgets('renders CreateHeadlineView', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      expect(find.byType(CreateHeadlineView), findsOneWidget);
    });

    testWidgets('renders AppBar with title and disabled save button', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text(l10n.createHeadline), findsOneWidget);

      final saveButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.save),
      );
      expect(saveButton.onPressed, isNull);
    });

    testWidgets('renders form fields', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));

      final titleFieldFinder = find.ancestor(
        of: find.text(l10n.headlineTitle),
        matching: find.byType(TextFormField),
      );
      final urlFieldFinder = find.ancestor(
        of: find.text(l10n.sourceUrl),
        matching: find.byType(TextFormField),
      );

      expect(titleFieldFinder, findsOneWidget);
      expect(urlFieldFinder, findsOneWidget);
      expect(find.byType(ImageUploadField), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(SearchableSelectionInput<Source>), findsOneWidget);
      expect(find.byType(SearchableSelectionInput<Topic>), findsOneWidget);
      expect(find.byType(SearchableSelectionInput<Country>), findsOneWidget);
    });

    group('form interactions', () {
      testWidgets('adds CreateHeadlineTitleChanged when title is changed', (
        tester,
      ) async {
        when(
          () => createHeadlineBloc.state,
        ).thenReturn(const CreateHeadlineState());
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        final titleFieldFinder = find.ancestor(
          of: find.text(l10n.headlineTitle),
          matching: find.byType(TextFormField),
        );
        await tester.enterText(titleFieldFinder, 'New Title');
        verify(
          () => createHeadlineBloc.add(
            const CreateHeadlineTitleChanged('New Title'),
          ),
        ).called(1);
      });

      testWidgets('adds CreateHeadlineUrlChanged when url is changed', (
        tester,
      ) async {
        when(
          () => createHeadlineBloc.state,
        ).thenReturn(const CreateHeadlineState());
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        final urlFieldFinder = find.ancestor(
          of: find.text(l10n.sourceUrl),
          matching: find.byType(TextFormField),
        );
        await tester.enterText(urlFieldFinder, 'http://new.url');
        verify(
          () => createHeadlineBloc.add(
            const CreateHeadlineUrlChanged('http://new.url'),
          ),
        ).called(1);
      });

      testWidgets(
        'adds CreateHeadlineIsBreakingChanged when switch is toggled',
        (tester) async {
          when(
            () => createHeadlineBloc.state,
          ).thenReturn(const CreateHeadlineState());
          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          await tester.tap(find.byType(Switch));
          verify(
            () => createHeadlineBloc.add(
              const CreateHeadlineIsBreakingChanged(true),
            ),
          ).called(1);
        },
      );

      testWidgets('adds CreateHeadlineImageChanged when image is picked', (
        tester,
      ) async {
        const fileName = 'test.png';
        when(
          () => filePicker.pickFiles(type: FileType.image, withData: true),
        ).thenAnswer(
          (_) async => FilePickerResult([
            PlatformFile(name: fileName, size: 3, bytes: kTestImageBytes),
          ]),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.tap(find.byType(ImageUploadField));
        await tester.pumpAndSettle();

        verify(
          () => createHeadlineBloc.add(
            CreateHeadlineImageChanged(
              imageFileBytes: kTestImageBytes,
              imageFileName: fileName,
            ),
          ),
        ).called(1);
      });

      testWidgets('adds CreateHeadlineImageRemoved when image is removed', (
        tester,
      ) async {
        // Simulate picking an image first to populate the widget's state
        const fileName = 'test.png';
        when(
          () => filePicker.pickFiles(type: FileType.image, withData: true),
        ).thenAnswer(
          (_) async => FilePickerResult([
            PlatformFile(name: fileName, size: 3, bytes: kTestImageBytes),
          ]),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(
          tester.element(find.byType(Scaffold)),
        );
        await tester.tap(find.byType(ImageUploadField));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byTooltip(l10n.removeImage));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip(l10n.removeImage));
        await tester.pumpAndSettle();

        verify(
          () => createHeadlineBloc.add(const CreateHeadlineImageRemoved()),
        ).called(1);
      });

      testWidgets('adds CreateHeadlineSourceChanged when source is selected', (
        tester,
      ) async {
        when(
          () => goRouter.pushNamed<List<Object>?>(
            Routes.searchableSelectionName,
            extra: any(named: 'extra'),
          ),
        ).thenAnswer((_) async => [testSource]);

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.tap(find.byType(SearchableSelectionInput<Source>));
        await tester.pumpAndSettle();

        verify(
          () => createHeadlineBloc.add(CreateHeadlineSourceChanged(testSource)),
        ).called(1);
      });
    });

    group('submission status', () {
      testWidgets('shows progress indicator when state is imageUploading', (
        tester,
      ) async {
        when(() => createHeadlineBloc.state).thenReturn(
          const CreateHeadlineState(
            status: CreateHeadlineStatus.imageUploading,
          ),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows progress indicator when state is entitySubmitting', (
        tester,
      ) async {
        when(() => createHeadlineBloc.state).thenReturn(
          const CreateHeadlineState(
            status: CreateHeadlineStatus.entitySubmitting,
          ),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows snackbar and pops on success', (tester) async {
        whenListen(
          createHeadlineBloc,
          Stream.fromIterable([
            CreateHeadlineState(
              status: CreateHeadlineStatus.success,
              createdHeadline: testHeadline,
            ),
          ]),
          initialState: const CreateHeadlineState(),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pumpAndSettle();

        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        expect(find.text(l10n.headlineCreatedSuccessfully), findsOneWidget);
        verify(() => goRouter.pop()).called(1);
      });

      testWidgets('shows error snackbar on imageUploadFailure', (tester) async {
        whenListen(
          createHeadlineBloc,
          Stream.fromIterable([
            const CreateHeadlineState(
              status: CreateHeadlineStatus.imageUploadFailure,
              exception: NetworkException(),
            ),
          ]),
          initialState: const CreateHeadlineState(),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final uiKitL10n = UiKitLocalizations.of(
          tester.element(find.byType(Scaffold)),
        )!;
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(uiKitL10n.networkError), findsOneWidget);
      });

      testWidgets('shows error snackbar on entitySubmitFailure', (
        tester,
      ) async {
        whenListen(
          createHeadlineBloc,
          Stream.fromIterable([
            const CreateHeadlineState(
              status: CreateHeadlineStatus.entitySubmitFailure,
              exception: NetworkException(),
            ),
          ]),
          initialState: const CreateHeadlineState(),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final uiKitL10n = UiKitLocalizations.of(
          tester.element(find.byType(Scaffold)),
        )!;
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(uiKitL10n.networkError), findsOneWidget);
      });
    });

    group('save button', () {
      testWidgets('is enabled when form is valid', (tester) async {
        when(() => createHeadlineBloc.state).thenReturn(
          CreateHeadlineState(
            title: 'T',
            url: 'U',
            imageFileBytes: kTestImageBytes,
            imageFileName: 'test.jpg',
            source: testSource,
            topic: testTopic,
            eventCountry: testCountry,
          ),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);

        final saveButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.save),
        );
        expect(saveButton.onPressed, isNotNull);
      });

      testWidgets(
        'when tapped with valid form, shows save options and saves as draft',
        (tester) async {
          when(() => createHeadlineBloc.state).thenReturn(
            CreateHeadlineState(
              title: 'T',
              url: 'U',
              imageFileBytes: kTestImageBytes,
              imageFileName: 'test.jpg',
              source: testSource,
              topic: testTopic,
              eventCountry: testCountry,
            ),
          );

          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          final l10n = AppLocalizations.of(
            tester.element(find.byType(Scaffold)),
          );

          await tester.tap(find.widgetWithIcon(IconButton, Icons.save));
          await tester.pumpAndSettle();

          expect(find.text(l10n.saveHeadlineTitle), findsOneWidget);
          await tester.tap(find.text(l10n.saveAsDraft));
          await tester.pumpAndSettle();

          verify(
            () => createHeadlineBloc.add(const CreateHeadlineSavedAsDraft()),
          ).called(1);
        },
      );

      testWidgets(
        'when tapped with valid form, shows save options and publishes',
        (tester) async {
          when(() => createHeadlineBloc.state).thenReturn(
            CreateHeadlineState(
              title: 'T',
              url: 'U',
              imageFileBytes: kTestImageBytes,
              imageFileName: 'test.jpg',
              source: testSource,
              topic: testTopic,
              eventCountry: testCountry,
            ),
          );

          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          final l10n = AppLocalizations.of(
            tester.element(find.byType(Scaffold)),
          );

          await tester.tap(find.widgetWithIcon(IconButton, Icons.save));
          await tester.pumpAndSettle();

          expect(find.text(l10n.saveHeadlineTitle), findsOneWidget);
          await tester.tap(find.text(l10n.publish));
          await tester.pumpAndSettle();

          verify(
            () => createHeadlineBloc.add(const CreateHeadlinePublished()),
          ).called(1);
        },
      );

      testWidgets(
        'when tapped with breaking news, shows confirmation and publishes',
        (tester) async {
          when(() => createHeadlineBloc.state).thenReturn(
            CreateHeadlineState(
              title: 'T',
              url: 'U',
              imageFileBytes: kTestImageBytes,
              imageFileName: 'test.jpg',
              source: testSource,
              topic: testTopic,
              eventCountry: testCountry,
              isBreaking: true,
            ),
          );

          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          final l10n = AppLocalizations.of(
            tester.element(find.byType(Scaffold)),
          );

          await tester.tap(find.widgetWithIcon(IconButton, Icons.save));
          await tester.pumpAndSettle(); // Show save options
          await tester.tap(find.text(l10n.publish));
          await tester.pumpAndSettle(); // Show breaking news confirmation

          expect(find.text(l10n.confirmBreakingNewsTitle), findsOneWidget);
          await tester.tap(find.text(l10n.confirmPublishButton));
          await tester.pumpAndSettle();

          verify(
            () => createHeadlineBloc.add(const CreateHeadlinePublished()),
          ).called(1);
        },
      );

      testWidgets(
        'when trying to save breaking news as draft, shows error dialog',
        (tester) async {
          when(() => createHeadlineBloc.state).thenReturn(
            CreateHeadlineState(
              title: 'T',
              url: 'U',
              imageFileBytes: kTestImageBytes,
              imageFileName: 'test.jpg',
              source: testSource,
              topic: testTopic,
              eventCountry: testCountry,
              isBreaking: true,
            ),
          );

          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          final l10n = AppLocalizations.of(
            tester.element(find.byType(Scaffold)),
          );

          await tester.tap(find.widgetWithIcon(IconButton, Icons.save));
          await tester.pumpAndSettle(); // Show save options
          await tester.tap(find.text(l10n.saveAsDraft));
          await tester.pumpAndSettle(); // Show error dialog

          expect(find.text(l10n.cannotDraftBreakingNews), findsOneWidget);
          verifyNever(
            () => createHeadlineBloc.add(const CreateHeadlineSavedAsDraft()),
          );
        },
      );
    });
  });
}
