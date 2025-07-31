import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// A generic type for the builder function that creates list items in the
/// searchable dropdown.
typedef SearchableDropdownItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

/// A generic type for the builder function that creates the widget to display
/// the selected item within the form field.
typedef SearchableDropdownSelectedItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

/// A form field that allows users to select an item from a searchable,
/// paginated list displayed in a modal dialog.
///
/// This widget is generic and can be used for any type [T]. It requires
/// builders for constructing the list items and the selected item display,
/// as well as callbacks to handle searching and pagination.
class SearchableDropdownFormField<T> extends FormField<T> {
  /// {@macro searchable_dropdown_form_field}
  SearchableDropdownFormField({
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required ValueChanged<String> onSearchChanged,
    required VoidCallback onLoadMore,
    required SearchableDropdownItemBuilder<T> itemBuilder,
    required SearchableDropdownSelectedItemBuilder<T> selectedItemBuilder,
    required bool hasMore,
    bool? isLoading,
    super.key,
    T? initialValue,
    String? labelText,
    String? searchHintText,
    String? noItemsFoundText,
    super.onSaved,
    super.validator,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(
          initialValue: initialValue,
          builder: (FormFieldState<T> state) {
            // This is the widget that will be displayed in the form.
            // It looks like a text field but opens a dialog on tap.
            return InkWell(
              onTap: () async {
                final selectedItem = await showDialog<T>(
                  context: state.context,
                  builder: (context) => _SearchableSelectionDialog<T>(
                    items: items,
                    onSearchChanged: onSearchChanged,
                    onLoadMore: onLoadMore,
                    itemBuilder: itemBuilder,
                    hasMore: hasMore,
                    isLoading: isLoading ?? false,
                    searchHintText: searchHintText,
                    noItemsFoundText: noItemsFoundText,
                  ),
                );

                if (selectedItem != null) {
                  state.didChange(selectedItem);
                  onChanged(selectedItem);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: labelText,
                  border: const OutlineInputBorder(),
                  errorText: state.errorText,
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                ),
                child: state.value == null
                    ? const SizedBox(height: 20) // To maintain field height
                    : selectedItemBuilder(state.context, state.value as T),
              ),
            );
          },
        );
}

/// The modal dialog that contains the searchable and paginated list.
class _SearchableSelectionDialog<T> extends StatefulWidget {
  const _SearchableSelectionDialog({
    required this.items,
    required this.onSearchChanged,
    required this.onLoadMore,
    required this.itemBuilder,
    required this.hasMore,
    required this.isLoading,
    this.searchHintText,
    this.noItemsFoundText,
    super.key,
  });

  final List<T> items;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onLoadMore;
  final SearchableDropdownItemBuilder<T> itemBuilder;
  final bool hasMore;
  final bool isLoading;
  final String? searchHintText;
  final String? noItemsFoundText;

  @override
  State<_SearchableSelectionDialog<T>> createState() =>
      _SearchableSelectionDialogState<T>();
}

class _SearchableSelectionDialogState<T>
    extends State<_SearchableSelectionDialog<T>> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      widget.onLoadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Add a small buffer to trigger before reaching the absolute bottom.
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        height: 600,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.searchHintText ?? 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: _buildList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (widget.isLoading && widget.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.items.isEmpty) {
      return Center(
        child: Text(widget.noItemsFoundText ?? 'No items found.'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount:
          widget.hasMore ? widget.items.length + 1 : widget.items.length,
      itemBuilder: (context, index) {
        if (index >= widget.items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final item = widget.items[index];
        return InkWell(
          onTap: () => Navigator.of(context).pop(item),
          child: widget.itemBuilder(context, item),
        );
      },
    );
  }
}