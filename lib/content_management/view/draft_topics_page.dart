import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template draft_topics_page}
/// A placeholder page for displaying draft topics.
/// {@endtemplate}
class DraftTopicsPage extends StatelessWidget {
  /// {@macro draft_topics_page}
  const DraftTopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.draftTopics),
      ),
      body: Center(
        child: Text(l10n.draftTopics),
      ),
    );
  }
}
