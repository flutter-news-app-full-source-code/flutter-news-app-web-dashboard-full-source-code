import 'package:core/core.dart';
import 'package:core_ui/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:verity_dashboard/l10n/app_localizations.dart';
import 'package:verity_dashboard/shared/services/analytics_service.dart';
import 'package:verity_dashboard/shared/widgets/analytics/analytics_card_shell.dart';
import 'package:verity_dashboard/shared/widgets/analytics/analytics_card_slot.dart';
import 'package:verity_dashboard/shared/widgets/analytics/kpi_card.dart';

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  group('AnalyticsCardSlot', () {
    late AnalyticsService analyticsService;

    const kpiData = KpiCardData(
      id: 'test-id',
      cardId: KpiCardId.usersTotalRegistered,
      label: {SupportedLanguage.en: 'Test KPI'},
      timeFrames: {},
    );

    setUpAll(() {
      registerFallbackValue(KpiCardId.usersTotalRegistered);
    });

    setUp(() {
      analyticsService = MockAnalyticsService();
    });

    Widget buildSubject({
      required List<KpiCardId> cardIds,
      List<dynamic>? data,
    }) {
      return MaterialApp(
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          UiKitLocalizations.delegate,
        ],
        supportedLocales: UiKitLocalizations.supportedLocales,
        home: Scaffold(
          body: RepositoryProvider.value(
            value: analyticsService,
            child: AnalyticsCardSlot<KpiCardId>(
              cardIds: cardIds,
              data: data,
            ),
          ),
        ),
      );
    }

    testWidgets(
      'renders empty card shell when data is null (FutureBuilder)',
      (tester) async {
        when(
          () => analyticsService.getKpi(any()),
        ).thenAnswer((_) async => null);

        await tester.pumpWidget(
          buildSubject(cardIds: [KpiCardId.usersTotalRegistered]),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AnalyticsCardShell), findsOneWidget);
        expect(find.byType(KpiCard), findsNothing);
      },
    );

    testWidgets('renders KpiCard when data is fetched via FutureBuilder', (
      tester,
    ) async {
      when(
        () => analyticsService.getKpi(any()),
      ).thenAnswer((_) async => kpiData);

      await tester.pumpWidget(
        buildSubject(cardIds: [KpiCardId.usersTotalRegistered]),
      );
      await tester.pumpAndSettle(); // Resolve Future

      expect(find.byType(KpiCard), findsOneWidget);
    });

    testWidgets(
      'renders KpiCard immediately when data is provided (Pre-fetched)',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(
            cardIds: [KpiCardId.usersTotalRegistered],
            data: [kpiData],
          ),
        );

        expect(find.byType(KpiCard), findsOneWidget);
        // Verify service was NOT called
        verifyNever(() => analyticsService.getKpi(any()));
      },
    );

    testWidgets('renders empty card shell when provided data is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          cardIds: [KpiCardId.usersTotalRegistered],
          data: [null],
        ),
      );

      expect(find.byType(AnalyticsCardShell), findsOneWidget);
      expect(find.byType(KpiCard), findsNothing);
    });
  });
}
