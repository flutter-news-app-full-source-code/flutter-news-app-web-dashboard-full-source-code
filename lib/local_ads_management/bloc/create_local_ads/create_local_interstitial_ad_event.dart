part of 'create_local_interstitial_ad_bloc.dart';

sealed class CreateLocalInterstitialAdEvent extends Equatable {
  const CreateLocalInterstitialAdEvent();

  @override
  List<Object?> get props => [];
}

/// {@template create_local_interstitial_ad_image_url_changed}
/// Event to notify that the image URL of the local interstitial ad has changed.
/// {@endtemplate}
final class CreateLocalInterstitialAdImageUrlChanged
    extends CreateLocalInterstitialAdEvent {
  /// {@macro create_local_interstitial_ad_image_url_changed}
  const CreateLocalInterstitialAdImageUrlChanged(this.imageUrl);

  /// The new image URL.
  final String imageUrl;

  @override
  List<Object?> get props => [imageUrl];
}

/// {@template create_local_interstitial_ad_target_url_changed}
/// Event to notify that the target URL of the local interstitial ad has changed.
/// {@endtemplate}
final class CreateLocalInterstitialAdTargetUrlChanged
    extends CreateLocalInterstitialAdEvent {
  /// {@macro create_local_interstitial_ad_target_url_changed}
  const CreateLocalInterstitialAdTargetUrlChanged(this.targetUrl);

  /// The new target URL.
  final String targetUrl;

  @override
  List<Object?> get props => [targetUrl];
}

/// {@template create_local_interstitial_ad_saved_as_draft}
/// Event to request saving the new local interstitial ad as a draft.
/// {@endtemplate}
final class CreateLocalInterstitialAdSavedAsDraft
    extends CreateLocalInterstitialAdEvent {
  /// {@macro create_local_interstitial_ad_saved_as_draft}
  const CreateLocalInterstitialAdSavedAsDraft();
}

/// {@template create_local_interstitial_ad_published}
/// Event to request publishing the new local interstitial ad.
/// {@endtemplate}
final class CreateLocalInterstitialAdPublished
    extends CreateLocalInterstitialAdEvent {
  /// {@macro create_local_interstitial_ad_published}
  const CreateLocalInterstitialAdPublished();
}
