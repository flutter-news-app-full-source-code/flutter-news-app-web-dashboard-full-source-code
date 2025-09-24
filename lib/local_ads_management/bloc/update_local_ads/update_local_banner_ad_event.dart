part of 'update_local_banner_ad_bloc.dart';

sealed class UpdateLocalBannerAdEvent extends Equatable {
  const UpdateLocalBannerAdEvent();

  @override
  List<Object?> get props => [];
}

/// {@template update_local_banner_ad_loaded}
/// Event to request loading of an existing local banner ad for editing.
/// {@endtemplate}
final class UpdateLocalBannerAdLoaded extends UpdateLocalBannerAdEvent {
  /// {@macro update_local_banner_ad_loaded}
  const UpdateLocalBannerAdLoaded(this.id);

  /// The ID of the local banner ad to load.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// {@template update_local_banner_ad_image_url_changed}
/// Event to notify that the image URL of the local banner ad has changed.
/// {@endtemplate}
final class UpdateLocalBannerAdImageUrlChanged
    extends UpdateLocalBannerAdEvent {
  /// {@macro update_local_banner_ad_image_url_changed}
  const UpdateLocalBannerAdImageUrlChanged(this.imageUrl);

  /// The new image URL.
  final String imageUrl;

  @override
  List<Object?> get props => [imageUrl];
}

/// {@template update_local_banner_ad_target_url_changed}
/// Event to notify that the target URL of the local banner ad has changed.
/// {@endtemplate}
final class UpdateLocalBannerAdTargetUrlChanged
    extends UpdateLocalBannerAdEvent {
  /// {@macro update_local_banner_ad_target_url_changed}
  const UpdateLocalBannerAdTargetUrlChanged(this.targetUrl);

  /// The new target URL.
  final String targetUrl;

  @override
  List<Object?> get props => [targetUrl];
}

/// {@template update_local_banner_ad_submitted}
/// Event to request submission of the updated local banner ad.
/// {@endtemplate}
final class UpdateLocalBannerAdSubmitted extends UpdateLocalBannerAdEvent {
  /// {@macro update_local_banner_ad_submitted}
  const UpdateLocalBannerAdSubmitted();
}
