part of 'update_local_video_ad_bloc.dart';

sealed class UpdateLocalVideoAdEvent extends Equatable {
  const UpdateLocalVideoAdEvent();

  @override
  List<Object?> get props => [];
}

/// {@template update_local_video_ad_loaded}
/// Event to request loading of an existing local video ad for editing.
/// {@endtemplate}
final class UpdateLocalVideoAdLoaded extends UpdateLocalVideoAdEvent {
  /// {@macro update_local_video_ad_loaded}
  const UpdateLocalVideoAdLoaded(this.id);

  /// The ID of the local video ad to load.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// {@template update_local_video_ad_video_url_changed}
/// Event to notify that the video URL of the local video ad has changed.
/// {@endtemplate}
final class UpdateLocalVideoAdVideoUrlChanged extends UpdateLocalVideoAdEvent {
  /// {@macro update_local_video_ad_video_url_changed}
  const UpdateLocalVideoAdVideoUrlChanged(this.videoUrl);

  /// The new video URL.
  final String videoUrl;

  @override
  List<Object?> get props => [videoUrl];
}

/// {@template update_local_video_ad_target_url_changed}
/// Event to notify that the target URL of the local video ad has changed.
/// {@endtemplate}
final class UpdateLocalVideoAdTargetUrlChanged extends UpdateLocalVideoAdEvent {
  /// {@macro update_local_video_ad_target_url_changed}
  const UpdateLocalVideoAdTargetUrlChanged(this.targetUrl);

  /// The new target URL.
  final String targetUrl;

  @override
  List<Object?> get props => [targetUrl];
}

/// {@template update_local_video_ad_status_changed}
/// Event to notify that the content status of the local video ad has changed.
/// {@endtemplate}
final class UpdateLocalVideoAdStatusChanged extends UpdateLocalVideoAdEvent {
  /// {@macro update_local_video_ad_status_changed}
  const UpdateLocalVideoAdStatusChanged(this.status);

  /// The new content status.
  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// {@template update_local_video_ad_submitted}
/// Event to request submission of the updated local video ad.
/// {@endtemplate}
final class UpdateLocalVideoAdSubmitted extends UpdateLocalVideoAdEvent {
  /// {@macro update_local_video_ad_submitted}
  const UpdateLocalVideoAdSubmitted();
}
