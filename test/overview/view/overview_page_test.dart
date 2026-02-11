import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/bloc/overview_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/view/overview_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_card_slot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui_kit/ui_kit.dart';

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockOverviewPageBloc extends MockBloc<OverviewEvent, OverviewState>
    implements OverviewBloc {}

void main() {
  group('OverviewPage', () {
    late AnalyticsService analyticsService;
    late OverviewBloc overviewPageBloc;

    const kpiData = KpiCardData(
      id: 'test-id',
      cardId: KpiCardId.usersTotalRegistered,
      label: 'Test KPI',
      timeFrames: {
        KpiTimeFrame.day: KpiTimeFrameData(value: 100, trend: '+10%'),
      },
    );
    const chartData = ChartCardData(
      id: 'test-id',
      cardId: ChartCardId.usersRegistrationsOverTime,
      label: 'Test Chart',
      type: ChartType.line,
      timeFrames: {
        ChartTimeFrame.week: [
          DataPoint(label: 'Now', value: 10),
        ],
      },
    );
    const rankedListData = RankedListCardData(
      id: 'test-id',
      cardId: RankedListCardId.overviewHeadlinesMostViewed,
      label: 'Test List',
      timeFrames: {
        RankedListTimeFrame.week: [
          RankedListItem(
            entityId: '1',
            displayTitle: 'Item 1',
            metricValue: 10,
          ),
        ],
      },
    );

    setUp(() {
      analyticsService = MockAnalyticsService();
      overviewPageBloc = MockOverviewPageBloc();
    });

    Widget buildSubject() {
      return MaterialApp(
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          UiKitLocalizations.delegate,
        ],
        supportedLocales: UiKitLocalizations.supportedLocales,
        home: RepositoryProvider.value(
          value: analyticsService,
          child: BlocProvider.value(
            value: overviewPageBloc,
            child: const OverviewView(),
          ),
        ),
      );
    }

    testWidgets('renders LoadingStateWidget when status is loading', (
      tester,
    ) async {
      when(() => overviewPageBloc.state).thenReturn(
        const OverviewState(status: OverviewStatus.loading),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(LoadingStateWidget), findsOneWidget);
    });

    testWidgets('renders FailureStateWidget when status is failure', (
      tester,
    ) async {
      when(() => overviewPageBloc.state).thenReturn(
        OverviewState(
          status: OverviewStatus.failure,
          error: Exception('oops'),
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(FailureStateWidget), findsOneWidget);
    });

    testWidgets('renders analytics content when status is success', (
      tester,
    ) async {
      when(() => overviewPageBloc.state).thenReturn(
        OverviewState(
          status: OverviewStatus.success,
          kpiData: List.filled(3, kpiData),
          chartData: List.filled(2, chartData),
          rankedListData: List.filled(2, rankedListData),
        ),
      );

      // Set screen size to desktop to test wide layout
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(AnalyticsCardSlot<KpiCardId>), findsNWidgets(3));
      expect(find.byType(AnalyticsCardSlot<ChartCardId>), findsNWidgets(2));
      expect(
        find.byType(AnalyticsCardSlot<RankedListCardId>),
        findsNWidgets(2),
      );

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('renders InitialStateWidget (Empty) when all data is empty', (
      tester,
    ) async {
      when(() => overviewPageBloc.state).thenReturn(
        OverviewState(
          status: OverviewStatus.success,
          kpiData: List.filled(3, null),
          chartData: List.filled(2, null),
          rankedListData: List.filled(2, null),
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(InitialStateWidget), findsOneWidget);
      expect(find.text('No Analytics Data'), findsOneWidget);
    });
  });
}
