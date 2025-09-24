part of 'update_local_native_ad_bloc.dart';

/// Represents the status of the update local native ad operation.
enum UpdateLocalNativeAdStatus {
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

/// The state for the [UpdateLocalNativeAdBloc].
final class UpdateLocalNativeAdState extends Equatable {
  const UpdateLocalNativeAdState({
    this.status = UpdateLocalNativeAdStatus.initial,
    this.initialAd,
    this.title = '',
    this.subtitle = '',
    this.imageUrl = '',
    this.targetUrl = '',
    this.exception,
    this.updatedAd,
  });

  final UpdateLocalNativeAdStatus status;
  final LocalNativeAd? initialAd;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String targetUrl;
  final HttpException? exception;
  final LocalNativeAd? updatedAd;

  /// Returns true if the form is valid and has changes.
  bool get isFormValid =>
      title.isNotEmpty &&
      subtitle.isNotEmpty &&
      imageUrl.isNotEmpty &&
      targetUrl.isNotEmpty &&
      initialAd != null;

  /// Returns true if there are changes compared to the initial ad.
  bool get isDirty =>
      initialAd != null &&
      (title != initialAd!.title ||
          subtitle != initialAd!.subtitle ||
          imageUrl != initialAd!.imageUrl ||
          targetUrl != initialAd!.targetUrl);

  UpdateLocalNativeAdState copyWith({
    UpdateLocalNativeAdStatus? status,
    LocalNativeAd? initialAd,
    String? title,
    String? subtitle,
    String? imageUrl,
    String? targetUrl,
    HttpException? exception,
    LocalNativeAd? updatedAd,
  }) {
    return UpdateLocalNativeAdState(
      status: status ?? this.status,
      initialAd: initialAd ?? this.initialAd,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      targetUrl: targetUrl ?? this.targetUrl,
      exception: exception,
      updatedAd: updatedAd ?? this.updatedAd,
    );
  }

  @override
  List<Object?> get props => [
    status,
    initialAd,
    title,
    subtitle,
    imageUrl,
    targetUrl,
    exception,
    updatedAd,
  ];
}
