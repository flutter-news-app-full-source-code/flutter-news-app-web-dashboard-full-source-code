import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/filter_local_ads/filter_local_ads_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/local_ads_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/widgets/local_ad_action_buttons.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/string_truncate.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template video_ads_page}
/// A page for displaying and managing Video Ads in a tabular format.
/// {@endtemplate}
class VideoAdsPage extends StatefulWidget {
  /// {@macro video_ads_page}
  const VideoAdsPage({super.key});

  @override
  State<VideoAdsPage> createState() => _VideoAdsPageState();
}

class _VideoAdsPageState extends State<VideoAdsPage> {
  @override
  void initState() {
    super.initState();
    // Initial load of video ads, applying the default filter from FilterLocalAdsBloc
    context.read<LocalAdsManagementBloc>().add(
      LoadLocalAdsRequested(
        limit: kDefaultRowsPerPage,
        filter: context.read<LocalAdsManagementBloc>().buildLocalAdsFilterMap(
          context.read<FilterLocalAdsBloc>().state,
          currentAdType: AdType.video,
        ),
        adType: AdType.video,
      ),
    );
  }

  /// Checks if any filters are currently active in the FilterLocalAdsBloc
  /// for the video ad type.
  bool _areFiltersActive(FilterLocalAdsState state) {
    return state.searchQuery.isNotEmpty ||
        state.selectedStatus != ContentStatus.active;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<LocalAdsManagementBloc, LocalAdsManagementState>(
        builder: (context, state) {
          final filterLocalAdsState = context.watch<FilterLocalAdsBloc>().state;
          final filtersActive = _areFiltersActive(filterLocalAdsState);

          if (state.videoAdsStatus == LocalAdsManagementStatus.loading &&
              state.videoAds.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.videocam,
              headline: l10n.loadingVideoAds,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.videoAdsStatus == LocalAdsManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<LocalAdsManagementBloc>().add(
                LoadLocalAdsRequested(
                  limit: kDefaultRowsPerPage,
                  forceRefresh: true,
                  filter: context
                      .read<LocalAdsManagementBloc>()
                      .buildLocalAdsFilterMap(
                        context.read<FilterLocalAdsBloc>().state,
                        currentAdType: AdType.video,
                      ),
                  adType: AdType.video,
                ),
              ),
            );
          }

          if (state.videoAds.isEmpty) {
            if (filtersActive) {
              // Conditionally show reset button if filters are active
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.noResultsWithCurrentFilters,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FilterLocalAdsBloc>().add(
                          const FilterLocalAdsReset(),
                        );
                        context.read<FilterLocalAdsBloc>().add(
                          const FilterLocalAdsApplied(
                            searchQuery: '',
                            selectedStatus: ContentStatus.active,
                          ),
                        );
                      },
                      child: Text(l10n.resetFiltersButtonText),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text(l10n.noVideoAdsFound));
          }

          return Column(
            children: [
              if (state.videoAdsStatus == LocalAdsManagementStatus.loading &&
                  state.videoAds.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: PaginatedDataTable2(
                  columns: [
                    DataColumn2(
                      label: Text(
                        l10n.adVideoUrl,
                      ),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text(l10n.lastUpdated),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(l10n.actions),
                      size: ColumnSize.S,
                    ),
                  ],
                  source: _VideoAdsDataSource(
                    context: context,
                    ads: state.videoAds,
                    hasMore: state.videoAdsHasMore,
                    l10n: l10n,
                  ),
                  rowsPerPage: kDefaultRowsPerPage,
                  availableRowsPerPage: const [kDefaultRowsPerPage],
                  onPageChanged: (pageIndex) {
                    final newOffset = pageIndex * kDefaultRowsPerPage;
                    if (newOffset >= state.videoAds.length &&
                        state.videoAdsHasMore &&
                        state.videoAdsStatus !=
                            LocalAdsManagementStatus.loading) {
                      context.read<LocalAdsManagementBloc>().add(
                        LoadLocalAdsRequested(
                          startAfterId: state.videoAdsCursor,
                          limit: kDefaultRowsPerPage,
                          filter: context
                              .read<LocalAdsManagementBloc>()
                              .buildLocalAdsFilterMap(
                                context.read<FilterLocalAdsBloc>().state,
                                currentAdType: AdType.video,
                              ),
                          adType: AdType.video,
                        ),
                      );
                    }
                  },
                  empty: Center(child: Text(l10n.noVideoAdsFound)),
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
      ),
    );
  }
}

class _VideoAdsDataSource extends DataTableSource {
  _VideoAdsDataSource({
    required this.context,
    required this.ads,
    required this.hasMore,
    required this.l10n,
  });

  final BuildContext context;
  final List<LocalVideoAd> ads;
  final bool hasMore;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= ads.length) {
      return null;
    }
    final ad = ads[index];

    return DataRow2(
      cells: [
        DataCell(
          Text(
            ad.videoUrl.truncate(50),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            DateFormat('dd-MM-yyyy').format(ad.updatedAt.toLocal()),
          ),
        ),
        DataCell(
          LocalAdActionButtons(item: ad, l10n: l10n),
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
