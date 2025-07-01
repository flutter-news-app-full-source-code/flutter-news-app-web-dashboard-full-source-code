import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/content_management/view/categories_page.dart';
import 'package:ht_dashboard/content_management/view/headlines_page.dart';
import 'package:ht_dashboard/content_management/view/sources_page.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/routes.dart';
import 'package:ht_dashboard/shared/constants/app_spacing.dart';

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
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final tab = ContentManagementTab.values[_tabController.index];
      context.read<ContentManagementBloc>().add(
        ContentManagementTabChanged(tab),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<ContentManagementBloc, ContentManagementState>(
      listener: (context, state) {
        // Optionally handle state changes, e.g., show snackbar for errors
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.contentManagement),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
              kTextTabBarHeight + AppSpacing.lg,
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
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add New Item', // Consider localizing this tooltip
              onPressed: () {
                final currentTab =
                    context.read<ContentManagementBloc>().state.activeTab;
                switch (currentTab) {
                  case ContentManagementTab.headlines:
                    context.goNamed(Routes.createHeadlineName);
                  case ContentManagementTab.categories:
                    context.goNamed(Routes.createCategoryName);
                  case ContentManagementTab.sources:
                    context.goNamed(Routes.createSourceName);
                }
              },
            ),
            const SizedBox(width: AppSpacing.md),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            HeadlinesPage(),
            CategoriesPage(),
            SourcesPage(),
          ],
        ),
      ),
    );
  }
}
