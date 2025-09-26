import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/filter_local_ads/filter_local_ads_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/local_ads_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/widgets/local_ad_action_buttons.dart'; // Import the new action buttons widget
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/string_truncate.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template native_ads_page}
/// A page for displaying and managing Native Ads in a tabular format.
/// {@endtemplate}
class NativeAdsPage extends StatefulWidget {
  /// {@macro native_ads_page}
  const NativeAdsPage({super.key});

  @override
  State<NativeAdsPage> createState() => _NativeAdsPageState();
}

class _NativeAdsPageState extends State<NativeAdsPage> {
  @override
  void initState() {
    super.initState();
    // Initial load of native ads, applying the default filter from FilterLocalAdsBloc
    context.read<LocalAdsManagementBloc>().add(
      LoadLocalAdsRequested(
        limit: kDefaultRowsPerPage,
        filter: context.read<LocalAdsManagementBloc>().buildLocalAdsFilterMap(
          context.read<FilterLocalAdsBloc>().state.copyWith(
            selectedAdType: AdType.native, // Ensure correct ad type is set for filter
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<LocalAdsManagementBloc, LocalAdsManagementState>(
        builder: (context, state) {
          final filterLocalAdsState = context.watch<FilterLocalAdsBloc>().state; // Watch filter state
          final filtersActive = filterLocalAdsState.searchQuery.isNotEmpty ||
              filterLocalAdsState.selectedStatus != ContentStatus.active ||
              filterLocalAdsState.selectedAdType != AdType.native; // Check filters for native ads

          if (state.nativeAdsStatus == LocalAdsManagementStatus.loading &&
              state.nativeAds.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.ads_click,
              headline: l10n.loadingNativeAds,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.nativeAdsStatus == LocalAdsManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<LocalAdsManagementBloc>().add(
                LoadLocalAdsRequested(
                  limit: kDefaultRowsPerPage,
                  forceRefresh: true,
                  filter: context
                      .read<LocalAdsManagementBloc>()
                      .buildLocalAdsFilterMap(
                        context.read<FilterLocalAdsBloc>().state.copyWith(
                          selectedAdType: AdType.native,
                        ),
                      ),
                ),
              ),
            );
          }

          if (state.nativeAds.isEmpty) {
            if (filtersActive) { // Conditionally show reset button if filters are active
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
                            selectedAdType: AdType.native,
                          ),
                        );
                      },
                      child: Text(l10n.resetFiltersButtonText),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text(l10n.noNativeAdsFound));
          }

          return Column(
            children: [
              if (state.nativeAdsStatus == LocalAdsManagementStatus.loading &&
                  state.nativeAds.isNotEmpty)
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
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(l10n.actions),
                      size: ColumnSize.S,
                    ),
                  ],
                  source: _NativeAdsDataSource(
                    context: context,
                    ads: state.nativeAds,
                    hasMore: state.nativeAdsHasMore,
                    l10n: l10n,
                  ),
                  rowsPerPage: kDefaultRowsPerPage,
                  availableRowsPerPage: const [kDefaultRowsPerPage],
                  onPageChanged: (pageIndex) {
                    final newOffset = pageIndex * kDefaultRowsPerPage;
                    if (newOffset >= state.nativeAds.length &&
                        state.nativeAdsHasMore &&
                        state.nativeAdsStatus !=
                            LocalAdsManagementStatus.loading) {
                      context.read<LocalAdsManagementBloc>().add(
                        LoadLocalAdsRequested(
                          startAfterId: state.nativeAdsCursor,
                          limit: kDefaultRowsPerPage,
                          filter: context
                              .read<LocalAdsManagementBloc>()
                              .buildLocalAdsFilterMap(
                                context.read<FilterLocalAdsBloc>().state.copyWith(
                                  selectedAdType: AdType.native,
                                ),
                              ),
                        ),
                      );
                    }
                  },
                  empty: Center(child: Text(l10n.noNativeAdsFound)),
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

class _NativeAdsDataSource extends DataTableSource {
  _NativeAdsDataSource({
    required this.context,
    required this.ads,
    required this.hasMore,
    required this.l10n,
  });

  final BuildContext context;
  final List<LocalNativeAd> ads;
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
            ad.title.truncate(50),
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
          LocalAdActionButtons(item: ad, l10n: l10n), // Use the new widget
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
