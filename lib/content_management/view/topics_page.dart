import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/l10n/app_localizations.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/routes.dart';
import 'package:ht_dashboard/shared/shared.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:ht_ui_kit/ht_ui_kit.dart';
import 'package:intl/intl.dart';

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
            return Center(
              child: Text(l10n.noTopicsFound),
            );
          }

          return PaginatedDataTable2(
            columns: [
              DataColumn2(
                label: Text(l10n.topicName),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Text(l10n.status),
                size: ColumnSize.S,
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
              isLoading: state.topicsStatus == ContentManagementStatus.loading,
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
    required this.isLoading,
    required this.hasMore,
    required this.l10n,
  });

  final BuildContext context;
  final List<Topic> topics;
  final bool isLoading;
  final bool hasMore;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= topics.length) {
      // This can happen if hasMore is true and the user is on the last page.
      // If we are loading, show a spinner. Otherwise, we've reached the end.
      if (isLoading) {
        return DataRow2(
          cells: List.generate(
            4,
            (_) => const DataCell(Center(child: CircularProgressIndicator())),
          ),
        );
      }
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
        DataCell(Text(topic.name)),
        DataCell(Text(topic.status.l10n(context))),
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
                    Routes.editTopicName, // Assuming an edit route exists
                    pathParameters: {'id': topic.id},
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Dispatch delete event
                  context.read<ContentManagementBloc>().add(
                    DeleteTopicRequested(topic.id),
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
    // If we have more items to fetch, we add 1 to the current length.
    // This signals to PaginatedDataTable2 that there is at least one more page,
    // which enables the 'next page' button.
    if (hasMore) {
      // When loading, we show an extra row for the spinner.
      // Otherwise, we just indicate that there are more rows.
      return isLoading
          ? topics.length + 1
          : topics.length + kDefaultRowsPerPage;
    }
    return topics.length;
  }

  @override
  int get selectedRowCount => 0;
}
