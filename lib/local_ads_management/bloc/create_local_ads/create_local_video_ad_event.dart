part of 'create_local_video_ad_bloc.dart';

sealed class CreateLocalVideoAdEvent extends Equatable {
  const CreateLocalVideoAdEvent();

  @override
  List<Object?> get props => [];
}

/// {@template create_local_video_ad_video_url_changed}
/// Event to notify that the video URL of the local video ad has changed.
/// {@endtemplate}
final class CreateLocalVideoAdVideoUrlChanged extends CreateLocalVideoAdEvent {
  /// {@macro create_local_video_ad_video_url_changed}
  const CreateLocalVideoAdVideoUrlChanged(this.videoUrl);

  /// The new video URL.
  final String videoUrl;

  @override
  List<Object?> get props => [videoUrl];
}

/// {@template create_local_video_ad_target_url_changed}
/// Event to notify that the target URL of the local video ad has changed.
/// {@endtemplate}
final class CreateLocalVideoAdTargetUrlChanged extends CreateLocalVideoAdEvent {
  /// {@macro create_local_video_ad_target_url_changed}
  const CreateLocalVideoAdTargetUrlChanged(this.targetUrl);

  /// The new target URL.
  final String targetUrl;

  @override
  List<Object?> get props => [targetUrl];
}

/// {@template create_local_video_ad_saved_as_draft}
/// Event to request saving the new local video ad as a draft.
/// {@endtemplate}
final class CreateLocalVideoAdSavedAsDraft extends CreateLocalVideoAdEvent {
  /// {@macro create_local_video_ad_saved_as_draft}
  const CreateLocalVideoAdSavedAsDraft();
}

/// {@template create_local_video_ad_published}
/// Event to request publishing the new local video ad.
/// {@endtemplate}
final class CreateLocalVideoAdPublished extends CreateLocalVideoAdEvent {
  /// {@macro create_local_video_ad_published}
  const CreateLocalVideoAdPublished();
}
