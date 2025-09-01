part of 'create_local_native_ad_bloc.dart';

sealed class CreateLocalNativeAdEvent extends Equatable {
  const CreateLocalNativeAdEvent();

  @override
  List<Object?> get props => [];
}

/// {@template create_local_native_ad_title_changed}
/// Event to notify that the title of the local native ad has changed.
/// {@endtemplate}
final class CreateLocalNativeAdTitleChanged extends CreateLocalNativeAdEvent {
  /// {@macro create_local_native_ad_title_changed}
  const CreateLocalNativeAdTitleChanged(this.title);

  /// The new title.
  final String title;

  @override
  List<Object?> get props => [title];
}

/// {@template create_local_native_ad_subtitle_changed}
/// Event to notify that the subtitle of the local native ad has changed.
/// {@endtemplate}
final class CreateLocalNativeAdSubtitleChanged extends CreateLocalNativeAdEvent {
  /// {@macro create_local_native_ad_subtitle_changed}
  const CreateLocalNativeAdSubtitleChanged(this.subtitle);

  /// The new subtitle.
  final String subtitle;

  @override
  List<Object?> get props => [subtitle];
}

/// {@template create_local_native_ad_image_url_changed}
/// Event to notify that the image URL of the local native ad has changed.
/// {@endtemplate}
final class CreateLocalNativeAdImageUrlChanged extends CreateLocalNativeAdEvent {
  /// {@macro create_local_native_ad_image_url_changed}
  const CreateLocalNativeAdImageUrlChanged(this.imageUrl);

  /// The new image URL.
  final String imageUrl;

  @override
  List<Object?> get props => [imageUrl];
}

/// {@template create_local_native_ad_target_url_changed}
/// Event to notify that the target URL of the local native ad has changed.
/// {@endtemplate}
final class CreateLocalNativeAdTargetUrlChanged extends CreateLocalNativeAdEvent {
  /// {@macro create_local_native_ad_target_url_changed}
  const CreateLocalNativeAdTargetUrlChanged(this.targetUrl);

  /// The new target URL.
  final String targetUrl;

  @override
  List<Object?> get props => [targetUrl];
}

/// {@template create_local_native_ad_status_changed}
/// Event to notify that the content status of the local native ad has changed.
/// {@endtemplate}
final class CreateLocalNativeAdStatusChanged extends CreateLocalNativeAdEvent {
  /// {@macro create_local_native_ad_status_changed}
  const CreateLocalNativeAdStatusChanged(this.status);

  /// The new content status.
  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// {@template create_local_native_ad_submitted}
/// Event to request submission of the new local native ad.
/// {@endtemplate}
final class CreateLocalNativeAdSubmitted extends CreateLocalNativeAdEvent {
  /// {@macro create_local_native_ad_submitted}
  const CreateLocalNativeAdSubmitted();
}
