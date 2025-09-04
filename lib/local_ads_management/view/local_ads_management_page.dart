import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/local_ads_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
// Added import
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template local_ads_management_page}
/// A page for managing local advertisements with tabbed navigation for ad types.
/// {@endtemplate}
class LocalAdsManagementPage extends StatelessWidget {
  /// {@macro local_ads_management_page}
  const LocalAdsManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LocalAdsManagementBloc(
              localAdsRepository: context.read<DataRepository<LocalAd>>(),
            )
            ..add(
              const LoadLocalAdsRequested(
                adType: AdType.native,
                limit: kDefaultRowsPerPage,
              ),
            )
            ..add(
              const LoadLocalAdsRequested(
                adType: AdType.banner,
                limit: kDefaultRowsPerPage,
              ),
            )
            ..add(
              const LoadLocalAdsRequested(
                adType: AdType.interstitial,
                limit: kDefaultRowsPerPage,
              ),
            )
            ..add(
              const LoadLocalAdsRequested(
                adType: AdType.video,
                limit: kDefaultRowsPerPage,
              ),
            ),
      child: const _LocalAdsManagementView(),
    );
  }
}

class _LocalAdsManagementView extends StatefulWidget {
  const _LocalAdsManagementView();

  @override
  State<_LocalAdsManagementView> createState() =>
      _LocalAdsManagementViewState();
}

class _LocalAdsManagementViewState extends State<_LocalAdsManagementView>
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
          previous.lastDeletedLocalAd != current.lastDeletedLocalAd,
      listener: (context, state) {
        if (state.lastDeletedLocalAd != null) {
          String truncatedTitle;
          switch (state.lastDeletedLocalAd!.adType) {
            case 'native':
              truncatedTitle = (state.lastDeletedLocalAd! as LocalNativeAd)
                  .title
                  .truncate(30);
            case 'banner':
              truncatedTitle = (state.lastDeletedLocalAd! as LocalBannerAd)
                  .imageUrl
                  .truncate(30);
            case 'interstitial':
              truncatedTitle =
                  (state.lastDeletedLocalAd! as LocalInterstitialAd).imageUrl
                      .truncate(30);
            case 'video':
              truncatedTitle = (state.lastDeletedLocalAd! as LocalVideoAd)
                  .videoUrl
                  .truncate(30);
            default:
              truncatedTitle = state.lastDeletedLocalAd!.id.truncate(30);
          }

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  l10n.localAdDeleted(truncatedTitle),
                ),
                action: SnackBarAction(
                  label: l10n.undo,
                  onPressed: () {
                    context.read<LocalAdsManagementBloc>().add(
                      const UndoDeleteLocalAdRequested(),
                    );
                  },
                ),
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.localAdsManagementTitle),
          bottom: TabBar(
            controller: _tabController,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: LocalAdsManagementTab.values
                .map((tab) => Tab(text: tab.name.capitalize()))
                .toList(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.inventory_2_outlined),
              tooltip: l10n.archivedItems,
              onPressed: () {
                context.goNamed(Routes.archivedLocalAdsName);
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: l10n.addNewItem,
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
            ),
            const SizedBox(width: AppSpacing.md),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: LocalAdsManagementTab.values.map((tab) {
            return _LocalAdsDataTable(adType: tab);
          }).toList(),
        ),
      ),
    );
  }
}

class _LocalAdsDataTable extends StatelessWidget {
  const _LocalAdsDataTable({required this.adType});

  final LocalAdsManagementTab adType;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return BlocBuilder<LocalAdsManagementBloc, LocalAdsManagementState>(
      builder: (context, state) {
        LocalAdsManagementStatus status;
        List<LocalAd> ads;
        String? cursor;
        bool hasMore;

        switch (adType) {
          case LocalAdsManagementTab.native:
            status = state.nativeAdsStatus;
            ads = state.nativeAds;
            cursor = state.nativeAdsCursor;
            hasMore = state.nativeAdsHasMore;
          case LocalAdsManagementTab.banner:
            status = state.bannerAdsStatus;
            ads = state.bannerAds;
            cursor = state.bannerAdsCursor;
            hasMore = state.bannerAdsHasMore;
          case LocalAdsManagementTab.interstitial:
            status = state.interstitialAdsStatus;
            ads = state.interstitialAds;
            cursor = state.interstitialAdsCursor;
            hasMore = state.interstitialAdsHasMore;
          case LocalAdsManagementTab.video:
            status = state.videoAdsStatus;
            ads = state.videoAds;
            cursor = state.videoAdsCursor;
            hasMore = state.videoAdsHasMore;
        }

        if (status == LocalAdsManagementStatus.loading && ads.isEmpty) {
          return LoadingStateWidget(
            icon: Icons.ads_click,
            headline: l10n.loadingLocalAds,
            subheadline: l10n.pleaseWait,
          );
        }

        if (status == LocalAdsManagementStatus.failure) {
          return FailureStateWidget(
            exception: state.exception!,
            onRetry: () => context.read<LocalAdsManagementBloc>().add(
              LoadLocalAdsRequested(
                adType: adType.toAdType(),
                limit: kDefaultRowsPerPage,
              ),
            ),
          );
        }

        if (ads.isEmpty) {
          return Center(child: Text(l10n.noLocalAdsFound));
        }

        return Column(
          children: [
            if (status == LocalAdsManagementStatus.loading && ads.isNotEmpty)
              const LinearProgressIndicator(),
            Expanded(
              child: PaginatedDataTable2(
                columns: [
                  DataColumn2(
                    label: Text(l10n.adTitle),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text(l10n.lastUpdated),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text(l10n.status),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text(l10n.actions),
                    size: ColumnSize.S,
                    fixedWidth: 180,
                  ),
                ],
                source: _LocalAdsDataSource(
                  context: context,
                  ads: ads,
                  hasMore: hasMore,
                  l10n: l10n,
                  adType: adType,
                ),
                rowsPerPage: kDefaultRowsPerPage,
                availableRowsPerPage: const [kDefaultRowsPerPage],
                onPageChanged: (pageIndex) {
                  final newOffset = pageIndex * kDefaultRowsPerPage;
                  if (newOffset >= ads.length &&
                      hasMore &&
                      status != LocalAdsManagementStatus.loading) {
                    context.read<LocalAdsManagementBloc>().add(
                      LoadLocalAdsRequested(
                        adType: adType.toAdType(),
                        startAfterId: cursor,
                        limit: kDefaultRowsPerPage,
                      ),
                    );
                  }
                },
                empty: Center(child: Text(l10n.noLocalAdsFound)),
                showCheckboxColumn: false,
                showFirstLastButtons: true,
                fit: FlexFit.tight,
                headingRowHeight: 56,
                dataRowHeight: 56,
                columnSpacing: AppSpacing.md,
                horizontalMargin: AppSpacing.md,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LocalAdsDataSource extends DataTableSource {
  _LocalAdsDataSource({
    required this.context,
    required this.ads,
    required this.hasMore,
    required this.l10n,
    required this.adType,
  });

  final BuildContext context;
  final List<LocalAd> ads;
  final bool hasMore;
  final AppLocalizations l10n;
  final LocalAdsManagementTab adType;

  @override
  DataRow? getRow(int index) {
    if (index >= ads.length) {
      return null;
    }
    final ad = ads[index];
    String title;
    DateTime updatedAt;
    ContentStatus status;

    // Determine title, updatedAt, and status based on ad type
    switch (ad.adType) {
      case 'native':
        final nativeAd = ad as LocalNativeAd;
        title = nativeAd.title;
        updatedAt = nativeAd.updatedAt;
        status = nativeAd.status;
      case 'banner':
        final bannerAd = ad as LocalBannerAd;
        title = bannerAd.imageUrl; // Use image URL as title for banners
        updatedAt = bannerAd.updatedAt;
        status = bannerAd.status;
      case 'interstitial':
        final interstitialAd = ad as LocalInterstitialAd;
        title = interstitialAd.imageUrl; // Use image URL as title
        updatedAt = interstitialAd.updatedAt;
        status = interstitialAd.status;
      case 'video':
        final videoAd = ad as LocalVideoAd;
        title = videoAd.videoUrl; // Use video URL as title
        updatedAt = videoAd.updatedAt;
        status = videoAd.status;
      default:
        title = 'Unknown Ad Type';
        updatedAt = DateTime.now();
        status = ContentStatus.active; // Default status
    }

    return DataRow2(
      cells: [
        DataCell(
          Text(
            title.truncate(50),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            DateFormat('dd-MM-yyyy').format(updatedAt.toLocal()),
          ),
        ),
        DataCell(Text(status.l10n(context))),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.archive),
                tooltip: l10n.archive,
                onPressed: () {
                  context.read<LocalAdsManagementBloc>().add(
                    ArchiveLocalAdRequested(ad.id, adType.toAdType()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: l10n.editLocalAds,
                onPressed: () {
                  // Navigate to edit page based on ad type
                  switch (ad.adType) {
                    case 'native':
                      context.goNamed(
                        Routes.editLocalNativeAdName,
                        pathParameters: {'id': ad.id},
                      );
                    case 'banner':
                      context.goNamed(
                        Routes.editLocalBannerAdName,
                        pathParameters: {'id': ad.id},
                      );
                    case 'interstitial':
                      context.goNamed(
                        Routes.editLocalInterstitialAdName,
                        pathParameters: {'id': ad.id},
                      );
                    case 'video':
                      context.goNamed(
                        Routes.editLocalVideoAdName,
                        pathParameters: {'id': ad.id},
                      );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: l10n.copyId,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: ad.id));
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(l10n.idCopiedToClipboard(ad.id)),
                      ),
                    );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => hasMore;

  @override
  int get rowCount => ads.length;

  @override
  int get selectedRowCount => 0;
}

extension on LocalAdsManagementTab {
  AdType toAdType() {
    switch (this) {
      case LocalAdsManagementTab.native:
        return AdType.native;
      case LocalAdsManagementTab.banner:
        return AdType.banner;
      case LocalAdsManagementTab.interstitial:
        return AdType.interstitial;
      case LocalAdsManagementTab.video:
        return AdType.video;
    }
  }
}
