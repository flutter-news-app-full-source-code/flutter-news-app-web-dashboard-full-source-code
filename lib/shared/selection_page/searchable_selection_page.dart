import 'package:data_repository/data_repository.dart' show DataRepository;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/selection_page/bloc/searchable_selection_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/selection_page/selection_page_arguments.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template searchable_selection_page}
/// A generic full-page component for selecting an item from a searchable,
/// paginated list.
///
/// This page is designed to be opened as a sub-route within the application's
/// main navigation shell, allowing it to inherit the parent layout constraints.
/// It supports both fetching data from a [DataRepository] (for dynamic,
/// API-backed lists) and displaying a static list of items.
///
/// Note: Due to GoRouter's limitations with passing generic types via `extra`,
/// this page is non-generic. It relies on [SelectionPageArguments] to provide
/// runtime type information (`itemType`) and functions (`itemBuilder`,
/// `itemToString`) that operate on [Object]. These functions are then safely
/// cast to the expected generic type at the point of use within this widget.
/// {@endtemplate}
class SearchableSelectionPage extends StatelessWidget {
  /// {@macro searchable_selection_page}
  const SearchableSelectionPage({
    required this.arguments,
    super.key,
  });

  /// The arguments used to configure this page, including title, item builders,
  /// data source (repository or static list), and initial selection.
  final SelectionPageArguments arguments;

  @override
  Widget build(BuildContext context) {
    // Provides the SearchableSelectionBloc to the widget tree.
    // The BLoC is instantiated with `Object` as its generic type, as it
    // operates on type-erased items from SelectionPageArguments.
    return BlocProvider(
      create: (context) => SearchableSelectionBloc(arguments: arguments),
      child: _SearchableSelectionView(arguments: arguments),
    );
  }
}

/// {@template _searchable_selection_view}
/// The stateful view for the [SearchableSelectionPage].
///
/// Manages text input for search and scroll events for pagination.
/// {@endtemplate}
class _SearchableSelectionView extends StatefulWidget {
  /// {@macro _searchable_selection_view}
  const _SearchableSelectionView({
    required this.arguments,
  });

  /// The arguments passed from the parent [SearchableSelectionPage].
  final SelectionPageArguments arguments;

  @override
  State<_SearchableSelectionView> createState() =>
      _SearchableSelectionViewState();
}

/// The state for [_SearchableSelectionView].
class _SearchableSelectionViewState extends State<_SearchableSelectionView> {
  /// Controller for the search text input field.
  final TextEditingController _searchController = TextEditingController();

  /// Controller for the scrollable list, used to detect when to load more items.
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add a listener to the scroll controller to trigger loading more items
    // when the user scrolls to the end of the list.
    _scrollController.addListener(_onScroll);
    // Initialize the search controller with the current search term from the BLoC state.
    _searchController.text = context
        .read<SearchableSelectionBloc>()
        .state
        .searchTerm;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Handles scroll events to trigger loading of more items.
  void _onScroll() {
    // If the user has scrolled to the very end of the list, request more items.
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<SearchableSelectionBloc>().add(
        const SearchableSelectionLoadMoreRequested(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.arguments.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.search,
                border: theme.inputDecorationTheme.border,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    // Dispatch an event to the BLoC to clear the search term.
                    context.read<SearchableSelectionBloc>().add(
                      const SearchableSelectionSearchTermChanged(''),
                    );
                  },
                ),
              ),
              onChanged: (value) => context
                  .read<SearchableSelectionBloc>()
                  .add(SearchableSelectionSearchTermChanged(value)),
            ),
          ),
        ),
      ),
      body:
          // Listens to changes in SearchableSelectionState and rebuilds the UI.
          BlocBuilder<SearchableSelectionBloc, SearchableSelectionState>(
            builder: (context, state) {
              // Show a loading indicator if data is being fetched and no items are yet displayed.
              if (state.status == SearchableSelectionStatus.loading &&
                  state.items.isEmpty) {
                return LoadingStateWidget(
                  icon: Icons.search,
                  headline: l10n.loadingData,
                  subheadline: l10n.pleaseWait,
                );
              }

              // Show an error message if data fetching failed and no items are displayed.
              if (state.status == SearchableSelectionStatus.failure &&
                  state.items.isEmpty) {
                return FailureStateWidget(
                  exception: state.exception!,
                  onRetry: () => context.read<SearchableSelectionBloc>().add(
                    const SearchableSelectionLoadRequested(),
                  ),
                );
              }

              // Show a message if no results are found after loading.
              if (state.items.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noResultsFound,
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }

              // Display the list of items.
              return ListView.builder(
                controller: _scrollController,
                // Add 1 to itemCount if there are more items to load, to show a loading spinner at the bottom.
                itemCount: state.items.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  // If it's the last item and there are more to load, show a progress indicator.
                  if (index == state.items.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final item = state.items[index];
                  // Retrieve the itemBuilder function from arguments.
                  // This function expects an Object and will cast it internally.
                  final itemBuilder =
                      widget.arguments.itemBuilder;

                  return ListTile(
                    // Build the title using the provided itemBuilder.
                    title: itemBuilder(context, item),
                    onTap: () {
                      // Dispatch an event to the BLoC to set the selected item.
                      context.read<SearchableSelectionBloc>().add(
                        SearchableSelectionSetSelectedItem(item),
                      );
                      // Pop the page with the selected item as the result.
                      Navigator.of(context).pop(item);
                    },
                    // Highlight the selected item.
                    selected: item == state.selectedItem,
                    // Show a checkmark for the selected item.
                    trailing: item == state.selectedItem
                        ? Icon(Icons.check, color: theme.colorScheme.primary)
                        : null,
                  );
                },
              );
            },
          ),
    );
  }
}
