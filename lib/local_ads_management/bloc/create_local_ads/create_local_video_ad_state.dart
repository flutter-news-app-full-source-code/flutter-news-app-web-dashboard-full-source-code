part of 'create_local_video_ad_bloc.dart';

/// Represents the status of the create local video ad operation.
enum CreateLocalVideoAdStatus {
  /// The operation is in its initial state.
  initial,

  /// The form is being submitted.
  submitting,

  /// The local video ad was created successfully.
  success,

  /// An error occurred during the creation of the local video ad.
  failure,
}

/// {@template create_local_video_ad_state}
/// State for the [CreateLocalVideoAdBloc] which manages the creation of a
/// new local video ad.
/// {@endtemplate}
class CreateLocalVideoAdState extends Equatable {
  /// {@macro create_local_video_ad_state}
  const CreateLocalVideoAdState({
    this.status = CreateLocalVideoAdStatus.initial,
    this.videoUrl = '',
    this.targetUrl = '',
    this.exception,
    this.createdLocalVideoAd,
  });

  /// The current status of the form submission.
  final CreateLocalVideoAdStatus status;

  /// The video URL of the local video ad.
  final String videoUrl;

  /// The target URL of the local video ad.
  final String targetUrl;

  /// The exception encountered during form submission, if any.
  final HttpException? exception;

  /// The local video ad created upon successful submission.
  final LocalVideoAd? createdLocalVideoAd;

  /// Returns true if the form is valid, false otherwise.
  bool get isFormValid => videoUrl.isNotEmpty && targetUrl.isNotEmpty;

  /// Creates a copy of this [CreateLocalVideoAdState] with updated values.
  CreateLocalVideoAdState copyWith({
    CreateLocalVideoAdStatus? status,
    String? videoUrl,
    String? targetUrl,
    HttpException? exception,
    LocalVideoAd? createdLocalVideoAd,
  }) {
    return CreateLocalVideoAdState(
      status: status ?? this.status,
      videoUrl: videoUrl ?? this.videoUrl,
      targetUrl: targetUrl ?? this.targetUrl,
      exception: exception ?? this.exception,
      createdLocalVideoAd: createdLocalVideoAd ?? this.createdLocalVideoAd,
    );
  }

  @override
  List<Object?> get props => [
    status,
    videoUrl,
    targetUrl,
    exception,
    createdLocalVideoAd,
  ];
}
