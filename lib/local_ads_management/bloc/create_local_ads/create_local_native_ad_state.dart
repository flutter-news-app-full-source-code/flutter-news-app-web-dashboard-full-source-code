part of 'create_local_native_ad_bloc.dart';

/// Represents the status of the create local native ad operation.
enum CreateLocalNativeAdStatus {
  /// The operation is in its initial state.
  initial,

  /// The form is being submitted.
  submitting,

  /// The local native ad was created successfully.
  success,

  /// An error occurred during the creation of the local native ad.
  failure,
}

/// {@template create_local_native_ad_state}
/// State for the [CreateLocalNativeAdBloc] which manages the creation of a
/// new local native ad.
/// {@endtemplate}
class CreateLocalNativeAdState extends Equatable {
  /// {@macro create_local_native_ad_state}
  const CreateLocalNativeAdState({
    this.status = CreateLocalNativeAdStatus.initial,
    this.title = '',
    this.subtitle = '',
    this.imageUrl = '',
    this.targetUrl = '',
    this.exception,
    this.createdLocalNativeAd,
    this.contentStatus = ContentStatus.draft,
  });

  /// The current status of the form submission.
  final CreateLocalNativeAdStatus status;

  /// The title of the local native ad.
  final String title;

  /// The subtitle of the local native ad.
  final String subtitle;

  /// The image URL of the local native ad.
  final String imageUrl;

  /// The target URL of the local native ad.
  final String targetUrl;

  /// The exception encountered during form submission, if any.
  final HttpException? exception;

  /// The local native ad created upon successful submission.
  final LocalNativeAd? createdLocalNativeAd;

  /// The content status of the ad (draft or active).
  final ContentStatus contentStatus;

  /// Returns true if the form is valid, false otherwise.
  bool get isFormValid =>
      title.isNotEmpty &&
      subtitle.isNotEmpty &&
      imageUrl.isNotEmpty &&
      targetUrl.isNotEmpty;

  /// Creates a copy of this [CreateLocalNativeAdState] with updated values.
  CreateLocalNativeAdState copyWith({
    CreateLocalNativeAdStatus? status,
    String? title,
    String? subtitle,
    String? imageUrl,
    String? targetUrl,
    HttpException? exception,
    LocalNativeAd? createdLocalNativeAd,
    ContentStatus? contentStatus,
  }) {
    return CreateLocalNativeAdState(
      status: status ?? this.status,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      targetUrl: targetUrl ?? this.targetUrl,
      exception: exception ?? this.exception,
      createdLocalNativeAd: createdLocalNativeAd ?? this.createdLocalNativeAd,
      contentStatus: contentStatus ?? this.contentStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    title,
    subtitle,
    imageUrl,
    targetUrl,
    exception,
    createdLocalNativeAd,
    contentStatus,
  ];
}
