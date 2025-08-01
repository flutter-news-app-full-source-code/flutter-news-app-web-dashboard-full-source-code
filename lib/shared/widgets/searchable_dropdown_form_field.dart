import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
class SearchableDropdownFormField<T, B extends BlocBase<S>, S>
    extends FormField<T> {
  /// {@macro searchable_dropdown_form_field}
  SearchableDropdownFormField({
    required B bloc,
    required List<T> Function(S state) itemsExtractor,
    required bool Function(S state) hasMoreExtractor,
    required bool Function(S state) isLoadingExtractor,
    required ValueChanged<T?> onChanged,
    required ValueChanged<String> onSearchChanged,
    required VoidCallback onLoadMore,
    required SearchableDropdownItemBuilder<T> itemBuilder,
    required SearchableDropdownSelectedItemBuilder<T> selectedItemBuilder,
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
                  builder: (context) => _SearchableSelectionDialog<T, B, S>(
                    bloc: bloc,
                    itemsExtractor: itemsExtractor,
                    hasMoreExtractor: hasMoreExtractor,
                    isLoadingExtractor: isLoadingExtractor,
                    onSearchChanged: onSearchChanged,
                    onLoadMore: onLoadMore,
                    itemBuilder: itemBuilder,
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
class _SearchableSelectionDialog<T, B extends BlocBase<S>, S>
    extends StatefulWidget {
  const _SearchableSelectionDialog({
    required this.bloc,
    required this.itemsExtractor,
    required this.hasMoreExtractor,
    required this.isLoadingExtractor,
    required this.onSearchChanged,
    required this.onLoadMore,
    required this.itemBuilder,
    this.searchHintText,
    this.noItemsFoundText,
    super.key,
  });

  final B bloc;
  final List<T> Function(S state) itemsExtractor;
  final bool Function(S state) hasMoreExtractor;
  final bool Function(S state) isLoadingExtractor;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onLoadMore;
  final SearchableDropdownItemBuilder<T> itemBuilder;
  final String? searchHintText;
  final String? noItemsFoundText;

  @override
  State<_SearchableSelectionDialog<T, B, S>> createState() =>
      _SearchableSelectionDialogState<T, B, S>();
}

class _SearchableSelectionDialogState<T, B extends BlocBase<S>, S>
    extends State<_SearchableSelectionDialog<T, B, S>> {
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
                child: BlocBuilder<B, S>(
                  bloc: widget.bloc,
                  builder: (context, state) {
                    final items = widget.itemsExtractor(state);
                    final hasMore = widget.hasMoreExtractor(state);
                    final isLoading = widget.isLoadingExtractor(state);

                    return _buildList(items, hasMore, isLoading);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<T> items, bool hasMore, bool isLoading) {
    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return Center(
        child: Text(widget.noItemsFoundText ?? 'No items found.'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: items.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          // This is the last item, which is the loading indicator.
          // It's only shown if we have more items and are currently loading.
          return isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox.shrink();
        }

        // This is a regular item.
        final item = items[index];
        return InkWell(
          onTap: () => Navigator.of(context).pop(item),
          child: widget.itemBuilder(context, item),
        );
      },
    );
  }
}