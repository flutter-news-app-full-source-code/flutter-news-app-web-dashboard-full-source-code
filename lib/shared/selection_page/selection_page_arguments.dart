import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template selection_page_arguments}
/// Arguments passed to the [SearchableSelectionPage] to configure its behavior.
///
/// This class supports two modes of operation:
/// 1. Fetching data from a [DataRepository] (for dynamic, API-backed lists).
/// 2. Displaying a static list of items (for enums or predefined lists).
///
/// It also includes common configuration like title, item builders, and
/// initial selection.
/// {@endtemplate}
class SelectionPageArguments<T extends Equatable> extends Equatable {
  /// {@macro selection_page_arguments}
  const SelectionPageArguments({
    required this.title,
    required this.itemBuilder,
    required this.itemToString,
    this.repository,
    this.filterBuilder,
    this.sortOptions,
    this.limit,
    this.staticItems,
    this.initialSelectedItem,
  }) : assert(
          (repository != null && filterBuilder != null && sortOptions != null && limit != null) ^
              (staticItems != null),
          'Either repository-related parameters or staticItems must be provided, but not both.',
        );

  /// The title to display in the AppBar of the selection page.
  final String title;

  /// A builder function to customize the display of each item in the list.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// A function to convert an item [T] to its string representation for
  /// display in the search bar and selected item text.
  final String Function(T item) itemToString;

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

  /// The item that is initially selected when the page opens.
  final T? initialSelectedItem;

  @override
  List<Object?> get props => [
        title,
        itemBuilder,
        itemToString,
        repository,
        filterBuilder,
        sortOptions,
        limit,
        staticItems,
        initialSelectedItem,
      ];
}
