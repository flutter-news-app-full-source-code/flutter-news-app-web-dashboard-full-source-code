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
    _searchController = TextEditingController();
    _searchController.text =
        context.read<CommunityFilterBloc>().state.searchQuery;
    super.initState();
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
    final activeTab = context.select<CommunityManagementBloc,
        CommunityManagementTab>((bloc) => bloc.state.activeTab);

    return BlocBuilder<CommunityFilterBloc, CommunityFilterState>(
      builder: (context, filterState) {
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
                  context
                      .read<CommunityFilterBloc>()
                      .add(const CommunityFilterReset());
                  context
                      .read<CommunityFilterBloc>()
                      .add(const CommunityFilterApplied());
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: l10n.applyFilters,
                onPressed: () {
                  context
                      .read<CommunityFilterBloc>()
                      .add(const CommunityFilterApplied());
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
                      context.read<CommunityFilterBloc>().add(
                            CommunityFilterSearchQueryChanged(query),
                          );
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

  Widget _buildCapsuleFilter<T extends Enum>({
    required String title,
    required List<T> allValues,
    required List<T> selectedValues,
    required String Function(T) labelBuilder,
    required void Function(List<T>) onChanged,
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
              selected: selectedValues.isEmpty,
              onSelected: (selected) {
                if (selected) {
                  onChanged([]);
                }
              },
            ),
            ...allValues.map((value) {
              final isSelected = selectedValues.contains(value);
              return ChoiceChip(
                label: Text(labelBuilder(value)),
                selected: isSelected,
                onSelected: (selected) {
                  final currentSelection = List<T>.from(selectedValues);
                  if (selected) {
                    currentSelection.add(value);
                  } else {
                    currentSelection.remove(value);
                  }
                  onChanged(currentSelection);
                },
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
            selectedValues: state.selectedModerationStatus,
            labelBuilder: (item) => item.l10n(context),
            onChanged: (items) => context
                .read<CommunityFilterBloc>()
                .add(CommunityFilterModerationStatusChanged(items)),
          ),
        ];
      case CommunityManagementTab.reports:
        return [
          _buildCapsuleFilter<ModerationStatus>(
            title: l10n.status,
            allValues: ModerationStatus.values,
            selectedValues: state.selectedModerationStatus,
            labelBuilder: (item) => item.l10n(context),
            onChanged: (items) => context
                .read<CommunityFilterBloc>()
                .add(CommunityFilterModerationStatusChanged(items)),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildCapsuleFilter<ReportableEntity>(
            title: l10n.reportedItem,
            allValues: ReportableEntity.values,
            selectedValues: state.selectedReportableEntity,
            labelBuilder: (item) => item.l10n(context),
            onChanged: (items) => context
                .read<CommunityFilterBloc>()
                .add(CommunityFilterReportableEntityChanged(items)),
          ),
        ];
      case CommunityManagementTab.appReviews:
        return [
          _buildCapsuleFilter<AppReviewFeedback>(
            title: l10n.initialFeedback,
            allValues: AppReviewFeedback.values,
            selectedValues: state.selectedAppReviewFeedback,
            labelBuilder: (item) => item.l10n(context),
            onChanged: (items) => context
                .read<CommunityFilterBloc>()
                .add(CommunityFilterAppReviewFeedbackChanged(items)),
          ),
        ];
    }
  }
}
