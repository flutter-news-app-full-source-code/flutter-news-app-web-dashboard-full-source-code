import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/draft_topics/draft_topics_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template draft_topics_page}
/// A page for displaying and managing draft topics in a tabular format.
/// {@endtemplate}
class DraftTopicsPage extends StatelessWidget {
  /// {@macro draft_topics_page}
  const DraftTopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final pendingDeletionsService = context.read<PendingDeletionsService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.draftTopics),
      ),
      body: BlocProvider(
        create: (context) => DraftTopicsBloc(
          topicsRepository: context.read<DataRepository<Topic>>(),
          pendingDeletionsService: pendingDeletionsService,
        )..add(const LoadDraftTopicsRequested(limit: kDefaultRowsPerPage)),
        child: BlocListener<DraftTopicsBloc, DraftTopicsState>(
          listenWhen: (previous, current) =>
              previous.lastPendingDeletionId != current.lastPendingDeletionId ||
              previous.publishedTopic != current.publishedTopic ||
              previous.snackbarTopicTitle != current.snackbarTopicTitle,
          listener: (context, state) {
            if (state.publishedTopic != null) {
              // When a topic is published, refresh the main topics list.
              context.read<ContentManagementBloc>().add(
                const LoadTopicsRequested(limit: kDefaultRowsPerPage),
              );
              // Clear the publishedTopic after it's been handled.
              context.read<DraftTopicsBloc>().add(
                const ClearPublishedTopic(),
              );
            }

            // Show snackbar for pending deletions.
            if (state.snackbarTopicTitle != null) {
              final topicId = state.lastPendingDeletionId!;
              final truncatedTitle = state.snackbarTopicTitle!.truncate(30);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.topicDeleted(truncatedTitle),
                    ),
                    action: SnackBarAction(
                      label: l10n.undo,
                      onPressed: () {
                        // Directly call undoDeletion on the service.
                        pendingDeletionsService.undoDeletion(topicId);
                      },
                    ),
                  ),
                );
            }
          },
          child: BlocBuilder<DraftTopicsBloc, DraftTopicsState>(
            builder: (context, state) {
              if (state.status == DraftTopicsStatus.loading &&
                  state.topics.isEmpty) {
                return LoadingStateWidget(
                  icon: Icons.edit_note,
                  headline: l10n.loadingDraftTopics,
                  subheadline: l10n.pleaseWait,
                );
              }

              if (state.status == DraftTopicsStatus.failure) {
                return FailureStateWidget(
                  exception: state.exception!,
                  onRetry: () => context.read<DraftTopicsBloc>().add(
                    const LoadDraftTopicsRequested(
                      limit: kDefaultRowsPerPage,
                    ),
                  ),
                );
              }

              if (state.topics.isEmpty) {
                return Center(child: Text(l10n.noDraftTopicsFound));
              }

              return Column(
                children: [
                  if (state.status == DraftTopicsStatus.loading &&
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
                        ),
                      ],
                      source: _DraftTopicsDataSource(
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
                            state.status != DraftTopicsStatus.loading) {
                          context.read<DraftTopicsBloc>().add(
                            LoadDraftTopicsRequested(
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

class _DraftTopicsDataSource extends DataTableSource {
  _DraftTopicsDataSource({
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
      onSelectChanged: (selected) {
        if (selected ?? false) {
          context.goNamed(
            Routes.editTopicName,
            pathParameters: {'id': topic.id},
          );
        }
      },
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
              // Primary action: Publish button
              IconButton(
                icon: const Icon(Icons.publish),
                tooltip: l10n.publish,
                onPressed: () {
                  context.read<DraftTopicsBloc>().add(
                    PublishDraftTopicRequested(topic.id),
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
                      Routes.editTopicName,
                      pathParameters: {'id': topic.id},
                    );
                  } else if (value == 'delete') {
                    context.read<DraftTopicsBloc>().add(
                      DeleteDraftTopicForeverRequested(topic.id),
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
                        Text(l10n.editTopic),
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
  int get rowCount => topics.length;

  @override
  int get selectedRowCount => 0;
}
