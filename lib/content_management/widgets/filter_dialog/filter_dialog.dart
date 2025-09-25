import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/sources_filter/sources_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/topics_filter/topics_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/widgets/filter_dialog/bloc/filter_dialog_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/content_status_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/source_type_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template filter_dialog}
/// A full-screen dialog for applying filters to content management lists.
///
/// This dialog provides a search text field and filter chips for content status,
/// as well as searchable selection inputs for other filter criteria.
/// It is designed to be generic and work with different filter BLoCs
/// (e.g., [HeadlinesFilterBloc], [TopicsFilterBloc], [SourcesFilterBloc]).
/// {@endtemplate}
class FilterDialog extends StatefulWidget {
  /// {@macro filter_dialog}
  const FilterDialog({
    required this.activeTab,
    required this.sourcesRepository,
    required this.topicsRepository,
    required this.countriesRepository,
    required this.languagesRepository,
    super.key,
  });

  /// The currently active content management tab, used to determine which
  /// filter BLoC to interact with.
  final ContentManagementTab activeTab;

  /// The repository for fetching [Source] items.
  final DataRepository<Source> sourcesRepository;

  /// The repository for fetching [Topic] items.
  final DataRepository<Topic> topicsRepository;

  /// The repository for fetching [Country] items.
  final DataRepository<Country> countriesRepository;

  /// The repository for fetching [Language] items.
  final DataRepository<Language> languagesRepository;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Initialize the FilterDialogBloc with current filter states.
    // The FilterDialogBloc is now provided by a parent widget, so we can
    // safely access it here.
    _loadInitialFilterState();
  }

  /// Loads the initial filter state from the appropriate BLoC and dispatches
  /// it to the FilterDialogBloc.
  void _loadInitialFilterState() {
    // Access the FilterDialogBloc directly from the context, as it's now
    // provided higher up in the widget tree.
    final filterDialogBloc = context.read<FilterDialogBloc>();

    final headlinesState = context.read<HeadlinesFilterBloc>().state;
    final topicsState = context.read<TopicsFilterBloc>().state;
    final sourcesState = context.read<SourcesFilterBloc>().state;

    filterDialogBloc.add(
      FilterDialogInitialized(
        activeTab: widget.activeTab,
        headlinesFilterState: headlinesState,
        topicsFilterState: topicsState,
        sourcesFilterState: sourcesState,
      ),
    );
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

    // The BlocProvider for FilterDialogBloc is now handled by the parent
    // ContentManagementPage, so we can directly use BlocBuilder here.
    return BlocBuilder<FilterDialogBloc, FilterDialogState>(
      builder: (context, filterDialogState) {
        _searchController.text = filterDialogState.searchQuery;
        return Scaffold(
          appBar: AppBar(
            title: Text(_getDialogTitle(l10n)),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
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
                      hintText: _getSearchHint(l10n),
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      context.read<FilterDialogBloc>().add(
                        FilterDialogSearchQueryChanged(query),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.status,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildStatusFilterChips(l10n, theme, filterDialogState),
                  const SizedBox(height: AppSpacing.lg),
                  _buildAdditionalFilters(l10n, filterDialogState),
                ],
              ),
            ),
          ),
        );
      },
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

  /// Builds the status filter chips based on the active tab's filter state.
  Widget _buildStatusFilterChips(
    AppLocalizations l10n,
    ThemeData theme,
    FilterDialogState filterDialogState,
  ) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: ContentStatus.values.map((status) {
        return ChoiceChip(
          label: Text(status.l10n(context)),
          selected: filterDialogState.selectedStatus == status,
          onSelected: (isSelected) {
            if (isSelected) {
              context.read<FilterDialogBloc>().add(
                FilterDialogStatusChanged(status),
              );
            }
          },
          selectedColor: theme.colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: filterDialogState.selectedStatus == status
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurface,
          ),
        );
      }).toList(),
    );
  }

  /// Builds additional filter widgets based on the active tab.
  Widget _buildAdditionalFilters(
    AppLocalizations l10n,
    FilterDialogState filterDialogState,
  ) {
    switch (widget.activeTab) {
      case ContentManagementTab.headlines:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            SearchableSelectionInput<Source>(
              label: l10n.sources,
              hintText: l10n.selectSources,
              isMultiSelect: true,
              selectedItems: filterDialogState.selectedSourceIds
                  .map(
                    (id) => filterDialogState.availableSources.firstWhere(
                      (source) => source.id == id,
                      orElse: () => Source(
                        id: id,
                        name: '',
                        description: '',
                        url: '',
                        sourceType: SourceType.other,
                        language: Language(
                          id: '',
                          code: '',
                          name: '',
                          nativeName: '',
                          createdAt: dummyDate,
                          updatedAt: dummyDate,
                          status: ContentStatus.active,
                        ),
                        headquarters: Country(
                          id: '',
                          isoCode: '',
                          name: '',
                          flagUrl: '',
                          createdAt: dummyDate,
                          updatedAt: dummyDate,
                          status: ContentStatus.active,
                        ),
                        createdAt: dummyDate,
                        updatedAt: dummyDate,
                        status: ContentStatus.active,
                      ),
                    ),
                  )
                  .toList(),
              itemBuilder: (context, item) => Text(item.name),
              itemToString: (item) => item.name,
              onChanged: (items) {
                context.read<FilterDialogBloc>().add(
                  FilterDialogHeadlinesSourceIdsChanged(
                    items?.map((e) => e.id).toList() ?? [],
                  ),
                );
              },
              repository: widget.sourcesRepository,
              filterBuilder: (searchTerm) => {
                if (searchTerm != null && searchTerm.isNotEmpty)
                  'name': {r'$regex': searchTerm, r'$options': 'i'},
              },
              sortOptions: const [SortOption('name', SortOrder.asc)],
              limit: AppConstants.kDefaultRowsPerPage,
              includeInactiveSelectedItem: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            SearchableSelectionInput<Topic>(
              label: l10n.topics,
              hintText: l10n.selectTopics,
              isMultiSelect: true,
              selectedItems: filterDialogState.selectedTopicIds
                  .map(
                    (id) => filterDialogState.availableTopics.firstWhere(
                      (topic) => topic.id == id,
                      orElse: () => Topic(
                        id: id,
                        name: '',
                        description: '',
                        iconUrl: '',
                        createdAt: dummyDate,
                        updatedAt: dummyDate,
                        status: ContentStatus.active,
                      ),
                    ),
                  )
                  .toList(),
              itemBuilder: (context, item) => Text(item.name),
              itemToString: (item) => item.name,
              onChanged: (items) {
                context.read<FilterDialogBloc>().add(
                  FilterDialogHeadlinesTopicIdsChanged(
                    items?.map((e) => e.id).toList() ?? [],
                  ),
                );
              },
              repository: widget.topicsRepository,
              filterBuilder: (searchTerm) => {
                if (searchTerm != null && searchTerm.isNotEmpty)
                  'name': {r'$regex': searchTerm, r'$options': 'i'},
              },
              sortOptions: const [SortOption('name', SortOrder.asc)],
              limit: AppConstants.kDefaultRowsPerPage,
              includeInactiveSelectedItem: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            SearchableSelectionInput<Country>(
              label: l10n.countries,
              hintText: l10n.selectCountries,
              isMultiSelect: true,
              selectedItems: filterDialogState.selectedCountryIds
                  .map(
                    (id) => filterDialogState.availableCountries.firstWhere(
                      (country) => country.id == id,
                      orElse: () => Country(
                        id: '',
                        isoCode: '',
                        name: '',
                        flagUrl: '',
                        createdAt: dummyDate,
                        updatedAt: dummyDate,
                        status: ContentStatus.active,
                      ),
                    ),
                  )
                  .toList(),
              itemBuilder: (context, item) => Text(item.name),
              itemToString: (item) => item.name,
              onChanged: (items) {
                context.read<FilterDialogBloc>().add(
                  FilterDialogHeadlinesCountryIdsChanged(
                    items?.map((e) => e.id).toList() ?? [],
                  ),
                );
              },
              repository: widget.countriesRepository,
              filterBuilder: (searchTerm) => {
                if (searchTerm != null && searchTerm.isNotEmpty)
                  'name': {r'$regex': searchTerm, r'$options': 'i'},
              },
              sortOptions: const [SortOption('name', SortOrder.asc)],
              limit: AppConstants.kDefaultRowsPerPage,
              includeInactiveSelectedItem: true,
            ),
          ],
        );
      case ContentManagementTab.topics:
        return const SizedBox.shrink(); // No additional filters for topics
      case ContentManagementTab.sources:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            SearchableSelectionInput<SourceType>(
              label: l10n.sourceType,
              hintText: l10n.selectSourceTypes,
              isMultiSelect: true,
              selectedItems: filterDialogState.selectedSourceTypes,
              itemBuilder: (context, item) => Text(item.localizedName(l10n)),
              itemToString: (item) => item.localizedName(l10n),
              onChanged: (items) {
                context.read<FilterDialogBloc>().add(
                  FilterDialogSourceTypesChanged(items ?? []),
                );
              },
              staticItems: SourceType.values,
            ),
            const SizedBox(height: AppSpacing.lg),
            SearchableSelectionInput<Language>(
              label: l10n.language,
              hintText: l10n.selectLanguages,
              isMultiSelect: true,
              selectedItems: filterDialogState.selectedLanguageCodes
                  .map(
                    (code) => filterDialogState.availableLanguages.firstWhere(
                      (language) => language.code == code,
                      orElse: () => Language(
                        id: '',
                        code: '',
                        name: '',
                        nativeName: '',
                        createdAt: dummyDate,
                        updatedAt: dummyDate,
                        status: ContentStatus.active,
                      ),
                    ),
                  )
                  .toList(),
              itemBuilder: (context, item) => Text(item.name),
              itemToString: (item) => item.name,
              onChanged: (items) {
                context.read<FilterDialogBloc>().add(
                  FilterDialogLanguageCodesChanged(
                    items?.map((e) => e.code).toList() ?? [],
                  ),
                );
              },
              repository: widget.languagesRepository,
              filterBuilder: (searchTerm) => {
                if (searchTerm != null && searchTerm.isNotEmpty)
                  'name': {r'$regex': searchTerm, r'$options': 'i'},
              },
              sortOptions: const [SortOption('name', SortOrder.asc)],
              limit: AppConstants.kDefaultRowsPerPage,
              includeInactiveSelectedItem: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            SearchableSelectionInput<Country>(
              label: l10n.headquarters,
              hintText: l10n.selectHeadquarters,
              isMultiSelect: true,
              selectedItems: filterDialogState.selectedHeadquartersCountryIds
                  .map(
                    (id) => filterDialogState.availableCountries.firstWhere(
                      (country) => country.id == id,
                      orElse: () => Country(
                        id: '',
                        isoCode: '',
                        name: '',
                        flagUrl: '',
                        createdAt: dummyDate,
                        updatedAt: dummyDate,
                        status: ContentStatus.active,
                      ),
                    ),
                  )
                  .toList(),
              itemBuilder: (context, item) => Text(item.name),
              itemToString: (item) => item.name,
              onChanged: (items) {
                context.read<FilterDialogBloc>().add(
                  FilterDialogHeadquartersCountryIdsChanged(
                    items?.map((e) => e.id).toList() ?? [],
                  ),
                );
              },
              repository: widget.countriesRepository,
              filterBuilder: (searchTerm) => {
                if (searchTerm != null && searchTerm.isNotEmpty)
                  'name': {r'$regex': searchTerm, r'$options': 'i'},
              },
              sortOptions: const [SortOption('name', SortOrder.asc)],
              limit: AppConstants.kDefaultRowsPerPage,
              includeInactiveSelectedItem: true,
            ),
          ],
        );
    }
  }

  /// Dispatches the filter applied event to the appropriate BLoC.
  void _dispatchFilterApplied(FilterDialogState filterDialogState) {
    switch (widget.activeTab) {
      case ContentManagementTab.headlines:
        context.read<HeadlinesFilterBloc>().add(
          HeadlinesFilterApplied(
            searchQuery: filterDialogState.searchQuery,
            selectedStatus: filterDialogState.selectedStatus,
            selectedSourceIds: filterDialogState.selectedSourceIds,
            selectedTopicIds: filterDialogState.selectedTopicIds,
            selectedCountryIds: filterDialogState.selectedCountryIds,
          ),
        );
      case ContentManagementTab.topics:
        context.read<TopicsFilterBloc>().add(
          TopicsFilterApplied(
            searchQuery: filterDialogState.searchQuery,
            selectedStatus: filterDialogState.selectedStatus,
          ),
        );
      case ContentManagementTab.sources:
        context.read<SourcesFilterBloc>().add(
          SourcesFilterApplied(
            searchQuery: filterDialogState.searchQuery,
            selectedStatus: filterDialogState.selectedStatus,
            selectedSourceTypes: filterDialogState.selectedSourceTypes,
            selectedLanguageCodes: filterDialogState.selectedLanguageCodes,
            selectedHeadquartersCountryIds:
                filterDialogState.selectedHeadquartersCountryIds,
          ),
        );
    }
  }
}
