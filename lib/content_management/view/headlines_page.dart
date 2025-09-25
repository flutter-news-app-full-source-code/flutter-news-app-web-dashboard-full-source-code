import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/widgets/content_action_buttons.dart'; // Import the new widget
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

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
  @override
  void initState() {
    super.initState();
    // Initial load of headlines, applying the default filter from HeadlinesFilterBloc
    context.read<ContentManagementBloc>().add(
      LoadHeadlinesRequested(
        limit: kDefaultRowsPerPage,
        filter: _buildHeadlinesFilterMap(
          context.read<HeadlinesFilterBloc>().state,
        ),
      ),
    );
  }

  /// Builds a filter map for headlines from the given filter state.
  Map<String, dynamic> _buildHeadlinesFilterMap(HeadlinesFilterState state) {
    final filter = <String, dynamic>{};

    if (state.searchQuery.isNotEmpty) {
      filter['title'] = {r'$regex': state.searchQuery, r'$options': 'i'};
    }

    filter['status'] = state.selectedStatus.name;

    if (state.selectedSourceIds.isNotEmpty) {
      filter['source.id'] = {r'$in': state.selectedSourceIds};
    }
    if (state.selectedTopicIds.isNotEmpty) {
      filter['topic.id'] = {r'$in': state.selectedTopicIds};
    }
    if (state.selectedCountryIds.isNotEmpty) {
      filter['eventCountry.id'] = {r'$in': state.selectedCountryIds};
    }

    return filter;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
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
              exception: state.exception!,
              onRetry: () => context.read<ContentManagementBloc>().add(
                LoadHeadlinesRequested(
                  limit: kDefaultRowsPerPage,
                  forceRefresh: true,
                  filter: _buildHeadlinesFilterMap(
                    context.read<HeadlinesFilterBloc>().state,
                  ),
                ),
              ),
            );
          }

          if (state.headlines.isEmpty) {
            return Center(child: Text(l10n.noHeadlinesFound));
          }

          return Column(
            children: [
              if (state.headlinesStatus == ContentManagementStatus.loading &&
                  state.headlines.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return PaginatedDataTable2(
                      columns: [
                        DataColumn2(
                          label: Text(l10n.headlineTitle),
                          size: ColumnSize.L,
                        ),
                        if (!isMobile) // Conditionally show Source Name
                          DataColumn2(
                            label: Text(l10n.sourceName),
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
                      source: _HeadlinesDataSource(
                        context: context,
                        headlines: state.headlines,
                        hasMore: state.headlinesHasMore,
                        l10n: l10n,
                        isMobile: isMobile, // Pass isMobile to data source
                      ),
                      rowsPerPage: kDefaultRowsPerPage,
                      availableRowsPerPage: const [kDefaultRowsPerPage],
                      onPageChanged: (pageIndex) {
                        final newOffset = pageIndex * kDefaultRowsPerPage;
                        if (newOffset >= state.headlines.length &&
                            state.headlinesHasMore &&
                            state.headlinesStatus !=
                                ContentManagementStatus.loading) {
                          context.read<ContentManagementBloc>().add(
                            LoadHeadlinesRequested(
                              startAfterId: state.headlinesCursor,
                              limit: kDefaultRowsPerPage,
                              filter: _buildHeadlinesFilterMap(
                                context.read<HeadlinesFilterBloc>().state,
                              ),
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
              ),
            ],
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
    required this.hasMore,
    required this.l10n,
    required this.isMobile, // New parameter
  });

  final BuildContext context;
  final List<Headline> headlines;
  final bool hasMore;
  final AppLocalizations l10n;
  final bool isMobile; // New parameter

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
        if (!isMobile) // Conditionally show Source Name
          DataCell(Text(headline.source.name)),
        DataCell(
          Text(
            DateFormat('dd-MM-yyyy').format(headline.updatedAt.toLocal()),
          ),
        ),
        DataCell(
          ContentActionButtons(
            item: headline,
            l10n: l10n,
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => hasMore;

  @override
  int get rowCount {
    return headlines.length;
  }

  @override
  int get selectedRowCount => 0;
}
