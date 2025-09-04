part of 'create_local_banner_ad_bloc.dart';

sealed class CreateLocalBannerAdEvent extends Equatable {
  const CreateLocalBannerAdEvent();

  @override
  List<Object?> get props => [];
}

/// {@template create_local_banner_ad_image_url_changed}
/// Event to notify that the image URL of the local banner ad has changed.
/// {@endtemplate}
final class CreateLocalBannerAdImageUrlChanged
    extends CreateLocalBannerAdEvent {
  /// {@macro create_local_banner_ad_image_url_changed}
  const CreateLocalBannerAdImageUrlChanged(this.imageUrl);

  /// The new image URL.
  final String imageUrl;

  @override
  List<Object?> get props => [imageUrl];
}

/// {@template create_local_banner_ad_target_url_changed}
/// Event to notify that the target URL of the local banner ad has changed.
/// {@endtemplate}
final class CreateLocalBannerAdTargetUrlChanged
    extends CreateLocalBannerAdEvent {
  /// {@macro create_local_banner_ad_target_url_changed}
  const CreateLocalBannerAdTargetUrlChanged(this.targetUrl);

  /// The new target URL.
  final String targetUrl;

  @override
  List<Object?> get props => [targetUrl];
}

/// {@template create_local_banner_ad_status_changed}
/// Event to notify that the content status of the local banner ad has changed.
/// {@endtemplate}
final class CreateLocalBannerAdStatusChanged extends CreateLocalBannerAdEvent {
  /// {@macro create_local_banner_ad_status_changed}
  const CreateLocalBannerAdStatusChanged(this.status);

  /// The new content status.
  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// {@template create_local_banner_ad_submitted}
/// Event to request submission of the new local banner ad.
/// {@endtemplate}
final class CreateLocalBannerAdSubmitted extends CreateLocalBannerAdEvent {
  /// {@macro create_local_banner_ad_submitted}
  const CreateLocalBannerAdSubmitted();
}
