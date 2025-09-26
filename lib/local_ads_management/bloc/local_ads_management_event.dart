part of 'local_ads_management_bloc.dart';

sealed class LocalAdsManagementEvent extends Equatable {
  const LocalAdsManagementEvent();

  @override
  List<Object?> get props => [];
}

/// {@template local_ads_management_tab_changed}
/// Event to change the active local ads management tab.
/// {@endtemplate}
final class LocalAdsManagementTabChanged extends LocalAdsManagementEvent {
  /// {@macro local_ads_management_tab_changed}
  const LocalAdsManagementTabChanged(this.tab);

  /// The new active tab.
  final LocalAdsManagementTab tab;

  @override
  List<Object?> get props => [tab];
}

/// {@template load_local_ads_requested}
/// Event to request loading of local ads for a specific type.
/// {@endtemplate}
final class LoadLocalAdsRequested extends LocalAdsManagementEvent {
  /// {@macro load_local_ads_requested}
  const LoadLocalAdsRequested({
    this.startAfterId,
    this.limit,
    this.forceRefresh = false,
    this.filter,
  });

  /// Optional ID to start pagination after.
  final String? startAfterId;

  /// Optional maximum number of items to return.
  final int? limit;

  /// If true, forces a refresh of the data, bypassing the cache.
  final bool forceRefresh;

  /// Optional filter to apply to the local ads query.
  final Map<String, dynamic>? filter;

  @override
  List<Object?> get props => [startAfterId, limit, forceRefresh, filter];
}

/// {@template archive_local_ad_requested}
/// Event to request archiving of a local ad.
/// {@endtemplate}
final class ArchiveLocalAdRequested extends LocalAdsManagementEvent {
  /// {@macro archive_local_ad_requested}
  const ArchiveLocalAdRequested(this.id);

  /// The ID of the local ad to archive.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// {@template restore_local_ad_requested}
/// Event to request restoring of a local ad.
/// {@endtemplate}
final class RestoreLocalAdRequested extends LocalAdsManagementEvent {
  /// {@macro restore_local_ad_requested}
  const RestoreLocalAdRequested(this.id);

  /// The ID of the local ad to restore.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// {@template delete_local_ad_forever_requested}
/// Event to request permanent deletion of a local ad.
/// {@endtemplate}
final class DeleteLocalAdForeverRequested extends LocalAdsManagementEvent {
  /// {@macro delete_local_ad_forever_requested}
  const DeleteLocalAdForeverRequested(this.id);

  /// The ID of the local ad to delete forever.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// {@template undo_delete_local_ad_requested}
/// Event to undo the deletion of a local ad.
/// {@endtemplate}
final class UndoDeleteLocalAdRequested extends LocalAdsManagementEvent {
  /// {@macro undo_delete_local_ad_requested}
  const UndoDeleteLocalAdRequested(this.id);

  /// The ID of the local ad to undo deletion for.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event received when a deletion event occurs in the PendingDeletionsService.
final class DeletionEventReceived extends LocalAdsManagementEvent {
  const DeletionEventReceived(this.event);

  final DeletionEvent<dynamic> event;

  @override
  List<Object?> get props => [event];
}
