part of 'edit_topic_bloc.dart';

/// Represents the status of the edit topic operation.
enum EditTopicStatus {
  /// Initial state, before any data is loaded.
  initial,

  /// Data is being loaded.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred.
  failure,

  /// The form is being submitted.
  submitting,
}

/// The state for the [EditTopicBloc].
final class EditTopicState extends Equatable {
  const EditTopicState({
    required this.topicId,
    this.status = EditTopicStatus.initial,
    this.name = '',
    this.description = '',
    this.iconUrl = '',
    this.contentStatus = ContentStatus.active,
    this.exception,
    this.updatedTopic,
  });

  final EditTopicStatus status;
  final String topicId;
  final String name;
  final String description;
  final String iconUrl;
  final ContentStatus contentStatus;
  final HttpException? exception;
  final Topic? updatedTopic;

  /// Returns true if the form is valid and can be submitted.
  /// Based on the Topic model, name, description, and iconUrl are required.
  bool get isFormValid =>
      topicId.isNotEmpty &&
      name.isNotEmpty &&
      description.isNotEmpty &&
      iconUrl.isNotEmpty;

  EditTopicState copyWith({
    EditTopicStatus? status,
    String? topicId,
    String? name,
    String? description,
    String? iconUrl,
    ContentStatus? contentStatus,
    HttpException? exception,
    Topic? updatedTopic,
  }) {
    return EditTopicState(
      status: status ?? this.status,
      topicId: topicId ?? this.topicId,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      contentStatus: contentStatus ?? this.contentStatus,
      exception: exception ?? this.exception,
      updatedTopic: updatedTopic ?? this.updatedTopic,
    );
  }

  @override
  List<Object?> get props => [
    status,
    topicId,
    name,
    description,
    iconUrl,
    contentStatus,
    exception,
    updatedTopic,
  ];
}
