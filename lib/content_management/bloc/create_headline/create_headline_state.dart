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
    this.sources = const [],
    this.topics = const [],
    this.countries = const [],
    this.countriesHasMore = true,
    this.countriesIsLoadingMore = false,
    this.countriesCursor,
    this.contentStatus = ContentStatus.active,
    this.exception,
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
  final List<Source> sources;
  final List<Topic> topics;
  final List<Country> countries;
  final bool countriesHasMore;
  final bool countriesIsLoadingMore;
  final String? countriesCursor;
  final ContentStatus contentStatus;
  final HttpException? exception;
  final Headline? createdHeadline;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      title.isNotEmpty &&
      excerpt.isNotEmpty &&
      url.isNotEmpty &&
      imageUrl.isNotEmpty &&
      source != null &&
      topic != null &&
      eventCountry != null;

  CreateHeadlineState copyWith({
    CreateHeadlineStatus? status,
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
    bool? countriesHasMore,
    bool? countriesIsLoadingMore,
    String? countriesCursor,
    ContentStatus? contentStatus,
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
      sources: sources ?? this.sources,
      topics: topics ?? this.topics,
      countries: countries ?? this.countries,
      countriesHasMore: countriesHasMore ?? this.countriesHasMore,
      countriesIsLoadingMore:
          countriesIsLoadingMore ?? this.countriesIsLoadingMore,
      countriesCursor: countriesCursor ?? this.countriesCursor,
      contentStatus: contentStatus ?? this.contentStatus,
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
    sources,
    topics,
    countries,
    countriesHasMore,
    countriesIsLoadingMore,
    countriesCursor,
    contentStatus,
    exception,
    createdHeadline,
  ];
}
