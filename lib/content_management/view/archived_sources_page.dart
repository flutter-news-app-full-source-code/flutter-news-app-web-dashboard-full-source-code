import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/archived_sources/archived_sources_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

class ArchivedSourcesPage extends StatelessWidget {
  const ArchivedSourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArchivedSourcesBloc(
        sourcesRepository: context.read<DataRepository<Source>>(),
      )..add(const LoadArchivedSourcesRequested(limit: kDefaultRowsPerPage)),
      child: const _ArchivedSourcesView(),
    );
  }
}

class _ArchivedSourcesView extends StatelessWidget {
  const _ArchivedSourcesView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.archivedSources),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: BlocListener<ArchivedSourcesBloc, ArchivedSourcesState>(
          listenWhen: (previous, current) =>
              previous.restoredSource != current.restoredSource,
          listener: (context, state) {
            if (state.restoredSource != null) {
              context.read<ContentManagementBloc>().add(
                const LoadSourcesRequested(limit: kDefaultRowsPerPage),
              );
            }
          },
          child: BlocBuilder<ArchivedSourcesBloc, ArchivedSourcesState>(
            builder: (context, state) {
              if (state.status == ArchivedSourcesStatus.loading &&
                  state.sources.isEmpty) {
                return LoadingStateWidget(
                  icon: Icons.source,
                  headline: l10n.loadingArchivedSources,
                  subheadline: l10n.pleaseWait,
                );
              }

              if (state.status == ArchivedSourcesStatus.failure) {
                return FailureStateWidget(
                  exception: state.exception!,
                  onRetry: () => context.read<ArchivedSourcesBloc>().add(
                    const LoadArchivedSourcesRequested(
                      limit: kDefaultRowsPerPage,
                    ),
                  ),
                );
              }

              if (state.sources.isEmpty) {
                return Center(child: Text(l10n.noArchivedSourcesFound));
              }

              return Column(
                children: [
                  if (state.status == ArchivedSourcesStatus.loading &&
                      state.sources.isNotEmpty)
                    const LinearProgressIndicator(),
                  Expanded(
                    child: PaginatedDataTable2(
                      columns: [
                        DataColumn2(
                          label: Text(l10n.sourceName),
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
                      source: _SourcesDataSource(
                        context: context,
                        sources: state.sources,
                        hasMore: state.hasMore,
                        l10n: l10n,
                      ),
                      rowsPerPage: kDefaultRowsPerPage,
                      availableRowsPerPage: const [kDefaultRowsPerPage],
                      onPageChanged: (pageIndex) {
                        final newOffset = pageIndex * kDefaultRowsPerPage;
                        if (newOffset >= state.sources.length &&
                            state.hasMore &&
                            state.status != ArchivedSourcesStatus.loading) {
                          context.read<ArchivedSourcesBloc>().add(
                            LoadArchivedSourcesRequested(
                              startAfterId: state.cursor,
                              limit: kDefaultRowsPerPage,
                            ),
                          );
                        }
                      },
                      empty: Center(child: Text(l10n.noSourcesFound)),
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

class _SourcesDataSource extends DataTableSource {
  _SourcesDataSource({
    required this.context,
    required this.sources,
    required this.hasMore,
    required this.l10n,
  });

  final BuildContext context;
  final List<Source> sources;
  final bool hasMore;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= sources.length) {
      return null;
    }
    final source = sources[index];
    return DataRow2(
      cells: [
        DataCell(
          Text(
            source.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(
            DateFormat('dd-MM-yyyy').format(source.updatedAt.toLocal()),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.restore),
                tooltip: l10n.restore,
                onPressed: () {
                  context.read<ArchivedSourcesBloc>().add(
                    RestoreSourceRequested(source.id),
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
  int get rowCount => sources.length;

  @override
  int get selectedRowCount => 0;
}
