import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_filter/rewards_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/enums/reward_type_filter.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/widgets/reward_action_buttons.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/analytics_dashboard_strip.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template rewards_page}
/// A page for displaying and managing User Rewards in a tabular format.
///
/// This widget listens to the [RewardsManagementBloc] and displays a paginated
/// data table of rewards. It handles loading, success, failure, and empty states.
/// {@endtemplate}
class RewardsPage extends StatefulWidget {
  /// {@macro rewards_page}
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  @override
  void initState() {
    super.initState();
    // Initial load of rewards, applying the default filter from RewardsFilterBloc.
    context.read<RewardsManagementBloc>().add(
      LoadRewardsRequested(
        limit: AppConstants.kDefaultRowsPerPage,
        filter: context.read<RewardsManagementBloc>().buildRewardsFilterMap(
          context.read<RewardsFilterBloc>().state,
        ),
      ),
    );
  }

  /// Checks if any filters are currently active in the RewardsFilterBloc.
  bool _areFiltersActive(RewardsFilterState state) {
    return state.searchQuery.isNotEmpty ||
        state.rewardTypeFilter != RewardTypeFilter.all;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<RewardsManagementBloc, RewardsManagementState>(
        builder: (context, state) {
          final rewardsFilterState = context.watch<RewardsFilterBloc>().state;
          final filtersActive = _areFiltersActive(rewardsFilterState);

          // Show loading indicator when fetching for the first time.
          if (state.status == RewardsManagementStatus.loading &&
              state.rewards.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.card_giftcard_outlined,
              headline: l10n.loadingRewards,
              subheadline: l10n.pleaseWait,
            );
          }

          // Show failure widget if an error occurs.
          if (state.status == RewardsManagementStatus.failure) {
            return FailureStateWidget(
              exception:
                  state.exception ?? const UnknownException('Unknown error'),
              onRetry: () => context.read<RewardsManagementBloc>().add(
                LoadRewardsRequested(
                  limit: AppConstants.kDefaultRowsPerPage,
                  forceRefresh: true,
                  filter: context
                      .read<RewardsManagementBloc>()
                      .buildRewardsFilterMap(
                        context.read<RewardsFilterBloc>().state,
                      ),
                ),
              ),
            );
          }

          // Handle empty states.
          if (state.rewards.isEmpty) {
            if (filtersActive) {
              // If filters are active, show a message to reset them.
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
                        context.read<RewardsFilterBloc>().add(
                          const RewardsFilterReset(),
                        );
                      },
                      child: Text(l10n.resetFiltersButtonText),
                    ),
                  ],
                ),
              );
            }
            // If no filters are active, show a generic "no rewards" message.
            return Center(child: Text(l10n.noRewardsFound));
          }

          // Display the data table with rewards.
          return Column(
            children: [
              // Analytics Dashboard Strip
              const AnalyticsDashboardStrip(
                kpiCards: [
                  KpiCardId.rewardsAdsWatchedTotal,
                  KpiCardId.rewardsActiveUsersCount,
                ],
                chartCards: [
                  ChartCardId.rewardsAdsWatchedOverTime,
                  ChartCardId.rewardsActiveByType,
                ],
              ),
              // Show a linear progress indicator during subsequent loads/pagination.
              if (state.status == RewardsManagementStatus.loading &&
                  state.rewards.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return PaginatedDataTable2(
                      columns: [
                        DataColumn2(
                          label: Text(l10n.userId),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text(l10n.activeRewards),
                          size: ColumnSize.L,
                        ),
                        if (!isMobile)
                          DataColumn2(
                            label: Text(l10n.expiry),
                            size: ColumnSize.M,
                          ),
                        DataColumn2(
                          label: Text(l10n.actions),
                          size: ColumnSize.S,
                        ),
                      ],
                      source: _RewardsDataSource(
                        context: context,
                        rewards: state.rewards,
                        hasMore: state.hasMore,
                        l10n: l10n,
                        isMobile: isMobile,
                      ),
                      rowsPerPage: AppConstants.kDefaultRowsPerPage,
                      availableRowsPerPage: const [
                        AppConstants.kDefaultRowsPerPage,
                      ],
                      onPageChanged: (pageIndex) {
                        // Handle pagination: fetch next page if needed.
                        final newOffset =
                            pageIndex * AppConstants.kDefaultRowsPerPage;
                        if (newOffset >= state.rewards.length &&
                            state.hasMore &&
                            state.status != RewardsManagementStatus.loading) {
                          context.read<RewardsManagementBloc>().add(
                            LoadRewardsRequested(
                              startAfterId: state.cursor,
                              limit: AppConstants.kDefaultRowsPerPage,
                              filter: context
                                  .read<RewardsManagementBloc>()
                                  .buildRewardsFilterMap(
                                    context.read<RewardsFilterBloc>().state,
                                  ),
                            ),
                          );
                        }
                      },
                      empty: Center(child: Text(l10n.noRewardsFound)),
                      showCheckboxColumn: false,
                      showFirstLastButtons: true,
                      fit: FlexFit.tight,
                      headingRowHeight: 56,
                      dataRowHeight: 56,
                      columnSpacing: AppSpacing.sm,
                      horizontalMargin: AppSpacing.sm,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Data source for the paginated rewards table.
class _RewardsDataSource extends DataTableSource {
  _RewardsDataSource({
    required this.context,
    required this.rewards,
    required this.hasMore,
    required this.l10n,
    required this.isMobile,
  });

  final BuildContext context;
  final List<UserRewards> rewards;
  final bool hasMore;
  final AppLocalizations l10n;
  final bool isMobile;

  @override
  DataRow? getRow(int index) {
    if (index >= rewards.length) {
      return null;
    }
    final reward = rewards[index];
    final activeRewardsList = reward.activeRewards.entries
        .where((e) => DateTime.now().isBefore(e.value))
        .toList();

    // Find the nearest expiry date for display
    DateTime? nearestExpiry;
    if (activeRewardsList.isNotEmpty) {
      nearestExpiry = activeRewardsList
          .map((e) => e.value)
          .reduce((a, b) => a.isBefore(b) ? a : b);
    }

    return DataRow2(
      cells: [
        DataCell(
          Text(reward.userId, overflow: TextOverflow.ellipsis),
        ),
        DataCell(
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: activeRewardsList.map((entry) {
              return Chip(
                label: Text(
                  _getRewardTypeLabel(entry.key, l10n),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
        if (!isMobile)
          DataCell(
            Text(
              nearestExpiry != null
                  ? DateFormat('dd-MM-yyyy').format(nearestExpiry.toLocal())
                  : '-',
            ),
          ),
        DataCell(
          RewardActionButtons(
            reward: reward,
            l10n: l10n,
          ),
        ),
      ],
    );
  }

  String _getRewardTypeLabel(RewardType type, AppLocalizations l10n) {
    switch (type) {
      case RewardType.adFree:
        return l10n.rewardTypeAdFree;
      case RewardType.dailyDigest:
        return l10n.rewardTypeDailyDigest;
    }
  }

  @override
  bool get isRowCountApproximate => hasMore;

  @override
  int get rowCount => rewards.length;

  @override
  int get selectedRowCount => 0;
}
