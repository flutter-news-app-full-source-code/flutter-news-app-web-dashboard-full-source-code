import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:verity_dashboard/content_sync/bloc/content_sync_bloc.dart';
import 'package:verity_dashboard/content_sync/widgets/sync_action_buttons.dart';
import 'package:verity_dashboard/l10n/app_localizations.dart';
import 'package:verity_dashboard/l10n/l10n.dart';
import 'package:verity_dashboard/router/routes.dart';
import 'package:verity_dashboard/shared/extensions/fetch_interval_extension.dart';
import 'package:verity_dashboard/shared/extensions/multilingual_map_extension.dart';
import 'package:verity_dashboard/shared/widgets/about_icon.dart';
import 'package:verity_dashboard/shared/widgets/analytics/analytics_dashboard_strip.dart';

class ContentSyncPage extends StatelessWidget {
  const ContentSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.contentSync),
            const SizedBox(width: AppSpacing.xs),
            AboutIcon(
              dialogTitle: l10n.contentSync,
              dialogDescription: l10n.contentSyncDescription,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(Routes.createSyncName),
        tooltip: l10n.createSync,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: BlocBuilder<ContentSyncBloc, ContentSyncState>(
          builder: (context, state) {
            if (state.status == ContentSyncStatus.loading &&
                state.tasks.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ContentSyncStatus.failure) {
              return FailureStateWidget(
                exception: state.exception!,
                onRetry: () => context.read<ContentSyncBloc>().add(
                  const ContentSyncStarted(forceRefresh: true),
                ),
              );
            }

            return Column(
              children: [
                const AnalyticsDashboardStrip(
                  kpiCards: [
                    KpiCardId.ingestionActiveTasks,
                    KpiCardId.ingestionFailedTasks,
                    KpiCardId.ingestionHeadlinesFetched,
                  ],
                  chartCards: [
                    ChartCardId.ingestionTaskStatusDistribution,
                    ChartCardId.ingestionHeadlinesOverTime,
                  ],
                ),
                if (state.status == ContentSyncStatus.loading)
                  const LinearProgressIndicator(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 600;
                      return PaginatedDataTable2(
                        columns: [
                          DataColumn2(
                            label: Text(l10n.source),
                            size: ColumnSize.L,
                          ),
                          if (!isMobile)
                            DataColumn2(
                              label: Text(l10n.syncFrequency),
                              size: ColumnSize.M,
                            ),
                          DataColumn2(
                            label: Text(l10n.syncStatus),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                            label: Text(l10n.actions),
                            size: ColumnSize.S,
                          ),
                        ],
                        source: _SyncDataSource(
                          context: context,
                          tasks: state.tasks,
                          sources: state.sources,
                          l10n: l10n,
                          isMobile: isMobile,
                        ),
                        rowsPerPage: kDefaultRowsPerPage,
                        onPageChanged: (index) {
                          if (state.hasMore &&
                              state.status != ContentSyncStatus.loading) {
                            context.read<ContentSyncBloc>().add(
                              ContentSyncStarted(cursor: state.cursor),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SyncDataSource extends DataTableSource {
  _SyncDataSource({
    required this.context,
    required this.tasks,
    required this.sources,
    required this.l10n,
    required this.isMobile,
  });

  final BuildContext context;
  final List<NewsAutomationTask> tasks;
  final Map<String, Source> sources;
  final AppLocalizations l10n;
  final bool isMobile;

  @override
  DataRow? getRow(int index) {
    if (index >= tasks.length) return null;
    final task = tasks[index];
    final source = sources[task.sourceId];

    return DataRow2(
      cells: [
        DataCell(
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.xs),
                child: source?.logoUrl != null
                    ? Image.network(
                        source!.logoUrl!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 32,
                        height: 32,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Icon(Icons.source, size: 16),
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  source?.name.getValue(context) ?? l10n.unknown,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (!isMobile) DataCell(Text(task.fetchInterval.localizedName(l10n))),
        DataCell(_StatusBadge(status: task.status, l10n: l10n)),
        DataCell(SyncActionButtons(task: task, l10n: l10n)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => tasks.length;
  @override
  int get selectedRowCount => 0;
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.l10n});
  final IngestionStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      IngestionStatus.active => Colors.green,
      IngestionStatus.paused => Colors.grey,
      IngestionStatus.error => Colors.orange,
    };
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
