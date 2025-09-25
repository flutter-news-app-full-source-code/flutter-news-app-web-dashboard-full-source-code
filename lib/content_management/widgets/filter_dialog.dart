import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/sources_filter/sources_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/topics_filter/topics_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/content_status_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template filter_dialog}
/// A full-screen dialog for applying filters to content management lists.
///
/// This dialog provides a search text field and filter chips for content status.
/// It is designed to be generic and work with different filter BLoCs
/// (e.g., [HeadlinesFilterBloc], [TopicsFilterBloc], [SourcesFilterBloc]).
/// {@endtemplate}
class FilterDialog extends StatefulWidget {
  /// {@macro filter_dialog}
  const FilterDialog({
    required this.activeTab,
    super.key,
  });

  /// The currently active content management tab, used to determine which
  /// filter BLoC to interact with.
  final ContentManagementTab activeTab;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadInitialFilterState();
  }

  /// Loads the initial filter state from the appropriate BLoC.
  void _loadInitialFilterState() {
    switch (widget.activeTab) {
      case ContentManagementTab.headlines:
        _searchController.text = context
            .read<HeadlinesFilterBloc>()
            .state
            .searchQuery;
      case ContentManagementTab.topics:
        _searchController.text = context
            .read<TopicsFilterBloc>()
            .state
            .searchQuery;
      case ContentManagementTab.sources:
        _searchController.text = context
            .read<SourcesFilterBloc>()
            .state
            .searchQuery;
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_getDialogTitle(l10n)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.search,
                hintText: _getSearchHint(l10n),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: _dispatchSearchQueryChanged,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.status,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildStatusFilterChips(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _dispatchFilterApplied();
                  Navigator.of(context).pop();
                },
                child: Text(l10n.applyFilters),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the appropriate dialog title based on the active tab.
  String _getDialogTitle(AppLocalizations l10n) {
    switch (widget.activeTab) {
      case ContentManagementTab.headlines:
        return l10n.filterHeadlines;
      case ContentManagementTab.topics:
        return l10n.filterTopics;
      case ContentManagementTab.sources:
        return l10n.filterSources;
    }
  }

  /// Returns the appropriate search hint based on the active tab.
  String _getSearchHint(AppLocalizations l10n) {
    switch (widget.activeTab) {
      case ContentManagementTab.headlines:
        return l10n.searchByHeadlineTitle;
      case ContentManagementTab.topics:
        return l10n.searchByTopicName;
      case ContentManagementTab.sources:
        return l10n.searchBySourceName;
    }
  }

  /// Dispatches the search query changed event to the appropriate BLoC.
  void _dispatchSearchQueryChanged(String query) {
    switch (widget.activeTab) {
      case ContentManagementTab.headlines:
        context.read<HeadlinesFilterBloc>().add(
          HeadlinesSearchQueryChanged(query),
        );
      case ContentManagementTab.topics:
        context.read<TopicsFilterBloc>().add(TopicsSearchQueryChanged(query));
      case ContentManagementTab.sources:
        context.read<SourcesFilterBloc>().add(SourcesSearchQueryChanged(query));
    }
  }

  /// Builds the status filter chips based on the active tab's filter state.
  Widget _buildStatusFilterChips() {
    switch (widget.activeTab) {
      case ContentManagementTab.headlines:
        return BlocBuilder<HeadlinesFilterBloc, HeadlinesFilterState>(
          builder: (context, state) {
            return Wrap(
              spacing: AppSpacing.sm,
              children: ContentStatus.values.map((status) {
                return FilterChip(
                  label: Text(status.l10n(context)),
                  selected: state.selectedStatuses.contains(status),
                  onSelected: (isSelected) {
                    context.read<HeadlinesFilterBloc>().add(
                      HeadlinesStatusFilterChanged(status, isSelected),
                    );
                  },
                );
              }).toList(),
            );
          },
        );
      case ContentManagementTab.topics:
        return BlocBuilder<TopicsFilterBloc, TopicsFilterState>(
          builder: (context, state) {
            return Wrap(
              spacing: AppSpacing.sm,
              children: ContentStatus.values.map((status) {
                return FilterChip(
                  label: Text(status.l10n(context)),
                  selected: state.selectedStatuses.contains(status),
                  onSelected: (isSelected) {
                    context.read<TopicsFilterBloc>().add(
                      TopicsStatusFilterChanged(status, isSelected),
                    );
                  },
                );
              }).toList(),
            );
          },
        );
      case ContentManagementTab.sources:
        return BlocBuilder<SourcesFilterBloc, SourcesFilterState>(
          builder: (context, state) {
            return Wrap(
              spacing: AppSpacing.sm,
              children: ContentStatus.values.map((status) {
                return FilterChip(
                  label: Text(status.l10n(context)),
                  selected: state.selectedStatuses.contains(status),
                  onSelected: (isSelected) {
                    context.read<SourcesFilterBloc>().add(
                      SourcesStatusFilterChanged(status, isSelected),
                    );
                  },
                );
              }).toList(),
            );
          },
        );
    }
  }

  /// Dispatches the filter applied event to the appropriate BLoC.
  void _dispatchFilterApplied() {
    switch (widget.activeTab) {
      case ContentManagementTab.headlines:
        context.read<HeadlinesFilterBloc>().add(const HeadlinesFilterApplied());
      case ContentManagementTab.topics:
        context.read<TopicsFilterBloc>().add(const TopicsFilterApplied());
      case ContentManagementTab.sources:
        context.read<SourcesFilterBloc>().add(const SourcesFilterApplied());
    }
  }
}
