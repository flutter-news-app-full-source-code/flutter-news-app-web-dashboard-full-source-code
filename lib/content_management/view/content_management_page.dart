import 'package:collection/collection.dart'; // For deep equality check on filter maps
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/sources_filter/sources_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/topics_filter/topics_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/headlines_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/sources_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/topics_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/widgets/filter_dialog.dart'; // Import the new FilterDialog
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

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
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
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

  /// Builds a filter map from the given search query and selected statuses.
  Map<String, dynamic> _buildFilterMap({
    required String searchQuery,
    required Set<ContentStatus> selectedStatuses,
    String? searchField,
  }) {
    final filter = <String, dynamic>{};

    if (searchQuery.isNotEmpty && searchField != null) {
      filter[searchField] = {r'$regex': searchQuery, r'$options': 'i'};
    }

    if (selectedStatuses.isNotEmpty) {
      filter['status'] = {r'$in': selectedStatuses.map((s) => s.name).toList()};
    }

    return filter;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<HeadlinesFilterBloc, HeadlinesFilterState>(
          listenWhen: (previous, current) =>
              !const DeepCollectionEquality().equals(
                _buildFilterMap(
                  searchQuery: previous.searchQuery,
                  selectedStatuses: previous.selectedStatuses,
                  searchField: 'title',
                ),
                _buildFilterMap(
                  searchQuery: current.searchQuery,
                  selectedStatuses: current.selectedStatuses,
                  searchField: 'title',
                ),
              ),
          listener: (context, state) {
            context.read<ContentManagementBloc>().add(
              LoadHeadlinesRequested(
                filter: _buildFilterMap(
                  searchQuery: state.searchQuery,
                  selectedStatuses: state.selectedStatuses,
                  searchField: 'title',
                ),
                forceRefresh: true,
              ),
            );
          },
        ),
        BlocListener<TopicsFilterBloc, TopicsFilterState>(
          listenWhen: (previous, current) =>
              !const DeepCollectionEquality().equals(
                _buildFilterMap(
                  searchQuery: previous.searchQuery,
                  selectedStatuses: previous.selectedStatuses,
                  searchField: 'name',
                ),
                _buildFilterMap(
                  searchQuery: current.searchQuery,
                  selectedStatuses: current.selectedStatuses,
                  searchField: 'name',
                ),
              ),
          listener: (context, state) {
            context.read<ContentManagementBloc>().add(
              LoadTopicsRequested(
                filter: _buildFilterMap(
                  searchQuery: state.searchQuery,
                  selectedStatuses: state.selectedStatuses,
                  searchField: 'name',
                ),
                forceRefresh: true,
              ),
            );
          },
        ),
        BlocListener<SourcesFilterBloc, SourcesFilterState>(
          listenWhen: (previous, current) =>
              !const DeepCollectionEquality().equals(
                _buildFilterMap(
                  searchQuery: previous.searchQuery,
                  selectedStatuses: previous.selectedStatuses,
                  searchField: 'name',
                ),
                _buildFilterMap(
                  searchQuery: current.searchQuery,
                  selectedStatuses: current.selectedStatuses,
                  searchField: 'name',
                ),
              ),
          listener: (context, state) {
            context.read<ContentManagementBloc>().add(
              LoadSourcesRequested(
                filter: _buildFilterMap(
                  searchQuery: state.searchQuery,
                  selectedStatuses: state.selectedStatuses,
                  searchField: 'name',
                ),
                forceRefresh: true,
              ),
            );
          },
        ),
      ],
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
                    Tab(text: l10n.topics),
                    Tab(text: l10n.sources),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: l10n.filter, // Assuming l10n.filter exists
              onPressed: () {
                final currentTab = context
                    .read<ContentManagementBloc>()
                    .state
                    .activeTab;
                showGeneralDialog<void>(
                  context: context,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FilterDialog(activeTab: currentTab);
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final currentTab = context
                .read<ContentManagementBloc>()
                .state
                .activeTab;
            switch (currentTab) {
              case ContentManagementTab.headlines:
                context.goNamed(Routes.createHeadlineName);
              case ContentManagementTab.topics:
                context.goNamed(Routes.createTopicName);
              case ContentManagementTab.sources:
                context.goNamed(Routes.createSourceName);
            }
          },
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            HeadlinesPage(),
            TopicPage(),
            SourcesPage(),
          ],
        ),
      ),
    );
  }
}
