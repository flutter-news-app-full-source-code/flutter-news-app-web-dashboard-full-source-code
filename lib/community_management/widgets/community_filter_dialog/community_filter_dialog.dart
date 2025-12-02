import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_filter/community_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/widgets/community_filter_dialog/bloc/community_filter_dialog_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _dispatchFilterApplied(CommunityFilterDialogState filterDialogState) {
    context.read<CommunityFilterBloc>().add(
      CommunityFilterApplied(
        searchQuery: filterDialogState.searchQuery,
        selectedCommentStatus: filterDialogState.selectedCommentStatus,
        selectedReportStatus: filterDialogState.selectedReportStatus,
        selectedReportableEntity: filterDialogState.selectedReportableEntity,
        selectedAppReviewFeedback: filterDialogState.selectedAppReviewFeedback,
        hasComment: filterDialogState.hasComment,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);

    return BlocBuilder<CommunityFilterDialogBloc, CommunityFilterDialogState>(
      builder: (context, filterDialogState) {
        if (_searchController.text != filterDialogState.searchQuery) {
          _searchController.text = filterDialogState.searchQuery;
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
        }

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
                  context.read<CommunityFilterBloc>().add(
                    const CommunityFilterReset(),
                  );
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: l10n.applyFilters,
                onPressed: () {
                  _dispatchFilterApplied(filterDialogState);
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
                      labelText: l10n.search,
                      hintText: l10n.searchByUserId,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      context.read<CommunityFilterDialogBloc>().add(
                        CommunityFilterDialogSearchQueryChanged(query),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ..._buildTabSpecificFilters(filterDialogState, l10n, theme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusFilter({
    required BuildContext context,
    required CommunityFilterDialogState state,
    required AppLocalizations l10n,
    required ThemeData theme,
    required List<ModerationStatus> selectedStatuses,
    required void Function(List<ModerationStatus>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.status,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: ModerationStatus.values.map((status) {
            final isSelected = selectedStatuses.contains(status);
            return ChoiceChip(
              label: Text(status.l10n(context)),
              selected: isSelected,
              onSelected: (selected) {
                final currentSelection = List<ModerationStatus>.from(
                  selectedStatuses,
                );
                if (selected) {
                  currentSelection.add(status);
                } else {
                  currentSelection.remove(status);
                }
                onChanged(currentSelection);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHasCommentFilter(
    CommunityFilterDialogState state,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.hasComment,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: HasCommentFilter.values.map((filter) {
            return ChoiceChip(
              label: Text(
                switch (filter) {
                  HasCommentFilter.any => l10n.any,
                  HasCommentFilter.withComment => l10n.withComment,
                  HasCommentFilter.withoutComment => l10n.withoutComment,
                },
              ),
              selected: state.hasComment == filter,
              onSelected: (selected) {
                if (selected) {
                  context.read<CommunityFilterDialogBloc>().add(
                    CommunityFilterDialogHasCommentChanged(filter),
                  );
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  List<Widget> _buildTabSpecificFilters(
    CommunityFilterDialogState state,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    switch (state.activeTab) {
      case CommunityManagementTab.engagements:
        return [
          _buildStatusFilter(
            context: context,
            state: state,
            l10n: l10n,
            theme: theme,
            selectedStatuses: state.selectedCommentStatus,
            onChanged: (statuses) =>
                context.read<CommunityFilterDialogBloc>().add(
                  CommunityFilterDialogCommentStatusChanged(statuses),
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildHasCommentFilter(state, l10n, theme),
        ];
      case CommunityManagementTab.reports:
        return [
          _buildStatusFilter(
            context: context,
            state: state,
            l10n: l10n,
            theme: theme,
            selectedStatuses: state.selectedReportStatus,
            onChanged: (statuses) =>
                context.read<CommunityFilterDialogBloc>().add(
                  CommunityFilterDialogReportStatusChanged(statuses),
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SearchableSelectionInput<ReportableEntity>(
            label: l10n.reportedItem,
            hintText: l10n.selectReportableEntity,
            isMultiSelect: true,
            selectedItems: state.selectedReportableEntity,
            itemBuilder: (context, item) => Text(item.l10n(context)),
            itemToString: (item) => item.l10n(context),
            onChanged: (items) => context.read<CommunityFilterDialogBloc>().add(
              CommunityFilterDialogReportableEntityChanged(items ?? []),
            ),
            staticItems: ReportableEntity.values,
          ),
        ];
      case CommunityManagementTab.appReviews:
        return [
          SearchableSelectionInput<AppReviewFeedback>(
            label: l10n.initialFeedback,
            hintText: l10n.selectInitialFeedback,
            isMultiSelect: true,
            selectedItems: state.selectedAppReviewFeedback,
            itemBuilder: (context, item) => Text(item.l10n(context)),
            itemToString: (item) => item.l10n(context),
            onChanged: (items) => context.read<CommunityFilterDialogBloc>().add(
              CommunityFilterDialogAppReviewFeedbackChanged(items ?? []),
            ),
            staticItems: AppReviewFeedback.values,
          ),
        ];
    }
  }
}
