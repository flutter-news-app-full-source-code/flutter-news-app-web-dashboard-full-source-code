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
    this.description = '',
    this.url = '',
    this.imageUrl = '',
    this.source,
    this.topic,
    this.sources = const [],
    this.topics = const [],
    this.contentStatus = ContentStatus.active,
    this.errorMessage,
    this.createdHeadline,
  });

  final CreateHeadlineStatus status;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final Source? source;
  final Topic? topic;
  final List<Source> sources;
  final List<Topic> topics;
  final ContentStatus contentStatus;
  final String? errorMessage;
  final Headline? createdHeadline;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid => title.isNotEmpty;

  CreateHeadlineState copyWith({
    CreateHeadlineStatus? status,
    String? title,
    String? description,
    String? url,
    String? imageUrl,
    ValueGetter<Source?>? source,
    ValueGetter<Topic?>? topic,
    List<Source>? sources,
    List<Topic>? topics,
    ContentStatus? contentStatus,
    String? errorMessage,
    Headline? createdHeadline,
  }) {
    return CreateHeadlineState(
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source != null ? source() : this.source,
      topic: topic != null ? topic() : this.topic,
      sources: sources ?? this.sources,
      topics: topics ?? this.topics,
      contentStatus: contentStatus ?? this.contentStatus,
      errorMessage: errorMessage,
      createdHeadline: createdHeadline ?? this.createdHeadline,
    );
  }

  @override
  List<Object?> get props => [
    status,
    title,
    description,
    url,
    imageUrl,
    source,
    topic,
    sources,
    topics,
    contentStatus,
    errorMessage,
    createdHeadline,
  ];
}
