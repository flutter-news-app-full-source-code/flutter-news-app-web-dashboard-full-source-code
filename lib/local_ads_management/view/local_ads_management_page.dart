import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/filter_local_ads/filter_local_ads_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/local_ads_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/view/banner_ads_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/view/interstitial_ads_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/view/native_ads_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/view/video_ads_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/shared.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template local_ads_management_page}
/// A page for managing local advertisements with tabbed navigation for ad types.
/// {@endtemplate}
class LocalAdsManagementPage extends StatefulWidget {
  /// {@macro local_ads_management_page}
  const LocalAdsManagementPage({super.key});

  @override
  State<LocalAdsManagementPage> createState() => _LocalAdsManagementPageState();
}

class _LocalAdsManagementPageState extends State<LocalAdsManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: LocalAdsManagementTab.values.length,
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
      final tab = LocalAdsManagementTab.values[_tabController.index];
      context.read<LocalAdsManagementBloc>().add(
        LocalAdsManagementTabChanged(tab),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return BlocListener<LocalAdsManagementBloc, LocalAdsManagementState>(
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
                  // The snackbar message is set when a deletion is requested.
                  // The ID of the item to undo is implicitly the one that
                  // triggered the snackbar.
                  context.read<LocalAdsManagementBloc>().add(
                    UndoDeleteLocalAdRequested(
                      state.snackbarMessage!.split(
                        '"',
                      )[1],
                    ),
                  );
                },
              ),
            ),
          );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.localAdManagementTitle),
              const SizedBox(
                width: AppSpacing.xs,
              ),
              AboutIcon(
                dialogTitle: l10n.aboutIconTooltip,
                dialogDescription: l10n.localAdManagementDescription,
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: LocalAdsManagementTab.values
                .map((tab) => Tab(text: tab.l10n(context)))
                .toList(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              tooltip: l10n.filter,
              onPressed: () {
                final filterLocalAdsBloc = context.read<FilterLocalAdsBloc>();
                // Construct arguments map to pass to the filter dialog route
                final arguments = <String, dynamic>{
                  'filterLocalAdsBloc': filterLocalAdsBloc,
                };

                // Push the filter dialog as a new route
                context.pushNamed(
                  Routes.localAdsFilterDialogName,
                  extra: arguments,
                );
              },
            ),
            const SizedBox(width: AppSpacing.md),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            NativeAdsPage(),
            BannerAdsPage(),
            InterstitialAdsPage(),
            VideoAdsPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final currentTab = context
                .read<LocalAdsManagementBloc>()
                .state
                .activeTab;
            switch (currentTab) {
              case LocalAdsManagementTab.native:
                context.goNamed(Routes.createLocalNativeAdName);
              case LocalAdsManagementTab.banner:
                context.goNamed(Routes.createLocalBannerAdName);
              case LocalAdsManagementTab.interstitial:
                context.goNamed(Routes.createLocalInterstitialAdName);
              case LocalAdsManagementTab.video:
                context.goNamed(Routes.createLocalVideoAdName);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
