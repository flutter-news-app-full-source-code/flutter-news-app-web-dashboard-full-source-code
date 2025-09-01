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

/// {@template create_local_video_ad_status_changed}
/// Event to notify that the content status of the local video ad has changed.
/// {@endtemplate}
final class CreateLocalVideoAdStatusChanged extends CreateLocalVideoAdEvent {
  /// {@macro create_local_video_ad_status_changed}
  const CreateLocalVideoAdStatusChanged(this.status);

  /// The new content status.
  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// {@template create_local_video_ad_submitted}
/// Event to request submission of the new local video ad.
/// {@endtemplate}
final class CreateLocalVideoAdSubmitted extends CreateLocalVideoAdEvent {
  /// {@macro create_local_video_ad_submitted}
  const CreateLocalVideoAdSubmitted();
}
