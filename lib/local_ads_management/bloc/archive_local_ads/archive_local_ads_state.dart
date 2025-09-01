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
    this.nativeAds = const [],
    this.nativeAdsCursor,
    this.nativeAdsHasMore = false,
    this.bannerAds = const [],
    this.bannerAdsCursor,
    this.bannerAdsHasMore = false,
    this.interstitialAds = const [],
    this.interstitialAdsCursor,
    this.interstitialAdsHasMore = false,
    this.videoAds = const [],
    this.videoAdsCursor,
    this.videoAdsHasMore = false,
    this.exception,
    this.lastDeletedLocalAd,
  });

  final ArchiveLocalAdsStatus status;

  /// List of archived native ads.
  final List<LocalNativeAd> nativeAds;

  /// Cursor for native ad pagination.
  final String? nativeAdsCursor;

  /// Indicates if there are more native ads to load.
  final bool nativeAdsHasMore;

  /// List of archived banner ads.
  final List<LocalBannerAd> bannerAds;

  /// Cursor for banner ad pagination.
  final String? bannerAdsCursor;

  /// Indicates if there are more banner ads to load.
  final bool bannerAdsHasMore;

  /// List of archived interstitial ads.
  final List<LocalInterstitialAd> interstitialAds;

  /// Cursor for interstitial ad pagination.
  final String? interstitialAdsCursor;

  /// Indicates if there are more interstitial ads to load.
  final bool interstitialAdsHasMore;

  /// List of archived video ads.
  final List<LocalVideoAd> videoAds;

  /// Cursor for video ad pagination.
  final String? videoAdsCursor;

  /// Indicates if there are more video ads to load.
  final bool videoAdsHasMore;

  /// The error describing an operation failure, if any.
  final HttpException? exception;

  /// The last deleted local ad, used for undo functionality.
  final LocalAd? lastDeletedLocalAd;

  ArchiveLocalAdsState copyWith({
    ArchiveLocalAdsStatus? status,
    List<LocalNativeAd>? nativeAds,
    String? nativeAdsCursor,
    bool? nativeAdsHasMore,
    List<LocalBannerAd>? bannerAds,
    String? bannerAdsCursor,
    bool? bannerAdsHasMore,
    List<LocalInterstitialAd>? interstitialAds,
    String? interstitialAdsCursor,
    bool? interstitialAdsHasMore,
    List<LocalVideoAd>? videoAds,
    String? videoAdsCursor,
    bool? videoAdsHasMore,
    HttpException? exception,
    LocalAd? lastDeletedLocalAd,
    bool clearLastDeletedLocalAd = false,
  }) {
    return ArchiveLocalAdsState(
      status: status ?? this.status,
      nativeAds: nativeAds ?? this.nativeAds,
      nativeAdsCursor: nativeAdsCursor ?? this.nativeAdsCursor,
      nativeAdsHasMore: nativeAdsHasMore ?? this.nativeAdsHasMore,
      bannerAds: bannerAds ?? this.bannerAds,
      bannerAdsCursor: bannerAdsCursor ?? this.bannerAdsCursor,
      bannerAdsHasMore: bannerAdsHasMore ?? this.bannerAdsHasMore,
      interstitialAds: interstitialAds ?? this.interstitialAds,
      interstitialAdsCursor:
          interstitialAdsCursor ?? this.interstitialAdsCursor,
      interstitialAdsHasMore:
          interstitialAdsHasMore ?? this.interstitialAdsHasMore,
      videoAds: videoAds ?? this.videoAds,
      videoAdsCursor: videoAdsCursor ?? this.videoAdsCursor,
      videoAdsHasMore: videoAdsHasMore ?? this.videoAdsHasMore,
      exception: exception ?? this.exception,
      lastDeletedLocalAd: clearLastDeletedLocalAd
          ? null
          : lastDeletedLocalAd ?? this.lastDeletedLocalAd,
    );
  }

  @override
  List<Object?> get props => [
    status,
    nativeAds,
    nativeAdsCursor,
    nativeAdsHasMore,
    bannerAds,
    bannerAdsCursor,
    bannerAdsHasMore,
    interstitialAds,
    interstitialAdsCursor,
    interstitialAdsHasMore,
    videoAds,
    videoAdsCursor,
    videoAdsHasMore,
    exception,
    lastDeletedLocalAd,
  ];
}
