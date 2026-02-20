import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_source/create_source_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/create_source_page.dart';
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

class MockCreateSourceBloc
    extends MockBloc<CreateSourceEvent, CreateSourceState>
    implements CreateSourceBloc {}

class MockGoRouter extends Mock implements go_router.GoRouter {}

class MockFilePicker extends Mock
    with MockPlatformInterfaceMixin
    implements FilePicker {}

// Mock data for tests
final testLanguage = Language(
  id: 'lang-1',
  code: 'en',
  name: 'English',
  nativeName: 'English',
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

final testSource = Source(
  id: 'source-1',
  name: 'Test Source',
  description: 'desc',
  url: 'http://example.com',
  sourceType: SourceType.blog,
  language: testLanguage,
  headquarters: testCountry,
  createdAt: DateTime(2023),
  updatedAt: DateTime(2023),
  status: ContentStatus.active,
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
  group('CreateSourcePage', () {
    late CreateSourceBloc createSourceBloc;
    late MockDataRepository<Source> sourcesRepository;
    late MockDataRepository<Language> languagesRepository;
    late MockDataRepository<Country> countriesRepository;
    late MockMediaRepository mediaRepository;
    late MockGoRouter goRouter;
    late FilePicker filePicker;

    setUp(() {
      createSourceBloc = MockCreateSourceBloc();
      sourcesRepository = MockDataRepository<Source>();
      languagesRepository = MockDataRepository<Language>();
      countriesRepository = MockDataRepository<Country>();
      mediaRepository = MockMediaRepository();
      goRouter = MockGoRouter();
      filePicker = MockFilePicker();
      FilePicker.platform = filePicker;
      Logger.root.level = Level.OFF;

      when(() => createSourceBloc.state).thenReturn(const CreateSourceState());
      when(() => goRouter.pop()).thenAnswer((_) async {});
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
          RepositoryProvider<DataRepository<Source>>.value(
            value: sourcesRepository,
          ),
          RepositoryProvider<DataRepository<Language>>.value(
            value: languagesRepository,
          ),
          RepositoryProvider<DataRepository<Country>>.value(
            value: countriesRepository,
          ),
          RepositoryProvider<MediaRepository>.value(
            value: mediaRepository,
          ),
        ],
        child: BlocProvider.value(
          value: createSourceBloc,
          child: const CreateSourceView(),
        ),
      );
    }

    testWidgets('renders CreateSourceView', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      expect(find.byType(CreateSourceView), findsOneWidget);
    });

    testWidgets('renders AppBar with title and disabled save button', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text(l10n.createSource), findsOneWidget);

      final saveButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.save),
      );
      expect(saveButton.onPressed, isNull);
    });

    testWidgets('renders form fields', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));

      expect(
        find.widgetWithText(TextFormField, l10n.sourceName),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, l10n.description),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, l10n.sourceUrl),
        findsOneWidget,
      );
      expect(find.byType(ImageUploadField), findsOneWidget);
      expect(find.byType(SearchableSelectionInput<Language>), findsOneWidget);
      expect(find.byType(SearchableSelectionInput<SourceType>), findsOneWidget);
      expect(find.byType(SearchableSelectionInput<Country>), findsOneWidget);
    });

    group('form interactions', () {
      testWidgets('adds CreateSourceNameChanged when name is changed', (
        tester,
      ) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        await tester.enterText(
          find.widgetWithText(TextFormField, l10n.sourceName),
          'New Source',
        );
        verify(
          () =>
              createSourceBloc.add(const CreateSourceNameChanged('New Source')),
        ).called(1);
      });

      testWidgets('adds CreateSourceDescriptionChanged when desc is changed', (
        tester,
      ) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        await tester.enterText(
          find.widgetWithText(TextFormField, l10n.description),
          'New Desc',
        );
        verify(
          () => createSourceBloc.add(
            const CreateSourceDescriptionChanged('New Desc'),
          ),
        ).called(1);
      });

      testWidgets('adds CreateSourceUrlChanged when url is changed', (
        tester,
      ) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        await tester.enterText(
          find.widgetWithText(TextFormField, l10n.sourceUrl),
          'http://url.com',
        );
        verify(
          () => createSourceBloc.add(
            const CreateSourceUrlChanged('http://url.com'),
          ),
        ).called(1);
      });

      testWidgets('adds CreateSourceImageChanged when image is picked', (
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
          () => createSourceBloc.add(
            CreateSourceImageChanged(
              imageFileBytes: kTestImageBytes,
              imageFileName: fileName,
            ),
          ),
        ).called(1);
      });

      testWidgets('adds CreateSourceImageRemoved when image is removed', (
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
          () => createSourceBloc.add(const CreateSourceImageRemoved()),
        ).called(1);
      });

      testWidgets(
        'adds CreateSourceLanguageChanged when language is selected',
        (
          tester,
        ) async {
          when(
            () => goRouter.pushNamed<List<Object>?>(
              Routes.searchableSelectionName,
              extra: any(named: 'extra'),
            ),
          ).thenAnswer((_) async => [testLanguage]);

          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          await tester.ensureVisible(
            find.byType(SearchableSelectionInput<Language>),
          );
          await tester.tap(find.byType(SearchableSelectionInput<Language>));
          await tester.pumpAndSettle();

          verify(
            () =>
                createSourceBloc.add(CreateSourceLanguageChanged(testLanguage)),
          ).called(1);
        },
      );

      testWidgets('adds CreateSourceTypeChanged when type is selected', (
        tester,
      ) async {
        when(
          () => goRouter.pushNamed<List<Object>?>(
            Routes.searchableSelectionName,
            extra: any(named: 'extra'),
          ),
        ).thenAnswer((_) async => [SourceType.blog]);

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.ensureVisible(
          find.byType(SearchableSelectionInput<SourceType>),
        );
        await tester.tap(find.byType(SearchableSelectionInput<SourceType>));
        await tester.pumpAndSettle();

        verify(
          () => createSourceBloc.add(
            const CreateSourceTypeChanged(SourceType.blog),
          ),
        ).called(1);
      });

      testWidgets(
        'adds CreateSourceHeadquartersChanged when headquarters is selected',
        (tester) async {
          when(
            () => goRouter.pushNamed<List<Object>?>(
              Routes.searchableSelectionName,
              extra: any(named: 'extra'),
            ),
          ).thenAnswer((_) async => [testCountry]);

          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          await tester.ensureVisible(
            find.byType(SearchableSelectionInput<Country>),
          );
          await tester.tap(find.byType(SearchableSelectionInput<Country>));
          await tester.pumpAndSettle();

          verify(
            () => createSourceBloc.add(
              CreateSourceHeadquartersChanged(testCountry),
            ),
          ).called(1);
        },
      );
    });

    group('submission status', () {
      testWidgets('shows progress indicator when state is imageUploading', (
        tester,
      ) async {
        when(() => createSourceBloc.state).thenReturn(
          const CreateSourceState(status: CreateSourceStatus.imageUploading),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows progress indicator when state is entitySubmitting', (
        tester,
      ) async {
        when(() => createSourceBloc.state).thenReturn(
          const CreateSourceState(status: CreateSourceStatus.entitySubmitting),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows snackbar and pops on success', (tester) async {
        whenListen(
          createSourceBloc,
          Stream.fromIterable([
            CreateSourceState(
              status: CreateSourceStatus.success,
              createdSource: testSource,
            ),
          ]),
          initialState: const CreateSourceState(),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pumpAndSettle();

        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        expect(find.text(l10n.sourceCreatedSuccessfully), findsOneWidget);
        verify(() => goRouter.pop()).called(1);
      });

      testWidgets('shows error snackbar on imageUploadFailure', (tester) async {
        whenListen(
          createSourceBloc,
          Stream.fromIterable([
            const CreateSourceState(
              status: CreateSourceStatus.imageUploadFailure,
              exception: NetworkException(),
            ),
          ]),
          initialState: const CreateSourceState(),
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
          createSourceBloc,
          Stream.fromIterable([
            const CreateSourceState(
              status: CreateSourceStatus.entitySubmitFailure,
              exception: NetworkException(),
            ),
          ]),
          initialState: const CreateSourceState(),
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
        when(() => createSourceBloc.state).thenReturn(
          CreateSourceState(
            name: 'N',
            description: 'D',
            url: 'U',
            imageFileBytes: kTestImageBytes,
            imageFileName: 'test.jpg',
            sourceType: SourceType.blog,
            language: testLanguage,
            headquarters: testCountry,
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
          when(() => createSourceBloc.state).thenReturn(
            CreateSourceState(
              name: 'N',
              description: 'D',
              url: 'U',
              imageFileBytes: kTestImageBytes,
              imageFileName: 'test.jpg',
              sourceType: SourceType.blog,
              language: testLanguage,
              headquarters: testCountry,
            ),
          );

          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          final l10n = AppLocalizations.of(
            tester.element(find.byType(Scaffold)),
          );

          await tester.tap(find.widgetWithIcon(IconButton, Icons.save));
          await tester.pumpAndSettle();

          expect(find.text(l10n.saveSourceTitle), findsOneWidget);
          await tester.tap(find.text(l10n.saveAsDraft));
          await tester.pumpAndSettle();

          verify(
            () => createSourceBloc.add(const CreateSourceSavedAsDraft()),
          ).called(1);
        },
      );

      testWidgets(
        'when tapped with valid form, shows save options and publishes',
        (tester) async {
          when(() => createSourceBloc.state).thenReturn(
            CreateSourceState(
              name: 'N',
              description: 'D',
              url: 'U',
              imageFileBytes: kTestImageBytes,
              imageFileName: 'test.jpg',
              sourceType: SourceType.blog,
              language: testLanguage,
              headquarters: testCountry,
            ),
          );

          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          final l10n = AppLocalizations.of(
            tester.element(find.byType(Scaffold)),
          );

          await tester.tap(find.widgetWithIcon(IconButton, Icons.save));
          await tester.pumpAndSettle();

          expect(find.text(l10n.saveSourceTitle), findsOneWidget);
          await tester.tap(find.text(l10n.publish));
          await tester.pumpAndSettle();

          verify(
            () => createSourceBloc.add(const CreateSourcePublished()),
          ).called(1);
        },
      );
    });
  });
}
