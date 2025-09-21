import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/archived_headlines/archived_headlines_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

class ArchivedHeadlinesPage extends StatelessWidget {
  const ArchivedHeadlinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArchivedHeadlinesBloc(
        headlinesRepository: context.read<DataRepository<Headline>>(),
      )..add(const LoadArchivedHeadlinesRequested(limit: kDefaultRowsPerPage)),
      child: const _ArchivedHeadlinesView(),
    );
  }
}

class _ArchivedHeadlinesView extends StatelessWidget {
  const _ArchivedHeadlinesView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.archivedHeadlines),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: BlocListener<ArchivedHeadlinesBloc, ArchivedHeadlinesState>(
          listenWhen: (previous, current) =>
              previous.pendingDeletions.length !=
                  current.pendingDeletions.length ||
              previous.restoredHeadline != current.restoredHeadline,
          listener: (context, state) {
            if (state.restoredHeadline != null) {
              context.read<ContentManagementBloc>().add(
                const LoadHeadlinesRequested(limit: kDefaultRowsPerPage),
              );
            }

            if (state.lastPendingDeletionId != null &&
                state.pendingDeletions.containsKey(
                  state.lastPendingDeletionId,
                )) {
              final headline =
                  state.pendingDeletions[state.lastPendingDeletionId];
              if (headline != null) {
                final truncatedTitle = headline.title.truncate(30);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.headlineDeleted(truncatedTitle),
                      ),
                      action: SnackBarAction(
                        label: l10n.undo,
                        onPressed: () {
                          context.read<ArchivedHeadlinesBloc>().add(
                            UndoDeleteHeadlineRequested(headline.id),
                          );
                        },
                      ),
                    ),
                  );
              }
            }
          },
          child: BlocBuilder<ArchivedHeadlinesBloc, ArchivedHeadlinesState>(
            builder: (context, state) {
              if (state.status == ArchivedHeadlinesStatus.loading &&
                  state.headlines.isEmpty) {
                return LoadingStateWidget(
                  icon: Icons.newspaper,
                  headline: l10n.loadingArchivedHeadlines,
                  subheadline: l10n.pleaseWait,
                );
              }

              if (state.status == ArchivedHeadlinesStatus.failure) {
                return FailureStateWidget(
                  exception: state.exception!,
                  onRetry: () => context.read<ArchivedHeadlinesBloc>().add(
                    const LoadArchivedHeadlinesRequested(
                      limit: kDefaultRowsPerPage,
                    ),
                  ),
                );
              }

              if (state.headlines.isEmpty) {
                return Center(child: Text(l10n.noArchivedHeadlinesFound));
              }

              return Column(
                children: [
                  if (state.status == ArchivedHeadlinesStatus.loading &&
                      state.headlines.isNotEmpty)
                    const LinearProgressIndicator(),
                  Expanded(
                    child: PaginatedDataTable2(
                      columns: [
                        DataColumn2(
                          label: Text(l10n.headlineTitle),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text(l10n.sourceName),
                          size: ColumnSize.M,
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
                      source: _HeadlinesDataSource(
                        context: context,
                        headlines: state.headlines,
                        hasMore: state.hasMore,
                        l10n: l10n,
                      ),
                      rowsPerPage: kDefaultRowsPerPage,
                      availableRowsPerPage: const [kDefaultRowsPerPage],
                      onPageChanged: (pageIndex) {
                        final newOffset = pageIndex * kDefaultRowsPerPage;
                        if (newOffset >= state.headlines.length &&
                            state.hasMore &&
                            state.status != ArchivedHeadlinesStatus.loading) {
                          context.read<ArchivedHeadlinesBloc>().add(
                            LoadArchivedHeadlinesRequested(
                              startAfterId: state.cursor,
                              limit: kDefaultRowsPerPage,
                            ),
                          );
                        }
                      },
                      empty: Center(child: Text(l10n.noHeadlinesFound)),
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

class _HeadlinesDataSource extends DataTableSource {
  _HeadlinesDataSource({
    required this.context,
    required this.headlines,
    required this.hasMore,
    required this.l10n,
  });

  final BuildContext context;
  final List<Headline> headlines;
  final bool hasMore;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= headlines.length) {
      return null;
    }
    final headline = headlines[index];
    return DataRow2(
      cells: [
        DataCell(
          Text(
            headline.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(Text(headline.source.name)),
        DataCell(
          Text(
            DateFormat('dd-MM-yyyy').format(headline.updatedAt.toLocal()),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.restore),
                tooltip: l10n.restore,
                onPressed: () {
                  context.read<ArchivedHeadlinesBloc>().add(
                    RestoreHeadlineRequested(headline.id),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever),
                tooltip: l10n.deleteForever,
                onPressed: () {
                  context.read<ArchivedHeadlinesBloc>().add(
                    DeleteHeadlineForeverRequested(headline.id),
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
  int get rowCount => headlines.length;

  @override
  int get selectedRowCount => 0;
}
