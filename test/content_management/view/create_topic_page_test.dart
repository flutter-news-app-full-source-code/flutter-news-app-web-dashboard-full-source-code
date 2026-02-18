import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_topic/create_topic_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/create_topic_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
import 'package:go_router/go_router.dart' as go_router;
import 'package:logging/logging.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../helpers/helpers.dart';
import '../../helpers/pump_app.dart';

class MockCreateTopicBloc extends MockBloc<CreateTopicEvent, CreateTopicState>
    implements CreateTopicBloc {}

class MockContentManagementBloc
    extends MockBloc<ContentManagementEvent, ContentManagementState>
    implements ContentManagementBloc {}

class MockGoRouter extends Mock implements go_router.GoRouter {}

class MockFilePicker extends Mock
    with MockPlatformInterfaceMixin
    implements FilePicker {}

// Mock data for tests
final testTopic = Topic(
  id: 'topic-1',
  name: 'Test Topic',
  description: 'Test Description',
  createdAt: DateTime(2023),
  updatedAt: DateTime(2023),
  status: ContentStatus.active,
  iconUrl: 'http://icon.url',
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
  group('CreateTopicPage', () {
    late MockCreateTopicBloc createTopicBloc;
    late MockContentManagementBloc contentManagementBloc;
    late MockDataRepository<Topic> topicsRepository;
    late MockMediaRepository mediaRepository;
    late MockOptimisticImageCacheService optimisticImageCacheService;
    late MockGoRouter goRouter;
    late FilePicker filePicker;

    setUp(() {
      createTopicBloc = MockCreateTopicBloc();
      contentManagementBloc = MockContentManagementBloc();
      topicsRepository = MockDataRepository<Topic>();
      mediaRepository = MockMediaRepository();
      optimisticImageCacheService = MockOptimisticImageCacheService();
      goRouter = MockGoRouter();
      filePicker = MockFilePicker();
      FilePicker.platform = filePicker;
      Logger.root.level = Level.OFF;

      when(() => createTopicBloc.state).thenReturn(const CreateTopicState());
      when(
        () => contentManagementBloc.state,
      ).thenReturn(const ContentManagementState());
      when(() => goRouter.pop()).thenAnswer((_) async {});
    });

    Widget buildSubject() {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<DataRepository<Topic>>.value(
            value: topicsRepository,
          ),
          RepositoryProvider<MediaRepository>.value(
            value: mediaRepository,
          ),
          RepositoryProvider<OptimisticImageCacheService>.value(
            value: optimisticImageCacheService,
          ),
        ],
        child: BlocProvider<CreateTopicBloc>.value(
          value: createTopicBloc,
          child: BlocProvider<ContentManagementBloc>.value(
            value: contentManagementBloc,
            child: const CreateTopicView(),
          ),
        ),
      );
    }

    testWidgets('renders CreateTopicView', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      expect(find.byType(CreateTopicView), findsOneWidget);
    });

    testWidgets('renders AppBar with title and disabled save button', (
      tester,
    ) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text(l10n.createTopic), findsOneWidget);

      final saveButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.save),
      );
      expect(saveButton.onPressed, isNull);
    });

    testWidgets('renders form fields', (tester) async {
      await tester.pumpApp(buildSubject(), goRouter: goRouter);
      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));

      expect(
        find.widgetWithText(TextFormField, l10n.topicName),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, l10n.description),
        findsOneWidget,
      );
      expect(find.byType(ImageUploadField), findsOneWidget);
    });

    group('form interactions', () {
      testWidgets('adds CreateTopicNameChanged when name is changed', (
        tester,
      ) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        await tester.enterText(
          find.widgetWithText(TextFormField, l10n.topicName),
          'New Topic Name',
        );
        verify(
          () => createTopicBloc.add(
            const CreateTopicNameChanged('New Topic Name'),
          ),
        ).called(1);
      });

      testWidgets('adds CreateTopicDescriptionChanged when desc is changed', (
        tester,
      ) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        await tester.enterText(
          find.widgetWithText(TextFormField, l10n.description),
          'New Topic Description',
        );
        verify(
          () => createTopicBloc.add(
            const CreateTopicDescriptionChanged('New Topic Description'),
          ),
        ).called(1);
      });

      testWidgets('adds CreateTopicImageChanged when image is picked', (
        tester,
      ) async {
        const fileName = 'test_topic.png';
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
          () => createTopicBloc.add(
            CreateTopicImageChanged(
              imageFileBytes: kTestImageBytes,
              imageFileName: fileName,
            ),
          ),
        ).called(1);
      });

      testWidgets('adds CreateTopicImageRemoved when image is removed', (
        tester,
      ) async {
        when(() => createTopicBloc.state).thenReturn(
          CreateTopicState(
            imageFileBytes: kTestImageBytes,
            imageFileName: 'test_topic.jpg',
          ),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(
          tester.element(find.byType(Scaffold)),
        );
        await tester.ensureVisible(find.byTooltip(l10n.removeImage));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip(l10n.removeImage));
        await tester.pumpAndSettle();

        verify(
          () => createTopicBloc.add(const CreateTopicImageRemoved()),
        ).called(1);
      });
    });

    group('submission status', () {
      testWidgets('shows progress indicator when state is imageUploading', (
        tester,
      ) async {
        when(() => createTopicBloc.state).thenReturn(
          const CreateTopicState(status: CreateTopicStatus.imageUploading),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows progress indicator when state is entitySubmitting', (
        tester,
      ) async {
        when(() => createTopicBloc.state).thenReturn(
          const CreateTopicState(status: CreateTopicStatus.entitySubmitting),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('shows snackbar and pops on success', (tester) async {
        whenListen(
          createTopicBloc,
          Stream.fromIterable([
            CreateTopicState(
              status: CreateTopicStatus.success,
              createdTopic: testTopic,
            ),
          ]),
          initialState: const CreateTopicState(),
        );

        when(
          () => contentManagementBloc.add(
            const LoadTopicsRequested(limit: kDefaultRowsPerPage),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pumpAndSettle();

        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        expect(find.text(l10n.topicCreatedSuccessfully), findsOneWidget);
        verify(() => goRouter.pop()).called(1);
        verify(
          () => contentManagementBloc.add(
            const LoadTopicsRequested(limit: kDefaultRowsPerPage),
          ),
        ).called(1);
      });

      testWidgets('shows error snackbar on imageUploadFailure', (tester) async {
        whenListen(
          createTopicBloc,
          Stream.fromIterable([
            const CreateTopicState(
              status: CreateTopicStatus.imageUploadFailure,
              exception: NetworkException(),
            ),
          ]),
          initialState: const CreateTopicState(),
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
          createTopicBloc,
          Stream.fromIterable([
            const CreateTopicState(
              status: CreateTopicStatus.entitySubmitFailure,
              exception: NetworkException(),
            ),
          ]),
          initialState: const CreateTopicState(),
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
        when(() => createTopicBloc.state).thenReturn(
          CreateTopicState(
            name: 'Valid Name',
            description: 'Valid Description',
            imageFileBytes: kTestImageBytes,
            imageFileName: 'test.jpg',
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
          when(() => createTopicBloc.state).thenReturn(
            CreateTopicState(
              name: 'Valid Name',
              description: 'Valid Description',
              imageFileBytes: kTestImageBytes,
              imageFileName: 'test.jpg',
            ),
          );

          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          final l10n = AppLocalizations.of(
            tester.element(find.byType(Scaffold)),
          );

          await tester.tap(find.widgetWithIcon(IconButton, Icons.save));
          await tester.pumpAndSettle();

          expect(find.text(l10n.saveTopicTitle), findsOneWidget);
          await tester.tap(find.text(l10n.saveAsDraft));
          await tester.pumpAndSettle();

          verify(
            () => createTopicBloc.add(const CreateTopicSavedAsDraft()),
          ).called(1);
        },
      );

      testWidgets(
        'when tapped with valid form, shows save options and publishes',
        (tester) async {
          when(() => createTopicBloc.state).thenReturn(
            CreateTopicState(
              name: 'Valid Name',
              description: 'Valid Description',
              imageFileBytes: kTestImageBytes,
              imageFileName: 'test.jpg',
            ),
          );

          await tester.pumpApp(buildSubject(), goRouter: goRouter);
          final l10n = AppLocalizations.of(
            tester.element(find.byType(Scaffold)),
          );

          await tester.tap(find.widgetWithIcon(IconButton, Icons.save));
          await tester.pumpAndSettle();

          expect(find.text(l10n.saveTopicTitle), findsOneWidget);
          await tester.tap(find.text(l10n.publish));
          await tester.pumpAndSettle();

          verify(
            () => createTopicBloc.add(const CreateTopicPublished()),
          ).called(1);
        },
      );
    });
  });
}
