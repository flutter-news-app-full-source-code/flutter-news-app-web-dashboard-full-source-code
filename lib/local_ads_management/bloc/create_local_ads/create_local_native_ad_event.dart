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
final class CreateLocalNativeAdSubtitleChanged
    extends CreateLocalNativeAdEvent {
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
final class CreateLocalNativeAdImageUrlChanged
    extends CreateLocalNativeAdEvent {
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
final class CreateLocalNativeAdTargetUrlChanged
    extends CreateLocalNativeAdEvent {
  /// {@macro create_local_native_ad_target_url_changed}
  const CreateLocalNativeAdTargetUrlChanged(this.targetUrl);

  /// The new target URL.
  final String targetUrl;

  @override
  List<Object?> get props => [targetUrl];
}

/// {@template create_local_native_ad_saved_as_draft}
/// Event to request saving the new local native ad as a draft.
/// {@endtemplate}
final class CreateLocalNativeAdSavedAsDraft extends CreateLocalNativeAdEvent {
  /// {@macro create_local_native_ad_saved_as_draft}
  const CreateLocalNativeAdSavedAsDraft();
}

/// {@template create_local_native_ad_published}
/// Event to request publishing the new local native ad.
/// {@endtemplate}
final class CreateLocalNativeAdPublished extends CreateLocalNativeAdEvent {
  /// {@macro create_local_native_ad_published}
  const CreateLocalNativeAdPublished();
}
