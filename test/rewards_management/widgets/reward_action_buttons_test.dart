import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/widgets/reward_action_buttons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  group('RewardActionButtons', () {
    late AppLocalizations l10n;
    const reward = UserRewards(id: '1', userId: 'test-user-id', activeRewards: {});

    setUp(() {
      l10n = MockAppLocalizations();
      when(() => l10n.copyUserId).thenReturn('Copy User ID');
      when(() => l10n.idCopiedToClipboard(any())).thenReturn('ID Copied');
    });

    // Mock the platform channel to test clipboard functionality.
    void setupClipboard() {
      const channel = MethodChannel('plugins.flutter.io/platform');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (methodCall) async {
        if (methodCall.method == 'Clipboard.setData') {
          return;
        }
        return null;
      });
    }

    testWidgets('renders correctly and handles copy action',
        (WidgetTester tester) async {
      setupClipboard();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: RewardActionButtons(
              reward: reward,
              l10n: l10n,
            ),
          ),
        ),
      );

      // Verify the IconButton is present.
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsOneWidget);

      // Tap the button.
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify SnackBar is shown.
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('ID Copied'), findsOneWidget);
    });
  });
}
