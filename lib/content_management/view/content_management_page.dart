import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/sources_filter/sources_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/topics_filter/topics_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/headlines_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/sources_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/topics_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/about_icon.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<HeadlinesFilterBloc, HeadlinesFilterState>(
          listenWhen: (previous, current) =>
              previous.searchQuery != current.searchQuery ||
              previous.selectedStatus != current.selectedStatus ||
              !const DeepCollectionEquality().equals(
                previous.selectedSourceIds,
                current.selectedSourceIds,
              ) ||
              !const DeepCollectionEquality().equals(
                previous.selectedTopicIds,
                current.selectedTopicIds,
              ) ||
              !const DeepCollectionEquality().equals(
                previous.selectedCountryIds,
                current.selectedCountryIds,
              ) ||
              previous.isBreaking != current.isBreaking,
          listener: (context, state) {
            final defaultLanguage =
                context
                    .read<AppBloc>()
                    .state
                    .remoteConfig
                    ?.app
                    .localization
                    .defaultLanguage
                    .name ??
                'en';
            context.read<ContentManagementBloc>().add(
              LoadHeadlinesRequested(
                filter: context.read<HeadlinesFilterBloc>().buildFilterMap(
                  languageCode: defaultLanguage,
                ),
                forceRefresh: true,
              ),
            );
          },
        ),
        BlocListener<TopicsFilterBloc, TopicsFilterState>(
          listenWhen: (previous, current) =>
              previous.searchQuery != current.searchQuery ||
              previous.selectedStatus != current.selectedStatus,
          listener: (context, state) {
            context.read<ContentManagementBloc>().add(
              LoadTopicsRequested(
                filter: context.read<TopicsFilterBloc>().buildFilterMap(),
                forceRefresh: true,
              ),
            );
          },
        ),
        BlocListener<SourcesFilterBloc, SourcesFilterState>(
          listenWhen: (previous, current) =>
              previous.searchQuery != current.searchQuery ||
              previous.selectedStatus != current.selectedStatus ||
              !const DeepCollectionEquality().equals(
                previous.selectedSourceTypes,
                current.selectedSourceTypes,
              ) ||
              !const DeepCollectionEquality().equals(
                previous.selectedLanguageCodes,
                current.selectedLanguageCodes,
              ) ||
              !const DeepCollectionEquality().equals(
                previous.selectedHeadquartersCountryIds,
                current.selectedHeadquartersCountryIds,
              ),
          listener: (context, state) {
            context.read<ContentManagementBloc>().add(
              LoadSourcesRequested(
                filter: context.read<SourcesFilterBloc>().buildFilterMap(),
                forceRefresh: true,
              ),
            );
          },
        ),
        BlocListener<ContentManagementBloc, ContentManagementState>(
          listenWhen: (previous, current) =>
              previous.itemPendingDeletion != current.itemPendingDeletion &&
              current.itemPendingDeletion != null,
          listener: (context, state) {
            final item = state.itemPendingDeletion!;
            String itemType;
            String itemName;
            if (item is Headline) {
              itemType = l10n.headline;
              itemName = item.title.values.firstOrNull ?? '';
            } else if (item is Topic) {
              itemType = l10n.topic;
              itemName = item.name.values.firstOrNull ?? '';
            } else if (item is Source) {
              itemType = l10n.source;
              itemName = item.name.values.firstOrNull ?? '';
            } else {
              // Fallback for unknown types
              itemType = '';
              itemName = '';
            }
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(l10n.itemDeletedSnackbar(itemType, itemName)),
                  action: SnackBarAction(
                    label: l10n.undo,
                    onPressed: () {
                      final activeTab = state.activeTab;
                      final lastPendingDeletionId = state.lastPendingDeletionId;
                      if (lastPendingDeletionId != null) {
                        switch (activeTab) {
                          case ContentManagementTab.headlines:
                            context.read<ContentManagementBloc>().add(
                              UndoDeleteHeadlineRequested(
                                lastPendingDeletionId,
                              ),
                            );
                          case ContentManagementTab.topics:
                            context.read<ContentManagementBloc>().add(
                              UndoDeleteTopicRequested(
                                lastPendingDeletionId,
                              ),
                            );
                          case ContentManagementTab.sources:
                            context.read<ContentManagementBloc>().add(
                              UndoDeleteSourceRequested(
                                lastPendingDeletionId,
                              ),
                            );
                        }
                      }
                    },
                  ),
                ),
              );
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.contentManagement),
              const SizedBox(
                width: AppSpacing.xs,
              ),
              AboutIcon(
                dialogTitle: l10n.contentManagement,
                dialogDescription: l10n.contentManagementPageDescription,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: l10n.filter,
              onPressed: () {
                final contentManagementBloc = context
                    .read<ContentManagementBloc>();
                final topicsRepository = context.read<DataRepository<Topic>>();
                final sourcesRepository = context
                    .read<DataRepository<Source>>();
                final countriesRepository = context
                    .read<DataRepository<Country>>();
                final languagesRepository = context
                    .read<DataRepository<Language>>();

                // Construct arguments map to pass to the filter dialog route
                final arguments = <String, dynamic>{
                  'activeTab': contentManagementBloc.state.activeTab,
                  'sourcesRepository': sourcesRepository,
                  'topicsRepository': topicsRepository,
                  'countriesRepository': countriesRepository,
                  'languagesRepository': languagesRepository,
                  'headlinesFilterState': context
                      .read<HeadlinesFilterBloc>()
                      .state,
                  'topicsFilterState': context.read<TopicsFilterBloc>().state,
                  'sourcesFilterState': context.read<SourcesFilterBloc>().state,
                };

                // Push the filter dialog as a new route
                context.pushNamed(Routes.filterDialogName, extra: arguments);
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
              Tab(text: l10n.headlines),
              Tab(text: l10n.topics),
              Tab(text: l10n.sources),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final currentTab = context
                .read<ContentManagementBloc>()
                .state
                .activeTab;
            switch (currentTab) {
              case ContentManagementTab.headlines:
                context.pushNamed(Routes.createHeadlineName);
              case ContentManagementTab.topics:
                context.pushNamed(Routes.createTopicName);
              case ContentManagementTab.sources:
                context.pushNamed(Routes.createSourceName);
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
