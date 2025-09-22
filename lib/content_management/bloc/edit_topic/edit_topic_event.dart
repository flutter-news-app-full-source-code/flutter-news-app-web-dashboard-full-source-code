part of 'edit_topic_bloc.dart';

/// Base class for all events related to the [EditTopicBloc].
sealed class EditTopicEvent extends Equatable {
  const EditTopicEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the initial topic data for editing.
final class EditTopicLoaded extends EditTopicEvent {
  const EditTopicLoaded();
}

/// Event triggered when the topic name input changes.
final class EditTopicNameChanged extends EditTopicEvent {
  const EditTopicNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

/// Event triggered when the topic description input changes.
final class EditTopicDescriptionChanged extends EditTopicEvent {
  const EditTopicDescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

/// Event triggered when the topic icon URL input changes.
final class EditTopicIconUrlChanged extends EditTopicEvent {
  const EditTopicIconUrlChanged(this.iconUrl);

  final String iconUrl;

  @override
  List<Object?> get props => [iconUrl];
}

/// Event to save the topic as a draft.
final class EditTopicSavedAsDraft extends EditTopicEvent {
  const EditTopicSavedAsDraft();
}

/// Event to publish the topic.
final class EditTopicPublished extends EditTopicEvent {
  const EditTopicPublished();
}
