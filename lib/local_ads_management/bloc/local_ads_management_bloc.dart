import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:ui_kit/ui_kit.dart';

part 'local_ads_management_event.dart';
part 'local_ads_management_state.dart';

class LocalAdsManagementBloc
    extends Bloc<LocalAdsManagementEvent, LocalAdsManagementState> {
  LocalAdsManagementBloc({
    required DataRepository<LocalAd> localAdsRepository,
  }) : _localAdsRepository = localAdsRepository,
       super(const LocalAdsManagementState()) {
    on<LocalAdsManagementTabChanged>(_onLocalAdsManagementTabChanged);
    on<LoadLocalAdsRequested>(_onLoadLocalAdsRequested);
    on<ArchiveLocalAdRequested>(_onArchiveLocalAdRequested);
    on<RestoreLocalAdRequested>(_onRestoreLocalAdRequested);
    on<DeleteLocalAdForeverRequested>(_onDeleteLocalAdForeverRequested);
    on<UndoDeleteLocalAdRequested>(_onUndoDeleteLocalAdRequested);
    on<_ConfirmDeleteLocalAdRequested>(_onConfirmDeleteLocalAdRequested);

    _localAdUpdateSubscription = _localAdsRepository.entityUpdated
        .where((type) => type == LocalAd)
        .listen((_) {
          add(
            const LoadLocalAdsRequested(
              adType: AdType.native,
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
            ),
          );
          add(
            const LoadLocalAdsRequested(
              adType: AdType.banner,
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
            ),
          );
          add(
            const LoadLocalAdsRequested(
              adType: AdType.interstitial,
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
            ),
          );
          add(
            const LoadLocalAdsRequested(
              adType: AdType.video,
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
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

  void _onLocalAdsManagementTabChanged(
    LocalAdsManagementTabChanged event,
    Emitter<LocalAdsManagementState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
  }

  Future<void> _onLoadLocalAdsRequested(
    LoadLocalAdsRequested event,
    Emitter<LocalAdsManagementState> emit,
  ) async {
    // Determine current state and emit loading status
    switch (event.adType) {
      case AdType.native:
        if (state.nativeAdsStatus == LocalAdsManagementStatus.success &&
            state.nativeAds.isNotEmpty &&
            event.startAfterId == null &&
            !event.forceRefresh) {
          return;
        }
        emit(state.copyWith(nativeAdsStatus: LocalAdsManagementStatus.loading));
      case AdType.banner:
        if (state.bannerAdsStatus == LocalAdsManagementStatus.success &&
            state.bannerAds.isNotEmpty &&
            event.startAfterId == null &&
            !event.forceRefresh) {
          return;
        }
        emit(state.copyWith(bannerAdsStatus: LocalAdsManagementStatus.loading));
      case AdType.interstitial:
        if (state.interstitialAdsStatus == LocalAdsManagementStatus.success &&
            state.interstitialAds.isNotEmpty &&
            event.startAfterId == null &&
            !event.forceRefresh) {
          return;
        }
        emit(
          state.copyWith(
            interstitialAdsStatus: LocalAdsManagementStatus.loading,
          ),
        );
      case AdType.video:
        if (state.videoAdsStatus == LocalAdsManagementStatus.success &&
            state.videoAds.isNotEmpty &&
            event.startAfterId == null &&
            !event.forceRefresh) {
          return;
        }
        emit(state.copyWith(videoAdsStatus: LocalAdsManagementStatus.loading));
    }

    try {
      final isPaginating = event.startAfterId != null;
      final paginatedAds = await _localAdsRepository.readAll(
        filter: {
          'adType': event.adType.name,
          'status': ContentStatus.active.name,
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
              nativeAdsStatus: LocalAdsManagementStatus.success,
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
              bannerAdsStatus: LocalAdsManagementStatus.success,
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
              interstitialAdsStatus: LocalAdsManagementStatus.success,
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
              videoAdsStatus: LocalAdsManagementStatus.success,
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
              nativeAdsStatus: LocalAdsManagementStatus.failure,
              exception: e,
            ),
          );
        case AdType.banner:
          emit(
            state.copyWith(
              bannerAdsStatus: LocalAdsManagementStatus.failure,
              exception: e,
            ),
          );
        case AdType.interstitial:
          emit(
            state.copyWith(
              interstitialAdsStatus: LocalAdsManagementStatus.failure,
              exception: e,
            ),
          );
        case AdType.video:
          emit(
            state.copyWith(
              videoAdsStatus: LocalAdsManagementStatus.failure,
              exception: e,
            ),
          );
      }
    } catch (e) {
      switch (event.adType) {
        case AdType.native:
          emit(
            state.copyWith(
              nativeAdsStatus: LocalAdsManagementStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
        case AdType.banner:
          emit(
            state.copyWith(
              bannerAdsStatus: LocalAdsManagementStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
        case AdType.interstitial:
          emit(
            state.copyWith(
              interstitialAdsStatus: LocalAdsManagementStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
        case AdType.video:
          emit(
            state.copyWith(
              videoAdsStatus: LocalAdsManagementStatus.failure,
              exception: UnknownException('An unexpected error occurred: $e'),
            ),
          );
      }
    }
  }

  Future<void> _onArchiveLocalAdRequested(
    ArchiveLocalAdRequested event,
    Emitter<LocalAdsManagementState> emit,
  ) async {
    LocalAd? adToArchive;
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
        adToArchive = originalNativeAds[index];
        originalNativeAds.removeAt(index);
        emit(state.copyWith(nativeAds: originalNativeAds));
      case AdType.banner:
        final index = originalBannerAds.indexWhere((ad) => ad.id == event.id);
        if (index == -1) return;
        adToArchive = originalBannerAds[index];
        originalBannerAds.removeAt(index);
        emit(state.copyWith(bannerAds: originalBannerAds));
      case AdType.interstitial:
        final index = originalInterstitialAds.indexWhere(
          (ad) => ad.id == event.id,
        );
        if (index == -1) return;
        adToArchive = originalInterstitialAds[index];
        originalInterstitialAds.removeAt(index);
        emit(state.copyWith(interstitialAds: originalInterstitialAds));
      case AdType.video:
        final index = originalVideoAds.indexWhere((ad) => ad.id == event.id);
        if (index == -1) return;
        adToArchive = originalVideoAds[index];
        originalVideoAds.removeAt(index);
        emit(state.copyWith(videoAds: originalVideoAds));
    }

    try {
      final updatedAd = switch (adToArchive) {
        final LocalNativeAd ad => ad.copyWith(status: ContentStatus.archived),
        final LocalBannerAd ad => ad.copyWith(status: ContentStatus.archived),
        final LocalInterstitialAd ad => ad.copyWith(
          status: ContentStatus.archived,
        ),
        final LocalVideoAd ad => ad.copyWith(status: ContentStatus.archived),
        _ => throw StateError(
          'Unknown LocalAd type: ${adToArchive.runtimeType}',
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
      emit(
        state.copyWith(
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onRestoreLocalAdRequested(
    RestoreLocalAdRequested event,
    Emitter<LocalAdsManagementState> emit,
  ) async {
    // This event is primarily for the archived ads page, but the bloc
    // needs to know about it to trigger a refresh of the active lists.
    // The actual UI update for the archived list will be handled by the
    // ArchivedLocalAdsBloc.
    try {
      // Fetch the ad to restore (it's currently archived)
      final adToRestore = await _localAdsRepository.read(id: event.id);
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
      // The entityUpdated stream will trigger a reload of active ads.
    } on HttpException catch (e) {
      emit(state.copyWith(exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _onDeleteLocalAdForeverRequested(
    DeleteLocalAdForeverRequested event,
    Emitter<LocalAdsManagementState> emit,
  ) async {
    _deleteTimer?.cancel();

    LocalAd? adToDelete;
    final currentNativeAds = List<LocalNativeAd>.from(state.nativeAds);
    final currentBannerAds = List<LocalBannerAd>.from(state.bannerAds);
    final currentInterstitialAds = List<LocalInterstitialAd>.from(
      state.interstitialAds,
    );
    final currentVideoAds = List<LocalVideoAd>.from(state.videoAds);

    // Find and remove the ad from the current active list
    var index = -1;
    if (state.activeTab == LocalAdsManagementTab.native) {
      index = currentNativeAds.indexWhere((ad) => ad.id == event.id);
      if (index != -1) adToDelete = currentNativeAds[index];
    } else if (state.activeTab == LocalAdsManagementTab.banner) {
      index = currentBannerAds.indexWhere((ad) => ad.id == event.id);
      if (index != -1) adToDelete = currentBannerAds[index];
    } else if (state.activeTab == LocalAdsManagementTab.interstitial) {
      index = currentInterstitialAds.indexWhere((ad) => ad.id == event.id);
      if (index != -1) adToDelete = currentInterstitialAds[index];
    } else if (state.activeTab == LocalAdsManagementTab.video) {
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
      () => add(_ConfirmDeleteLocalAdRequested(event.id)),
    );
  }

  Future<void> _onConfirmDeleteLocalAdRequested(
    _ConfirmDeleteLocalAdRequested event,
    Emitter<LocalAdsManagementState> emit,
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
            final updatedAds = List<LocalInterstitialAd>.from(
              state.interstitialAds,
            )..add(restoredAd as LocalInterstitialAd);
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
            final updatedAds = List<LocalInterstitialAd>.from(
              state.interstitialAds,
            )..add(restoredAd as LocalInterstitialAd);
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
    Emitter<LocalAdsManagementState> emit,
  ) {
    _deleteTimer?.cancel();
    if (state.lastDeletedLocalAd != null) {
      final restoredAd = state.lastDeletedLocalAd!;
      switch (restoredAd.adType) {
        case 'native':
          final updatedAds = List<LocalNativeAd>.from(state.nativeAds)
            ..insert(
              0,
              restoredAd as LocalNativeAd,
            );
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
          final updatedAds = List<LocalInterstitialAd>.from(
            state.interstitialAds,
          )..insert(0, restoredAd as LocalInterstitialAd);
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
