import 'dart:async';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
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
    required this.repository,
    required this.itemBuilder,
    required this.itemToString,
    required this.filterBuilder,
    required this.onChanged,
    this.selectedItem,
    this.sortOptions = const [],
    this.limit = 20,
    super.key,
  });

  /// The label text for the input field.
  final String label;

  /// The data repository to fetch items from.
  final DataRepository<T> repository;

  /// The currently selected item.
  final T? selectedItem;

  /// A builder function to customize the display of each item in the list.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// A function to convert an item [T] to its string representation for
  /// display in the input field and for search filtering.
  final String Function(T item) itemToString;

  /// A function to build a filter map for the repository based on a search term.
  /// The search term will be `null` for initial load without search.
  final Map<String, dynamic> Function(String? searchTerm) filterBuilder;

  /// Callback when an item is selected or cleared.
  final ValueChanged<T?> onChanged;

  /// Sorting options for fetching data from the repository.
  final List<SortOption> sortOptions;

  /// The maximum number of items to fetch per page.
  final int limit;

  @override
  State<SearchablePaginatedDropdown<T>> createState() =>
      _SearchablePaginatedDropdownState<T>();
}

class _SearchablePaginatedDropdownState<T extends Equatable>
    extends State<SearchablePaginatedDropdown<T>> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<T> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String? _cursor;
  HttpException? _exception;
  String _searchTerm = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _textController.text =
        widget.selectedItem != null ? widget.itemToString(widget.selectedItem!) : '';
    _scrollController.addListener(_onScroll);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant SearchablePaginatedDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      _textController.text =
          widget.selectedItem != null ? widget.itemToString(widget.selectedItem!) : '';
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasMore &&
        !_isLoading) {
      _fetchItems(isPaginating: true);
    }
  }

  void _onSearchTermChanged(String value) {
    _searchTerm = value;
    _debounce?.cancel();
    _debounce = Timer(AppConstants.kSearchDebounceDuration, () {
      _resetAndFetchItems();
    });
  }

  Future<void> _resetAndFetchItems() async {
    _items = [];
    _cursor = null;
    _hasMore = true;
    _exception = null;
    await _fetchItems();
  }

  Future<void> _fetchItems({bool isPaginating = false}) async {
    if (_isLoading || (!_hasMore && isPaginating)) return;

    setState(() {
      _isLoading = true;
      _exception = null;
    });

    try {
      final filter = widget.filterBuilder(_searchTerm.isEmpty ? null : _searchTerm);
      final response = await widget.repository.readAll(
        filter: filter,
        sort: widget.sortOptions,
        pagination: PaginationOptions(
          cursor: isPaginating ? _cursor : null,
          limit: widget.limit,
        ),
      );

      setState(() {
        _items.addAll(response.items);
        _cursor = response.cursor;
        _hasMore = response.hasMore;
      });
    } on HttpException catch (e) {
      setState(() {
        _exception = e;
      });
    } catch (e) {
      setState(() {
        _exception = UnknownException('An unexpected error occurred: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        // Position the overlay directly below the input field
        top: offset.dy + size.height + AppSpacing.xs,
        left: offset.dx,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(AppConstants.kCardRadius),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: AppConstants.kMaxDropdownOverlayHeight,
              minHeight: 100,
            ),
            child: _OverlayContent(
              items: _items,
              isLoading: _isLoading,
              hasMore: _hasMore,
              exception: _exception,
              itemBuilder: widget.itemBuilder,
              itemToString: widget.itemToString,
              onSearchTermChanged: _onSearchTermChanged,
              onItemSelected: (item) {
                widget.onChanged(item);
                _textController.text = widget.itemToString(item);
                overlayEntry?.remove();
                _focusNode.unfocus();
              },
              onClose: () {
                overlayEntry?.remove();
                _focusNode.unfocus();
              },
              scrollController: _scrollController,
              onRetry: _resetAndFetchItems,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    _resetAndFetchItems(); // Load initial data when overlay opens
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
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.arrow_drop_down),
          onPressed: () {
            _focusNode.requestFocus(); // Open overlay on icon tap
          },
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
      onTap: () {
        _focusNode.requestFocus(); // Open overlay on text field tap
      },
    );
  }
}

/// {@template _overlay_content}
/// The content displayed within the overlay of the [SearchablePaginatedDropdown].
/// {@endtemplate}
class _OverlayContent<T extends Equatable> extends StatefulWidget {
  /// {@macro _overlay_content}
  const _OverlayContent({
    required this.items,
    required this.isLoading,
    required this.hasMore,
    required this.exception,
    required this.itemBuilder,
    required this.itemToString,
    required this.onSearchTermChanged,
    required this.onItemSelected,
    required this.onClose,
    required this.scrollController,
    required this.onRetry,
    super.key,
  });

  final List<T> items;
  final bool isLoading;
  final bool hasMore;
  final HttpException? exception;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String Function(T item) itemToString;
  final ValueChanged<String> onSearchTermChanged;
  final ValueChanged<T> onItemSelected;
  final VoidCallback onClose;
  final ScrollController scrollController;
  final VoidCallback onRetry;

  @override
  State<_OverlayContent<T>> createState() => _OverlayContentState<T>();
}

class _OverlayContentState<T extends Equatable>
    extends State<_OverlayContent<T>> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: l10n.search,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  widget.onSearchTermChanged('');
                },
              ),
            ),
            onChanged: widget.onSearchTermChanged,
          ),
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              if (widget.isLoading && widget.items.isEmpty) {
                return LoadingStateWidget(
                  icon: Icons.search,
                  headline: l10n.loadingData,
                  subheadline: l10n.pleaseWait,
                );
              }

              if (widget.exception != null && widget.items.isEmpty) {
                return FailureStateWidget(
                  exception: widget.exception!,
                  onRetry: widget.onRetry,
                );
              }

              if (widget.items.isEmpty) {
                return Center(child: Text(l10n.noResultsFound));
              }

              return ListView.builder(
                controller: widget.scrollController,
                itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == widget.items.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final item = widget.items[index];
                  return ListTile(
                    title: widget.itemBuilder(context, item),
                    onTap: () => widget.onItemSelected(item),
                  );
                },
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextButton(
              onPressed: widget.onClose,
              child: Text(l10n.close),
            ),
          ),
        ),
      ],
    );
  }
}
