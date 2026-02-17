import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockGoRouter extends Mock implements GoRouter {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    GoRouter? goRouter,
  }) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: goRouter == null
            ? widget
            : InheritedGoRouter(
                goRouter: goRouter,
                child: widget,
              ),
      ),
    );
  }
}
