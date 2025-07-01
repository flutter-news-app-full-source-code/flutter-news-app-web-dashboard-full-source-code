import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/l10n/app_localizations.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/routes.dart';
import 'package:ht_dashboard/shared/constants/app_spacing.dart';
import 'package:ht_dashboard/shared/widgets/failure_state_widget.dart';
import 'package:ht_dashboard/shared/widgets/loading_state_widget.dart';
import 'package:ht_shared/ht_shared.dart';

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
  static const int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    context.read<ContentManagementBloc>().add(
          const LoadSourcesRequested(limit: _rowsPerPage),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              message: state.errorMessage ?? l10n.unknownError,
              onRetry: () => context.read<ContentManagementBloc>().add(
                    const LoadSourcesRequested(limit: _rowsPerPage),
                  ),
            );
          }

          if (state.sources.isEmpty) {
            return Center(
              child: Text(l10n.noSourcesFound),
            );
          }

          return PaginatedDataTable2(
            columns: [
              DataColumn2(
                label: Text(l10n.sourceName),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Text(l10n.sourceType),
                size: ColumnSize.M,
              ),
              DataColumn2(
                label: Text(l10n.language),
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
              l10n: l10n,
            ),
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: const [_rowsPerPage],
            onPageChanged: (pageIndex) {
              final newOffset = pageIndex * _rowsPerPage;
              if (newOffset >= state.sources.length && state.sourcesHasMore) {
                context.read<ContentManagementBloc>().add(
                      LoadSourcesRequested(
                        startAfterId: state.sourcesCursor,
                        limit: _rowsPerPage,
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
    required this.l10n,
  });

  final BuildContext context;
  final List<Source> sources;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= sources.length) {
      return null;
    }
    final source = sources[index];
    return DataRow2(
      cells: [
        DataCell(Text(source.name)),
        DataCell(Text(source.sourceType?.name ?? l10n.unknown)),
        DataCell(Text(source.language ?? l10n.unknown)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Navigate to edit page
                  context.goNamed(
                    Routes.editSourceName, // Assuming an edit route exists
                    pathParameters: {'id': source.id},
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Dispatch delete event
                  context.read<ContentManagementBloc>().add(
                        DeleteSourceRequested(source.id),
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
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => sources.length;

  @override
  int get selectedRowCount => 0;
}
