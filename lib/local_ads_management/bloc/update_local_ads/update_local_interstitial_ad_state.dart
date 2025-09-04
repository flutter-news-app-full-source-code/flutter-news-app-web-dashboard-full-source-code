part of 'update_local_interstitial_ad_bloc.dart';

/// Represents the status of the update local interstitial ad operation.
enum UpdateLocalInterstitialAdStatus {
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

/// The state for the [UpdateLocalInterstitialAdBloc].
final class UpdateLocalInterstitialAdState extends Equatable {
  const UpdateLocalInterstitialAdState({
    this.status = UpdateLocalInterstitialAdStatus.initial,
    this.initialAd,
    this.imageUrl = '',
    this.targetUrl = '',
    this.contentStatus = ContentStatus.active,
    this.exception,
    this.updatedAd,
  });

  final UpdateLocalInterstitialAdStatus status;
  final LocalInterstitialAd? initialAd;
  final String imageUrl;
  final String targetUrl;
  final ContentStatus contentStatus;
  final HttpException? exception;
  final LocalInterstitialAd? updatedAd;

  /// Returns true if the form is valid and has changes.
  bool get isFormValid =>
      imageUrl.isNotEmpty && targetUrl.isNotEmpty && initialAd != null;

  /// Returns true if there are changes compared to the initial ad.
  bool get isDirty =>
      initialAd != null &&
      (imageUrl != initialAd!.imageUrl ||
          targetUrl != initialAd!.targetUrl ||
          contentStatus != initialAd!.status);

  UpdateLocalInterstitialAdState copyWith({
    UpdateLocalInterstitialAdStatus? status,
    LocalInterstitialAd? initialAd,
    String? imageUrl,
    String? targetUrl,
    ContentStatus? contentStatus,
    HttpException? exception,
    LocalInterstitialAd? updatedAd,
  }) {
    return UpdateLocalInterstitialAdState(
      status: status ?? this.status,
      initialAd: initialAd ?? this.initialAd,
      imageUrl: imageUrl ?? this.imageUrl,
      targetUrl: targetUrl ?? this.targetUrl,
      contentStatus: contentStatus ?? this.contentStatus,
      exception: exception,
      updatedAd: updatedAd ?? this.updatedAd,
    );
  }

  @override
  List<Object?> get props => [
    status,
    initialAd,
    imageUrl,
    targetUrl,
    contentStatus,
    exception,
    updatedAd,
  ];
}
