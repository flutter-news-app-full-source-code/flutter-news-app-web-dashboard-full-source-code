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
  EditHeadlineState({
    this.status = EditHeadlineStatus.initial,
    this.initialHeadline,
    this.title = '',
    this.excerpt = '',
    this.url = '',
    this.imageUrl = '',
    this.source,
    this.topic,
    this.eventCountry,
    this.sources = const [],
    this.topics = const [],
    this.countries = const [],
    this.contentStatus = ContentStatus.active,
    this.exception,
    this.updatedHeadline,
  });

  final EditHeadlineStatus status;
  final Headline? initialHeadline;
  final String title;
  final String excerpt;
  final String url;
  final String imageUrl;
  final Source? source;
  final Topic? topic;
  final Country? eventCountry;
  final List<Source> sources;
  final List<Topic> topics;
  final List<Country> countries;
  final ContentStatus contentStatus;
  final HttpException? exception;
  final Headline? updatedHeadline;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      title.isNotEmpty &&
      excerpt.isNotEmpty &&
      url.isNotEmpty &&
      imageUrl.isNotEmpty &&
      source != null &&
      topic != null &&
      eventCountry != null;

  EditHeadlineState copyWith({
    EditHeadlineStatus? status,
    Headline? initialHeadline,
    String? title,
    String? excerpt,
    String? url,
    String? imageUrl,
    ValueGetter<Source?>? source,
    ValueGetter<Topic?>? topic,
    ValueGetter<Country?>? eventCountry,
    List<Source>? sources,
    List<Topic>? topics,
    List<Country>? countries,
    ContentStatus? contentStatus,
    HttpException? exception,
    Headline? updatedHeadline,
  }) {
    return EditHeadlineState(
      status: status ?? this.status,
      initialHeadline: initialHeadline ?? this.initialHeadline,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source != null ? source() : this.source,
      topic: topic != null ? topic() : this.topic,
      eventCountry: eventCountry != null ? eventCountry() : this.eventCountry,
      sources: sources ?? this.sources,
      topics: topics ?? this.topics,
      countries: countries ?? this.countries,
      contentStatus: contentStatus ?? this.contentStatus,
      exception: exception,
      updatedHeadline: updatedHeadline ?? this.updatedHeadline,
    );
  }

  @override
  List<Object?> get props => [
    status,
    initialHeadline,
    title,
    excerpt,
    url,
    imageUrl,
    source,
    topic,
    eventCountry,
    sources,
    topics,
    countries,
    contentStatus,
    exception,
    updatedHeadline,
  ];
}
