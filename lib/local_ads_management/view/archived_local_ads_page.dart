import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/archive_local_ads/archived_local_ads_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/local_ads_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/content_status_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template archived_local_ads_page}
/// A page for viewing and managing archived local advertisements.
/// {@endtemplate}
class ArchivedLocalAdsPage extends StatelessWidget {
  /// {@macro archived_local_ads_page}
  const ArchivedLocalAdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArchivedLocalAdsBloc(
        localAdsRepository: context.read<DataRepository<LocalAd>>(),
      )
        ..add(const LoadArchivedLocalAdsRequested(adType: AdType.native))
        ..add(const LoadArchivedLocalAdsRequested(adType: AdType.banner))
        ..add(const LoadArchivedLocalAdsRequested(adType: AdType.interstitial))
        ..add(const LoadArchivedLocalAdsRequested(adType: AdType.video)),
      child: const _ArchivedLocalAdsView(),
    );
  }
}

class _ArchivedLocalAdsView extends StatefulWidget {
  const _ArchivedLocalAdsView();

  @override
  State<_ArchivedLocalAdsView> createState() => _ArchivedLocalAdsViewState();
}

class _ArchivedLocalAdsViewState extends State<_ArchivedLocalAdsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AdType.values.length,
      vsync: this,
    );
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
        title: Text(l10n.archivedLocalAdsTitle),
        bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          tabs: AdType.values
              .map((type) => Tab(text: type.name.capitalize()))
              .toList(),
        ),
      ),
      body: BlocListener<ArchivedLocalAdsBloc, ArchivedLocalAdsState>(
        listenWhen: (previous, current) =>
            previous.lastDeletedLocalAd != current.lastDeletedLocalAd ||
            (previous.nativeAds.length != current.nativeAds.length &&
                current.lastDeletedLocalAd == null) ||
            (previous.bannerAds.length != current.bannerAds.length &&
                current.lastDeletedLocalAd == null) ||
            (previous.interstitialAds.length != current.interstitialAds.length &&
                current.lastDeletedLocalAd == null) ||
            (previous.videoAds.length != current.videoAds.length &&
                current.lastDeletedLocalAd == null),
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
                    (state.lastDeletedLocalAd! as LocalInterstitialAd)
                        .imageUrl
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
                      context.read<ArchivedLocalAdsBloc>().add(
                            const UndoDeleteLocalAdRequested(),
                          );
                    },
                  ),
                ),
              );
          }
          // Trigger refresh of active ads in LocalAdsManagementBloc if an ad was restored
          if (state.restoredLocalAd != null) {
            context.read<LocalAdsManagementBloc>().add(
                  LoadLocalAdsRequested(
                    adType: state.restoredLocalAd!.toAdType(),
                    forceRefresh: true,
                  ),
                );
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: AdType.values.map((type) {
            return _ArchivedLocalAdsDataTable(adType: type);
          }).toList(),
        ),
      ),
    );
  }
}

class _ArchivedLocalAdsDataTable extends StatelessWidget {
  const _ArchivedLocalAdsDataTable({required this.adType});

  final AdType adType;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return BlocBuilder<ArchivedLocalAdsBloc, ArchivedLocalAdsState>(
      builder: (context, state) {
        ArchivedLocalAdsStatus status;
        List<LocalAd> ads;
        String? cursor;
        bool hasMore;

        switch (adType) {
          case AdType.native:
            status = state.nativeAdsStatus;
            ads = state.nativeAds;
            cursor = state.nativeAdsCursor;
            hasMore = state.nativeAdsHasMore;
          case AdType.banner:
            status = state.bannerAdsStatus;
            ads = state.bannerAds;
            cursor = state.bannerAdsCursor;
            hasMore = state.bannerAdsHasMore;
          case AdType.interstitial:
            status = state.interstitialAdsStatus;
            ads = state.interstitialAds;
            cursor = state.interstitialAdsCursor;
            hasMore = state.interstitialAdsHasMore;
          case AdType.video:
            status = state.videoAdsStatus;
            ads = state.videoAds;
            cursor = state.videoAdsCursor;
            hasMore = state.videoAdsHasMore;
        }

        if (status == ArchivedLocalAdsStatus.loading && ads.isEmpty) {
          return LoadingStateWidget(
            icon: Icons.ads_click,
            headline: l10n.loadingArchivedLocalAds,
            subheadline: l10n.pleaseWait,
          );
        }

        if (status == ArchivedLocalAdsStatus.failure) {
          return FailureStateWidget(
            exception: state.exception!,
            onRetry: () => context.read<ArchivedLocalAdsBloc>().add(
                  LoadArchivedLocalAdsRequested(
                    adType: adType,
                    limit: kDefaultRowsPerPage,
                  ),
                ),
          );
        }

        if (ads.isEmpty) {
          return Center(child: Text(l10n.noArchivedLocalAdsFound));
        }

        return Column(
          children: [
            if (status == ArchivedLocalAdsStatus.loading && ads.isNotEmpty)
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
                source: _ArchivedLocalAdsDataSource(
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
                      status != ArchivedLocalAdsStatus.loading) {
                    context.read<ArchivedLocalAdsBloc>().add(
                          LoadArchivedLocalAdsRequested(
                            adType: adType,
                            startAfterId: cursor,
                            limit: kDefaultRowsPerPage,
                          ),
                        );
                  }
                },
                empty: Center(child: Text(l10n.noArchivedLocalAdsFound)),
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

class _ArchivedLocalAdsDataSource extends DataTableSource {
  _ArchivedLocalAdsDataSource({
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
  final AdType adType;

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
                icon: const Icon(Icons.restore),
                tooltip: l10n.restore,
                onPressed: () {
                  context.read<ArchivedLocalAdsBloc>().add(
                        RestoreLocalAdRequested(ad.id, adType),
                      );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever),
                tooltip: l10n.deleteForever,
                onPressed: () {
                  context.read<ArchivedLocalAdsBloc>().add(
                        DeleteLocalAdForeverRequested(ad.id, adType),
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

extension on LocalAd {
  AdType toAdType() {
    switch (adType) {
      case 'native':
        return AdType.native;
      case 'banner':
        return AdType.banner;
      case 'interstitial':
        return AdType.interstitial;
      case 'video':
        return AdType.video;
      default:
        throw FormatException('Unknown AdType: $adType');
    }
  }
}
