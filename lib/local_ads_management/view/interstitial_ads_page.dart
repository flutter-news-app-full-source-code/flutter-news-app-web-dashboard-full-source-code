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

/// {@template interstitial_ads_page}
/// A page for displaying and managing Interstitial Ads in a tabular format.
/// {@endtemplate}
class InterstitialAdsPage extends StatefulWidget {
  /// {@macro interstitial_ads_page}
  const InterstitialAdsPage({super.key});

  @override
  State<InterstitialAdsPage> createState() => _InterstitialAdsPageState();
}

class _InterstitialAdsPageState extends State<InterstitialAdsPage> {
  @override
  void initState() {
    super.initState();
    // Initial load of interstitial ads, applying the default filter from FilterLocalAdsBloc
    context.read<LocalAdsManagementBloc>().add(
      LoadLocalAdsRequested(
        limit: kDefaultRowsPerPage,
        filter: context.read<LocalAdsManagementBloc>().buildLocalAdsFilterMap(
          context.read<FilterLocalAdsBloc>().state,
          currentAdType: AdType.interstitial,
        ),
        adType: AdType.interstitial,
      ),
    );
  }

  /// Checks if any filters are currently active in the FilterLocalAdsBloc
  /// for the interstitial ad type.
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

          if (state.interstitialAdsStatus == LocalAdsManagementStatus.loading &&
              state.interstitialAds.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.fullscreen,
              headline: l10n.loadingInterstitialAds,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.interstitialAdsStatus == LocalAdsManagementStatus.failure) {
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
                        currentAdType: AdType.interstitial,
                      ),
                  adType: AdType.interstitial,
                ),
              ),
            );
          }

          if (state.interstitialAds.isEmpty) {
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
            return Center(child: Text(l10n.noInterstitialAdsFound));
          }

          return Column(
            children: [
              if (state.interstitialAdsStatus ==
                      LocalAdsManagementStatus.loading &&
                  state.interstitialAds.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: PaginatedDataTable2(
                  columns: [
                    DataColumn2(
                      label: Text(l10n.adImageUrl),
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
                  source: _InterstitialAdsDataSource(
                    context: context,
                    ads: state.interstitialAds,
                    hasMore: state.interstitialAdsHasMore,
                    l10n: l10n,
                  ),
                  rowsPerPage: kDefaultRowsPerPage,
                  availableRowsPerPage: const [kDefaultRowsPerPage],
                  onPageChanged: (pageIndex) {
                    final newOffset = pageIndex * kDefaultRowsPerPage;
                    if (newOffset >= state.interstitialAds.length &&
                        state.interstitialAdsHasMore &&
                        state.interstitialAdsStatus !=
                            LocalAdsManagementStatus.loading) {
                      context.read<LocalAdsManagementBloc>().add(
                        LoadLocalAdsRequested(
                          startAfterId: state.interstitialAdsCursor,
                          limit: kDefaultRowsPerPage,
                          filter: context
                              .read<LocalAdsManagementBloc>()
                              .buildLocalAdsFilterMap(
                                context.read<FilterLocalAdsBloc>().state,
                                currentAdType: AdType.interstitial,
                              ),
                          adType: AdType.interstitial,
                        ),
                      );
                    }
                  },
                  empty: Center(child: Text(l10n.noInterstitialAdsFound)),
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

class _InterstitialAdsDataSource extends DataTableSource {
  _InterstitialAdsDataSource({
    required this.context,
    required this.ads,
    required this.hasMore,
    required this.l10n,
  });

  final BuildContext context;
  final List<LocalInterstitialAd> ads;
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
            ad.imageUrl.truncate(50),
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
