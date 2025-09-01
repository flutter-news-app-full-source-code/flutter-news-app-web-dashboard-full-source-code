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
    this.contentStatus = ContentStatus.active,
    this.exception,
    this.createdLocalBannerAd,
  });

  /// The current status of the form submission.
  final CreateLocalBannerAdStatus status;

  /// The image URL of the local banner ad.
  final String imageUrl;

  /// The target URL of the local banner ad.
  final String targetUrl;

  /// The content status of the local banner ad.
  final ContentStatus contentStatus;

  /// The exception encountered during form submission, if any.
  final HttpException? exception;

  /// The local banner ad created upon successful submission.
  final LocalBannerAd? createdLocalBannerAd;

  /// Returns true if the form is valid, false otherwise.
  bool get isFormValid => imageUrl.isNotEmpty && targetUrl.isNotEmpty;

  /// Creates a copy of this [CreateLocalBannerAdState] with updated values.
  CreateLocalBannerAdState copyWith({
    CreateLocalBannerAdStatus? status,
    String? imageUrl,
    String? targetUrl,
    ContentStatus? contentStatus,
    HttpException? exception,
    LocalBannerAd? createdLocalBannerAd,
  }) {
    return CreateLocalBannerAdState(
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      targetUrl: targetUrl ?? this.targetUrl,
      contentStatus: contentStatus ?? this.contentStatus,
      exception: exception ?? this.exception,
      createdLocalBannerAd: createdLocalBannerAd ?? this.createdLocalBannerAd,
    );
  }

  @override
  List<Object?> get props => [
        status,
        imageUrl,
        targetUrl,
        contentStatus,
        exception,
        createdLocalBannerAd,
      ];
}
