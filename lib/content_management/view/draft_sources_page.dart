import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/draft_sources/draft_sources_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template draft_sources_page}
/// A page for displaying and managing draft sources in a tabular format.
/// {@endtemplate}
class DraftSourcesPage extends StatelessWidget {
  /// {@macro draft_sources_page}
  const DraftSourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final pendingDeletionsService = context.read<PendingDeletionsService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.draftSources),
      ),
      body: BlocProvider(
        create: (context) => DraftSourcesBloc(
          sourcesRepository: context.read<DataRepository<Source>>(),
          pendingDeletionsService: pendingDeletionsService,
        )..add(const LoadDraftSourcesRequested(limit: kDefaultRowsPerPage)),
        child: BlocListener<DraftSourcesBloc, DraftSourcesState>(
          listenWhen: (previous, current) =>
              previous.lastPendingDeletionId != current.lastPendingDeletionId ||
              previous.publishedSource != current.publishedSource ||
              previous.snackbarSourceTitle != current.snackbarSourceTitle,
          listener: (context, state) {
            if (state.publishedSource != null) {
              // When a source is published, refresh the main sources list.
              context.read<ContentManagementBloc>().add(
                const LoadSourcesRequested(limit: kDefaultRowsPerPage),
              );
              // Clear the publishedSource after it's been handled.
              context.read<DraftSourcesBloc>().add(
                const ClearPublishedSource(),
              );
            }

            // Show snackbar for pending deletions.
            if (state.snackbarSourceTitle != null) {
              final sourceId = state.lastPendingDeletionId!;
              final truncatedTitle = state.snackbarSourceTitle!.truncate(30);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.sourceDeleted(truncatedTitle),
                    ),
                    action: SnackBarAction(
                      label: l10n.undo,
                      onPressed: () {
                        // Directly call undoDeletion on the service.
                        pendingDeletionsService.undoDeletion(sourceId);
                      },
                    ),
                  ),
                );
            }
          },
          child: BlocBuilder<DraftSourcesBloc, DraftSourcesState>(
            builder: (context, state) {
              if (state.status == DraftSourcesStatus.loading &&
                  state.sources.isEmpty) {
                return LoadingStateWidget(
                  icon: Icons.edit_note,
                  headline: l10n.loadingDraftSources,
                  subheadline: l10n.pleaseWait,
                );
              }

              if (state.status == DraftSourcesStatus.failure) {
                return FailureStateWidget(
                  exception: state.exception!,
                  onRetry: () => context.read<DraftSourcesBloc>().add(
                    const LoadDraftSourcesRequested(
                      limit: kDefaultRowsPerPage,
                    ),
                  ),
                );
              }

              if (state.sources.isEmpty) {
                return Center(child: Text(l10n.noDraftSourcesFound));
              }

              return Column(
                children: [
                  if (state.status == DraftSourcesStatus.loading &&
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
                      source: _DraftSourcesDataSource(
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
                            state.status != DraftSourcesStatus.loading) {
                          context.read<DraftSourcesBloc>().add(
                            LoadDraftSourcesRequested(
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

class _DraftSourcesDataSource extends DataTableSource {
  _DraftSourcesDataSource({
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
      onSelectChanged: (selected) {
        if (selected ?? false) {
          context.goNamed(
            Routes.editSourceName,
            pathParameters: {'id': source.id},
          );
        }
      },
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
                icon: const Icon(Icons.publish),
                tooltip: l10n.publish,
                onPressed: () {
                  context.read<DraftSourcesBloc>().add(
                    PublishDraftSourceRequested(source.id),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: l10n.editSource,
                onPressed: () {
                  context.goNamed(
                    Routes.editSourceName,
                    pathParameters: {'id': source.id},
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever),
                tooltip: l10n.deleteForever,
                onPressed: () {
                  context.read<DraftSourcesBloc>().add(
                    DeleteDraftSourceForeverRequested(source.id),
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
