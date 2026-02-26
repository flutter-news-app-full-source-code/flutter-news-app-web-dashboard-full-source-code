import 'package:core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_topic/edit_topic_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/edit_topic_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
import 'package:go_router/go_router.dart' as go_router;
import 'package:logging/logging.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../helpers/helpers.dart';
import '../../helpers/pump_app.dart';

class MockEditTopicBloc extends MockBloc<EditTopicEvent, EditTopicState>
    implements EditTopicBloc {}

class MockGoRouter extends Mock implements go_router.GoRouter {}

class MockFilePicker extends Mock
    with MockPlatformInterfaceMixin
    implements FilePicker {}

void main() {
  setUpAll(registerFallbackValues);

  group('EditTopicPage', () {
    late EditTopicBloc editTopicBloc;
    late MockGoRouter goRouter;
    late FilePicker filePicker;

    const kTestTopicId = 'topic-id-123';
    final kInitialTopic = Topic(
      id: kTestTopicId,
      name: const {SupportedLanguage.en: 'Initial Name'},
      description: const {SupportedLanguage.en: 'Initial Description'},
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
      status: ContentStatus.draft,
      iconUrl: 'http://initial.url/image.png',
    );

    setUp(() {
      editTopicBloc = MockEditTopicBloc();
      goRouter = MockGoRouter();
      filePicker = MockFilePicker();
      FilePicker.platform = filePicker;
      Logger.root.level = Level.OFF;

      when(
        () => editTopicBloc.state,
      ).thenReturn(
        EditTopicState(
          topicId: kTestTopicId,
          status: EditTopicStatus.initial,
          initialTopic: kInitialTopic,
          name: kInitialTopic.name,
          description: kInitialTopic.description,
          iconUrl: kInitialTopic.iconUrl,
        ),
      );
      when(() => goRouter.pop()).thenAnswer((_) async {});
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: editTopicBloc,
        child: const EditTopicView(),
      );
    }

    group('rendering', () {
      testWidgets('renders loading state', (tester) async {
        when(() => editTopicBloc.state).thenReturn(
          const EditTopicState(
            topicId: kTestTopicId,
            status: EditTopicStatus.loading,
          ),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        expect(find.byType(LoadingStateWidget), findsOneWidget);
      });

      testWidgets('renders failure state when loading fails', (tester) async {
        when(() => editTopicBloc.state).thenReturn(
          const EditTopicState(
            topicId: kTestTopicId,
            status: EditTopicStatus.failure,
            exception: NetworkException(),
          ),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        expect(find.byType(FailureStateWidget), findsOneWidget);
      });

      testWidgets('renders form fields with initial data', (tester) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        expect(
          find.text(kInitialTopic.name[SupportedLanguage.en]!),
          findsOneWidget,
        );
        expect(
          find.text(kInitialTopic.description[SupportedLanguage.en]!),
          findsOneWidget,
        );
        expect(find.byType(ImageUploadField), findsOneWidget);
      });

      testWidgets('save button is disabled when name is empty', (tester) async {
        when(() => editTopicBloc.state).thenReturn(
          EditTopicState(
            topicId: kTestTopicId,
            initialTopic: kInitialTopic,
            name: const {}, // Empty name map
            description: kInitialTopic.description,
            iconUrl: kInitialTopic.iconUrl,
            status: EditTopicStatus.initial,
          ),
        );
        await tester.pumpApp(buildSubject(), goRouter: goRouter);

        final saveButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.save),
        );
        expect(saveButton.onPressed, isNull);
      });
    });

    group('interactions', () {
      testWidgets('entering text in name field updates bloc', (tester) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        final nameField = find.widgetWithText(
          TextFormField,
          '${l10n.topicName} (${l10n.languageNameEn})',
        );

        await tester.enterText(nameField, 'New Name');
        verify(
          () => editTopicBloc.add(
            const EditTopicNameChanged({SupportedLanguage.en: 'New Name'}),
          ),
        ).called(1);
      });

      testWidgets('shows success snackbar and pops on successful submission', (
        tester,
      ) async {
        whenListen(
          editTopicBloc,
          Stream.fromIterable([
            EditTopicState(
              topicId: kTestTopicId,
              status: EditTopicStatus.success,
              updatedTopic: kInitialTopic,
            ),
          ]),
          initialState: const EditTopicState(topicId: kTestTopicId),
        );

        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pump(); // Let listener process the new state

        final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(l10n.topicUpdatedSuccessfully), findsOneWidget);
        verify(() => goRouter.pop()).called(1);
      });
    });
  });
}
