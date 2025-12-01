import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/view/app_reviews_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/view/engagements_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/view/reports_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/about_icon.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

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
    return Scaffold(
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
              final communityManagementBloc = context
                  .read<CommunityManagementBloc>();
              final engagementsRepository = context
                  .read<DataRepository<Engagement>>();
              final reportsRepository = context.read<DataRepository<Report>>();
              final appReviewsRepository = context
                  .read<DataRepository<AppReview>>();

              final arguments = <String, dynamic>{
                'activeTab': communityManagementBloc.state.activeTab,
                'engagementsRepository': engagementsRepository,
                'reportsRepository': reportsRepository,
                'appReviewsRepository': appReviewsRepository,
              };

              context.pushNamed(
                Routes.communityFilterDialogName,
                extra: arguments,
              );
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
        children: const [EngagementsPage(), ReportsPage(), AppReviewsPage()],
      ),
    );
  }
}
