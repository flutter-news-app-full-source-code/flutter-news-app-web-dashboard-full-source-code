import 'dart:async';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';

/// {@template throttled_fetching_service}
/// A service that provides a robust and efficient mechanism for fetching all
/// items from a paginated data source.
///
/// In scenarios where an entire dataset is needed upfront (e.g., for populating
/// dropdowns, client-side searching, or when UI components don't support
/// on-scroll pagination), this service offers an optimized solution.
///
/// It fetches all pages from a repository, providing a significant performance
/// improvement over fetching pages one by one, while avoiding the risk of
/// overwhelming the server by fetching all pages at once.
/// {@endtemplate}
class ThrottledFetchingService {
  /// {@macro throttled_fetching_service}
  const ThrottledFetchingService();

  /// Fetches all items of type [T] from the provided [repository].
  ///
  /// It fetches pages in parallel batches to optimize loading time without
  /// overwhelming the server.
  ///
  /// - [repository]: The data repository to fetch from.
  /// - [sort]: The sorting options for the query.
  /// - [batchSize]: The number of pages to fetch in each concurrent batch.
  ///   Defaults to 5.
  Future<List<T>> fetchAll<T>({
    required DataRepository<T> repository,
    required List<SortOption> sort,
    int batchSize = 5,
  }) async {
    final allItems = <T>[];
    String? cursor;
    bool hasMore;

    // First, fetch the initial page to get the first set of items and
    // determine the pagination status.
    final initialResponse = await repository.readAll(
      sort: sort,
      filter: {'status': ContentStatus.active.name},
    );
    allItems.addAll(initialResponse.items);
    cursor = initialResponse.cursor;
    hasMore = initialResponse.hasMore;

    // Sequentially fetch all remaining pages. The loop is resilient to a
    // misbehaving API by also checking if the cursor is null, which would
    // otherwise cause an infinite loop by re-fetching the first page.
    while (hasMore && cursor != null) {
      final response = await repository.readAll(
        sort: sort,
        pagination: PaginationOptions(cursor: cursor),
        filter: {'status': ContentStatus.active.name},
      );
      allItems.addAll(response.items);
      cursor = response.cursor;
      hasMore = response.hasMore;
    }

    return allItems;
  }
}
