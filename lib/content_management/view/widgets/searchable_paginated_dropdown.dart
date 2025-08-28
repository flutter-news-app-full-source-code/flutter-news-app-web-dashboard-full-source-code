import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/searchable_paginated_dropdown/searchable_paginated_dropdown_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template searchable_paginated_dropdown}
/// A custom dropdown widget that provides search and paginated loading
/// capabilities for a generic type [T].
///
/// This widget displays as a [TextFormField] with a dropdown icon. When tapped,
/// it opens an overlay containing a search input and a scrollable list of items.
/// Items are fetched on demand from a [DataRepository] and can be filtered
/// by a search term.
/// {@endtemplate}
class SearchablePaginatedDropdown<T extends Equatable> extends StatefulWidget {
  /// {@macro searchable_paginated_dropdown}
  const SearchablePaginatedDropdown({
    required this.label,
    required this.itemBuilder,
    required this.itemToString,
    required this.onChanged,
    this.selectedItem,
    super.key,
  });

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

  @override
  State<SearchablePaginatedDropdown<T>> createState() =>
      _SearchablePaginatedDropdownState<T>();
}

/// State class for [SearchablePaginatedDropdown].
class _SearchablePaginatedDropdownState<T extends Equatable>
    extends State<SearchablePaginatedDropdown<T>> {
  /// Controller for the text input field.
  final TextEditingController _textController = TextEditingController();

  /// Focus node for the text input field.
  final FocusNode _focusNode = FocusNode();

  /// A reference to the currently active [OverlayEntry] for the dropdown.
  /// Used to manage dismissal and prevent multiple overlays.
  OverlayEntry? _currentOverlayEntry;

  @override
  void initState() {
    super.initState();
    // Initialize text field with selected item's string representation
    _textController.text = widget.selectedItem != null
        ? widget.itemToString(widget.selectedItem!)
        : '';
    // Add listener to detect when the input field gains focus to show the overlay
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant SearchablePaginatedDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update text field if the selected item changes externally
    if (widget.selectedItem != oldWidget.selectedItem) {
      _textController.text = widget.selectedItem != null
          ? widget.itemToString(widget.selectedItem!)
          : '';
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    // Ensure any active overlay is removed when the widget is disposed
    _currentOverlayEntry?.remove();
    super.dispose();
  }

  /// Handles focus changes for the input field.
  /// If the field gains focus, it triggers the display of the overlay.
  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    }
  }

  /// Displays the full-screen overlay for searching and selecting items.
  void _showOverlay() {
    // Dismiss any existing overlay before showing a new one to prevent stacking
    _currentOverlayEntry?.remove();
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate the available space for the overlay.
    // This assumes the main content is within a Card, and we want the overlay
    // to fill that Card's area, not the entire browser window.
    final cardContext = context.findAncestorRenderObjectOfType<RenderBox>()
        ?.paintBounds;

    // Determine the width, height, top, and left for the Positioned widget
    // If cardContext is null (e.g., not within a Card), fallback to screen dimensions
    final availableWidth = cardContext?.width ?? screenWidth;
    final availableHeight = cardContext?.height ?? screenHeight;
    final availableTop = cardContext?.top ?? 0;
    final availableLeft = cardContext?.left ?? 0;

    // Retrieve the Bloc instance from the widget tree
    final bloc = context.read<SearchablePaginatedDropdownBloc<T>>();

    // Create the OverlayEntry
    _currentOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: availableTop,
        left: availableLeft,
        width: availableWidth,
        height: availableHeight,
        child: _OverlayContent<T>(
          bloc: bloc,
          itemBuilder: widget.itemBuilder,
          itemToString: widget.itemToString,
          onItemSelected: (item) {
            // Update the selected item, text controller, and dismiss the overlay
            widget.onChanged(item);
            _textController.text = widget.itemToString(item);
            _currentOverlayEntry?.remove();
            _currentOverlayEntry = null; // Clear reference
            _focusNode.unfocus(); // Remove focus from the input field
          },
          onClose: () {
            // Dismiss the overlay when the close button is pressed
            _currentOverlayEntry?.remove();
            _currentOverlayEntry = null; // Clear reference
            _focusNode.unfocus(); // Remove focus from the input field
          },
        ),
      ),
    );

    // Insert the overlay into the Overlay widget tree
    Overlay.of(context).insert(_currentOverlayEntry!);
    // Trigger an initial load of items when the overlay is opened
    bloc.add(
      const SearchablePaginatedDropdownLoadRequested(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return TextFormField(
      controller: _textController,
      focusNode: _focusNode,
      readOnly: true, // Prevent direct text input, only allow selection
      decoration: InputDecoration(
        labelText: widget.label,
        border: Theme.of(context).inputDecorationTheme.border,
        suffixIcon: IconButton(
          icon: const Icon(Icons.arrow_drop_down),
          onPressed: _focusNode.requestFocus, // Request focus to open overlay
        ),
        // Clear button if an item is selected
        prefixIcon: widget.selectedItem != null
            ? IconButton(
                icon: const Icon(Icons.clear),
                tooltip: l10n.clearSelection,
                onPressed: () {
                  // Clear selected item and text field
                  widget.onChanged(null);
                  _textController.clear();
                  // Dispatch event to clear selection in the Bloc
                  context.read<SearchablePaginatedDropdownBloc<T>>().add(
                    const SearchablePaginatedDropdownClearSelection(),
                  );
                },
              )
            : null,
      ),
      onTap: _focusNode.requestFocus, // Request focus to open overlay on tap
    );
  }
}

/// {@template _overlay_content}
/// The content displayed within the overlay of the [SearchablePaginatedDropdown].
/// This widget provides a full-screen modal experience with a search bar
/// and a paginated list of items.
/// {@endtemplate}
class _OverlayContent<T extends Equatable> extends StatefulWidget {
  /// {@macro _overlay_content}
  const _OverlayContent({
    required this.bloc,
    required this.itemBuilder,
    required this.itemToString,
    required this.onItemSelected,
    required this.onClose,
    super.key,
  });

  /// The Bloc instance managing the dropdown's state.
  final SearchablePaginatedDropdownBloc<T> bloc;

  /// A builder function to customize the display of each item in the list.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// A function to convert an item [T] to its string representation for
  /// display in the input field and for search filtering.
  final String Function(T item) itemToString;

  /// Callback when an item is selected.
  final ValueChanged<T> onItemSelected;

  /// Callback to close the overlay.
  final VoidCallback onClose;

  @override
  State<_OverlayContent<T>> createState() => _OverlayContentState<T>();
}

/// State class for [_OverlayContent].
class _OverlayContentState<T extends Equatable>
    extends State<_OverlayContent<T>> {
  /// Controller for the search input field within the overlay.
  final TextEditingController _searchController = TextEditingController();

  /// Controller for the scrollable list of items, used for pagination.
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add listener to detect when the scroll reaches the end for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Handles scroll events to trigger loading more items when the end is reached.
  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Dispatch event to load more items
      widget.bloc.add(
        const SearchablePaginatedDropdownLoadMoreRequested(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return Scaffold(
      appBar: AppBar(
        // Display selected item's string representation or a generic title
        title: Text(
          widget.bloc.state.selectedItem != null
              ? widget.itemToString(widget.bloc.state.selectedItem!)
              : l10n.none, // Use a localized string when no item is selected
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onClose, // Close the overlay
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.search,
                border: Theme.of(context).inputDecorationTheme.border,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // Clear search input and trigger a new search event
                    _searchController.clear();
                    widget.bloc.add(
                      const SearchablePaginatedDropdownSearchTermChanged(''),
                    );
                  },
                ),
              ),
              onChanged: (value) =>
                  // Dispatch search term changed event on input
                  widget.bloc.add(SearchablePaginatedDropdownSearchTermChanged(value)),
            ),
          ),
        ),
      ),
      body: BlocBuilder<
          SearchablePaginatedDropdownBloc<T>,
          SearchablePaginatedDropdownState<T>>(
        bloc: widget.bloc,
        builder: (context, state) {
          // Show loading indicator if no items are loaded yet
          if (state.status == SearchablePaginatedDropdownStatus.loading &&
              state.items.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.search,
              headline: l10n.loadingData,
              subheadline: l10n.pleaseWait,
            );
          }

          // Show error message if loading failed and no items are present
          if (state.status == SearchablePaginatedDropdownStatus.failure &&
              state.items.isEmpty) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () =>
                  // Retry loading data
                  widget.bloc.add(const SearchablePaginatedDropdownLoadRequested()),
            );
          }

          // Show message if no results are found
          if (state.items.isEmpty) {
            return Center(
              child: Text(
                l10n.noResultsFound,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          // Display the list of items
          return ListView.builder(
            controller: _scrollController,
            // Add 1 to itemCount if there are more items to load (for loading indicator)
            itemCount: state.items.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              // Show circular progress indicator at the end if more items are available
              if (index == state.items.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              // Build each item using the provided itemBuilder
              final item = state.items[index];
              return ListTile(
                title: widget.itemBuilder(context, item),
                onTap: () => widget.onItemSelected(item), // Select item on tap
              );
            },
          );
        },
      ),
    );
  }
}
