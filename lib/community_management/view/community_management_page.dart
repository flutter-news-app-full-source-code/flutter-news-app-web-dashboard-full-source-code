import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_filter/community_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/view/app_reviews_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/view/engagements_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/view/reports_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/about_icon.dart';
import 'package:go_router/go_router.dart';

class CommunityManagementPage extends StatefulWidget {
  const CommunityManagementPage({super.key});

  @override
  State<CommunityManagementPage> createState() =>
      _CommunityManagementPageState();
}

class _CommunityManagementPageState extends State<CommunityManagementPage>
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
      final tab = CommunityManagementTab.values[_tabController.index];
      context.read<CommunityManagementBloc>().add(
        CommunityManagementTabChanged(tab),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<CommunityFilterBloc, CommunityFilterState>(
          listenWhen: (previous, current) =>
              previous.version != current.version,
          listener: (context, filterState) {
            final communityManagementBloc = context
                .read<CommunityManagementBloc>();
            switch (communityManagementBloc.state.activeTab) {
              case CommunityManagementTab.engagements:
                communityManagementBloc.add(
                  LoadEngagementsRequested(
                    filter: communityManagementBloc.buildEngagementsFilterMap(
                      filterState.engagementsFilter,
                    ),
                    forceRefresh: true,
                  ),
                );
              case CommunityManagementTab.reports:
                communityManagementBloc.add(
                  LoadReportsRequested(
                    filter: communityManagementBloc.buildReportsFilterMap(
                      filterState.reportsFilter,
                    ),
                    forceRefresh: true,
                  ),
                );
              case CommunityManagementTab.appReviews:
                communityManagementBloc.add(
                  LoadAppReviewsRequested(
                    filter: communityManagementBloc.buildAppReviewsFilterMap(
                      filterState.appReviewsFilter,
                    ),
                    forceRefresh: true,
                  ),
                );
            }
          },
        ),
        BlocListener<CommunityManagementBloc, CommunityManagementState>(
          listenWhen: (previous, current) =>
              previous.snackbarMessage != current.snackbarMessage &&
              current.snackbarMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.snackbarMessage!),
                  action: SnackBarAction(
                    label: l10n.undo,
                    onPressed: () {
                      if (state.lastPendingUpdateId != null) {
                        context.read<CommunityManagementBloc>().add(
                          UndoUpdateRequested(state.lastPendingUpdateId!),
                        );
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
              Text(l10n.communityManagement),
              const SizedBox(width: AppSpacing.xs),
              AboutIcon(
                dialogTitle: l10n.communityManagement,
                dialogDescription: l10n.communityManagementPageDescription,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: l10n.filterCommunity,
              onPressed: () {
                context.pushNamed(Routes.communityFilterDialogName);
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
              Tab(text: l10n.engagements),
              Tab(text: l10n.reports),
              Tab(text: l10n.appReviews),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            EngagementsPage(),
            ReportsPage(),
            AppReviewsPage(),
          ],
        ),
      ),
    );
  }
}
