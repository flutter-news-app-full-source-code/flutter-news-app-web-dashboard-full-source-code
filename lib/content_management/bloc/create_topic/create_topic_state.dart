part of 'create_topic_bloc.dart';

/// Represents the status of the create topic operation.
enum CreateTopicStatus {
  /// Initial state.
  initial,

  /// The form is being submitted.
  submitting,

  /// The operation completed successfully.
  success,

  /// An error occurred.
  failure,
}

/// The state for the [CreateTopicBloc].
final class CreateTopicState extends Equatable {
  /// {@macro create_topic_state}
  const CreateTopicState({
    this.status = CreateTopicStatus.initial,
    this.name = '',
    this.description = '',
    this.iconUrl = '',
    this.contentStatus = ContentStatus.active,
    this.exception,
    this.createdTopic,
  });

  final CreateTopicStatus status;
  final String name;
  final String description;
  final String iconUrl;
  final ContentStatus contentStatus;
  final HttpException? exception;
  final Topic? createdTopic;

  /// Returns true if the form is valid and can be submitted.
  /// Based on the Topic model, name, description, and iconUrl are required.
  bool get isFormValid =>
      name.isNotEmpty && description.isNotEmpty && iconUrl.isNotEmpty;

  CreateTopicState copyWith({
    CreateTopicStatus? status,
    String? name,
    String? description,
    String? iconUrl,
    ContentStatus? contentStatus,
    HttpException? exception,
    Topic? createdTopic,
  }) {
    return CreateTopicState(
      status: status ?? this.status,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      contentStatus: contentStatus ?? this.contentStatus,
      exception: exception,
      createdTopic: createdTopic ?? this.createdTopic,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    description,
    iconUrl,
    contentStatus,
    exception,
    createdTopic,
  ];
}
