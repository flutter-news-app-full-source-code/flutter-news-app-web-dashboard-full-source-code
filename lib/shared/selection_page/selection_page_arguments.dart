import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/selection_page/searchable_selection_page.dart'
    show SearchableSelectionPage;

/// {@template selection_page_arguments}
/// Arguments passed to the [SearchableSelectionPage] to configure its behavior.
///
/// This class supports two modes of operation:
/// 1. Fetching data from a [DataRepository] (for dynamic, API-backed lists).
/// 2. Displaying a static list of items (for enums or predefined lists).
///
/// It also includes common configuration like title, item builders, and
/// initial selection.
///
/// Note: Due to GoRouter's limitations with passing generic types via `extra`,
/// this class is non-generic and relies on runtime type information (`itemType`)
/// and casting at the point of use for `itemBuilder`, `itemToString`, etc.
/// {@endtemplate}
class SelectionPageArguments extends Equatable {
  /// {@macro selection_page_arguments}
  const SelectionPageArguments({
    required this.title,
    required this.itemType,
    required this.itemBuilder,
    required this.itemToString,
    this.repository,
    this.filterBuilder,
    this.sortOptions,
    this.limit,
    this.staticItems,
    this.initialSelectedItem,
  }) : assert(
         (repository != null &&
                 filterBuilder != null &&
                 sortOptions != null &&
                 limit != null) ^
             (staticItems != null),
         'Either repository-related parameters or staticItems must be provided, but not both.',
       );

  /// The title to display in the AppBar of the selection page.
  final String title;

  /// The runtime type of the items being selected (e.g., `Source`, `Topic`).
  /// This is used for safe casting of generic functions.
  final Type itemType;

  /// A builder function to customize the display of each item in the list.
  /// The item parameter is of type [Object] and must be cast to [itemType]
  /// before use.
  final Widget Function(BuildContext context, Object item) itemBuilder;

  /// A function to convert an item to its string representation for
  /// display in the search bar and selected item text.
  /// The item parameter is of type [Object] and must be cast to [itemType]
  /// before use.
  final String Function(Object item) itemToString;

  /// The [DataRepository] to use for fetching items (if not using static items).
  /// The repository's generic type is [Object] and must be cast to [itemType]
  /// before use.
  final DataRepository<Object>? repository;

  /// A function to build the filter map for the repository based on a search term.
  final Map<String, dynamic> Function(String? searchTerm)? filterBuilder;

  /// The sorting options for repository queries.
  final List<SortOption>? sortOptions;

  /// The pagination limit for repository queries.
  final int? limit;

  /// A static list of items to display (if not fetching from a repository).
  /// Items are of type [Object] and must be cast to [itemType] before use.
  final List<Object>? staticItems;

  /// The item that is initially selected when the page opens.
  /// The item is of type [Object] and must be cast to [itemType] before use.
  final Object? initialSelectedItem;

  @override
  List<Object?> get props => [
    title,
    itemType,
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
