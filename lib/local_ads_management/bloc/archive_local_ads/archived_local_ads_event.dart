part of 'archived_local_ads_bloc.dart';

sealed class ArchivedLocalAdsEvent extends Equatable {
  const ArchivedLocalAdsEvent();

  @override
  List<Object?> get props => [];
}

/// {@template load_archived_local_ads_requested}
/// Event to request loading of archived local ads for a specific type.
/// {@endtemplate}
final class LoadArchivedLocalAdsRequested extends ArchivedLocalAdsEvent {
  /// {@macro load_archived_local_ads_requested}
  const LoadArchivedLocalAdsRequested({
    required this.adType,
    this.startAfterId,
    this.limit,
  });

  /// The type of ad to load.
  final AdType adType;

  /// Optional ID to start pagination after.
  final String? startAfterId;

  /// Optional maximum number of items to return.
  final int? limit;

  @override
  List<Object?> get props => [adType, startAfterId, limit];
}

/// {@template restore_local_ad_requested}
/// Event to restore an archived local ad.
/// {@endtemplate}
final class RestoreLocalAdRequested extends ArchivedLocalAdsEvent {
  /// {@macro restore_local_ad_requested}
  const RestoreLocalAdRequested(this.id, this.adType);

  /// The ID of the local ad to restore.
  final String id;

  /// The type of the local ad to restore.
  final AdType adType;

  @override
  List<Object?> get props => [id, adType];
}

/// {@template delete_local_ad_forever_requested}
/// Event to permanently delete an archived local ad.
/// {@endtemplate}
final class DeleteLocalAdForeverRequested extends ArchivedLocalAdsEvent {
  /// {@macro delete_local_ad_forever_requested}
  const DeleteLocalAdForeverRequested(this.id, this.adType);

  /// The ID of the local ad to delete forever.
  final String id;

  /// The type of the local ad to delete forever.
  final AdType adType;

  @override
  List<Object?> get props => [id, adType];
}

/// {@template undo_delete_local_ad_requested}
/// Event to undo the deletion of a local ad.
/// {@endtemplate}
final class UndoDeleteLocalAdRequested extends ArchivedLocalAdsEvent {
  /// {@macro undo_delete_local_ad_requested}
  const UndoDeleteLocalAdRequested();
}

/// Internal event to confirm the permanent deletion of a local ad after a delay.
final class _ConfirmDeleteLocalAdRequested extends ArchivedLocalAdsEvent {
  /// {@macro _confirm_delete_local_ad_requested}
  const _ConfirmDeleteLocalAdRequested(this.id, this.adType);

  /// The ID of the local ad to confirm deletion for.
  final String id;

  /// The type of the local ad to confirm deletion for.
  final AdType adType;

  @override
  List<Object?> get props => [id, adType];
}
