import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:ui_kit/ui_kit.dart';

part 'archived_local_ads_event.dart';
part 'archived_local_ads_state.dart';

class ArchivedLocalAdsBloc
    extends Bloc<ArchivedLocalAdsEvent, ArchivedLocalAdsState> {
  ArchivedLocalAdsBloc({
    required DataRepository<LocalAd> localAdsRepository,
  }) : _localAdsRepository = localAdsRepository,
       super(const ArchivedLocalAdsState()) {
    on<LoadArchivedLocalAdsRequested>(_onLoadArchivedLocalAdsRequested);
    on<RestoreLocalAdRequested>(_onRestoreLocalAdRequested);
    on<DeleteLocalAdForeverRequested>(_onDeleteLocalAdForeverRequested);
    on<UndoDeleteLocalAdRequested>(_onUndoDeleteLocalAdRequested);
    on<_ConfirmDeleteLocalAdRequested>(_onConfirmDeleteLocalAdRequested);

    _localAdUpdateSubscription = _localAdsRepository.entityUpdated
        .where((type) => type == LocalAd)
        .listen((_) {
          add(
            const LoadArchivedLocalAdsRequested(
              adType: AdType.native, // Default to native for refresh
              limit: kDefaultRowsPerPage,
            ),
          );
          add(
            const LoadArchivedLocalAdsRequested(
              adType: AdType.banner,
              limit: kDefaultRowsPerPage,
            ),
          );
          add(
            const LoadArchivedLocalAdsRequested(
              adType: AdType.interstitial,
              limit: kDefaultRowsPerPage,
            ),
          );
          add(
            const LoadArchivedLocalAdsRequested(
              adType: AdType.video,
              limit: kDefaultRowsPerPage,
            ),
          );
        });
  }

  final DataRepository<LocalAd> _localAdsRepository;
  late final StreamSubscription<Type> _localAdUpdateSubscription;
  Timer? _deleteTimer;

  @override
  Future<void> close() {
    _localAdUpdateSubscription.cancel();
    _deleteTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoadArchivedLocalAdsRequested(
    LoadArchivedLocalAdsRequested event,
    Emitter<ArchivedLocalAdsState> emit,
  ) async {
    // Determine current state and emit loading status
    switch (event.adType) {
      case AdType.native:
        emit(state.copyWith(nativeAdsStatus: ArchivedLocalAdsStatus.loading));
      case AdType.banner:
        emit(state.copyWith(bannerAdsStatus: ArchivedLocalAdsStatus.loading));
      case AdType.interstitial:
        emit(
          state.copyWith(
            interstitialAdsStatus: ArchivedLocalAdsStatus.loading,
          ),
        );
      case AdType.video:
        emit(state.copyWith(videoAdsStatus: ArchivedLocalAdsStatus.loading));
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
          final previousAds = isPaginating ? state.nativeAds : <LocalNativeAd>[];
          emit(
            state.copyWith(
              nativeAdsStatus: ArchivedLocalAdsStatus.success,
              nativeAds: [
                ...previousAds,
                ...paginatedAds.items.cast<LocalNativeAd>(),
              ],
              nativeAdsCursor: paginatedAds.cursor,
              nativeAdsHasMore: paginatedAds.hasMore,
            ),
          );
        case AdType.banner:
          final previousAds = isPaginating ? state.bannerAds : <LocalBannerAd>[];
          emit(
            state.copyWith(
              bannerAdsStatus: ArchivedLocalAdsStatus.success,
              bannerAds: [
                ...previousAds,
                ...paginatedAds.items.cast<LocalBannerAd>(),
              ],
              bannerAdsCursor: paginatedAds.cursor,
              bannerAdsHasMore: paginatedAds.hasMore,
            ),
          );
        case AdType.interstitial:
          final previousAds =
              isPaginating ? state.interstitialAds : <LocalInterstitialAd>[];
          emit(
            state.copyWith(
              interstitialAdsStatus: ArchivedLocalAdsStatus.success,
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
              videoAdsStatus: ArchivedLocalAdsStatus.success,
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
              nativeAdsStatus: ArchivedLocalAdsStatus.failure,
              exception: e,
            ),
          );
        case AdType.banner:
          emit(
            state.copyWith(
              bannerAdsStatus: ArchivedLocalAdsStatus.failure,
              exception: e,
            ),
          );
        case AdType.interstitial:
          emit(
            state.copyWith(
              interstitialAdsStatus: ArchivedLocalAdsStatus.failure,
              exception: e,
            ),
          );
        case AdType.video:
          emit(
            state.copyWith(
              videoAdsStatus: ArchivedLocalAdsStatus.failure,
              exception: e,
            ),
          );
      }
    } catch (e) {
      switch (event.adType) {
        case AdType.native:
          emit(
            state.copyWith(
              nativeAdsStatus: ArchivedLocalAdsStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
        case AdType.banner:
          emit(
            state.copyWith(
              bannerAdsStatus: ArchivedLocalAdsStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
        case AdType.interstitial:
          emit(
            state.copyWith(
              interstitialAdsStatus: ArchivedLocalAdsStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
        case AdType.video:
          emit(
            state.copyWith(
              videoAdsStatus: ArchivedLocalAdsStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
      }
    }
  }

  Future<void> _onRestoreLocalAdRequested(
    RestoreLocalAdRequested event,
    Emitter<ArchivedLocalAdsState> emit,
  ) async {
    LocalAd? adToRestore;
    final originalNativeAds = List<LocalNativeAd>.from(state.nativeAds);
    final originalBannerAds = List<LocalBannerAd>.from(state.bannerAds);
    final originalInterstitialAds =
        List<LocalInterstitialAd>.from(state.interstitialAds);
    final originalVideoAds = List<LocalVideoAd>.from(state.videoAds);

    switch (event.adType) {
      case AdType.native:
        final index = originalNativeAds.indexWhere((ad) => ad.id == event.id);
        if (index == -1) return;
        adToRestore = originalNativeAds[index];
        originalNativeAds.removeAt(index);
        emit(state.copyWith(nativeAds: originalNativeAds));
      case AdType.banner:
        final index = originalBannerAds.indexWhere((ad) => ad.id == event.id);
        if (index == -1) return;
        adToRestore = originalBannerAds[index];
        originalBannerAds.removeAt(index);
        emit(state.copyWith(bannerAds: originalBannerAds));
      case AdType.interstitial:
        final index =
            originalInterstitialAds.indexWhere((ad) => ad.id == event.id);
        if (index == -1) return;
        adToRestore = originalInterstitialAds[index];
        originalInterstitialAds.removeAt(index);
        emit(state.copyWith(interstitialAds: originalInterstitialAds));
      case AdType.video:
        final index = originalVideoAds.indexWhere((ad) => ad.id == event.id);
        if (index == -1) return;
        adToRestore = originalVideoAds[index];
        originalVideoAds.removeAt(index);
        emit(state.copyWith(videoAds: originalVideoAds));
    }

    try {
      await _localAdsRepository.update(
        id: event.id,
        item: adToRestore.copyWith(status: ContentStatus.active),
      );
      // The entityUpdated stream will trigger a reload of active ads.
    } on HttpException catch (e) {
      // Revert UI on failure
      switch (event.adType) {
        case AdType.native:
          emit(state.copyWith(nativeAds: originalNativeAds));
        case AdType.banner:
          emit(state.copyWith(bannerAds: originalBannerAds));
        case AdType.interstitial:
          emit(state.copyWith(interstitialAds: originalInterstitialAds));
        case AdType.video:
          emit(state.copyWith(videoAds: originalVideoAds));
      }
      emit(state.copyWith(exception: e));
    } catch (e) {
      switch (event.adType) {
        case AdType.native:
          emit(state.copyWith(nativeAds: originalNativeAds));
        case AdType.banner:
          emit(state.copyWith(bannerAds: originalBannerAds));
        case AdType.interstitial:
          emit(state.copyWith(interstitialAds: originalInterstitialAds));
        case AdType.video:
          emit(state.copyWith(videoAds: originalVideoAds));
      }
      emit(state.copyWith(exception: UnknownException('An unexpected error occurred: $e')));
    }
  }

  Future<void> _onDeleteLocalAdForeverRequested(
    DeleteLocalAdForeverRequested event,
    Emitter<ArchivedLocalAdsState> emit,
  ) async {
    _deleteTimer?.cancel();

    LocalAd? adToDelete;
    final var currentNativeAds = List<LocalNativeAd>.from(state.nativeAds);
    final var currentBannerAds = List<LocalBannerAd>.from(state.bannerAds);
    final currentInterstitialAds =
        List<LocalInterstitialAd>.from(state.interstitialAds);
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

    emit(state.copyWith(lastDeletedLocalAd: adToDelete));

    _deleteTimer = Timer(
      const Duration(seconds: 5),
      () => add(_ConfirmDeleteLocalAdRequested(event.id, event.adType)),
    );
  }

  Future<void> _onConfirmDeleteLocalAdRequested(
    _ConfirmDeleteLocalAdRequested event,
    Emitter<ArchivedLocalAdsState> emit,
  ) async {
    try {
      await _localAdsRepository.delete(id: event.id);
      emit(state.copyWith(clearLastDeletedLocalAd: true));
    } on HttpException catch (e) {
      // If deletion fails, restore the ad to the list
      if (state.lastDeletedLocalAd != null) {
        final restoredAd = state.lastDeletedLocalAd!;
        switch (restoredAd.adType) {
          case 'native':
            final updatedAds = List<LocalNativeAd>.from(state.nativeAds)
              ..add(restoredAd as LocalNativeAd);
            emit(state.copyWith(nativeAds: updatedAds));
          case 'banner':
            final updatedAds = List<LocalBannerAd>.from(state.bannerAds)
              ..add(restoredAd as LocalBannerAd);
            emit(state.copyWith(bannerAds: updatedAds));
          case 'interstitial':
            final updatedAds = List<LocalInterstitialAd>.from(state.interstitialAds)
              ..add(restoredAd as LocalInterstitialAd);
            emit(state.copyWith(interstitialAds: updatedAds));
          case 'video':
            final updatedAds = List<LocalVideoAd>.from(state.videoAds)
              ..add(restoredAd as LocalVideoAd);
            emit(state.copyWith(videoAds: updatedAds));
        }
      }
      emit(state.copyWith(exception: e, clearLastDeletedLocalAd: true));
    } catch (e) {
      if (state.lastDeletedLocalAd != null) {
        final restoredAd = state.lastDeletedLocalAd!;
        switch (restoredAd.adType) {
          case 'native':
            final updatedAds = List<LocalNativeAd>.from(state.nativeAds)
              ..add(restoredAd as LocalNativeAd);
            emit(state.copyWith(nativeAds: updatedAds));
          case 'banner':
            final updatedAds = List<LocalBannerAd>.from(state.bannerAds)
              ..add(restoredAd as LocalBannerAd);
            emit(state.copyWith(bannerAds: updatedAds));
          case 'interstitial':
            final updatedAds = List<LocalInterstitialAd>.from(state.interstitialAds)
              ..add(restoredAd as LocalInterstitialAd);
            emit(state.copyWith(interstitialAds: updatedAds));
          case 'video':
            final updatedAds = List<LocalVideoAd>.from(state.videoAds)
              ..add(restoredAd as LocalVideoAd);
            emit(state.copyWith(videoAds: updatedAds));
        }
      }
      emit(
        state.copyWith(
          exception: UnknownException('An unexpected error occurred: $e'),
          clearLastDeletedLocalAd: true,
        ),
      );
    }
  }

  void _onUndoDeleteLocalAdRequested(
    UndoDeleteLocalAdRequested event,
    Emitter<ArchivedLocalAdsState> emit,
  ) {
    _deleteTimer?.cancel();
    if (state.lastDeletedLocalAd != null) {
      final restoredAd = state.lastDeletedLocalAd!;
      switch (restoredAd.adType) {
        case 'native':
          final updatedAds = List<LocalNativeAd>.from(state.nativeAds)
            ..insert(0, restoredAd as LocalNativeAd); // Insert at beginning for simplicity
          emit(
            state.copyWith(
              nativeAds: updatedAds,
              clearLastDeletedLocalAd: true,
            ),
          );
        case 'banner':
          final updatedAds = List<LocalBannerAd>.from(state.bannerAds)
            ..insert(0, restoredAd as LocalBannerAd);
          emit(
            state.copyWith(
              bannerAds: updatedAds,
              clearLastDeletedLocalAd: true,
            ),
          );
        case 'interstitial':
          final updatedAds = List<LocalInterstitialAd>.from(state.interstitialAds)
            ..insert(0, restoredAd as LocalInterstitialAd);
          emit(
            state.copyWith(
              interstitialAds: updatedAds,
              clearLastDeletedLocalAd: true,
            ),
          );
        case 'video':
          final updatedAds = List<LocalVideoAd>.from(state.videoAds)
            ..insert(0, restoredAd as LocalVideoAd);
          emit(
            state.copyWith(
              videoAds: updatedAds,
              clearLastDeletedLocalAd: true,
            ),
          );
      }
    }
  }
}
