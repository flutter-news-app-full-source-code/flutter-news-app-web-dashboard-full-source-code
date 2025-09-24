import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/shared.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template topics_page}
/// A page for displaying and managing Topics in a tabular format.
/// {@endtemplate}
class TopicPage extends StatefulWidget {
  /// {@macro topics_page}
  const TopicPage({super.key});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContentManagementBloc>().add(
      const LoadTopicsRequested(limit: kDefaultRowsPerPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: BlocBuilder<ContentManagementBloc, ContentManagementState>(
        builder: (context, state) {
          if (state.topicsStatus == ContentManagementStatus.loading &&
              state.topics.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.topic,
              headline: l10n.loadingTopics,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.topicsStatus == ContentManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<ContentManagementBloc>().add(
                const LoadTopicsRequested(limit: kDefaultRowsPerPage),
              ),
            );
          }

          if (state.topics.isEmpty) {
            return Center(child: Text(l10n.noTopicsFound));
          }

          return Column(
            children: [
              if (state.topicsStatus == ContentManagementStatus.loading &&
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
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(l10n.actions),
                      size: ColumnSize.S,
                    ),
                  ],
                  source: _TopicsDataSource(
                    context: context,
                    topics: state.topics,
                    hasMore: state.topicsHasMore,
                    l10n: l10n,
                  ),
                  rowsPerPage: kDefaultRowsPerPage,
                  availableRowsPerPage: const [kDefaultRowsPerPage],
                  onPageChanged: (pageIndex) {
                    final newOffset = pageIndex * kDefaultRowsPerPage;
                    if (newOffset >= state.topics.length &&
                        state.topicsHasMore &&
                        state.topicsStatus != ContentManagementStatus.loading) {
                      context.read<ContentManagementBloc>().add(
                        LoadTopicsRequested(
                          startAfterId: state.topicsCursor,
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
            // TODO(fulleni): Make date format configurable by admin.
            DateFormat('dd-MM-yyyy').format(topic.updatedAt.toLocal()),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Navigate to edit page
                  context.goNamed(
                    Routes.editTopicName,
                    pathParameters: {'id': topic.id},
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.archive),
                tooltip: l10n.archive,
                onPressed: () {
                  // Dispatch delete event
                  context.read<ContentManagementBloc>().add(
                    ArchiveTopicRequested(topic.id),
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
  int get rowCount {
    return topics.length;
  }

  @override
  int get selectedRowCount => 0;
}
