import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/selection_page/selection_page_arguments.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template searchable_selection_input}
/// A custom input widget that, when tapped, navigates to a full-page
/// searchable selection screen to allow the user to select an item of type [T].
///
/// This widget replaces the functionality of a traditional dropdown with a
/// more robust, page-based selection experience, supporting search and
/// pagination on the selection page.
/// {@endtemplate}
class SearchableSelectionInput<T extends Equatable> extends StatefulWidget {
  /// {@macro searchable_selection_input}
  const SearchableSelectionInput({
    required this.label,
    required this.itemBuilder,
    required this.itemToString,
    required this.onChanged,
    this.selectedItem,
    this.repository,
    this.filterBuilder,
    this.sortOptions,
    this.limit,
    this.staticItems,
    super.key,
  }) : assert(
          (repository != null && filterBuilder != null && sortOptions != null && limit != null) ^
              (staticItems != null),
          'Either repository-related parameters or staticItems must be provided, but not both.',
        );

  /// The label text for the input field.
  final String label;

  /// The currently selected item.
  final T? selectedItem;

  /// A builder function to customize the display of each item in the list.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// A function to convert an item [T] to its string representation for
  /// display in the input field and for search filtering.
  final String Function(T item) itemToString;

  /// Callback when an item is selected or cleared.
  final ValueChanged<T?> onChanged;

  /// The [DataRepository] to use for fetching items (if not using static items).
  final DataRepository<T>? repository;

  /// A function to build the filter map for the repository based on a search term.
  final Map<String, dynamic> Function(String? searchTerm)? filterBuilder;

  /// The sorting options for repository queries.
  final List<SortOption>? sortOptions;

  /// The pagination limit for repository queries.
  final int? limit;

  /// A static list of items to display (if not fetching from a repository).
  final List<T>? staticItems;

  @override
  State<SearchableSelectionInput<T>> createState() =>
      _SearchableSelectionInputState<T>();
}

/// State class for [SearchableSelectionInput].
class _SearchableSelectionInputState<T extends Equatable>
    extends State<SearchableSelectionInput<T>> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateTextController();
  }

  @override
  void didUpdateWidget(covariant SearchableSelectionInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      _updateTextController();
    }
  }

  void _updateTextController() {
    _textController.text = widget.selectedItem != null
        ? widget.itemToString(widget.selectedItem!)
        : '';
  }

  Future<void> _openSelectionPage() async {
    final arguments = SelectionPageArguments<T>(
      title: widget.label,
      itemBuilder: widget.itemBuilder,
      itemToString: widget.itemToString,
      initialSelectedItem: widget.selectedItem,
      repository: widget.repository,
      filterBuilder: widget.filterBuilder,
      sortOptions: widget.sortOptions,
      limit: widget.limit,
      staticItems: widget.staticItems,
    );

    final selectedItem = await context.pushNamed<T>(
      Routes.searchableSelectionName,
      extra: arguments,
    );

    if (selectedItem != null) {
      widget.onChanged(selectedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return TextFormField(
      controller: _textController,
      readOnly: true, // Prevent direct text input, only allow selection
      decoration: InputDecoration(
        labelText: widget.label,
        border: Theme.of(context).inputDecorationTheme.border,
        suffixIcon: IconButton(
          icon: const Icon(Icons.arrow_drop_down),
          onPressed: _openSelectionPage,
        ),
        // Clear button if an item is selected
        prefixIcon: widget.selectedItem != null
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
