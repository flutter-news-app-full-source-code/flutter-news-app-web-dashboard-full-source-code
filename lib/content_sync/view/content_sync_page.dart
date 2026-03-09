import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:verity_dashboard/content_sync/bloc/content_sync_bloc.dart';
import 'package:verity_dashboard/content_sync/widgets/sync_action_buttons.dart';
import 'package:verity_dashboard/l10n/app_localizations.dart';
import 'package:verity_dashboard/l10n/l10n.dart';
import 'package:verity_dashboard/router/routes.dart';
import 'package:verity_dashboard/shared/extensions/fetch_interval_extension.dart';
import 'package:verity_dashboard/shared/extensions/multilingual_map_extension.dart';
import 'package:verity_dashboard/shared/widgets/analytics/analytics_dashboard_strip.dart';

class ContentSyncPage extends StatelessWidget {
  const ContentSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contentSync),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(Routes.createSyncName),
        icon: const Icon(Icons.add),
        label: Text(l10n.createSync),
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
                  child: PaginatedDataTable2(
                    columns: [
                      DataColumn2(label: Text(l10n.source), size: ColumnSize.L),
                      DataColumn2(
                        label: Text(l10n.syncFrequency),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: Text(l10n.syncStatus),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text(l10n.lastSynced),
                        size: ColumnSize.M,
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
  });

  final BuildContext context;
  final List<NewsAutomationTask> tasks;
  final Map<String, Source> sources;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= tasks.length) return null;
    final task = tasks[index];
    final source = sources[task.sourceId];

    return DataRow2(
      onSelectChanged: (_) => context.goNamed(
        Routes.editSyncName,
        pathParameters: {'id': task.id},
      ),
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: source?.logoUrl != null
                    ? NetworkImage(source!.logoUrl!)
                    : null,
                child: source?.logoUrl == null
                    ? const Icon(Icons.source)
                    : null,
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
        DataCell(Text(task.fetchInterval.localizedName(l10n))),
        DataCell(_StatusBadge(status: task.status, l10n: l10n)),
        DataCell(
          Text(
            task.lastRunAt != null
                ? DateFormat.yMMMd().add_Hm().format(task.lastRunAt!.toLocal())
                : l10n.notAvailable,
          ),
        ),
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
    final label = status == IngestionStatus.active
        ? l10n.syncActive
        : l10n.syncPaused;
    return Badge(label: Text(label), backgroundColor: color);
  }
}
