import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/source_type_l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template sources_page}
/// A page for displaying and managing Sources in a tabular format.
/// {@endtemplate}
class SourcesPage extends StatefulWidget {
  /// {@macro sources_page}
  const SourcesPage({super.key});

  @override
  State<SourcesPage> createState() => _SourcesPageState();
}

class _SourcesPageState extends State<SourcesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContentManagementBloc>().add(
      const LoadSourcesRequested(limit: kDefaultRowsPerPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: BlocBuilder<ContentManagementBloc, ContentManagementState>(
        builder: (context, state) {
          if (state.sourcesStatus == ContentManagementStatus.loading &&
              state.sources.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.source,
              headline: l10n.loadingSources,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.sourcesStatus == ContentManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<ContentManagementBloc>().add(
                const LoadSourcesRequested(limit: kDefaultRowsPerPage),
              ),
            );
          }

          if (state.sources.isEmpty) {
            return Center(child: Text(l10n.noSourcesFound));
          }

          return Column(
            children: [
              if (state.sourcesStatus == ContentManagementStatus.loading &&
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
                      label: Text(l10n.sourceType),
                      size: ColumnSize.S,
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
                  source: _SourcesDataSource(
                    context: context,
                    sources: state.sources,
                    hasMore: state.sourcesHasMore,
                    l10n: l10n,
                  ),
                  rowsPerPage: kDefaultRowsPerPage,
                  availableRowsPerPage: const [kDefaultRowsPerPage],
                  onPageChanged: (pageIndex) {
                    final newOffset = pageIndex * kDefaultRowsPerPage;
                    if (newOffset >= state.sources.length &&
                        state.sourcesHasMore &&
                        state.sourcesStatus !=
                            ContentManagementStatus.loading) {
                      context.read<ContentManagementBloc>().add(
                        LoadSourcesRequested(
                          startAfterId: state.sourcesCursor,
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
        DataCell(Text(source.sourceType.localizedName(l10n))),
        DataCell(
          Text(
            // TODO(fulleni): Make date format configurable by admin.
            DateFormat('dd-MM-yyyy').format(source.updatedAt.toLocal()),
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
                    Routes.editSourceName,
                    pathParameters: {'id': source.id},
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.archive),
                tooltip: l10n.archive,
                onPressed: () {
                  // Dispatch delete event
                  context.read<ContentManagementBloc>().add(
                    ArchiveSourceRequested(source.id),
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
    return sources.length;
  }

  @override
  int get selectedRowCount => 0;
}
