part of 'update_local_interstitial_ad_bloc.dart';

sealed class UpdateLocalInterstitialAdEvent extends Equatable {
  const UpdateLocalInterstitialAdEvent();

  @override
  List<Object?> get props => [];
}

/// {@template update_local_interstitial_ad_loaded}
/// Event to request loading of an existing local interstitial ad for editing.
/// {@endtemplate}
final class UpdateLocalInterstitialAdLoaded extends UpdateLocalInterstitialAdEvent {
  /// {@macro update_local_interstitial_ad_loaded}
  const UpdateLocalInterstitialAdLoaded(this.id);

  /// The ID of the local interstitial ad to load.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// {@template update_local_interstitial_ad_image_url_changed}
/// Event to notify that the image URL of the local interstitial ad has changed.
/// {@endtemplate}
final class UpdateLocalInterstitialAdImageUrlChanged extends UpdateLocalInterstitialAdEvent {
  /// {@macro update_local_interstitial_ad_image_url_changed}
  const UpdateLocalInterstitialAdImageUrlChanged(this.imageUrl);

  /// The new image URL.
  final String imageUrl;

  @override
  List<Object?> get props => [imageUrl];
}

/// {@template update_local_interstitial_ad_target_url_changed}
/// Event to notify that the target URL of the local interstitial ad has changed.
/// {@endtemplate}
final class UpdateLocalInterstitialAdTargetUrlChanged extends UpdateLocalInterstitialAdEvent {
  /// {@macro update_local_interstitial_ad_target_url_changed}
  const UpdateLocalInterstitialAdTargetUrlChanged(this.targetUrl);

  /// The new target URL.
  final String targetUrl;

  @override
  List<Object?> get props => [targetUrl];
}

/// {@template update_local_interstitial_ad_status_changed}
/// Event to notify that the content status of the local interstitial ad has changed.
/// {@endtemplate}
final class UpdateLocalInterstitialAdStatusChanged extends UpdateLocalInterstitialAdEvent {
  /// {@macro update_local_interstitial_ad_status_changed}
  const UpdateLocalInterstitialAdStatusChanged(this.status);

  /// The new content status.
  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// {@template update_local_interstitial_ad_submitted}
/// Event to request submission of the updated local interstitial ad.
/// {@endtemplate}
final class UpdateLocalInterstitialAdSubmitted extends UpdateLocalInterstitialAdEvent {
  /// {@macro update_local_interstitial_ad_submitted}
  const UpdateLocalInterstitialAdSubmitted();
}
