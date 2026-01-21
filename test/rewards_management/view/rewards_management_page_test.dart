import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_filter/rewards_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/view/rewards_management_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/view/rewards_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingjay/mockingjay.dart';

class MockRewardsManagementBloc
    extends MockBloc<RewardsManagementEvent, RewardsManagementState>
    implements RewardsManagementBloc {}

class MockRewardsFilterBloc
    extends MockBloc<RewardsFilterEvent, RewardsFilterState>
    implements RewardsFilterBloc {}

class MockGoRouter extends Mock implements GoRouter {}

class FakeRewardsFilterState extends Fake implements RewardsFilterState {}

void main() {
  group('RewardsManagementPage', () {
    late RewardsManagementBloc rewardsManagementBloc;
    late RewardsFilterBloc rewardsFilterBloc;

    setUpAll(() {
      registerFallbackValue(FakeRewardsFilterState());
    });

    setUp(() {
      rewardsManagementBloc = MockRewardsManagementBloc();
      rewardsFilterBloc = MockRewardsFilterBloc();

      when(() => rewardsManagementBloc.state).thenReturn(
        const RewardsManagementState(),
      );
      when(() => rewardsFilterBloc.state).thenReturn(
        const RewardsFilterState(),
      );
      when(
        () => rewardsManagementBloc.buildRewardsFilterMap(any()),
      ).thenReturn({});
    });

    Widget buildSubject(MockGoRouter goRouter) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: InheritedGoRouter(
          goRouter: goRouter,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: rewardsManagementBloc),
              BlocProvider.value(value: rewardsFilterBloc),
            ],
            child: const RewardsManagementPage(),
          ),
        ),
      );
    }

    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(buildSubject(MockGoRouter()));
      expect(find.byType(RewardsManagementPage), findsOneWidget);
      expect(find.byType(RewardsPage), findsOneWidget);
    });

    testWidgets('shows info dialog when info button is tapped', (tester) async {
      await tester.pumpWidget(buildSubject(MockGoRouter()));
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('navigates to filter dialog when filter button is tapped', (
      tester,
    ) async {
      final goRouter = MockGoRouter();
      await tester.pumpWidget(buildSubject(goRouter));

      await tester.tap(find.byIcon(Icons.filter_list));

      verify(
        () => goRouter.goNamed(
          any(),
          extra: any(named: 'extra'),
        ),
      ).called(1);
    });
  });
}
