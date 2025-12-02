import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_filter/community_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/widgets/community_action_buttons.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

class EngagementsPage extends StatefulWidget {
  const EngagementsPage({super.key});

  @override
  State<EngagementsPage> createState() => _EngagementsPageState();
}

class _EngagementsPageState extends State<EngagementsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityManagementBloc>().add(
      LoadEngagementsRequested(
        limit: kDefaultRowsPerPage,
        filter: context
            .read<CommunityManagementBloc>()
            .buildEngagementsFilterMap(
              context.read<CommunityFilterBloc>().state,
            ),
      ),
    );
  }

  bool _areFiltersActive(CommunityFilterState state) {
    return state.searchQuery.isNotEmpty ||
        state.selectedModerationStatus.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<CommunityManagementBloc, CommunityManagementState>(
        builder: (context, state) {
          final communityFilterState = context
              .watch<CommunityFilterBloc>()
              .state;
          final filtersActive = _areFiltersActive(communityFilterState);

          if (state.engagementsStatus == CommunityManagementStatus.loading &&
              state.engagements.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.comment_outlined,
              headline: l10n.loadingEngagements,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.engagementsStatus == CommunityManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<CommunityManagementBloc>().add(
                LoadEngagementsRequested(
                  limit: kDefaultRowsPerPage,
                  forceRefresh: true,
                  filter: context
                      .read<CommunityManagementBloc>()
                      .buildEngagementsFilterMap(
                        context.read<CommunityFilterBloc>().state,
                      ),
                ),
              ),
            );
          }

          if (state.engagements.isEmpty) {
            if (filtersActive) {
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
                      onPressed: () => context.read<CommunityFilterBloc>().add(
                        const CommunityFilterReset(),
                      ),
                      child: Text(l10n.resetFiltersButtonText),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text(l10n.noEngagementsFound));
          }

          return Column(
            children: [
              if (state.engagementsStatus ==
                      CommunityManagementStatus.loading &&
                  state.engagements.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return PaginatedDataTable2(
                      columns: [
                        DataColumn2(
                          label: Text(l10n.reaction),
                          size: ColumnSize.S,
                        ),
                        if (!isMobile)
                          DataColumn2(
                            label: Text(l10n.comment),
                            size: ColumnSize.L,
                          ),
                        DataColumn2(
                          label: Text(l10n.date),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text(l10n.actions),
                          size: ColumnSize.S,
                        ),
                      ],
                      source: _EngagementsDataSource(
                        context: context,
                        engagements: state.engagements,
                        hasMore: state.hasMoreEngagements,
                        l10n: l10n,
                        isMobile: isMobile,
                      ),
                      rowsPerPage: kDefaultRowsPerPage,
                      availableRowsPerPage: const [kDefaultRowsPerPage],
                      onPageChanged: (pageIndex) {
                        final newOffset = pageIndex * kDefaultRowsPerPage;
                        if (newOffset >= state.engagements.length &&
                            state.hasMoreEngagements &&
                            state.engagementsStatus !=
                                CommunityManagementStatus.loading) {
                          context.read<CommunityManagementBloc>().add(
                            LoadEngagementsRequested(
                              startAfterId: state.engagementsCursor,
                              limit: kDefaultRowsPerPage,
                              filter: context
                                  .read<CommunityManagementBloc>()
                                  .buildEngagementsFilterMap(
                                    context.read<CommunityFilterBloc>().state,
                                  ),
                            ),
                          );
                        }
                      },
                      empty: Center(child: Text(l10n.noEngagementsFound)),
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

class _EngagementsDataSource extends DataTableSource {
  _EngagementsDataSource({
    required this.context,
    required this.engagements,
    required this.hasMore,
    required this.l10n,
    required this.isMobile,
  });

  final BuildContext context;
  final List<Engagement> engagements;
  final bool hasMore;
  final AppLocalizations l10n;
  final bool isMobile;

  @override
  DataRow? getRow(int index) {
    if (index >= engagements.length) return null;
    final engagement = engagements[index];
    return DataRow2(
      cells: [
        DataCell(
          Chip(
            label: Text(engagement.reaction.reactionType.name),
            visualDensity: VisualDensity.compact,
          ),
        ),
        if (!isMobile) ...[
          DataCell(
            Row(
              children: [
                if (engagement.comment != null &&
                    engagement.comment!.status ==
                        ModerationStatus.pendingReview) ...[
                  Tooltip(
                    message: l10n.moderationStatusPendingReview,
                    child: Icon(
                      Icons.hourglass_empty_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Tooltip(
                    message: engagement.comment?.content ?? l10n.notAvailable,
                    child: Text(
                      engagement.comment?.content ?? l10n.notAvailable,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        DataCell(
          Text(DateFormat('dd-MM-yyyy').format(engagement.createdAt.toLocal())),
        ),
        DataCell(CommunityActionButtons(item: engagement, l10n: l10n)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => hasMore;

  @override
  int get rowCount => engagements.length;

  @override
  int get selectedRowCount => 0;
}
