part of 'update_local_banner_ad_bloc.dart';

/// Represents the status of the update local banner ad operation.
enum UpdateLocalBannerAdStatus {
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

/// The state for the [UpdateLocalBannerAdBloc].
final class UpdateLocalBannerAdState extends Equatable {
  const UpdateLocalBannerAdState({
    this.status = UpdateLocalBannerAdStatus.initial,
    this.initialAd,
    this.imageUrl = '',
    this.targetUrl = '',
    this.contentStatus = ContentStatus.active,
    this.exception,
    this.updatedAd,
  });

  final UpdateLocalBannerAdStatus status;
  final LocalBannerAd? initialAd;
  final String imageUrl;
  final String targetUrl;
  final ContentStatus contentStatus;
  final HttpException? exception;
  final LocalBannerAd? updatedAd;

  /// Returns true if the form is valid and has changes.
  bool get isFormValid =>
      imageUrl.isNotEmpty && targetUrl.isNotEmpty && initialAd != null;

  /// Returns true if there are changes compared to the initial ad.
  bool get isDirty =>
      initialAd != null &&
      (imageUrl != initialAd!.imageUrl ||
          targetUrl != initialAd!.targetUrl ||
          contentStatus != initialAd!.status);

  UpdateLocalBannerAdState copyWith({
    UpdateLocalBannerAdStatus? status,
    LocalBannerAd? initialAd,
    String? imageUrl,
    String? targetUrl,
    ContentStatus? contentStatus,
    HttpException? exception,
    LocalBannerAd? updatedAd,
  }) {
    return UpdateLocalBannerAdState(
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
