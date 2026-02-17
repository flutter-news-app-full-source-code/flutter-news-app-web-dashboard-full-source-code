part of 'create_topic_bloc.dart';

/// Base class for all events related to the [CreateTopicBloc].
sealed class CreateTopicEvent extends Equatable {
  const CreateTopicEvent();

  @override
  List<Object?> get props => [];
}

/// Event for when the topic's name is changed.
final class CreateTopicNameChanged extends CreateTopicEvent {
  const CreateTopicNameChanged(this.name);
  final String name;
  @override
  List<Object?> get props => [name];
}

/// Event for when the topic's description is changed.
final class CreateTopicDescriptionChanged extends CreateTopicEvent {
  const CreateTopicDescriptionChanged(this.description);
  final String description;
  @override
  List<Object?> get props => [description];
}

/// Event for when the topic's icon image is changed.
final class CreateTopicImageChanged extends CreateTopicEvent {
  const CreateTopicImageChanged({
    required this.imageFileBytes,
    required this.imageFileName,
  });

  final Uint8List imageFileBytes;
  final String imageFileName;

  @override
  List<Object?> get props => [imageFileBytes, imageFileName];
}

/// Event for when the topic's icon image is removed.
final class CreateTopicImageRemoved extends CreateTopicEvent {
  const CreateTopicImageRemoved();
}

/// Event to save the topic as a draft.
final class CreateTopicSavedAsDraft extends CreateTopicEvent {
  const CreateTopicSavedAsDraft();
}

/// Event to publish the topic.
final class CreateTopicPublished extends CreateTopicEvent {
  const CreateTopicPublished();
}
