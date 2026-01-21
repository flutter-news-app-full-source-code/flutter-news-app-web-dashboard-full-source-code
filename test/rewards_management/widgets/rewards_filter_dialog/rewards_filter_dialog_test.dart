import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_filter/rewards_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/enums/reward_type_filter.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/widgets/rewards_filter_dialog/bloc/rewards_filter_dialog_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/widgets/rewards_filter_dialog/rewards_filter_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

class MockRewardsFilterBloc
    extends MockBloc<RewardsFilterEvent, RewardsFilterState>
    implements RewardsFilterBloc {}

class MockRewardsFilterDialogBloc
    extends MockBloc<RewardsFilterDialogEvent, RewardsFilterDialogState>
    implements RewardsFilterDialogBloc {}

void main() {
  group('RewardsFilterDialog', () {
    late RewardsFilterBloc rewardsFilterBloc;
    late RewardsFilterDialogBloc rewardsFilterDialogBloc;
    late MockNavigator navigator;

    setUp(() {
      rewardsFilterBloc = MockRewardsFilterBloc();
      rewardsFilterDialogBloc = MockRewardsFilterDialogBloc();
      navigator = MockNavigator();

      when(
        () => rewardsFilterBloc.state,
      ).thenReturn(const RewardsFilterState());
      when(() => rewardsFilterDialogBloc.state).thenReturn(
        const RewardsFilterDialogState(),
      );
      when(() => navigator.canPop()).thenReturn(true);
    });

    Widget buildSubject() {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: rewardsFilterBloc),
              BlocProvider.value(value: rewardsFilterDialogBloc),
            ],
            child: const Scaffold(
              body: RewardsFilterDialog(),
            ),
          ),
        ),
      );
    }

    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byType(RewardsFilterDialog), findsOneWidget);
    });

    testWidgets('applies filters and pops when apply button is tapped', (
      tester,
    ) async {
      when(() => rewardsFilterDialogBloc.state).thenReturn(
        const RewardsFilterDialogState(
          searchQuery: 'test',
          rewardTypeFilter: RewardTypeFilter.adFree,
        ),
      );
      when(() => navigator.pop()).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      verify(
        () => rewardsFilterBloc.add(
          const RewardsFilterApplied(
            searchQuery: 'test',
            rewardTypeFilter: RewardTypeFilter.adFree,
          ),
        ),
      ).called(1);
      verify(() => navigator.pop()).called(1);
    });

    testWidgets('resets filters and pops when reset button is tapped', (
      tester,
    ) async {
      when(() => navigator.pop()).thenAnswer((_) async {});
      await tester.pumpWidget(buildSubject());

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(() => rewardsFilterBloc.add(const RewardsFilterReset())).called(1);
      verify(() => navigator.pop()).called(1);
    });

    testWidgets('pops when close button is tapped', (tester) async {
      when(() => navigator.pop()).thenAnswer((_) async {});
      await tester.pumpWidget(buildSubject());

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      verify(() => navigator.pop()).called(1);
    });
  });
}
