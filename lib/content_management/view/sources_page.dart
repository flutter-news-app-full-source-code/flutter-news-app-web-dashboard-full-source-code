import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/sources_filter/sources_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/widgets/content_action_buttons.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
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
    // Initial load of sources, applying the default filter from SourcesFilterBloc
    context.read<ContentManagementBloc>().add(
      LoadSourcesRequested(
        limit: kDefaultRowsPerPage,
        filter: context
            .read<ContentManagementBloc>()
            .buildSourcesFilterMap(context.read<SourcesFilterBloc>().state),
      ),
    );
  }

  /// Checks if any filters are currently active in the SourcesFilterBloc.
  bool _areFiltersActive(SourcesFilterState state) {
    return state.searchQuery.isNotEmpty ||
        state.selectedStatus != ContentStatus.active ||
        state.selectedSourceTypes.isNotEmpty ||
        state.selectedLanguageCodes.isNotEmpty ||
        state.selectedHeadquartersCountryIds.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: BlocBuilder<ContentManagementBloc, ContentManagementState>(
        builder: (context, state) {
          final sourcesFilterState = context.watch<SourcesFilterBloc>().state;
          final filtersActive = _areFiltersActive(sourcesFilterState);

          if (state.sourcesStatus == ContentManagementStatus.loading &&
              state.sources.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.rss_feed,
              headline: l10n.loadingSources,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.sourcesStatus == ContentManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<ContentManagementBloc>().add(
                LoadSourcesRequested(
                  limit: kDefaultRowsPerPage,
                  forceRefresh: true,
                  filter: context
                      .read<ContentManagementBloc>()
                      .buildSourcesFilterMap(
                        context.read<SourcesFilterBloc>().state,
                      ),
                ),
              ),
            );
          }

          if (state.sources.isEmpty) {
            if (filtersActive) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.noResultsWithCurrentFilters,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SourcesFilterBloc>().add(
                              const SourcesFilterReset(),
                            );
                      },
                      child: Text(l10n.resetFiltersButtonText),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text(l10n.noSourcesFound));
          }

          return Column(
            children: [
              if (state.sourcesStatus == ContentManagementStatus.loading &&
                  state.sources.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return PaginatedDataTable2(
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
                        isMobile: isMobile,
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
                              filter: context
                                  .read<ContentManagementBloc>()
                                  .buildSourcesFilterMap(
                                    context.read<SourcesFilterBloc>().state,
                                  ),
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
    required this.isMobile,
  });

  final BuildContext context;
  final List<Source> sources;
  final bool hasMore;
  final AppLocalizations l10n;
  final bool isMobile;

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
            source.sourceType.localizedName(l10n),
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
          ContentActionButtons(
            item: source,
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
    return sources.length;
  }

  @override
  int get selectedRowCount => 0;
}
