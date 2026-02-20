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

/// Event for when the topic's icon image is changed.
final class EditTopicImageChanged extends EditTopicEvent {
  const EditTopicImageChanged({
    required this.imageFileBytes,
    required this.imageFileName,
  });

  final Uint8List imageFileBytes;
  final String imageFileName;

  @override
  List<Object?> get props => [imageFileBytes, imageFileName];
}

/// Event for when the topic's icon image is removed.
final class EditTopicImageRemoved extends EditTopicEvent {
  const EditTopicImageRemoved();
}

/// Event to save the topic as a draft.
final class EditTopicSavedAsDraft extends EditTopicEvent {
  const EditTopicSavedAsDraft();
}

/// Event to publish the topic.
final class EditTopicPublished extends EditTopicEvent {
  const EditTopicPublished();
}
