import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_source/edit_source_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/edit_source_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:go_router/go_router.dart' as go_router;
import 'package:logging/logging.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../helpers/helpers.dart';
import '../../helpers/pump_app.dart';

class MockEditSourceBloc extends MockBloc<EditSourceEvent, EditSourceState>
    implements EditSourceBloc {}

class MockGoRouter extends Mock implements go_router.GoRouter {}

class MockFilePicker extends Mock
    with MockPlatformInterfaceMixin
    implements FilePicker {}

// --- Test Data ---

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
  logoUrl: 'http://logo.url',
);

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
  group('EditSourcePage', () {
    late EditSourceBloc editSourceBloc;
    late MockDataRepository<Source> sourcesRepository;
    late MockDataRepository<Language> languagesRepository;
    late MockDataRepository<Country> countriesRepository;
    late MockMediaRepository mediaRepository;
    late MockOptimisticImageCacheService optimisticImageCacheService;
    late MockGoRouter goRouter;
    late FilePicker filePicker;

    setUp(() {
      editSourceBloc = MockEditSourceBloc();
      sourcesRepository = MockDataRepository<Source>();
      languagesRepository = MockDataRepository<Language>();
      countriesRepository = MockDataRepository<Country>();
      mediaRepository = MockMediaRepository();
      optimisticImageCacheService = MockOptimisticImageCacheService();
      goRouter = MockGoRouter();
      filePicker = MockFilePicker();
      FilePicker.platform = filePicker;
      Logger.root.level = Level.OFF;

      // Default state: Data loaded successfully
      when(() => editSourceBloc.state).thenReturn(
        EditSourceState(
          sourceId: testSource.id,
          status: EditSourceStatus.initial,
          name: testSource.name,
          description: testSource.description,
          url: testSource.url,
          logoUrl: testSource.logoUrl,
          sourceType: testSource.sourceType,
          language: testSource.language,
          headquarters: testSource.headquarters,
          initialSource: testSource,
        ),
      );

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
          RepositoryProvider<OptimisticImageCacheService>.value(
            value: optimisticImageCacheService,
          ),
        ],
        child: BlocProvider.value(
          value: editSourceBloc,
          child: const EditSourceView(),
        ),
      );
    }

    testWidgets('renders EditSourceView', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      expect(find.byType(EditSourceView), findsOneWidget);
    });

    testWidgets('renders loading state', (tester) async {
      when(() => editSourceBloc.state).thenReturn(
        EditSourceState(
          sourceId: testSource.id,
          status: EditSourceStatus.loading,
        ),
      );
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      expect(find.byType(LoadingStateWidget), findsOneWidget);
    });

    testWidgets('renders failure state', (tester) async {
      when(() => editSourceBloc.state).thenReturn(
        EditSourceState(
          sourceId: testSource.id,
          status: EditSourceStatus.failure,
          exception: const NetworkException(),
        ),
      );
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      expect(find.byType(FailureStateWidget), findsOneWidget);
    });

    testWidgets('renders form fields populated with initial data', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));

      expect(find.text(testSource.name), findsOneWidget);
      expect(find.text(testSource.description), findsOneWidget);
      expect(find.text(testSource.url), findsOneWidget);
      expect(find.byType(ImageUploadField), findsOneWidget);
      expect(find.text(testSource.language.name), findsOneWidget);
      expect(find.text(testSource.headquarters.name), findsOneWidget);
      // SourceType is localized, so we check if the widget exists
      expect(find.byType(SearchableSelectionInput<SourceType>), findsOneWidget);
    });

    group('form interactions', () {
      testWidgets('adds EditSourceNameChanged when name is changed', (
        tester,
      ) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        final nameField = find.widgetWithText(TextFormField, l10n.sourceName);
        await tester.enterText(nameField, 'Updated Name');
        verify(
          () => editSourceBloc.add(const EditSourceNameChanged('Updated Name')),
        ).called(1);
      });

      testWidgets('adds EditSourceImageRemoved when image is removed', (
        tester,
      ) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        await tester.tap(find.byTooltip(l10n.removeImage));
        await tester.pumpAndSettle();

        verify(
          () => editSourceBloc.add(const EditSourceImageRemoved()),
        ).called(1);
      });

      testWidgets('adds EditSourceImageChanged when image is picked', (
        tester,
      ) async {
        // Arrange: Start with a state that has no image to ensure the upload
        // button is visible, mimicking the simpler, working tests.
        when(() => editSourceBloc.state).thenReturn(
          EditSourceState(
            sourceId: testSource.id,
            status: EditSourceStatus.initial,
            name: testSource.name,
            description: testSource.description,
            url: testSource.url,
            logoUrl: null,
            sourceType: testSource.sourceType,
            language: testSource.language,
            headquarters: testSource.headquarters,
            initialSource: testSource.copyWith(
              logoUrl: const ValueWrapper(null),
            ),
          ),
        );

        const fileName = 'new_logo.png';
        when(
          () => filePicker.pickFiles(type: FileType.image, withData: true),
        ).thenAnswer(
          (_) async => FilePickerResult([
            PlatformFile(name: fileName, size: 3, bytes: kTestImageBytes),
          ]),
        );

        // Act
        await tester.pumpApp(buildSubject(), goRouter: goRouter);

        await tester.tap(find.byType(ImageUploadField));
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => editSourceBloc.add(
            EditSourceImageChanged(
              imageFileBytes: kTestImageBytes,
              imageFileName: fileName,
            ),
          ),
        ).called(1);
      });
    });

    group('submission status', () {
      testWidgets('shows progress indicator when state is entitySubmitting', (
        tester,
      ) async {
        when(() => editSourceBloc.state).thenReturn(
          EditSourceState(
            sourceId: testSource.id,
            status: EditSourceStatus.entitySubmitting,
            name: 'Name',
            description: 'Desc',
            url: 'Url',
            sourceType: SourceType.blog,
            language: testLanguage,
            headquarters: testCountry,
          ),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows snackbar and pops on success', (tester) async {
        whenListen(
          editSourceBloc,
          Stream.fromIterable([
            EditSourceState(
              sourceId: testSource.id,
              status: EditSourceStatus.success,
              updatedSource: testSource,
            ),
          ]),
          initialState: EditSourceState(
            sourceId: testSource.id,
            status: EditSourceStatus.initial,
          ),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pumpAndSettle();

        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        expect(find.text(l10n.sourceUpdatedSuccessfully), findsOneWidget);
        verify(() => goRouter.pop()).called(1);
      });
    });

    group('save button', () {
      testWidgets(
        'when tapped with valid form, shows save options and publishes',
        (tester) async {
          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          final l10n = AppLocalizations.of(
            tester.element(find.byType(Scaffold)),
          );

          await tester.tap(find.widgetWithIcon(IconButton, Icons.save));
          await tester.pumpAndSettle();

          expect(find.text(l10n.updateSourceTitle), findsOneWidget);
          await tester.tap(find.text(l10n.publish));
          await tester.pumpAndSettle();

          verify(
            () => editSourceBloc.add(const EditSourcePublished()),
          ).called(1);
        },
      );
    });
  });
}
