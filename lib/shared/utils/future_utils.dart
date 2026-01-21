import 'dart:async';

/// A utility class for handling asynchronous operations with Futures.
abstract final class FutureUtils {
  /// Executes a list of [futures] in sequential batches to avoid overwhelming
  /// the server with too many simultaneous requests.
  ///
  /// This is a more controlled alternative to `Future.wait`, which executes all
  /// futures in parallel.
  ///
  /// - [futures]: A list of `Future<T> Function()` providers. Using function
  ///   providers ensures that futures are only created when they are about to be
  ///   executed, preventing them from starting prematurely.
  /// - [batchSize]: The number of futures to execute in parallel in each batch.
  /// - [delayBetweenBatches]: The duration to wait before starting the next batch.
  static Future<List<T>> fetchInBatches<T>(
    List<Future<T> Function()> futures, {
    int batchSize = 3,
    Duration delayBetweenBatches = const Duration(milliseconds: 200),
  }) async {
    final results = <T>[];
    for (var i = 0; i < futures.length; i += batchSize) {
      // Determine the end index for the current batch, ensuring it doesn't
      // exceed the list length.
      final end = (i + batchSize > futures.length)
          ? futures.length
          : i + batchSize;
      final batchFutures = futures.sublist(i, end).map((f) => f()).toList();

      // Execute the current batch in parallel.
      final batchResults = await Future.wait(batchFutures);
      results.addAll(batchResults);

      // If there are more batches to process, introduce a delay.
      if (end < futures.length) {
        // ignore: inference_failure_on_instance_creation
        await Future.delayed(delayBetweenBatches);
      }
    }
    return results;
  }
}
