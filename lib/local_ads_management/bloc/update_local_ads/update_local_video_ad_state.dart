part of 'update_local_video_ad_bloc.dart';

/// Represents the status of the update local video ad operation.
enum UpdateLocalVideoAdStatus {
  /// Initial state, before any data is loaded.
  initial,

  /// Data is being loaded.
  loading,

  /// An operation completed successfully.
  success,

  /// An error occurred.
  failure,

  /// The form is being submitted.
  submitting,
}

/// The state for the [UpdateLocalVideoAdBloc].
final class UpdateLocalVideoAdState extends Equatable {
  const UpdateLocalVideoAdState({
    this.status = UpdateLocalVideoAdStatus.initial,
    this.initialAd,
    this.videoUrl = '',
    this.targetUrl = '',
    this.exception,
    this.updatedAd,
  });

  final UpdateLocalVideoAdStatus status;
  final LocalVideoAd? initialAd;
  final String videoUrl;
  final String targetUrl;
  final HttpException? exception;
  final LocalVideoAd? updatedAd;

  /// Returns true if the form is valid and has changes.
  bool get isFormValid =>
      videoUrl.isNotEmpty && targetUrl.isNotEmpty && initialAd != null;

  /// Returns true if there are changes compared to the initial ad.
  bool get isDirty =>
      initialAd != null &&
      (videoUrl != initialAd!.videoUrl || targetUrl != initialAd!.targetUrl);

  UpdateLocalVideoAdState copyWith({
    UpdateLocalVideoAdStatus? status,
    LocalVideoAd? initialAd,
    String? videoUrl,
    String? targetUrl,
    HttpException? exception,
    LocalVideoAd? updatedAd,
  }) {
    return UpdateLocalVideoAdState(
      status: status ?? this.status,
      initialAd: initialAd ?? this.initialAd,
      videoUrl: videoUrl ?? this.videoUrl,
      targetUrl: targetUrl ?? this.targetUrl,
      exception: exception,
      updatedAd: updatedAd ?? this.updatedAd,
    );
  }

  @override
  List<Object?> get props => [
    status,
    initialAd,
    videoUrl,
    targetUrl,
    exception,
    updatedAd,
  ];
}
