import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/searchable_paginated_dropdown/searchable_paginated_dropdown_bloc.dart';
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

class _SearchablePaginatedDropdownState<T extends Equatable>
    extends State<SearchablePaginatedDropdown<T>> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController.text =
        widget.selectedItem != null ? widget.itemToString(widget.selectedItem!) : '';
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
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject()! as RenderBox;
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
          elevation: Theme.of(context).cardTheme.elevation ?? 4,
          borderRadius: (Theme.of(context).cardTheme.shape
                  as RoundedRectangleBorder?)
              ?.borderRadius
              .resolve(Directionality.of(context)) ??
              BorderRadius.circular(AppSpacing.sm),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: AppConstants.kMaxDropdownOverlayHeight,
              minHeight: 100,
            ),
            child: BlocProvider<SearchablePaginatedDropdownBloc<T>>.value(
              value: context.read<SearchablePaginatedDropdownBloc<T>>(),
              child: _OverlayContent<T>(
                itemBuilder: widget.itemBuilder,
                itemToString: widget.itemToString,
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
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    // Trigger initial load when overlay opens
    context.read<SearchablePaginatedDropdownBloc<T>>().add(
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
          onPressed: _focusNode.requestFocus,
        ),
        // Clear button if an item is selected
        prefixIcon: widget.selectedItem != null
            ? IconButton(
                icon: const Icon(Icons.clear),
                tooltip: l10n.clearSelection,
                onPressed: () {
                  widget.onChanged(null);
                  _textController.clear();
                  context.read<SearchablePaginatedDropdownBloc<T>>().add(
                        const SearchablePaginatedDropdownClearSelection(),
                      );
                },
              )
            : null,
      ),
      onTap: _focusNode.requestFocus,
    );
  }
}

/// {@template _overlay_content}
/// The content displayed within the overlay of the [SearchablePaginatedDropdown].
/// {@endtemplate}
class _OverlayContent<T extends Equatable> extends StatefulWidget {
  /// {@macro _overlay_content}
  const _OverlayContent({
    required this.itemBuilder,
    required this.itemToString,
    required this.onItemSelected,
    required this.onClose,
    super.key,
  });

  final Widget Function(BuildContext context, T item) itemBuilder;
  final String Function(T item) itemToString;
  final ValueChanged<T> onItemSelected;
  final VoidCallback onClose;

  @override
  State<_OverlayContent<T>> createState() => _OverlayContentState<T>();
}

class _OverlayContentState<T extends Equatable>
    extends State<_OverlayContent<T>> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<SearchablePaginatedDropdownBloc<T>>().add(
            const SearchablePaginatedDropdownLoadMoreRequested(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: l10n.search,
              border: Theme.of(context).inputDecorationTheme.border,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<SearchablePaginatedDropdownBloc<T>>().add(
                        const SearchablePaginatedDropdownSearchTermChanged(''),
                      );
                },
              ),
            ),
            onChanged: (value) => context
                .read<SearchablePaginatedDropdownBloc<T>>()
                .add(SearchablePaginatedDropdownSearchTermChanged(value)),
          ),
        ),
        Expanded(
          child: BlocBuilder<SearchablePaginatedDropdownBloc<T>,
              SearchablePaginatedDropdownState<T>>(
            builder: (context, state) {
              if (state.status == SearchablePaginatedDropdownStatus.loading &&
                  state.items.isEmpty) {
                return LoadingStateWidget(
                  icon: Icons.search,
                  headline: l10n.loadingData,
                  subheadline: l10n.pleaseWait,
                );
              }

              if (state.status == SearchablePaginatedDropdownStatus.failure &&
                  state.items.isEmpty) {
                return FailureStateWidget(
                  exception: state.exception!,
                  onRetry: () => context
                      .read<SearchablePaginatedDropdownBloc<T>>()
                      .add(const SearchablePaginatedDropdownLoadRequested()),
                );
              }

              if (state.items.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noResultsFound,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: state.items.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.items.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final item = state.items[index];
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
