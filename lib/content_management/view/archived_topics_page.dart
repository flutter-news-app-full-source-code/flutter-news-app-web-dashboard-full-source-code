import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/archived_topics/archived_topics_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

class ArchivedTopicsPage extends StatelessWidget {
  const ArchivedTopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArchivedTopicsBloc(
        topicsRepository: context.read<DataRepository<Topic>>(),
      )..add(const LoadArchivedTopicsRequested(limit: kDefaultRowsPerPage)),
      child: const _ArchivedTopicsView(),
    );
  }
}

class _ArchivedTopicsView extends StatelessWidget {
  const _ArchivedTopicsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.archivedTopics),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: BlocListener<ArchivedTopicsBloc, ArchivedTopicsState>(
          listenWhen: (previous, current) =>
              previous.restoredTopic != current.restoredTopic,
          listener: (context, state) {
            if (state.restoredTopic != null) {
              context
                  .read<ContentManagementBloc>()
                  .add(const LoadTopicsRequested(limit: kDefaultRowsPerPage));
            }
          },
          child: BlocBuilder<ArchivedTopicsBloc, ArchivedTopicsState>(
            builder: (context, state) {
              if (state.status == ArchivedTopicsStatus.loading &&
                  state.topics.isEmpty) {
              return LoadingStateWidget(
                icon: Icons.topic,
                headline: l10n.loadingArchivedTopics,
                subheadline: l10n.pleaseWait,
              );
            }

            if (state.status == ArchivedTopicsStatus.failure) {
              return FailureStateWidget(
                exception: state.exception!,
                onRetry: () => context.read<ArchivedTopicsBloc>().add(
                      const LoadArchivedTopicsRequested(
                        limit: kDefaultRowsPerPage,
                      ),
                    ),
              );
            }

            if (state.topics.isEmpty) {
              return Center(child: Text(l10n.noArchivedTopicsFound));
            }

            return Column(
              children: [
                if (state.status == ArchivedTopicsStatus.loading &&
                    state.topics.isNotEmpty)
                  const LinearProgressIndicator(),
                Expanded(
                  child: PaginatedDataTable2(
                    columns: [
                      DataColumn2(
                        label: Text(l10n.topicName),
                        size: ColumnSize.L,
                      ),
                      DataColumn2(
                        label: Text(l10n.lastUpdated),
                        size: ColumnSize.M,
                      ),
                      DataColumn2(
                        label: Text(l10n.actions),
                        size: ColumnSize.S,
                        fixedWidth: 120,
                      ),
                    ],
                    source: _TopicsDataSource(
                      context: context,
                      topics: state.topics,
                      hasMore: state.hasMore,
                      l10n: l10n,
                    ),
                    rowsPerPage: kDefaultRowsPerPage,
                    availableRowsPerPage: const [kDefaultRowsPerPage],
                    onPageChanged: (pageIndex) {
                      final newOffset = pageIndex * kDefaultRowsPerPage;
                      if (newOffset >= state.topics.length &&
                          state.hasMore &&
                          state.status != ArchivedTopicsStatus.loading) {
                        context.read<ArchivedTopicsBloc>().add(
                              LoadArchivedTopicsRequested(
                                startAfterId: state.cursor,
                                limit: kDefaultRowsPerPage,
                              ),
                            );
                      }
                    },
                    empty: Center(child: Text(l10n.noTopicsFound)),
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
        ),
      ),
    );
  }
}

class _TopicsDataSource extends DataTableSource {
  _TopicsDataSource({
    required this.context,
    required this.topics,
    required this.hasMore,
    required this.l10n,
  });

  final BuildContext context;
  final List<Topic> topics;
  final bool hasMore;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= topics.length) {
      return null;
    }
    final topic = topics[index];
    return DataRow2(
      cells: [
        DataCell(
          Text(
            topic.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            DateFormat('dd-MM-yyyy').format(topic.updatedAt.toLocal()),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.restore),
                tooltip: l10n.restore,
                onPressed: () {
                  context.read<ArchivedTopicsBloc>().add(
                        RestoreTopicRequested(topic.id),
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
  int get rowCount => topics.length;

  @override
  int get selectedRowCount => 0;
}
