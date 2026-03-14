import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:verity_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:verity_dashboard/content_management/bloc/persons_filter/persons_filter_bloc.dart';
import 'package:verity_dashboard/content_management/bloc/persons_filter/persons_filter_event.dart';
import 'package:verity_dashboard/content_management/bloc/persons_filter/persons_filter_state.dart';
import 'package:verity_dashboard/content_management/widgets/content_action_buttons.dart';
import 'package:verity_dashboard/l10n/app_localizations.dart';
import 'package:verity_dashboard/l10n/l10n.dart';
import 'package:verity_dashboard/router/routes.dart';
import 'package:verity_dashboard/shared/extensions/multilingual_map_extension.dart';
import 'package:verity_dashboard/shared/widgets/analytics/analytics_dashboard_strip.dart';
import 'package:verity_dashboard/shared/widgets/entity_image.dart';

/// {@template persons_page}
/// A page for displaying and managing Persons in a tabular format.
/// {@endtemplate}
class PersonsPage extends StatefulWidget {
  /// {@macro persons_page}
  const PersonsPage({super.key});

  @override
  State<PersonsPage> createState() => _PersonsPageState();
}

class _PersonsPageState extends State<PersonsPage> {
  @override
  void initState() {
    super.initState();
    // Initial load of persons, applying the default filter from PersonsFilterBloc
    context.read<ContentManagementBloc>().add(
      LoadPersonsRequested(
        limit: kDefaultRowsPerPage,
        filter: context.read<PersonsFilterBloc>().buildFilterMap(),
      ),
    );
  }

  /// Checks if any filters are currently active in the PersonsFilterBloc.
  bool _areFiltersActive(PersonsFilterState state) {
    return state.searchQuery.isNotEmpty ||
        state.selectedStatus != ContentStatus.active;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<ContentManagementBloc, ContentManagementState>(
        builder: (context, state) {
          final personsFilterState = context.watch<PersonsFilterBloc>().state;
          final filtersActive = _areFiltersActive(personsFilterState);

          if (state.personsStatus == ContentManagementStatus.loading &&
              state.persons.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.person,
              headline: l10n.loadingPersons,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.personsStatus == ContentManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () {
                context.read<ContentManagementBloc>().add(
                  LoadPersonsRequested(
                    limit: kDefaultRowsPerPage,
                    forceRefresh: true,
                    filter: context.read<PersonsFilterBloc>().buildFilterMap(),
                  ),
                );
              },
            );
          }

          if (state.persons.isEmpty) {
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
                        context.read<PersonsFilterBloc>().add(
                          const PersonsFilterReset(),
                        );
                      },
                      child: Text(l10n.resetFiltersButtonText),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text(l10n.noPersonsFound));
          }

          return Column(
            children: [
              // Analytics Dashboard Strip
              const AnalyticsDashboardStrip(
                kpiCards: [
                  KpiCardId.contentPersonsTotal,
                  KpiCardId.contentPersonsTotalFollowers,
                ],
                chartCards: [
                  ChartCardId.contentPersonsMentionsOverTime,
                  ChartCardId.contentPersonsEngagementByEntity,
                  ChartCardId.contentHeadlinesViewsByPerson,
                ],
              ),
              if (state.personsStatus == ContentManagementStatus.loading &&
                  state.persons.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return PaginatedDataTable2(
                      columns: [
                        DataColumn2(
                          label: Text(l10n.personName),
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
                      source: _PersonsDataSource(
                        context: context,
                        persons: state.persons,
                        hasMore: state.personsHasMore,
                        l10n: l10n,
                        isMobile: isMobile,
                      ),
                      rowsPerPage: kDefaultRowsPerPage,
                      availableRowsPerPage: const [kDefaultRowsPerPage],
                      onPageChanged: (pageIndex) {
                        final newOffset = pageIndex * kDefaultRowsPerPage;
                        if (newOffset >= state.persons.length &&
                            state.personsHasMore &&
                            state.personsStatus !=
                                ContentManagementStatus.loading) {
                          context.read<ContentManagementBloc>().add(
                            LoadPersonsRequested(
                              startAfterId: state.personsCursor,
                              limit: kDefaultRowsPerPage,
                              filter: context
                                  .read<PersonsFilterBloc>()
                                  .buildFilterMap(),
                            ),
                          );
                        }
                      },
                      empty: Center(child: Text(l10n.noPersonsFound)),
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

class _PersonsDataSource extends DataTableSource {
  _PersonsDataSource({
    required this.context,
    required this.persons,
    required this.hasMore,
    required this.l10n,
    required this.isMobile,
  });

  final BuildContext context;
  final List<Person> persons;
  final bool hasMore;
  final AppLocalizations l10n;
  final bool isMobile;

  @override
  DataRow? getRow(int index) {
    if (index >= persons.length) {
      return null;
    }
    final person = persons[index];
    return DataRow2(
      onSelectChanged: (selected) {
        if (selected ?? false) {
          context.goNamed(
            Routes.editPersonName,
            pathParameters: {'id': person.id},
          );
        }
      },
      cells: [
        DataCell(
          Row(
            children: [
              EntityImage(
                imageUrl: person.imageUrl,
                placeholderIcon: Icons.person,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  person.name.getValue(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            DateFormat('dd-MM-yyyy').format(person.updatedAt.toLocal()),
          ),
        ),
        DataCell(
          ContentActionButtons(
            item: person,
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
    return persons.length;
  }

  @override
  int get selectedRowCount => 0;
}
