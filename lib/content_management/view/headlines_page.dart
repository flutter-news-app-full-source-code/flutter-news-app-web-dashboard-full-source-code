import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/l10n/app_localizations.dart'; // Corrected import
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/routes.dart';
import 'package:ht_dashboard/shared/constants/app_spacing.dart';
import 'package:ht_dashboard/shared/utils/date_formatter.dart';
import 'package:ht_dashboard/shared/widgets/failure_state_widget.dart';
import 'package:ht_dashboard/shared/widgets/loading_state_widget.dart';
import 'package:ht_shared/ht_shared.dart';

/// {@template headlines_page}
/// A page for displaying and managing Headlines in a tabular format.
/// {@endtemplate}
class HeadlinesPage extends StatefulWidget {
  /// {@macro headlines_page}
  const HeadlinesPage({super.key});

  @override
  State<HeadlinesPage> createState() => _HeadlinesPageState();
}

class _HeadlinesPageState extends State<HeadlinesPage> {
  static const int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    context.read<ContentManagementBloc>().add(
          const LoadHeadlinesRequested(limit: _rowsPerPage),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: BlocBuilder<ContentManagementBloc, ContentManagementState>(
        builder: (context, state) {
          if (state.headlinesStatus == ContentManagementStatus.loading &&
              state.headlines.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.newspaper,
              headline: l10n.loadingHeadlines,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.headlinesStatus == ContentManagementStatus.failure) {
            return FailureStateWidget(
              message: state.errorMessage ?? l10n.unknownError,
              onRetry: () => context.read<ContentManagementBloc>().add(
                    const LoadHeadlinesRequested(limit: _rowsPerPage),
                  ),
            );
          }

          if (state.headlines.isEmpty) {
            return Center(
              child: Text(l10n.noHeadlinesFound),
            );
          }

          return PaginatedDataTable2(
            columns: [
              DataColumn2(
                label: Text(l10n.headlineTitle),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Text(l10n.source),
                size: ColumnSize.M,
              ),
              DataColumn2(
                label: Text(l10n.publishedAt),
                size: ColumnSize.S,
              ),
              DataColumn2(
                label: Text(l10n.actions),
                size: ColumnSize.S,
              ),
            ],
            source: _HeadlinesDataSource(
              context: context,
              headlines: state.headlines,
              l10n: l10n,
            ),
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: const [_rowsPerPage],
            onPageChanged: (pageIndex) {
              final newOffset = pageIndex * _rowsPerPage;
              if (newOffset >= state.headlines.length &&
                  state.headlinesHasMore) {
                context.read<ContentManagementBloc>().add(
                      LoadHeadlinesRequested(
                        startAfterId: state.headlinesCursor,
                        limit: _rowsPerPage,
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
          );
        },
      ),
    );
  }
}

class _HeadlinesDataSource extends DataTableSource {
  _HeadlinesDataSource({
    required this.context,
    required this.headlines,
    required this.l10n,
  });

  final BuildContext context;
  final List<Headline> headlines;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= headlines.length) {
      return null;
    }
    final headline = headlines[index];
    return DataRow2(
      cells: [
        DataCell(Text(headline.title)),
        DataCell(Text(headline.source?.name ?? l10n.unknown)),
        DataCell(
          Text(
            headline.publishedAt != null
                ? DateFormatter.formatDate(headline.publishedAt!)
                : l10n.unknown,
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
                    Routes.editHeadlineName,
                    pathParameters: {'id': headline.id},
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Dispatch delete event
                  context.read<ContentManagementBloc>().add(
                        DeleteHeadlineRequested(headline.id),
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
  int get rowCount => headlines.length;

  @override
  int get selectedRowCount => 0;
}
