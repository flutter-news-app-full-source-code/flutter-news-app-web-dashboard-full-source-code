part of 'local_ads_management_bloc.dart';

/// Represents the status of local ad loading and operations.
enum LocalAdsManagementStatus {
  /// The operation is in its initial state.
  initial,

  /// Data is currently being loaded or an operation is in progress.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred during data loading or an operation.
  failure,
}

/// Defines the tabs available in the local ads management section.
enum LocalAdsManagementTab {
  /// Represents the Native Ads tab.
  native,

  /// Represents the Banner Ads tab.
  banner,

  /// Represents the Interstitial Ads tab.
  interstitial,

  /// Represents the Video Ads tab.
  video,
}

/// Defines the state for the local ads management feature.
class LocalAdsManagementState extends Equatable {
  /// {@macro local_ads_management_state}
  const LocalAdsManagementState({
    this.activeTab = LocalAdsManagementTab.native,
    this.nativeAdsStatus = LocalAdsManagementStatus.initial,
    this.nativeAds = const [],
    this.nativeAdsCursor,
    this.nativeAdsHasMore = false,
    this.bannerAdsStatus = LocalAdsManagementStatus.initial,
    this.bannerAds = const [],
    this.bannerAdsCursor,
    this.bannerAdsHasMore = false,
    this.interstitialAdsStatus = LocalAdsManagementStatus.initial,
    this.interstitialAds = const [],
    this.interstitialAdsCursor,
    this.interstitialAdsHasMore = false,
    this.videoAdsStatus = LocalAdsManagementStatus.initial,
    this.videoAds = const [],
    this.videoAdsCursor,
    this.videoAdsHasMore = false,
    this.exception,
    this.lastDeletedLocalAd,
  });

  /// The currently active tab in the local ads management section.
  final LocalAdsManagementTab activeTab;

  /// Status of native ad data operations.
  final LocalAdsManagementStatus nativeAdsStatus;

  /// List of native ads.
  final List<LocalNativeAd> nativeAds;

  /// Cursor for native ad pagination.
  final String? nativeAdsCursor;

  /// Indicates if there are more native ads to load.
  final bool nativeAdsHasMore;

  /// Status of banner ad data operations.
  final LocalAdsManagementStatus bannerAdsStatus;

  /// List of banner ads.
  final List<LocalBannerAd> bannerAds;

  /// Cursor for banner ad pagination.
  final String? bannerAdsCursor;

  /// Indicates if there are more banner ads to load.
  final bool bannerAdsHasMore;

  /// Status of interstitial ad data operations.
  final LocalAdsManagementStatus interstitialAdsStatus;

  /// List of interstitial ads.
  final List<LocalInterstitialAd> interstitialAds;

  /// Cursor for interstitial ad pagination.
  final String? interstitialAdsCursor;

  /// Indicates if there are more interstitial ads to load.
  final bool interstitialAdsHasMore;

  /// Status of video ad data operations.
  final LocalAdsManagementStatus videoAdsStatus;

  /// List of video ads.
  final List<LocalVideoAd> videoAds;

  /// Cursor for video ad pagination.
  final String? videoAdsCursor;

  /// Indicates if there are more video ads to load.
  final bool videoAdsHasMore;

  /// The error describing an operation failure, if any.
  final HttpException? exception;

  /// The last deleted local ad, used for undo functionality.
  final LocalAd? lastDeletedLocalAd;

  /// Creates a copy of this [LocalAdsManagementState] with updated values.
  LocalAdsManagementState copyWith({
    LocalAdsManagementTab? activeTab,
    LocalAdsManagementStatus? nativeAdsStatus,
    List<LocalNativeAd>? nativeAds,
    String? nativeAdsCursor,
    bool? nativeAdsHasMore,
    LocalAdsManagementStatus? bannerAdsStatus,
    List<LocalBannerAd>? bannerAds,
    String? bannerAdsCursor,
    bool? bannerAdsHasMore,
    LocalAdsManagementStatus? interstitialAdsStatus,
    List<LocalInterstitialAd>? interstitialAds,
    String? interstitialAdsCursor,
    bool? interstitialAdsHasMore,
    LocalAdsManagementStatus? videoAdsStatus,
    List<LocalVideoAd>? videoAds,
    String? videoAdsCursor,
    bool? videoAdsHasMore,
    HttpException? exception,
    LocalAd? lastDeletedLocalAd,
    bool clearLastDeletedLocalAd = false,
  }) {
    return LocalAdsManagementState(
      activeTab: activeTab ?? this.activeTab,
      nativeAdsStatus: nativeAdsStatus ?? this.nativeAdsStatus,
      nativeAds: nativeAds ?? this.nativeAds,
      nativeAdsCursor: nativeAdsCursor ?? this.nativeAdsCursor,
      nativeAdsHasMore: nativeAdsHasMore ?? this.nativeAdsHasMore,
      bannerAdsStatus: bannerAdsStatus ?? this.bannerAdsStatus,
      bannerAds: bannerAds ?? this.bannerAds,
      bannerAdsCursor: bannerAdsCursor ?? this.bannerAdsCursor,
      bannerAdsHasMore: bannerAdsHasMore ?? this.bannerAdsHasMore,
      interstitialAdsStatus: interstitialAdsStatus ?? this.interstitialAdsStatus,
      interstitialAds: interstitialAds ?? this.interstitialAds,
      interstitialAdsCursor: interstitialAdsCursor ?? this.interstitialAdsCursor,
      interstitialAdsHasMore: interstitialAdsHasMore ?? this.interstitialAdsHasMore,
      videoAdsStatus: videoAdsStatus ?? this.videoAdsStatus,
      videoAds: videoAds ?? this.videoAds,
      videoAdsCursor: videoAdsCursor ?? this.videoAdsCursor,
      videoAdsHasMore: videoAdsHasMore ?? this.videoAdsHasMore,
      exception: exception ?? this.exception,
      lastDeletedLocalAd:
          clearLastDeletedLocalAd ? null : lastDeletedLocalAd ?? this.lastDeletedLocalAd,
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
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
        lastDeletedLocalAd,
      ];
}
