import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_filter/community_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart'
    show CommunityManagementBloc, CommunityManagementTab;
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:ui_kit/ui_kit.dart';

class CommunityFilterDialog extends StatefulWidget {
  const CommunityFilterDialog({super.key});

  @override
  State<CommunityFilterDialog> createState() => _CommunityFilterDialogState();
}

class _CommunityFilterDialogState extends State<CommunityFilterDialog> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    final filterState = context.read<CommunityFilterBloc>().state;
    final activeTab = context.read<CommunityManagementBloc>().state.activeTab;
    switch (activeTab) {
      case CommunityManagementTab.engagements:
        _searchController.text =
            filterState.engagementsFilter.searchQuery ?? '';
      case CommunityManagementTab.reports:
        _searchController.text = filterState.reportsFilter.searchQuery ?? '';
      case CommunityManagementTab.appReviews:
        _searchController.text = filterState.appReviewsFilter.searchQuery ?? '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);
    final activeTab = context
        .select<CommunityManagementBloc, CommunityManagementTab>(
          (bloc) => bloc.state.activeTab,
        );

    return BlocBuilder<CommunityFilterBloc, CommunityFilterState>(
      builder: (context, filterState) {
        _updateSearchController(filterState, activeTab);
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _searchController.text.length),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.filterCommunity),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l10n.resetFiltersButtonText,
                onPressed: () {
                  final filterBloc = context.read<CommunityFilterBloc>()
                    ..add(const CommunityFilterReset());
                  _dispatchFilterChanges(
                    filterBloc,
                    const CommunityFilterState(),
                  );
                  filterBloc.add(const CommunityFilterApplied());
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: l10n.applyFilters,
                onPressed: () {
                  context.read<CommunityFilterBloc>().add(
                    const CommunityFilterApplied(),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: l10n.searchByUserId,
                      hintText: l10n.searchByUserId,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      _onSearchQueryChanged(context, query, activeTab);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ..._buildTabSpecificFilters(
                    activeTab,
                    filterState,
                    l10n,
                    theme,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateSearchController(
    CommunityFilterState filterState,
    CommunityManagementTab activeTab,
  ) {
    final String currentSearchQuery;
    switch (activeTab) {
      case CommunityManagementTab.engagements:
        currentSearchQuery = filterState.engagementsFilter.searchQuery ?? '';
      case CommunityManagementTab.reports:
        currentSearchQuery = filterState.reportsFilter.searchQuery ?? '';
      case CommunityManagementTab.appReviews:
        currentSearchQuery = filterState.appReviewsFilter.searchQuery ?? '';
    }

    if (_searchController.text != currentSearchQuery) {
      _searchController.text = currentSearchQuery;
    }
  }

  void _dispatchFilterChanges(
    CommunityFilterBloc bloc,
    CommunityFilterState state,
  ) {
    bloc
      ..add(EngagementsFilterChanged(state.engagementsFilter))
      ..add(ReportsFilterChanged(state.reportsFilter))
      ..add(AppReviewsFilterChanged(state.appReviewsFilter));
  }

  void _onSearchQueryChanged(
    BuildContext context,
    String query,
    CommunityManagementTab activeTab,
  ) {
    final bloc = context.read<CommunityFilterBloc>();
    final state = bloc.state;
    switch (activeTab) {
      case CommunityManagementTab.engagements:
        bloc.add(
          EngagementsFilterChanged(
            EngagementsFilter(
              searchQuery: query,
              selectedStatus: state.engagementsFilter.selectedStatus,
            ),
          ),
        );
      case CommunityManagementTab.reports:
        bloc.add(
          ReportsFilterChanged(
            ReportsFilter(
              searchQuery: query,
              selectedStatus: state.reportsFilter.selectedStatus,
              selectedReportableEntity:
                  state.reportsFilter.selectedReportableEntity,
            ),
          ),
        );
      case CommunityManagementTab.appReviews:
        bloc.add(
          AppReviewsFilterChanged(
            AppReviewsFilter(
              searchQuery: query,
              selectedFeedback: state.appReviewsFilter.selectedFeedback,
            ),
          ),
        );
    }
  }

  Widget _buildCapsuleFilter<T extends Enum>({
    required String title,
    required List<T> allValues,
    required T? selectedValue,
    required String Function(T) labelBuilder,
    required void Function(T?) onChanged,
  }) {
    final theme = Theme.of(context);
    final l10n = AppLocalizationsX(context).l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            ChoiceChip(
              label: Text(l10n.any),
              selected: selectedValue == null,
              onSelected: (selected) {
                if (selected) {
                  onChanged(null);
                }
              },
            ),
            ...allValues.map((value) {
              final isSelected = selectedValue == value;
              return ChoiceChip(
                label: Text(labelBuilder(value)),
                selected: isSelected,
                onSelected: (selected) => onChanged(selected ? value : null),
              );
            }),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildTabSpecificFilters(
    CommunityManagementTab activeTab,
    CommunityFilterState state,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    switch (activeTab) {
      case CommunityManagementTab.engagements:
        return [
          _buildCapsuleFilter<ModerationStatus>(
            title: l10n.status,
            allValues: ModerationStatus.values,
            selectedValue: state.engagementsFilter.selectedStatus,
            labelBuilder: (item) => item.l10n(context),
            onChanged: (item) {
              context.read<CommunityFilterBloc>().add(
                EngagementsFilterChanged(
                  EngagementsFilter(
                    searchQuery: state.engagementsFilter.searchQuery,
                    selectedStatus: item,
                  ),
                ),
              );
            },
          ),
        ];
      case CommunityManagementTab.reports:
        return [
          _buildCapsuleFilter<ModerationStatus>(
            title: l10n.status,
            allValues: ModerationStatus.values,
            selectedValue: state.reportsFilter.selectedStatus,
            labelBuilder: (item) => item.l10n(context),
            onChanged: (item) {
              context.read<CommunityFilterBloc>().add(
                ReportsFilterChanged(
                  ReportsFilter(
                    searchQuery: state.reportsFilter.searchQuery,
                    selectedStatus: item,
                    selectedReportableEntity:
                        state.reportsFilter.selectedReportableEntity,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildCapsuleFilter<ReportableEntity>(
            title: l10n.reportedItem,
            allValues: ReportableEntity.values,
            selectedValue: state.reportsFilter.selectedReportableEntity,
            labelBuilder: (item) => item.l10n(context),
            onChanged: (item) {
              context.read<CommunityFilterBloc>().add(
                ReportsFilterChanged(
                  ReportsFilter(
                    searchQuery: state.reportsFilter.searchQuery,
                    selectedStatus: state.reportsFilter.selectedStatus,
                    selectedReportableEntity: item,
                  ),
                ),
              );
            },
          ),
        ];
      case CommunityManagementTab.appReviews:
        return [
          _buildCapsuleFilter<AppReviewFeedback>(
            title: l10n.initialFeedback,
            allValues: AppReviewFeedback.values,
            selectedValue: state.appReviewsFilter.selectedFeedback,
            labelBuilder: (item) => item.l10n(context),
            onChanged: (item) {
              context.read<CommunityFilterBloc>().add(
                AppReviewsFilterChanged(
                  AppReviewsFilter(
                    searchQuery: state.appReviewsFilter.searchQuery,
                    selectedFeedback: item,
                  ),
                ),
              );
            },
          ),
        ];
    }
  }
}
