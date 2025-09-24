import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/draft_headlines/draft_headlines_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template draft_headlines_page}
/// A page for displaying and managing draft headlines in a tabular format.
/// {@endtemplate}
class DraftHeadlinesPage extends StatelessWidget {
  /// {@macro draft_headlines_page}
  const DraftHeadlinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final pendingDeletionsService = context.read<PendingDeletionsService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.draftHeadlines),
      ),
      body: BlocProvider(
        create: (context) => DraftHeadlinesBloc(
          headlinesRepository: context.read<DataRepository<Headline>>(),
          pendingDeletionsService: pendingDeletionsService,
        )..add(const LoadDraftHeadlinesRequested(limit: kDefaultRowsPerPage)),
        child: BlocListener<DraftHeadlinesBloc, DraftHeadlinesState>(
          listenWhen: (previous, current) =>
              previous.lastPendingDeletionId != current.lastPendingDeletionId ||
              previous.publishedHeadline != current.publishedHeadline ||
              previous.snackbarHeadlineTitle != current.snackbarHeadlineTitle,
          listener: (context, state) {
            if (state.publishedHeadline != null) {
              // When a headline is published, refresh the main headlines list.
              context.read<ContentManagementBloc>().add(
                const LoadHeadlinesRequested(limit: kDefaultRowsPerPage),
              );
              // Clear the publishedHeadline after it's been handled.
              context.read<DraftHeadlinesBloc>().add(
                const ClearPublishedHeadline(),
              );
            }

            // Show snackbar for pending deletions.
            if (state.snackbarHeadlineTitle != null) {
              final headlineId = state.lastPendingDeletionId!;
              final truncatedTitle = state.snackbarHeadlineTitle!.truncate(30);
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
                        // Directly call undoDeletion on the service.
                        pendingDeletionsService.undoDeletion(headlineId);
                      },
                    ),
                  ),
                );
            }
          },
          child: BlocBuilder<DraftHeadlinesBloc, DraftHeadlinesState>(
            builder: (context, state) {
              if (state.status == DraftHeadlinesStatus.loading &&
                  state.headlines.isEmpty) {
                return LoadingStateWidget(
                  icon: Icons.edit_note,
                  headline: l10n.loadingDraftHeadlines,
                  subheadline: l10n.pleaseWait,
                );
              }

              if (state.status == DraftHeadlinesStatus.failure) {
                return FailureStateWidget(
                  exception: state.exception!,
                  onRetry: () => context.read<DraftHeadlinesBloc>().add(
                    const LoadDraftHeadlinesRequested(
                      limit: kDefaultRowsPerPage,
                    ),
                  ),
                );
              }

              if (state.headlines.isEmpty) {
                return Center(child: Text(l10n.noDraftHeadlinesFound));
              }

              return Column(
                children: [
                  if (state.status == DraftHeadlinesStatus.loading &&
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
                        ),
                      ],
                      source: _DraftHeadlinesDataSource(
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
                            state.status != DraftHeadlinesStatus.loading) {
                          context.read<DraftHeadlinesBloc>().add(
                            LoadDraftHeadlinesRequested(
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

class _DraftHeadlinesDataSource extends DataTableSource {
  _DraftHeadlinesDataSource({
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
      onSelectChanged: (selected) {
        if (selected ?? false) {
          context.goNamed(
            Routes.editHeadlineName,
            pathParameters: {'id': headline.id},
          );
        }
      },
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
              // Primary action: Publish button
              IconButton(
                icon: const Icon(Icons.publish),
                tooltip: l10n.publish,
                onPressed: () {
                  context.read<DraftHeadlinesBloc>().add(
                    PublishDraftHeadlineRequested(headline.id),
                  );
                },
              ),
              // Secondary actions: Edit and Delete via PopupMenuButton
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                tooltip: l10n.moreActions,
                onSelected: (value) {
                  if (value == 'edit') {
                    context.goNamed(
                      Routes.editHeadlineName,
                      pathParameters: {'id': headline.id},
                    );
                  } else if (value == 'delete') {
                    context.read<DraftHeadlinesBloc>().add(
                      DeleteDraftHeadlineForeverRequested(headline.id),
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
                        Text(l10n.editHeadline),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_forever),
                        const SizedBox(width: AppSpacing.sm),
                        Text(l10n.deleteForever),
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
  int get rowCount => headlines.length;

  @override
  int get selectedRowCount => 0;
}
