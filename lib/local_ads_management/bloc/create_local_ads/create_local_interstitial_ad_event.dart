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

/// {@template create_local_interstitial_ad_status_changed}
/// Event to notify that the content status of the local interstitial ad has changed.
/// {@endtemplate}
final class CreateLocalInterstitialAdStatusChanged
    extends CreateLocalInterstitialAdEvent {
  /// {@macro create_local_interstitial_ad_status_changed}
  const CreateLocalInterstitialAdStatusChanged(this.status);

  /// The new content status.
  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// {@template create_local_interstitial_ad_submitted}
/// Event to request submission of the new local interstitial ad.
/// {@endtemplate}
final class CreateLocalInterstitialAdSubmitted
    extends CreateLocalInterstitialAdEvent {
  /// {@macro create_local_interstitial_ad_submitted}
  const CreateLocalInterstitialAdSubmitted();
}
