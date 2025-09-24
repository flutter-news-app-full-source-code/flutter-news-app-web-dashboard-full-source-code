part of 'update_local_native_ad_bloc.dart';

sealed class UpdateLocalNativeAdEvent extends Equatable {
  const UpdateLocalNativeAdEvent();

  @override
  List<Object?> get props => [];
}

/// {@template update_local_native_ad_loaded}
/// Event to request loading of an existing local native ad for editing.
/// {@endtemplate}
final class UpdateLocalNativeAdLoaded extends UpdateLocalNativeAdEvent {
  /// {@macro update_local_native_ad_loaded}
  const UpdateLocalNativeAdLoaded(this.id);

  /// The ID of the local native ad to load.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// {@template update_local_native_ad_title_changed}
/// Event to notify that the title of the local native ad has changed.
/// {@endtemplate}
final class UpdateLocalNativeAdTitleChanged extends UpdateLocalNativeAdEvent {
  /// {@macro update_local_native_ad_title_changed}
  const UpdateLocalNativeAdTitleChanged(this.title);

  /// The new title.
  final String title;

  @override
  List<Object?> get props => [title];
}

/// {@template update_local_native_ad_subtitle_changed}
/// Event to notify that the subtitle of the local native ad has changed.
/// {@endtemplate}
final class UpdateLocalNativeAdSubtitleChanged
    extends UpdateLocalNativeAdEvent {
  /// {@macro update_local_native_ad_subtitle_changed}
  const UpdateLocalNativeAdSubtitleChanged(this.subtitle);

  /// The new subtitle.
  final String subtitle;

  @override
  List<Object?> get props => [subtitle];
}

/// {@template update_local_native_ad_image_url_changed}
/// Event to notify that the image URL of the local native ad has changed.
/// {@endtemplate}
final class UpdateLocalNativeAdImageUrlChanged
    extends UpdateLocalNativeAdEvent {
  /// {@macro update_local_native_ad_image_url_changed}
  const UpdateLocalNativeAdImageUrlChanged(this.imageUrl);

  /// The new image URL.
  final String imageUrl;

  @override
  List<Object?> get props => [imageUrl];
}

/// {@template update_local_native_ad_target_url_changed}
/// Event to notify that the target URL of the local native ad has changed.
/// {@endtemplate}
final class UpdateLocalNativeAdTargetUrlChanged
    extends UpdateLocalNativeAdEvent {
  /// {@macro update_local_native_ad_target_url_changed}
  const UpdateLocalNativeAdTargetUrlChanged(this.targetUrl);

  /// The new target URL.
  final String targetUrl;

  @override
  List<Object?> get props => [targetUrl];
}

/// {@template update_local_native_ad_submitted}
/// Event to request submission of the updated local native ad.
/// {@endtemplate}
final class UpdateLocalNativeAdSubmitted extends UpdateLocalNativeAdEvent {
  /// {@macro update_local_native_ad_submitted}
  const UpdateLocalNativeAdSubmitted();
}
