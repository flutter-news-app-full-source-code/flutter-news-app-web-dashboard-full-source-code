import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
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
/// This page can display items fetched from a [DataRepository] or from a
/// static list, supporting search and infinite scrolling.
/// {@endtemplate}
class SearchableSelectionPage<T extends Equatable> extends StatelessWidget {
  /// {@macro searchable_selection_page}
  const SearchableSelectionPage({
    required this.arguments,
    super.key,
  });

  /// The arguments used to configure this page.
  final SelectionPageArguments<T> arguments;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchableSelectionBloc<T>(arguments: arguments),
      child: _SearchableSelectionView<T>(arguments: arguments),
    );
  }
}

class _SearchableSelectionView<T extends Equatable> extends StatefulWidget {
  const _SearchableSelectionView({
    required this.arguments,
  });

  final SelectionPageArguments<T> arguments;

  @override
  State<_SearchableSelectionView<T>> createState() =>
      _SearchableSelectionViewState<T>();
}

class _SearchableSelectionViewState<T extends Equatable>
    extends State<_SearchableSelectionView<T>> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.text = context
        .read<SearchableSelectionBloc<T>>()
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

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<SearchableSelectionBloc<T>>().add(
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
                    context.read<SearchableSelectionBloc<T>>().add(
                      const SearchableSelectionSearchTermChanged(''),
                    );
                  },
                ),
              ),
              onChanged: (value) => context
                  .read<SearchableSelectionBloc<T>>()
                  .add(SearchableSelectionSearchTermChanged(value)),
            ),
          ),
        ),
      ),
      body:
          BlocBuilder<SearchableSelectionBloc<T>, SearchableSelectionState<T>>(
            builder: (context, state) {
              if (state.status == SearchableSelectionStatus.loading &&
                  state.items.isEmpty) {
                return LoadingStateWidget(
                  icon: Icons.search,
                  headline: l10n.loadingData,
                  subheadline: l10n.pleaseWait,
                );
              }

              if (state.status == SearchableSelectionStatus.failure &&
                  state.items.isEmpty) {
                return FailureStateWidget(
                  exception: state.exception!,
                  onRetry: () => context.read<SearchableSelectionBloc<T>>().add(
                    const SearchableSelectionLoadRequested(),
                  ),
                );
              }

              if (state.items.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noResultsFound,
                    style: theme.textTheme.bodyLarge,
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
                    title: widget.arguments.itemBuilder(context, item),
                    onTap: () {
                      context.read<SearchableSelectionBloc<T>>().add(
                        SearchableSelectionSetSelectedItem(item),
                      );
                      Navigator.of(context).pop(item);
                    },
                    selected: item == state.selectedItem,
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
