import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart';
import 'package:ui_kit/ui_kit.dart';

part 'archive_local_ads_event.dart';
part 'archive_local_ads_state.dart';

/// {@template archive_local_ads_bloc}
/// A BLoC responsible for managing the state of archived local ads.
///
/// It handles loading, restoring, and permanently deleting archived local ads,
/// leveraging the [PendingDeletionsService] for undo functionality.
/// {@endtemplate}
class ArchiveLocalAdsBloc
    extends Bloc<ArchiveLocalAdsEvent, ArchiveLocalAdsState> {
  /// {@macro archive_local_ads_bloc}
  ArchiveLocalAdsBloc({
    required DataRepository<LocalAd> localAdsRepository,
    required PendingDeletionsService pendingDeletionsService,
  }) : _localAdsRepository = localAdsRepository,
       _pendingDeletionsService = pendingDeletionsService,
       super(const ArchiveLocalAdsState()) {
    on<LoadArchivedLocalAdsRequested>(_onLoadArchivedLocalAdsRequested);
    on<RestoreLocalAdRequested>(_onRestoreLocalAdRequested);
    on<DeleteLocalAdForeverRequested>(_onDeleteLocalAdForeverRequested);
    on<UndoDeleteLocalAdRequested>(_onUndoDeleteLocalAdRequested);
    on<_DeletionServiceStatusChanged>(_onDeletionServiceStatusChanged);

    // Listen to deletion events from the PendingDeletionsService.
    _deletionEventSubscription = _pendingDeletionsService.deletionEvents.listen(
      (event) {
        if (event.item is LocalAd) {
          add(_DeletionServiceStatusChanged(event));
        }
      },
    );
  }

  final DataRepository<LocalAd> _localAdsRepository;
  final PendingDeletionsService _pendingDeletionsService;

  /// Subscription to deletion events from the PendingDeletionsService.
  late final StreamSubscription<DeletionEvent<dynamic>>
  _deletionEventSubscription;

  @override
  Future<void> close() {
    _deletionEventSubscription.cancel();
    return super.close();
  }

  /// Handles the request to load archived local ads for a specific type.
  ///
  /// Fetches paginated archived local ads from the repository and updates the state.
  Future<void> _onLoadArchivedLocalAdsRequested(
    LoadArchivedLocalAdsRequested event,
    Emitter<ArchiveLocalAdsState> emit,
  ) async {
    // Determine current state and emit loading status
    switch (event.adType) {
      case AdType.native:
        emit(state.copyWith(nativeAdsStatus: ArchiveLocalAdsStatus.loading));
      case AdType.banner:
        emit(state.copyWith(bannerAdsStatus: ArchiveLocalAdsStatus.loading));
      case AdType.interstitial:
        emit(
          state.copyWith(
            interstitialAdsStatus: ArchiveLocalAdsStatus.loading,
          ),
        );
      case AdType.video:
        emit(state.copyWith(videoAdsStatus: ArchiveLocalAdsStatus.loading));
    }

    try {
      final isPaginating = event.startAfterId != null;
      final paginatedAds = await _localAdsRepository.readAll(
        filter: {
          'adType': event.adType.name,
          'status': ContentStatus.archived.name,
        },
        sort: [const SortOption('updatedAt', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );

      switch (event.adType) {
        case AdType.native:
          final previousAds = isPaginating
              ? state.nativeAds
              : <LocalNativeAd>[];
          emit(
            state.copyWith(
              nativeAdsStatus: ArchiveLocalAdsStatus.success,
              nativeAds: [
                ...previousAds,
                ...paginatedAds.items.cast<LocalNativeAd>(),
              ],
              nativeAdsCursor: paginatedAds.cursor,
              nativeAdsHasMore: paginatedAds.hasMore,
            ),
          );
        case AdType.banner:
          final previousAds = isPaginating
              ? state.bannerAds
              : <LocalBannerAd>[];
          emit(
            state.copyWith(
              bannerAdsStatus: ArchiveLocalAdsStatus.success,
              bannerAds: [
                ...previousAds,
                ...paginatedAds.items.cast<LocalBannerAd>(),
              ],
              bannerAdsCursor: paginatedAds.cursor,
              bannerAdsHasMore: paginatedAds.hasMore,
            ),
          );
        case AdType.interstitial:
          final previousAds = isPaginating
              ? state.interstitialAds
              : <LocalInterstitialAd>[];
          emit(
            state.copyWith(
              interstitialAdsStatus: ArchiveLocalAdsStatus.success,
              interstitialAds: [
                ...previousAds,
                ...paginatedAds.items.cast<LocalInterstitialAd>(),
              ],
              interstitialAdsCursor: paginatedAds.cursor,
              interstitialAdsHasMore: paginatedAds.hasMore,
            ),
          );
        case AdType.video:
          final previousAds = isPaginating ? state.videoAds : <LocalVideoAd>[];
          emit(
            state.copyWith(
              videoAdsStatus: ArchiveLocalAdsStatus.success,
              videoAds: [
                ...previousAds,
                ...paginatedAds.items.cast<LocalVideoAd>(),
              ],
              videoAdsCursor: paginatedAds.cursor,
              videoAdsHasMore: paginatedAds.hasMore,
            ),
          );
      }
    } on HttpException catch (e) {
      switch (event.adType) {
        case AdType.native:
          emit(
            state.copyWith(
              nativeAdsStatus: ArchiveLocalAdsStatus.failure,
              exception: e,
            ),
          );
        case AdType.banner:
          emit(
            state.copyWith(
              bannerAdsStatus: ArchiveLocalAdsStatus.failure,
              exception: e,
            ),
          );
        case AdType.interstitial:
          emit(
            state.copyWith(
              interstitialAdsStatus: ArchiveLocalAdsStatus.failure,
              exception: e,
            ),
          );
        case AdType.video:
          emit(
            state.copyWith(
              videoAdsStatus: ArchiveLocalAdsStatus.failure,
              exception: e,
            ),
          );
      }
    } catch (e) {
      switch (event.adType) {
        case AdType.native:
          emit(
            state.copyWith(
              nativeAdsStatus: ArchiveLocalAdsStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
        case AdType.banner:
          emit(
            state.copyWith(
              bannerAdsStatus: ArchiveLocalAdsStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
        case AdType.interstitial:
          emit(
            state.copyWith(
              interstitialAdsStatus: ArchiveLocalAdsStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
        case AdType.video:
          emit(
            state.copyWith(
              videoAdsStatus: ArchiveLocalAdsStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
      }
    }
  }

  /// Handles the request to restore an archived local ad.
  ///
  /// Optimistically removes the ad from the UI, updates its status to active
  /// in the repository, and then updates the state. If the ad was pending
  /// deletion, its pending deletion is cancelled.
  Future<void> _onRestoreLocalAdRequested(
    RestoreLocalAdRequested event,
    Emitter<ArchiveLocalAdsState> emit,
  ) async {
    // Cancel any pending deletion for this ad.
    _pendingDeletionsService.undoDeletion(event.id);

    LocalAd? adToRestore;
    final originalNativeAds = List<LocalNativeAd>.from(state.nativeAds);
    final originalBannerAds = List<LocalBannerAd>.from(state.bannerAds);
    final originalInterstitialAds = List<LocalInterstitialAd>.from(
      state.interstitialAds,
    );
    final originalVideoAds = List<LocalVideoAd>.from(state.videoAds);

    switch (event.adType) {
      case AdType.native:
        final index = originalNativeAds.indexWhere((ad) => ad.id == event.id);
        if (index == -1) return;
        adToRestore = originalNativeAds[index];
        originalNativeAds.removeAt(index);
        emit(
          state.copyWith(
            nativeAds: originalNativeAds,
            lastPendingDeletionId: state.lastPendingDeletionId == event.id
                ? null
                : state.lastPendingDeletionId,
            snackbarLocalAdTitle: null,
          ),
        );
      case AdType.banner:
        final index = originalBannerAds.indexWhere((ad) => ad.id == event.id);
        if (index == -1) return;
        adToRestore = originalBannerAds[index];
        originalBannerAds.removeAt(index);
        emit(
          state.copyWith(
            bannerAds: originalBannerAds,
            lastPendingDeletionId: state.lastPendingDeletionId == event.id
                ? null
                : state.lastPendingDeletionId,
            snackbarLocalAdTitle: null,
          ),
        );
      case AdType.interstitial:
        final index = originalInterstitialAds.indexWhere(
          (ad) => ad.id == event.id,
        );
        if (index == -1) return;
        adToRestore = originalInterstitialAds[index];
        originalInterstitialAds.removeAt(index);
        emit(
          state.copyWith(
            interstitialAds: originalInterstitialAds,
            lastPendingDeletionId: state.lastPendingDeletionId == event.id
                ? null
                : state.lastPendingDeletionId,
            snackbarLocalAdTitle: null,
          ),
        );
      case AdType.video:
        final index = originalVideoAds.indexWhere((ad) => ad.id == event.id);
        if (index == -1) return;
        adToRestore = originalVideoAds[index];
        originalVideoAds.removeAt(index);
        emit(
          state.copyWith(
            videoAds: originalVideoAds,
            lastPendingDeletionId: state.lastPendingDeletionId == event.id
                ? null
                : state.lastPendingDeletionId,
            snackbarLocalAdTitle: null,
          ),
        );
    }

    try {
      final updatedAd = switch (adToRestore) {
        final LocalNativeAd ad => ad.copyWith(status: ContentStatus.active),
        final LocalBannerAd ad => ad.copyWith(status: ContentStatus.active),
        final LocalInterstitialAd ad => ad.copyWith(
          status: ContentStatus.active,
        ),
        final LocalVideoAd ad => ad.copyWith(status: ContentStatus.active),
        _ => throw StateError(
          'Unknown LocalAd type: ${adToRestore.runtimeType}',
        ),
      };
      await _localAdsRepository.update(
        id: event.id,
        item: updatedAd,
      );
    } on HttpException catch (e) {
      // Revert UI on failure
      switch (event.adType) {
        case AdType.native:
          emit(
            state.copyWith(
              nativeAds: originalNativeAds,
              exception: e,
              lastPendingDeletionId: state.lastPendingDeletionId,
            ),
          );
        case AdType.banner:
          emit(
            state.copyWith(
              bannerAds: originalBannerAds,
              exception: e,
              lastPendingDeletionId: state.lastPendingDeletionId,
            ),
          );
        case AdType.interstitial:
          emit(
            state.copyWith(
              interstitialAds: originalInterstitialAds,
              exception: e,
              lastPendingDeletionId: state.lastPendingDeletionId,
            ),
          );
        case AdType.video:
          emit(
            state.copyWith(
              videoAds: originalVideoAds,
              exception: e,
              lastPendingDeletionId: state.lastPendingDeletionId,
            ),
          );
      }
    } catch (e) {
      switch (event.adType) {
        case AdType.native:
          emit(
            state.copyWith(
              nativeAds: originalNativeAds,
              exception: UnknownException('An unexpected error occurred: $e'),
              lastPendingDeletionId: state.lastPendingDeletionId,
            ),
          );
        case AdType.banner:
          emit(
            state.copyWith(
              bannerAds: originalBannerAds,
              exception: UnknownException('An unexpected error occurred: $e'),
              lastPendingDeletionId: state.lastPendingDeletionId,
            ),
          );
        case AdType.interstitial:
          emit(
            state.copyWith(
              interstitialAds: originalInterstitialAds,
              exception: UnknownException('An unexpected error occurred: $e'),
              lastPendingDeletionId: state.lastPendingDeletionId,
            ),
          );
        case AdType.video:
          emit(
            state.copyWith(
              videoAds: originalVideoAds,
              exception: UnknownException('An unexpected error occurred: $e'),
              lastPendingDeletionId: state.lastPendingDeletionId,
            ),
          );
      }
    }
  }

  /// Handles the request to permanently delete an archived local ad.
  ///
  /// This optimistically removes the ad from the UI and initiates a
  /// timed deletion via the [PendingDeletionsService].
  Future<void> _onDeleteLocalAdForeverRequested(
    DeleteLocalAdForeverRequested event,
    Emitter<ArchiveLocalAdsState> emit,
  ) async {
    LocalAd? adToDelete;
    final currentNativeAds = List<LocalNativeAd>.from(state.nativeAds);
    final currentBannerAds = List<LocalBannerAd>.from(state.bannerAds);
    final currentInterstitialAds = List<LocalInterstitialAd>.from(
      state.interstitialAds,
    );
    final currentVideoAds = List<LocalVideoAd>.from(state.videoAds);

    // Find and remove the ad from the current active list
    var index = -1;
    switch (event.adType) {
      case AdType.native:
        index = currentNativeAds.indexWhere((ad) => ad.id == event.id);
        if (index != -1) adToDelete = currentNativeAds[index];
      case AdType.banner:
        index = currentBannerAds.indexWhere((ad) => ad.id == event.id);
        if (index != -1) adToDelete = currentBannerAds[index];
      case AdType.interstitial:
        index = currentInterstitialAds.indexWhere((ad) => ad.id == event.id);
        if (index != -1) adToDelete = currentInterstitialAds[index];
      case AdType.video:
        index = currentVideoAds.indexWhere((ad) => ad.id == event.id);
        if (index != -1) adToDelete = currentVideoAds[index];
    }

    if (adToDelete == null) return;

    // Optimistically remove from UI
    switch (adToDelete.adType) {
      case 'native':
        currentNativeAds.removeWhere((ad) => ad.id == event.id);
        emit(state.copyWith(nativeAds: currentNativeAds));
      case 'banner':
        currentBannerAds.removeWhere((ad) => ad.id == event.id);
        emit(state.copyWith(bannerAds: currentBannerAds));
      case 'interstitial':
        currentInterstitialAds.removeWhere((ad) => ad.id == event.id);
        emit(state.copyWith(interstitialAds: currentInterstitialAds));
      case 'video':
        currentVideoAds.removeWhere((ad) => ad.id == event.id);
        emit(state.copyWith(videoAds: currentVideoAds));
    }

    String snackbarTitle;
    switch (adToDelete.adType) {
      case 'native':
        snackbarTitle = (adToDelete as LocalNativeAd).title;
      case 'banner':
        snackbarTitle = (adToDelete as LocalBannerAd).imageUrl;
      case 'interstitial':
        snackbarTitle = (adToDelete as LocalInterstitialAd).imageUrl;
      case 'video':
        snackbarTitle = (adToDelete as LocalVideoAd).videoUrl;
      default:
        snackbarTitle = adToDelete.id;
    }

    emit(
      state.copyWith(
        lastPendingDeletionId: event.id,
        snackbarLocalAdTitle: snackbarTitle,
      ),
    );

    // Request deletion via the service.
    _pendingDeletionsService.requestDeletion(
      item: adToDelete,
      repository: _localAdsRepository,
      undoDuration: const Duration(seconds: 5),
    );
  }

  /// Handles the request to undo a pending deletion of an archived local ad.
  ///
  /// This cancels the deletion timer in the [PendingDeletionsService].
  Future<void> _onUndoDeleteLocalAdRequested(
    UndoDeleteLocalAdRequested event,
    Emitter<ArchiveLocalAdsState> emit,
  ) async {
    if (state.lastPendingDeletionId != null) {
      _pendingDeletionsService.undoDeletion(state.lastPendingDeletionId!);
    }
    // The _onDeletionServiceStatusChanged will handle re-adding to the list
    // and updating pendingDeletions when DeletionStatus.undone is emitted.
  }

  /// Handles deletion events from the [PendingDeletionsService].
  ///
  /// This method is called when an item's deletion is confirmed or undone
  /// by the service. It updates the BLoC's state accordingly.
  Future<void> _onDeletionServiceStatusChanged(
    _DeletionServiceStatusChanged event,
    Emitter<ArchiveLocalAdsState> emit,
  ) async {
    final id = event.event.id;
    final status = event.event.status;
    final item = event.event.item;

    if (status == DeletionStatus.confirmed) {
      // Deletion confirmed, no action needed in BLoC as it was optimistically removed.
      // Ensure lastPendingDeletionId and snackbarLocalAdTitle are cleared if this was the one.
      emit(
        state.copyWith(
          lastPendingDeletionId: state.lastPendingDeletionId == id
              ? null
              : state.lastPendingDeletionId,
          snackbarLocalAdTitle: null,
        ),
      );
    } else if (status == DeletionStatus.undone) {
      // Deletion undone, restore the local ad to the main list.
      if (item is LocalAd) {
        switch (item.adType) {
          case 'native':
            final updatedAds = List<LocalNativeAd>.from(state.nativeAds)
              ..insert(0, item as LocalNativeAd);
            emit(
              state.copyWith(
                nativeAds: updatedAds,
                lastPendingDeletionId: state.lastPendingDeletionId == id
                    ? null
                    : state.lastPendingDeletionId,
                snackbarLocalAdTitle: null,
              ),
            );
          case 'banner':
            final updatedAds = List<LocalBannerAd>.from(state.bannerAds)
              ..insert(0, item as LocalBannerAd);
            emit(
              state.copyWith(
                bannerAds: updatedAds,
                lastPendingDeletionId: state.lastPendingDeletionId == id
                    ? null
                    : state.lastPendingDeletionId,
                snackbarLocalAdTitle: null,
              ),
            );
          case 'interstitial':
            final updatedAds = List<LocalInterstitialAd>.from(
              state.interstitialAds,
            )..insert(0, item as LocalInterstitialAd);
            emit(
              state.copyWith(
                interstitialAds: updatedAds,
                lastPendingDeletionId: state.lastPendingDeletionId == id
                    ? null
                    : state.lastPendingDeletionId,
                snackbarLocalAdTitle: null,
              ),
            );
          case 'video':
            final updatedAds = List<LocalVideoAd>.from(state.videoAds)
              ..insert(0, item as LocalVideoAd);
            emit(
              state.copyWith(
                videoAds: updatedAds,
                lastPendingDeletionId: state.lastPendingDeletionId == id
                    ? null
                    : state.lastPendingDeletionId,
                snackbarLocalAdTitle: null,
              ),
            );
        }
      }
    }
  }
}
