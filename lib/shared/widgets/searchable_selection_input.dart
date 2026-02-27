import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/selection_page/searchable_selection_page.dart'
    show SearchableSelectionPage;
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/selection_page/selection_page_arguments.dart';
import 'package:go_router/go_router.dart';

/// {@template searchable_selection_input}
/// A custom input widget that, when tapped, navigates to a full-page
/// searchable selection screen to allow the user to select one or more items of type [T].
///
/// This widget replaces the functionality of a traditional dropdown with a
/// more robust, page-based selection experience, supporting search and
/// pagination on the selection page.
///
/// It handles the conversion of generic type [T] to [Object] for passing
/// arguments via `GoRouter` and then casts the selected item(s) back to type [T].
/// {@endtemplate}
class SearchableSelectionInput<T> extends StatefulWidget {
  /// {@macro searchable_selection_input}
  const SearchableSelectionInput({
    required this.label,
    required this.itemBuilder,
    required this.itemToString,
    required this.onChanged,
    this.selectedItems,
    this.repository,
    this.filterBuilder,
    this.sortOptions,
    this.limit,
    this.staticItems,
    this.includeInactiveSelectedItem = false,
    this.isMultiSelect = false,
    this.hintText,
    super.key,
  }) : assert(
         (repository != null &&
                 filterBuilder != null &&
                 sortOptions != null &&
                 limit != null) ^
             (staticItems != null),
         'Either repository-related parameters or staticItems must be provided, but not both.',
       );

  /// The label text for the input field.
  final String label;

  /// The currently selected item(s).
  final List<T>? selectedItems;

  /// If true, the [selectedItems] will be included in the fetched results
  /// even if they do not match the current filter criteria (e.g., if they are
  /// inactive items that were previously selected). This is useful for edit
  /// pages where the previously selected item(s) should always be visible.
  final bool includeInactiveSelectedItem;

  /// A builder function to customize the display of each item in the list.
  /// This function expects an item of type [T].
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// A function to convert an item [T] to its string representation for
  /// display in the input field and for search filtering.
  final String Function(T item) itemToString;

  /// Callback when item(s) are selected or cleared.
  final ValueChanged<List<T>?> onChanged;

  /// The [DataRepository] to use for fetching items (if not using static items).
  /// The generic type of the repository must match [T].
  final DataRepository<T>? repository;

  /// A function to build the filter map for the repository based on a search term.
  final Map<String, dynamic> Function(String? searchTerm)? filterBuilder;

  /// The sorting options for repository queries.
  final List<SortOption>? sortOptions;

  /// The pagination limit for repository queries.
  final int? limit;

  /// A static list of items to display (if not fetching from a repository).
  /// The items in this list must be of type [T].
  final List<T>? staticItems;

  /// If true, the selection page will allow multiple items to be selected.
  /// Defaults to false for single selection.
  final bool isMultiSelect;

  /// Optional hint text for the input field.
  final String? hintText;

  @override
  State<SearchableSelectionInput<T>> createState() =>
      _SearchableSelectionInputState<T>();
}

/// State class for [SearchableSelectionInput].
class _SearchableSelectionInputState<T>
    extends State<SearchableSelectionInput<T>> {
  /// Controller for the text displayed in the input field.
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text controller with the selected item(s)'s string representation.
    _updateTextController();
  }

  @override
  void didUpdateWidget(covariant SearchableSelectionInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the text controller if the selected item(s) change externally.
    if (widget.selectedItems != oldWidget.selectedItems) {
      _updateTextController();
    }
  }

  /// Updates the text controller's text based on the current selected item(s).
  void _updateTextController() {
    if (widget.selectedItems != null && widget.selectedItems!.isNotEmpty) {
      _textController.text = widget.selectedItems!
          .map((item) => widget.itemToString(item))
          .join(', ');
    } else {
      _textController.clear();
    }
  }

  /// Opens the [SearchableSelectionPage] as a new route.
  ///
  /// It constructs [SelectionPageArguments] by converting generic functions
  /// and lists to operate on [Object] to bypass `GoRouter`'s generic limitations.
  /// After selection, it casts the selected item(s) back to type [T].
  Future<void> _openSelectionPage() async {
    // Determine whether to use repository-based fetching or static items.
    final SelectionPageArguments arguments;
    if (widget.repository != null) {
      arguments = SelectionPageArguments(
        title: widget.label,
        itemType: T,
        itemBuilder: (context, item) => widget.itemBuilder(context, item as T),
        itemToString: (item) => widget.itemToString(item as T),
        initialSelectedItems: widget.selectedItems?.cast<Object>(),
        repository: widget.repository! as DataRepository<Object>,
        filterBuilder: widget.filterBuilder,
        sortOptions: widget.sortOptions,
        limit: widget.limit,
        includeInactiveSelectedItem: widget.includeInactiveSelectedItem,
        isMultiSelect: widget.isMultiSelect,
      );
    } else {
      arguments = SelectionPageArguments(
        title: widget.label,
        itemType: T,
        itemBuilder: (context, item) => widget.itemBuilder(context, item as T),
        itemToString: (item) => widget.itemToString(item as T),
        initialSelectedItems: widget.selectedItems?.cast<Object>(),
        staticItems: widget.staticItems! as List<Object>,
        includeInactiveSelectedItem: widget.includeInactiveSelectedItem,
        isMultiSelect: widget.isMultiSelect,
      );
    }

    // Push the searchable selection page and await a result.
    final result = await context.pushNamed<List<Object>?>(
      Routes.searchableSelectionName,
      extra: arguments,
    );

    // If item(s) were selected, notify the parent widget.
    if (result != null) {
      widget.onChanged(result.cast<T>());
    } else {
      widget.onChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return TextFormField(
      controller: _textController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        border: Theme.of(context).inputDecorationTheme.border,
        suffixIcon: IconButton(
          icon: const Icon(Icons.arrow_drop_down),
          onPressed: _openSelectionPage,
        ),
        // Show a clear button if item(s) are currently selected.
        prefixIcon:
            (widget.selectedItems != null && widget.selectedItems!.isNotEmpty)
            ? IconButton(
                icon: const Icon(Icons.clear),
                tooltip: l10n.clearSelection,
                onPressed: () {
                  widget.onChanged(null);
                  _textController.clear();
                },
              )
            : null,
      ),
      onTap: _openSelectionPage,
    );
  }
}
