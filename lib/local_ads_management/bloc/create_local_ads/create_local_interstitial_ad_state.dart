part of 'create_local_interstitial_ad_bloc.dart';

/// Represents the status of the create local interstitial ad operation.
enum CreateLocalInterstitialAdStatus {
  /// The operation is in its initial state.
  initial,

  /// The form is being submitted.
  submitting,

  /// The local interstitial ad was created successfully.
  success,

  /// An error occurred during the creation of the local interstitial ad.
  failure,
}

/// {@template create_local_interstitial_ad_state}
/// State for the [CreateLocalInterstitialAdBloc] which manages the creation of a
/// new local interstitial ad.
/// {@endtemplate}
class CreateLocalInterstitialAdState extends Equatable {
  /// {@macro create_local_interstitial_ad_state}
  const CreateLocalInterstitialAdState({
    this.status = CreateLocalInterstitialAdStatus.initial,
    this.imageUrl = '',
    this.targetUrl = '',
    this.contentStatus = ContentStatus.active,
    this.exception,
    this.createdLocalInterstitialAd,
  });

  /// The current status of the form submission.
  final CreateLocalInterstitialAdStatus status;

  /// The image URL of the local interstitial ad.
  final String imageUrl;

  /// The target URL of the local interstitial ad.
  final String targetUrl;

  /// The content status of the local interstitial ad.
  final ContentStatus contentStatus;

  /// The exception encountered during form submission, if any.
  final HttpException? exception;

  /// The local interstitial ad created upon successful submission.
  final LocalInterstitialAd? createdLocalInterstitialAd;

  /// Returns true if the form is valid, false otherwise.
  bool get isFormValid => imageUrl.isNotEmpty && targetUrl.isNotEmpty;

  /// Creates a copy of this [CreateLocalInterstitialAdState] with updated values.
  CreateLocalInterstitialAdState copyWith({
    CreateLocalInterstitialAdStatus? status,
    String? imageUrl,
    String? targetUrl,
    ContentStatus? contentStatus,
    HttpException? exception,
    LocalInterstitialAd? createdLocalInterstitialAd,
  }) {
    return CreateLocalInterstitialAdState(
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      targetUrl: targetUrl ?? this.targetUrl,
      contentStatus: contentStatus ?? this.contentStatus,
      exception: exception ?? this.exception,
      createdLocalInterstitialAd:
          createdLocalInterstitialAd ?? this.createdLocalInterstitialAd,
    );
  }

  @override
  List<Object?> get props => [
        status,
        imageUrl,
        targetUrl,
        contentStatus,
        exception,
        createdLocalInterstitialAd,
      ];
}
