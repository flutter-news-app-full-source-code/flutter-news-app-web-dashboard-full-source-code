import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:veritai_dashboard/content_sync/bloc/create_sync/create_sync_bloc.dart';
import 'package:veritai_dashboard/content_sync/view/create_sync_page.dart';
import 'package:veritai_dashboard/shared/widgets/searchable_selection_input.dart';
import '../../helpers/pump_app.dart';

class MockCreateSyncBloc extends MockBloc<CreateSyncEvent, CreateSyncState>
    implements CreateSyncBloc {}

class MockSourceRepository extends Mock implements DataRepository<Source> {}

void main() {
  group('CreateSyncPage', () {
    late CreateSyncBloc createSyncBloc;
    late MockSourceRepository sourceRepository;

    setUp(() {
      createSyncBloc = MockCreateSyncBloc();
      sourceRepository = MockSourceRepository();

      when(() => createSyncBloc.state).thenReturn(const CreateSyncState());
    });

    Widget buildSubject() {
      return RepositoryProvider<DataRepository<Source>>.value(
        value: sourceRepository,
        child: BlocProvider.value(
          value: createSyncBloc,
          child: const CreateSyncPage(),
        ),
      );
    }

    testWidgets('save button is disabled when form is invalid', (tester) async {
      await tester.pumpApp(buildSubject());

      final saveButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.save),
      );
      expect(saveButton.onPressed, isNull);
    });

    testWidgets('save button is enabled when form is valid', (tester) async {
      final source = Source(
        id: 'src1',
        name: const {SupportedLanguage.en: 'Test'},
        description: const {},
        url: '',
        sourceType: SourceType.blog,
        language: SupportedLanguage.en,
        headquarters: const Country(
          id: 'c',
          isoCode: 'US',
          name: {},
          flagUrl: '',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: ContentStatus.active,
      );

      when(() => createSyncBloc.state).thenReturn(
        CreateSyncState(source: source),
      );

      await tester.pumpApp(buildSubject());

      final saveButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.save),
      );
      expect(saveButton.onPressed, isNotNull);
    });

    testWidgets('renders SearchableSelectionInput for source', (tester) async {
      await tester.pumpApp(buildSubject());
      expect(
        find.byType(SearchableSelectionInput<Source>),
        findsOneWidget,
      );
    });
  });
}
