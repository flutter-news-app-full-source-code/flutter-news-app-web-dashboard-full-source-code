import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Represents the status of a pending deletion.
enum DeletionStatus {
  /// The deletion has been confirmed and executed.
  confirmed,

  /// The deletion has been successfully undone.
  undone,
}

/// {@template deletion_event}
/// An event representing a change in the status of a pending deletion.
///
/// Contains the ID of the item and its new status.
/// {@endtemplate}
@immutable
class DeletionEvent<T> extends Equatable {
  /// {@macro deletion_event}
  const DeletionEvent(this.id, this.status, {this.item});

  /// The unique identifier of the item.
  final String id;

  /// The new status of the deletion.
  final DeletionStatus status;

  /// The item associated with the deletion event.
  /// This is typically provided when a deletion is undone.
  final T? item;

  @override
  List<Object?> get props => [id, status, item];
}

/// {@template pending_deletions_service}
/// An abstract interface for a service that manages pending deletions.
///
/// This service provides a mechanism to request a delayed deletion of an item,
/// allowing for an "undo" period. It is designed to be a singleton with a

/// lifecycle tied to the application, ensuring that deletion timers persist
/// even if the user navigates away from the page where the deletion was
/// initiated.
/// {@endtemplate}
abstract class PendingDeletionsService {
  /// A stream that emits [DeletionEvent]s when a deletion is confirmed or undone.
  ///
  /// BLoCs can listen to this stream to react to deletion status changes,
  /// such as removing an item from the state permanently or re-inserting it.
  Stream<DeletionEvent<dynamic>> get deletionEvents;

  /// Requests the deletion of an item of a specific type [T].
  ///
  /// - [item]: The item to be deleted. Must have an `id` property.
  /// - [repository]: The `DataRepository<T>` responsible for deleting the item.
  /// - [undoDuration]: The duration to wait before confirming the deletion.
  void requestDeletion<T>({
    required T item,
    required DataRepository<T> repository,
    required Duration undoDuration,
  });

  /// Cancels a pending deletion for the item with the given [id].
  void undoDeletion(String id);

  /// Disposes of the service's resources, like closing the stream controller.
  void dispose();
}

/// {@template pending_deletions_service_impl}
/// A concrete implementation of [PendingDeletionsService].
///
/// This class manages a map of timers for items pending deletion. When a
/// deletion is requested, it starts a timer. If the timer completes, it calls
/// the appropriate repository to perform the deletion and emits a `confirmed`
/// event. If an undo is requested, it cancels the timer and emits an `undone`
/// event.
/// {@endtemplate}
class PendingDeletionsServiceImpl implements PendingDeletionsService {
  /// {@macro pending_deletions_service_impl}
  PendingDeletionsServiceImpl({Logger? logger})
    : _logger = logger ?? Logger('PendingDeletionsServiceImpl');

  /// The logger instance for this service.
  final Logger _logger;

  /// The stream controller that broadcasts [DeletionEvent]s.
  final _deletionEventController =
      StreamController<DeletionEvent<dynamic>>.broadcast();

  /// A map that stores the `Timer` for each pending deletion, keyed by item ID.
  final Map<String, _PendingDeletion<dynamic>> _pendingDeletionTimers = {};

  @override
  Stream<DeletionEvent<dynamic>> get deletionEvents =>
      _deletionEventController.stream;

  @override
  void requestDeletion<T>({
    required T item,
    required DataRepository<T> repository,
    required Duration undoDuration,
  }) {
    // The item must have an 'id' property.
    final id = (item as dynamic).id as String;
    _logger.info('Requesting deletion for item ID: $id');

    // If there's already a pending deletion for this item, cancel it first.
    if (_pendingDeletionTimers.containsKey(id)) {
      _logger.info('Cancelling existing pending deletion for ID: $id');
      _pendingDeletionTimers.remove(id)?.timer.cancel();
    }

    final timer = Timer(undoDuration, () async {
      try {
        await repository.delete(id: id);
        _logger.info('Deletion confirmed for item ID: $id');
        _deletionEventController.add(
          DeletionEvent<T>(id, DeletionStatus.confirmed),
        );
      } catch (error) {
        _logger.severe('Error confirming deletion for item ID: $id: $error');
        _deletionEventController.addError(error);
      } finally {
        // Clean up the timer once the operation is complete.
        _pendingDeletionTimers.remove(id);
      }
    });

    _pendingDeletionTimers[id] = _PendingDeletion<T>(timer: timer, item: item);
  }

  @override
  void undoDeletion(String id) {
    _logger.info('Attempting to undo deletion for item ID: $id');
    // Cancel the timer and remove it from the map.
    final pendingDeletion = _pendingDeletionTimers.remove(id);
    if (pendingDeletion != null) {
      pendingDeletion.timer.cancel();
      _logger.info('Deletion undone for item ID: $id');
      // Notify listeners that the deletion was undone, including the item.
      _deletionEventController.add(
        DeletionEvent<dynamic>(
          id,
          DeletionStatus.undone,
          item: pendingDeletion.item,
        ),
      );
    } else {
      _logger.warning('No pending deletion found for ID: $id to undo.');
    }
  }

  @override
  void dispose() {
    _logger.info(
      'Disposing PendingDeletionsService. Cancelling ${_pendingDeletionTimers.length} pending timers.',
    );
    // Cancel all pending timers to prevent memory leaks.
    for (final pendingDeletion in _pendingDeletionTimers.values) {
      pendingDeletion.timer.cancel();
    }
    _pendingDeletionTimers.clear();
    _deletionEventController.close();
  }
}

/// A private class to hold the timer and the item for a pending deletion.
@immutable
class _PendingDeletion<T> extends Equatable {
  const _PendingDeletion({required this.timer, required this.item});

  final Timer timer;
  final T item;

  @override
  List<Object?> get props => [timer, item];
}
