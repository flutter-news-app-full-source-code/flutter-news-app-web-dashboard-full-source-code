import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/edit_topic_page.dart';

import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../helpers/helpers.dart';
import '../../helpers/pump_app.dart';

class MockContentManagementBloc
    extends MockBloc<ContentManagementEvent, ContentManagementState>
    implements ContentManagementBloc {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  setUpAll(registerFallbackValues);

  group('EditTopicPage', () {
    late DataRepository<Topic> topicsRepository;
    late MediaRepository mediaRepository;
    late ContentManagementBloc contentManagementBloc;
    late GoRouter goRouter;

    const kTestTopicId = 'topic-id-123';
    final kInitialTopic = Topic(
      id: kTestTopicId,
      name: 'Initial Name',
      description: 'Initial Description',
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
      status: ContentStatus.draft,
      iconUrl: 'http://initial.url/image.png',
    );

    setUp(() {
      topicsRepository = MockDataRepository<Topic>();
      mediaRepository = MockMediaRepository();
      contentManagementBloc = MockContentManagementBloc();
      goRouter = MockGoRouter();

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
        () => contentManagementBloc.state,
      ).thenReturn(const ContentManagementState());
      when(() => goRouter.pop()).thenAnswer((_) async {});
    });

    Widget buildSubject() {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: topicsRepository),
          RepositoryProvider.value(value: mediaRepository),
        ],
        child: BlocProvider.value(
          value: contentManagementBloc,
          child: const EditTopicPage(topicId: kTestTopicId),
        ),
      );
    }

    group('rendering', () {
      testWidgets('renders loading state and then form fields', (tester) async {
        await tester.pumpApp(buildSubject());
        expect(find.byType(LoadingStateWidget), findsOneWidget);

        await tester.pumpAndSettle();
        expect(find.text(kInitialTopic.name), findsOneWidget);
        expect(find.text(kInitialTopic.description), findsOneWidget);
        expect(find.byType(ImageUploadField), findsOneWidget);
      });

      testWidgets('renders failure state when loading fails', (tester) async {
        when(
          () => topicsRepository.read(id: any(named: 'id')),
        ).thenThrow(const NetworkException());
        await tester.pumpApp(buildSubject());
        await tester.pumpAndSettle();
        expect(find.byType(FailureStateWidget), findsOneWidget);
      });

      testWidgets('save button is disabled when name is empty', (tester) async {
        when(() => topicsRepository.read(id: any(named: 'id'))).thenAnswer(
          (_) async => kInitialTopic.copyWith(name: ''),
        );
        await tester.pumpApp(buildSubject());
        await tester.pumpAndSettle();

        final saveButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.save),
        );
        expect(saveButton.onPressed, isNull);
      });

      testWidgets('save button is enabled when form is valid', (tester) async {
        await tester.pumpApp(buildSubject());
        await tester.pumpAndSettle();

        final saveButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.save),
        );
        expect(saveButton.onPressed, isNotNull);
      });
    });

    group('interactions', () {
      testWidgets('entering text in name field updates bloc', (tester) async {
        await tester.pumpApp(buildSubject());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField).first, 'New Name');
        await tester.pump();

        // The BLoC receives the event and the state's `isFormValid` remains true
        final saveButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.save),
        );
        expect(saveButton.onPressed, isNotNull);
      });

      testWidgets('shows success snackbar and pops on successful submission', (
        tester,
      ) async {
        await tester.pumpApp(buildSubject(), goRouter: goRouter);
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithIcon(IconButton, Icons.save));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Publish'));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Topic updated successfully.'), findsOneWidget);
        verify(
          () => contentManagementBloc.add(
            const LoadTopicsRequested(limit: kDefaultRowsPerPage),
          ),
        ).called(1);
        verify(() => goRouter.pop()).called(1);
      });
    });
  });
}
