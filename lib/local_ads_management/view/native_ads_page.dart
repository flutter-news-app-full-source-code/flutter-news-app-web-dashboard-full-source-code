import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/filter_local_ads/filter_local_ads_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/local_ads_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/string_truncate.dart';
import 'package:go_router/go_router.dart';
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
          context.read<FilterLocalAdsBloc>().state,
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
                        context.read<FilterLocalAdsBloc>().state,
                      ),
                ),
              ),
            );
          }

          if (state.nativeAds.isEmpty) {
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
                                context.read<FilterLocalAdsBloc>().state,
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
          Row(
            children: [
              // Primary action: Copy ID button
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
              // Secondary actions: Edit and Archive via PopupMenuButton
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                tooltip: l10n.moreActions,
                onSelected: (value) {
                  if (value == 'edit') {
                    context.goNamed(
                      Routes.editLocalNativeAdName,
                      pathParameters: {'id': ad.id},
                    );
                  } else if (value == 'archive') {
                    context.read<LocalAdsManagementBloc>().add(
                      ArchiveLocalAdRequested(ad.id),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit),
                        const SizedBox(width: AppSpacing.sm),
                        Text(l10n.editLocalAds),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'archive',
                    child: Row(
                      children: [
                        const Icon(Icons.archive),
                        const SizedBox(width: AppSpacing.sm),
                        Text(l10n.archive),
                      ],
                    ),
                  ),
                ],
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
