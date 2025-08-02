import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template archived_content_page}
/// A page for viewing and managing archived content.
/// {@endtemplate}
class ArchivedContentPage extends StatefulWidget {
  /// {@macro archived_content_page}
  const ArchivedContentPage({super.key});

  @override
  State<ArchivedContentPage> createState() => _ArchivedContentPageState();
}

class _ArchivedContentPageState extends State<ArchivedContentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Content'), // TODO(you): Will be fixed in l10n phase.
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.headlines),
            Tab(text: l10n.topics),
            Tab(text: l10n.sources),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('Archived Headlines View Placeholder')),
          Center(child: Text('Archived Topics View Placeholder')),
          Center(child: Text('Archived Sources View Placeholder')),
        ],
      ),
    );
  }
}
