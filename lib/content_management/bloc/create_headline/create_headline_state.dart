part of 'create_headline_bloc.dart';

/// Represents the status of the create headline operation.
enum CreateHeadlineStatus {
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

/// The state for the [CreateHeadlineBloc].
final class CreateHeadlineState extends Equatable {
  const CreateHeadlineState({
    this.status = CreateHeadlineStatus.initial,
    this.title = '',
    this.excerpt = '',
    this.url = '',
    this.imageUrl = '',
    this.source,
    this.topic,
    this.eventCountry,
    this.exception,
    this.isBreaking = false,
    this.createdHeadline,
  });

  final CreateHeadlineStatus status;
  final String title;
  final String excerpt;
  final String url;
  final String imageUrl;
  final Source? source;
  final Topic? topic;
  final Country? eventCountry;
  final HttpException? exception;
  final bool isBreaking;
  final Headline? createdHeadline;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      title.isNotEmpty &&
      excerpt.isNotEmpty &&
      url.isNotEmpty &&
      imageUrl.isNotEmpty &&
      source != null &&
      topic != null &&
      eventCountry != null &&
      !isBreaking; // If breaking, it must be published, not drafted.

  CreateHeadlineState copyWith({
    CreateHeadlineStatus? status,
    String? title,
    String? excerpt,
    String? url,
    String? imageUrl,
    ValueGetter<Source?>? source,
    ValueGetter<Topic?>? topic,
    ValueGetter<Country?>? eventCountry,
    bool? isBreaking,
    HttpException? exception,
    Headline? createdHeadline,
  }) {
    return CreateHeadlineState(
      status: status ?? this.status,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source != null ? source() : this.source,
      topic: topic != null ? topic() : this.topic,
      eventCountry: eventCountry != null ? eventCountry() : this.eventCountry,
      isBreaking: isBreaking ?? this.isBreaking,
      exception: exception,
      createdHeadline: createdHeadline ?? this.createdHeadline,
    );
  }

  @override
  List<Object?> get props => [
    status,
    title,
    excerpt,
    url,
    imageUrl,
    source,
    topic,
    eventCountry,
    isBreaking,
    exception,
    createdHeadline,
  ];
}
