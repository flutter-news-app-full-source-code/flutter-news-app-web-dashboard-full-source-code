part of 'create_local_banner_ad_bloc.dart';

/// Represents the status of the create local banner ad operation.
enum CreateLocalBannerAdStatus {
  /// The operation is in its initial state.
  initial,

  /// The form is being submitted.
  submitting,

  /// The local banner ad was created successfully.
  success,

  /// An error occurred during the creation of the local banner ad.
  failure,
}

/// {@template create_local_banner_ad_state}
/// State for the [CreateLocalBannerAdBloc] which manages the creation of a
/// new local banner ad.
/// {@endtemplate}
class CreateLocalBannerAdState extends Equatable {
  /// {@macro create_local_banner_ad_state}
  const CreateLocalBannerAdState({
    this.status = CreateLocalBannerAdStatus.initial,
    this.imageUrl = '',
    this.targetUrl = '',
    this.exception,
    this.createdLocalBannerAd,
    this.contentStatus = ContentStatus.draft,
  });

  /// The current status of the form submission.
  final CreateLocalBannerAdStatus status;

  /// The image URL of the local banner ad.
  final String imageUrl;

  /// The target URL of the local banner ad.
  final String targetUrl;

  /// The exception encountered during form submission, if any.
  final HttpException? exception;

  /// The local banner ad created upon successful submission.
  final LocalBannerAd? createdLocalBannerAd;

  /// The content status of the ad (draft or active).
  final ContentStatus contentStatus;

  /// Returns true if the form is valid, false otherwise.
  bool get isFormValid => imageUrl.isNotEmpty && targetUrl.isNotEmpty;

  /// Creates a copy of this [CreateLocalBannerAdState] with updated values.
  CreateLocalBannerAdState copyWith({
    CreateLocalBannerAdStatus? status,
    String? imageUrl,
    String? targetUrl,
    HttpException? exception,
    LocalBannerAd? createdLocalBannerAd,
    ContentStatus? contentStatus,
  }) {
    return CreateLocalBannerAdState(
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      targetUrl: targetUrl ?? this.targetUrl,
      exception: exception ?? this.exception,
      createdLocalBannerAd: createdLocalBannerAd ?? this.createdLocalBannerAd,
      contentStatus: contentStatus ?? this.contentStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    imageUrl,
    targetUrl,
    exception,
    createdLocalBannerAd,
    contentStatus,
  ];
}
