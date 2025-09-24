part of 'archive_local_ads_bloc.dart';

/// Represents the status of archived local ad operations.
enum ArchiveLocalAdsStatus {
  initial,
  loading,
  success,
  failure,
}

/// Defines the state for the archived local ads feature.
class ArchiveLocalAdsState extends Equatable {
  const ArchiveLocalAdsState({
    this.status = ArchiveLocalAdsStatus.initial,
    this.nativeAdsStatus = ArchiveLocalAdsStatus.initial,
    this.nativeAds = const [],
    this.nativeAdsCursor,
    this.nativeAdsHasMore = false,
    this.bannerAdsStatus = ArchiveLocalAdsStatus.initial,
    this.bannerAds = const [],
    this.bannerAdsCursor,
    this.bannerAdsHasMore = false,
    this.interstitialAdsStatus = ArchiveLocalAdsStatus.initial,
    this.interstitialAds = const [],
    this.interstitialAdsCursor,
    this.interstitialAdsHasMore = false,
    this.videoAdsStatus = ArchiveLocalAdsStatus.initial,
    this.videoAds = const [],
    this.videoAdsCursor,
    this.videoAdsHasMore = false,
    this.exception,
    this.lastPendingDeletionId,
    this.snackbarLocalAdTitle,
  });

  final ArchiveLocalAdsStatus status;

  /// Status for native ads loading.
  final ArchiveLocalAdsStatus nativeAdsStatus;

  /// List of archived native ads.
  final List<LocalNativeAd> nativeAds;

  /// Cursor for native ad pagination.
  final String? nativeAdsCursor;

  /// Indicates if there are more native ads to load.
  final bool nativeAdsHasMore;

  /// Status for banner ads loading.
  final ArchiveLocalAdsStatus bannerAdsStatus;

  /// List of archived banner ads.
  final List<LocalBannerAd> bannerAds;

  /// Cursor for banner ad pagination.
  final String? bannerAdsCursor;

  /// Indicates if there are more banner ads to load.
  final bool bannerAdsHasMore;

  /// Status for interstitial ads loading.
  final ArchiveLocalAdsStatus interstitialAdsStatus;

  /// List of archived interstitial ads.
  final List<LocalInterstitialAd> interstitialAds;

  /// Cursor for interstitial ad pagination.
  final String? interstitialAdsCursor;

  /// Indicates if there are more interstitial ads to load.
  final bool interstitialAdsHasMore;

  /// Status for video ads loading.
  final ArchiveLocalAdsStatus videoAdsStatus;

  /// List of archived video ads.
  final List<LocalVideoAd> videoAds;

  /// Cursor for video ad pagination.
  final String? videoAdsCursor;

  /// Indicates if there are more video ads to load.
  final bool videoAdsHasMore;

  /// The error describing an operation failure, if any.
  final HttpException? exception;

  /// The ID of the local ad that was most recently added to pending deletions.
  /// Used to trigger the snackbar display.
  final String? lastPendingDeletionId;

  /// The title of the local ad for which the snackbar should be displayed.
  /// This is set when a deletion is requested and cleared when the snackbar
  /// is no longer needed.
  final String? snackbarLocalAdTitle;

  ArchiveLocalAdsState copyWith({
    ArchiveLocalAdsStatus? status,
    ArchiveLocalAdsStatus? nativeAdsStatus,
    List<LocalNativeAd>? nativeAds,
    String? nativeAdsCursor,
    bool? nativeAdsHasMore,
    ArchiveLocalAdsStatus? bannerAdsStatus,
    List<LocalBannerAd>? bannerAds,
    String? bannerAdsCursor,
    bool? bannerAdsHasMore,
    ArchiveLocalAdsStatus? interstitialAdsStatus,
    List<LocalInterstitialAd>? interstitialAds,
    String? interstitialAdsCursor,
    bool? interstitialAdsHasMore,
    ArchiveLocalAdsStatus? videoAdsStatus,
    List<LocalVideoAd>? videoAds,
    String? videoAdsCursor,
    bool? videoAdsHasMore,
    HttpException? exception,
    String? lastPendingDeletionId,
    String? snackbarLocalAdTitle,
  }) {
    return ArchiveLocalAdsState(
      status: status ?? this.status,
      nativeAdsStatus: nativeAdsStatus ?? this.nativeAdsStatus,
      nativeAds: nativeAds ?? this.nativeAds,
      nativeAdsCursor: nativeAdsCursor ?? this.nativeAdsCursor,
      nativeAdsHasMore: nativeAdsHasMore ?? this.nativeAdsHasMore,
      bannerAdsStatus: bannerAdsStatus ?? this.bannerAdsStatus,
      bannerAds: bannerAds ?? this.bannerAds,
      bannerAdsCursor: bannerAdsCursor ?? this.bannerAdsCursor,
      bannerAdsHasMore: bannerAdsHasMore ?? this.bannerAdsHasMore,
      interstitialAdsStatus:
          interstitialAdsStatus ?? this.interstitialAdsStatus,
      interstitialAds: interstitialAds ?? this.interstitialAds,
      interstitialAdsCursor:
          interstitialAdsCursor ?? this.interstitialAdsCursor,
      interstitialAdsHasMore:
          interstitialAdsHasMore ?? this.interstitialAdsHasMore,
      videoAdsStatus: videoAdsStatus ?? this.videoAdsStatus,
      videoAds: videoAds ?? this.videoAds,
      videoAdsCursor: videoAdsCursor ?? this.videoAdsCursor,
      videoAdsHasMore: videoAdsHasMore ?? this.videoAdsHasMore,
      exception: exception,
      lastPendingDeletionId:
          lastPendingDeletionId ?? this.lastPendingDeletionId,
      snackbarLocalAdTitle: snackbarLocalAdTitle,
    );
  }

  @override
  List<Object?> get props => [
    status,
    nativeAdsStatus,
    nativeAds,
    nativeAdsCursor,
    nativeAdsHasMore,
    bannerAdsStatus,
    bannerAds,
    bannerAdsCursor,
    bannerAdsHasMore,
    interstitialAdsStatus,
    interstitialAds,
    interstitialAdsCursor,
    interstitialAdsHasMore,
    videoAdsStatus,
    videoAds,
    videoAdsCursor,
    videoAdsHasMore,
    exception,
    lastPendingDeletionId,
    snackbarLocalAdTitle,
  ];
}
