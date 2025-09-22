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

/// Event for when the topic's icon URL is changed.
final class CreateTopicIconUrlChanged extends CreateTopicEvent {
  const CreateTopicIconUrlChanged(this.iconUrl);
  final String iconUrl;
  @override
  List<Object?> get props => [iconUrl];
}

/// Event to save the topic as a draft.
final class CreateTopicSavedAsDraft extends CreateTopicEvent {
  const CreateTopicSavedAsDraft();
}

/// Event to publish the topic.
final class CreateTopicPublished extends CreateTopicEvent {
  const CreateTopicPublished();
}
