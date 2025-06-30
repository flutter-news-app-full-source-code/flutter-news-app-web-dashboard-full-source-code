import 'package:flutter/material.dart';
import 'package:ht_dashboard/content_management/view/categories_page.dart';
import 'package:ht_dashboard/content_management/view/headlines_page.dart';
import 'package:ht_dashboard/content_management/view/sources_page.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/shared/constants/app_spacing.dart';
import 'package:ht_dashboard/shared/theme/app_theme.dart';

/// {@template content_management_page}
/// A page for Content Management with tabbed navigation for sub-sections.
/// {@endtemplate}
class ContentManagementPage extends StatefulWidget {
  /// {@macro content_management_page}
  const ContentManagementPage({super.key});

  @override
  State<ContentManagementPage> createState() => _ContentManagementPageState();
}

class _ContentManagementPageState extends State<ContentManagementPage>
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contentManagement),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            kToolbarHeight + kTextTabBarHeight + AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                ),
                child: Text(
                  l10n.contentManagementPageDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                tabs: [
                  Tab(text: l10n.headlines),
                  Tab(text: l10n.categories),
                  Tab(text: l10n.sources),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HeadlinesPage(),
          CategoriesPage(),
          SourcesPage(),
        ],
      ),
    );
  }
}
