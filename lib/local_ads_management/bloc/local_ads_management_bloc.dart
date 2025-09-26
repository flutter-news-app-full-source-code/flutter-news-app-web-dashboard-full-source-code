import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/filter_local_ads/filter_local_ads_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/string_truncate.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart';
import 'package:ui_kit/ui_kit.dart';

part 'local_ads_management_event.dart';
part 'local_ads_management_state.dart';

class LocalAdsManagementBloc
    extends Bloc<LocalAdsManagementEvent, LocalAdsManagementState> {
  LocalAdsManagementBloc({
    required DataRepository<LocalAd> localAdsRepository,
    required FilterLocalAdsBloc filterLocalAdsBloc,
    required PendingDeletionsService pendingDeletionsService,
  }) : _localAdsRepository = localAdsRepository,
       _filterLocalAdsBloc = filterLocalAdsBloc,
       _pendingDeletionsService = pendingDeletionsService,
       super(const LocalAdsManagementState()) {
    on<LocalAdsManagementTabChanged>(_onLocalAdsManagementTabChanged);
    on<LoadLocalAdsRequested>(_onLoadLocalAdsRequested);
    on<ArchiveLocalAdRequested>(_onArchiveLocalAdRequested);
    on<RestoreLocalAdRequested>(_onRestoreLocalAdRequested);
    on<DeleteLocalAdForeverRequested>(_onDeleteLocalAdForeverRequested);
    on<UndoDeleteLocalAdRequested>(_onUndoDeleteLocalAdRequested);
    on<DeletionEventReceived>(_onDeletionEventReceived);

    _localAdUpdateSubscription = _localAdsRepository.entityUpdated
        .where((type) => type == LocalAd)
        .listen((_) {
          add(
            LoadLocalAdsRequested(
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
              filter: buildLocalAdsFilterMap(_filterLocalAdsBloc.state),
            ),
          );
        });

    _filterLocalAdsSubscription = _filterLocalAdsBloc.stream.listen((_) {
      add(
        LoadLocalAdsRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildLocalAdsFilterMap(_filterLocalAdsBloc.state),
        ),
      );
    });

    _deletionEventsSubscription = _pendingDeletionsService.deletionEvents
        .listen(
          (event) => add(DeletionEventReceived(event)),
        );
  }

  final DataRepository<LocalAd> _localAdsRepository;
  final FilterLocalAdsBloc _filterLocalAdsBloc;
  final PendingDeletionsService _pendingDeletionsService;

  late final StreamSubscription<Type> _localAdUpdateSubscription;
  late final StreamSubscription<FilterLocalAdsState>
  _filterLocalAdsSubscription;
  late final StreamSubscription<DeletionEvent<dynamic>>
  _deletionEventsSubscription;

  @override
  Future<void> close() {
    _localAdUpdateSubscription.cancel();
    _filterLocalAdsSubscription.cancel();
    _deletionEventsSubscription.cancel();
    return super.close();
  }

  /// Builds a filter map for local ads from the given filter state.
  Map<String, dynamic> buildLocalAdsFilterMap(FilterLocalAdsState state) {
    final filter = <String, dynamic>{};

    if (state.searchQuery.isNotEmpty) {
      filter[r'$or'] = [
        {
          'title': {r'$regex': state.searchQuery, r'$options': 'i'},
        },
        {
          'imageUrl': {r'$regex': state.searchQuery, r'$options': 'i'},
        },
        {
          'videoUrl': {r'$regex': state.searchQuery, r'$options': 'i'},
        },
      ];
    }

    filter['status'] = state.selectedStatus.name;
    filter['adType'] = state.selectedAdType.name;

    return filter;
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
    final currentFilterAdType = _filterLocalAdsBloc.state.selectedAdType;

    switch (currentFilterAdType) {
      case AdType.native:
        if (state.nativeAdsStatus == LocalAdsManagementStatus.success &&
            state.nativeAds.isNotEmpty &&
            event.startAfterId == null &&
            !event.forceRefresh &&
            event.filter == null) {
          return;
        }
        emit(state.copyWith(nativeAdsStatus: LocalAdsManagementStatus.loading));
      case AdType.banner:
        if (state.bannerAdsStatus == LocalAdsManagementStatus.success &&
            state.bannerAds.isNotEmpty &&
            event.startAfterId == null &&
            !event.forceRefresh &&
            event.filter == null) {
          return;
        }
        emit(state.copyWith(bannerAdsStatus: LocalAdsManagementStatus.loading));
      case AdType.interstitial:
        if (state.interstitialAdsStatus == LocalAdsManagementStatus.success &&
            state.interstitialAds.isNotEmpty &&
            event.startAfterId == null &&
            !event.forceRefresh &&
            event.filter == null) {
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
            !event.forceRefresh &&
            event.filter == null) {
          return;
        }
        emit(state.copyWith(videoAdsStatus: LocalAdsManagementStatus.loading));
    }

    try {
      final isPaginating = event.startAfterId != null;
      final paginatedAds = await _localAdsRepository.readAll(
        filter:
            event.filter ?? buildLocalAdsFilterMap(_filterLocalAdsBloc.state),
        sort: [const SortOption('updatedAt', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );

      switch (currentFilterAdType) {
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
              exception: null,
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
              exception: null,
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
              exception: null,
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
              exception: null,
            ),
          );
      }
    } on HttpException catch (e) {
      switch (currentFilterAdType) {
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
      switch (currentFilterAdType) {
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
    try {
      final adToUpdate = await _localAdsRepository.read(id: event.id);
      final updatedAd = switch (adToUpdate) {
        final LocalNativeAd ad => ad.copyWith(status: ContentStatus.archived),
        final LocalBannerAd ad => ad.copyWith(status: ContentStatus.archived),
        final LocalInterstitialAd ad => ad.copyWith(
          status: ContentStatus.archived,
        ),
        final LocalVideoAd ad => ad.copyWith(status: ContentStatus.archived),
        _ => throw StateError(
          'Unknown LocalAd type: ${adToUpdate.runtimeType}',
        ),
      };
      await _localAdsRepository.update(
        id: event.id,
        item: updatedAd,
      );
      emit(
        state.copyWith(
          snackbarMessage: 'Ad archived successfully.',
          exception: null,
        ),
      );
      // Explicitly trigger a refresh after archiving
      add(
        LoadLocalAdsRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildLocalAdsFilterMap(_filterLocalAdsBloc.state),
        ),
      );
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

  Future<void> _onRestoreLocalAdRequested(
    RestoreLocalAdRequested event,
    Emitter<LocalAdsManagementState> emit,
  ) async {
    try {
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
      emit(
        state.copyWith(
          snackbarMessage: 'Ad restored successfully.',
          exception: null,
        ),
      );
      // Explicitly trigger a refresh after restoring
      add(
        LoadLocalAdsRequested(
          limit: kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildLocalAdsFilterMap(_filterLocalAdsBloc.state),
        ),
      );
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
    LocalAd? adToDelete;
    // Find the ad to delete from the current active list based on the active tab
    switch (state.activeTab) {
      case LocalAdsManagementTab.native:
        adToDelete = state.nativeAds.firstWhereOrNull(
          (ad) => ad.id == event.id,
        );
      case LocalAdsManagementTab.banner:
        adToDelete = state.bannerAds.firstWhereOrNull(
          (ad) => ad.id == event.id,
        );
      case LocalAdsManagementTab.interstitial:
        adToDelete = state.interstitialAds.firstWhereOrNull(
          (ad) => ad.id == event.id,
        );
      case LocalAdsManagementTab.video:
        adToDelete = state.videoAds.firstWhereOrNull((ad) => ad.id == event.id);
    }

    if (adToDelete == null) return;

    // Optimistically remove from UI
    switch (adToDelete.adType) {
      case 'native':
        final updatedAds = List<LocalNativeAd>.from(state.nativeAds)
          ..removeWhere((ad) => ad.id == event.id);
        emit(state.copyWith(nativeAds: updatedAds));
      case 'banner':
        final updatedAds = List<LocalBannerAd>.from(state.bannerAds)
          ..removeWhere((ad) => ad.id == event.id);
        emit(state.copyWith(bannerAds: updatedAds));
      case 'interstitial':
        final updatedAds = List<LocalInterstitialAd>.from(state.interstitialAds)
          ..removeWhere((ad) => ad.id == event.id);
        emit(state.copyWith(interstitialAds: updatedAds));
      case 'video':
        final updatedAds = List<LocalVideoAd>.from(state.videoAds)
          ..removeWhere((ad) => ad.id == event.id);
        emit(state.copyWith(videoAds: updatedAds));
    }

    emit(
      state.copyWith(
        snackbarMessage: 'Ad "${adToDelete.id.truncate(30)}" deleted.',
        exception: null,
      ),
    );

    _pendingDeletionsService.requestDeletion(
      item: adToDelete,
      repository: _localAdsRepository,
      undoDuration: AppConstants.kSnackbarDuration,
    );
  }

  void _onUndoDeleteLocalAdRequested(
    UndoDeleteLocalAdRequested event,
    Emitter<LocalAdsManagementState> emit,
  ) {
    _pendingDeletionsService.undoDeletion(event.id);
  }

  /// Handles deletion events from the [PendingDeletionsService].
  ///
  /// This method is responsible for updating the BLoC state based on whether
  /// a deletion was confirmed or undone.
  Future<void> _onDeletionEventReceived(
    DeletionEventReceived event,
    Emitter<LocalAdsManagementState> emit,
  ) async {
    switch (event.event.status) {
      case DeletionStatus.confirmed:
        // If deletion is confirmed, clear pending status.
        // The item was already optimistically removed from the list.
        emit(
          state.copyWith(
            snackbarMessage: null,
            exception: null,
          ),
        );
      case DeletionStatus.undone:
        // If deletion is undone, re-add the item to the appropriate list.
        final item = event.event.item;
        if (item is LocalNativeAd) {
          final updatedAds = List<LocalNativeAd>.from(state.nativeAds)
            ..add(item)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          emit(
            state.copyWith(
              nativeAds: updatedAds,
              snackbarMessage: null,
              exception: null,
            ),
          );
        } else if (item is LocalBannerAd) {
          final updatedAds = List<LocalBannerAd>.from(state.bannerAds)
            ..add(item)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          emit(
            state.copyWith(
              bannerAds: updatedAds,
              snackbarMessage: null,
              exception: null,
            ),
          );
        } else if (item is LocalInterstitialAd) {
          final updatedAds =
              List<LocalInterstitialAd>.from(state.interstitialAds)
                ..add(item)
                ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          emit(
            state.copyWith(
              interstitialAds: updatedAds,
              snackbarMessage: null,
              exception: null,
            ),
          );
        } else if (item is LocalVideoAd) {
          final updatedAds = List<LocalVideoAd>.from(state.videoAds)
            ..add(item)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          emit(
            state.copyWith(
              videoAds: updatedAds,
              snackbarMessage: null,
              exception: null,
            ),
          );
        }
    }
  }
}
