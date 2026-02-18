import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart' as go_router;
import 'package:ui_kit/ui_kit.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    go_router.GoRouter? goRouter,
  }) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          UiKitLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: goRouter == null
            ? widget
            : go_router.InheritedGoRouter(
                goRouter: goRouter!,
                child: widget,
              ),
      ),
    );
  }
}
