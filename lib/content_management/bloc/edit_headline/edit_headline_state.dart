part of 'edit_headline_bloc.dart';

/// Represents the status of the edit headline operation.
enum EditHeadlineStatus {
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

/// The state for the [EditHeadlineBloc].
final class EditHeadlineState extends Equatable {
  const EditHeadlineState({
    required this.headlineId,
    this.status = EditHeadlineStatus.initial,
    this.title = '',
    this.excerpt = '',
    this.url = '',
    this.imageUrl = '',
    this.source,
    this.topic,
    this.eventCountry,
    this.contentStatus = ContentStatus.active,
    this.exception,
    this.updatedHeadline,
  });

  final EditHeadlineStatus status;
  final String headlineId;
  final String title;
  final String excerpt;
  final String url;
  final String imageUrl;
  final Source? source;
  final Topic? topic;
  final Country? eventCountry;
  final ContentStatus contentStatus;
  final HttpException? exception;
  final Headline? updatedHeadline;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      headlineId.isNotEmpty &&
      title.isNotEmpty &&
      excerpt.isNotEmpty &&
      url.isNotEmpty &&
      imageUrl.isNotEmpty &&
      source != null &&
      topic != null &&
      eventCountry != null;

  EditHeadlineState copyWith({
    EditHeadlineStatus? status,
    String? headlineId,
    String? title,
    String? excerpt,
    String? url,
    String? imageUrl,
    ValueGetter<Source?>? source,
    ValueGetter<Topic?>? topic,
    ValueGetter<Country?>? eventCountry,
    ContentStatus? contentStatus,
    HttpException? exception,
    Headline? updatedHeadline,
  }) {
    return EditHeadlineState(
      status: status ?? this.status,
      headlineId: headlineId ?? this.headlineId,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source != null ? source() : this.source,
      topic: topic != null ? topic() : this.topic,
      eventCountry: eventCountry != null ? eventCountry() : this.eventCountry,
      contentStatus: contentStatus ?? this.contentStatus,
      exception: exception,
      updatedHeadline: updatedHeadline ?? this.updatedHeadline,
    );
  }

  @override
  List<Object?> get props => [
    status,
    headlineId,
    title,
    excerpt,
    url,
    imageUrl,
    source,
    topic,
    eventCountry,
    contentStatus,
    exception,
    updatedHeadline,
  ];
}
