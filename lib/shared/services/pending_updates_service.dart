import 'dart:async';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Represents the status of a pending update.
enum UpdateStatus {
  /// The update has been confirmed and executed.
  confirmed,

  /// The update has been successfully undone.
  undone,
}

/// {@template update_event}
/// An event representing a change in the status of a pending update.
///
/// Contains the ID of the item and its new status.
/// {@endtemplate}
@immutable
class UpdateEvent<T> extends Equatable {
  /// {@macro update_event}
  const UpdateEvent(this.id, this.status, {this.originalItem});

  /// The unique identifier of the item.
  final String id;

  /// The new status of the update.
  final UpdateStatus status;

  /// The original item before the update was requested.
  /// This is provided when an update is undone.
  final T? originalItem;

  @override
  List<Object?> get props => [id, status, originalItem];
}

/// {@template pending_updates_service}
/// An abstract interface for a service that manages pending updates.
///
/// This service provides a mechanism to request a delayed update of an item,
/// allowing for an "undo" period.
/// {@endtemplate}
abstract class PendingUpdatesService {
  /// A stream that emits [UpdateEvent]s when an update is confirmed or undone.
  Stream<UpdateEvent<dynamic>> get updateEvents;

  /// Requests the update of an item of a specific type [T].
  void requestUpdate<T>({
    required T originalItem,
    required T updatedItem,
    required DataRepository<T> repository,
    required Duration undoDuration,
  });

  /// Cancels a pending update for the item with the given [id].
  void undoUpdate(String id);

  /// Disposes of the service's resources.
  void dispose();
}

/// {@template pending_updates_service_impl}
/// A concrete implementation of [PendingUpdatesService].
/// {@endtemplate}
class PendingUpdatesServiceImpl implements PendingUpdatesService {
  /// {@macro pending_updates_service_impl}
  PendingUpdatesServiceImpl({Logger? logger})
    : _logger = logger ?? Logger('PendingUpdatesServiceImpl');

  final Logger _logger;
  final _updateEventController =
      StreamController<UpdateEvent<dynamic>>.broadcast();
  final Map<String, _PendingUpdate<dynamic>> _pendingUpdateTimers = {};

  @override
  Stream<UpdateEvent<dynamic>> get updateEvents =>
      _updateEventController.stream;

  @override
  void requestUpdate<T>({
    required T originalItem,
    required T updatedItem,
    required DataRepository<T> repository,
    required Duration undoDuration,
  }) {
    final id = (updatedItem as dynamic).id as String;
    _logger.info('Requesting update for item ID: $id');

    if (_pendingUpdateTimers.containsKey(id)) {
      _logger.info('Cancelling existing pending update for ID: $id');
      _pendingUpdateTimers.remove(id)?.timer.cancel();
    }

    final timer = Timer(undoDuration, () async {
      try {
        await repository.update(id: id, item: updatedItem);
        _logger.info('Update confirmed for item ID: $id');
        _updateEventController.add(
          UpdateEvent<T>(id, UpdateStatus.confirmed),
        );
      } catch (error) {
        _logger.severe('Error confirming update for item ID: $id: $error');
        _updateEventController.addError(error);
      } finally {
        _pendingUpdateTimers.remove(id);
      }
    });

    _pendingUpdateTimers[id] = _PendingUpdate<T>(
      timer: timer,
      originalItem: originalItem,
    );
  }

  @override
  void undoUpdate(String id) {
    _logger.info('Attempting to undo update for item ID: $id');
    final pendingUpdate = _pendingUpdateTimers.remove(id);
    if (pendingUpdate != null) {
      pendingUpdate.timer.cancel();
      _logger.info('Update undone for item ID: $id');
      _updateEventController.add(
        UpdateEvent<dynamic>(
          id,
          UpdateStatus.undone,
          originalItem: pendingUpdate.originalItem,
        ),
      );
    } else {
      _logger.warning('No pending update found for ID: $id to undo.');
    }
  }

  @override
  void dispose() {
    _logger.info(
      'Disposing PendingUpdatesService. Cancelling ${_pendingUpdateTimers.length} pending timers.',
    );
    for (final pendingUpdate in _pendingUpdateTimers.values) {
      pendingUpdate.timer.cancel();
    }
    _pendingUpdateTimers.clear();
    _updateEventController.close();
  }
}

@immutable
class _PendingUpdate<T> extends Equatable {
  const _PendingUpdate({required this.timer, required this.originalItem});

  final Timer timer;
  final T originalItem;

  @override
  List<Object?> get props => [timer, originalItem];
}
