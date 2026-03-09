import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:verity_dashboard/app/bloc/app_bloc.dart';
import 'package:verity_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:verity_dashboard/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:verity_dashboard/content_management/widgets/content_action_buttons.dart';
import 'package:verity_dashboard/l10n/app_localizations.dart';
import 'package:verity_dashboard/l10n/l10n.dart';
import 'package:verity_dashboard/router/routes.dart';
import 'package:verity_dashboard/shared/extensions/multilingual_map_extension.dart';
import 'package:verity_dashboard/shared/widgets/analytics/analytics_dashboard_strip.dart';

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
    final appSettings = context.read<AppBloc>().state.appSettings;
    final currentLanguageCode = appSettings?.language.name ?? 'en';
    context.read<ContentManagementBloc>().add(
      LoadHeadlinesRequested(
        limit: kDefaultRowsPerPage,
        filter: context.read<HeadlinesFilterBloc>().buildFilterMap(
          languageCode: currentLanguageCode,
        ),
      ),
    );
  }

  /// Checks if any filters are currently active in the HeadlinesFilterBloc.
  bool _areFiltersActive(HeadlinesFilterState state) {
    return state.searchQuery.isNotEmpty ||
        state.selectedStatus != ContentStatus.active ||
        state.selectedSourceIds.isNotEmpty ||
        state.selectedTopicIds.isNotEmpty ||
        state.selectedCountryIds.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<ContentManagementBloc, ContentManagementState>(
        builder: (context, state) {
          final headlinesFilterState = context
              .watch<HeadlinesFilterBloc>()
              .state;
          final filtersActive = _areFiltersActive(headlinesFilterState);

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
              onRetry: () {
                final appSettings = context.read<AppBloc>().state.appSettings;
                final currentLanguageCode = appSettings?.language.name ?? 'en';
                context.read<ContentManagementBloc>().add(
                  LoadHeadlinesRequested(
                    limit: kDefaultRowsPerPage,
                    forceRefresh: true,
                    filter: context.read<HeadlinesFilterBloc>().buildFilterMap(
                      languageCode: currentLanguageCode,
                    ),
                  ),
                );
              },
            );
          }

          if (state.headlines.isEmpty) {
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
                        context.read<HeadlinesFilterBloc>().add(
                          const HeadlinesFilterReset(),
                        );
                      },
                      child: Text(l10n.resetFiltersButtonText),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text(l10n.noHeadlinesFound));
          }

          return Column(
            children: [
              // Analytics Dashboard Strip
              const AnalyticsDashboardStrip(
                kpiCards: [
                  KpiCardId.contentHeadlinesTotalPublished,
                  KpiCardId.contentHeadlinesTotalViews,
                  KpiCardId.contentHeadlinesTotalLikes,
                ],
                chartCards: [
                  ChartCardId.contentHeadlinesViewsOverTime,
                  ChartCardId.contentHeadlinesLikesOverTime,
                  ChartCardId.contentHeadlinesViewsByTopic,
                ],
              ),
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
                        isMobile: isMobile,
                      ),
                      rowsPerPage: kDefaultRowsPerPage,
                      availableRowsPerPage: const [kDefaultRowsPerPage],
                      onPageChanged: (pageIndex) {
                        final newOffset = pageIndex * kDefaultRowsPerPage;
                        if (newOffset >= state.headlines.length &&
                            state.headlinesHasMore &&
                            state.headlinesStatus !=
                                ContentManagementStatus.loading) {
                          final appSettings = context
                              .read<AppBloc>()
                              .state
                              .appSettings;
                          final currentLanguageCode =
                              appSettings?.language.name ?? 'en';
                          context.read<ContentManagementBloc>().add(
                            LoadHeadlinesRequested(
                              startAfterId: state.headlinesCursor,
                              limit: kDefaultRowsPerPage,
                              filter: context
                                  .read<HeadlinesFilterBloc>()
                                  .buildFilterMap(
                                    languageCode: currentLanguageCode,
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
                      columnSpacing: AppSpacing.sm,
                      horizontalMargin: AppSpacing.sm,
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
    required this.isMobile,
  });

  final BuildContext context;
  final List<Headline> headlines;
  final bool hasMore;
  final AppLocalizations l10n;
  final bool isMobile;

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
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.xs),
                    child: headline.imageUrl != null
                        ? Image.network(
                            headline.imageUrl!,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 32,
                            height: 32,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: const Icon(Icons.image, size: 16),
                          ),
                  ),
                  if (headline.isBreaking)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Tooltip(
                        message: l10n.breakingNewsHint,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.flash_on,
                            size: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  headline.title.getValue(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        if (!isMobile)
          DataCell(
            Tooltip(
              message: headline.source.name.getValue(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.xs),
                child: headline.source.logoUrl != null
                    ? Image.network(
                        headline.source.logoUrl!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 32,
                        height: 32,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Icon(Icons.source, size: 16),
                      ),
              ),
            ),
          ),
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
