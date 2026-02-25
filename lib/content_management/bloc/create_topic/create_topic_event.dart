part of 'create_topic_bloc.dart';

/// Base class for all events related to the [CreateTopicBloc].
sealed class CreateTopicEvent extends Equatable {
  const CreateTopicEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the BLoC, fetching necessary config.
final class CreateTopicInitialized extends CreateTopicEvent {
  const CreateTopicInitialized({
    required this.enabledLanguages,
    required this.defaultLanguage,
  });
  final List<SupportedLanguage> enabledLanguages;
  final SupportedLanguage defaultLanguage;
  @override
  List<Object?> get props => [enabledLanguages, defaultLanguage];
}

/// Event for when the topic's name is changed.
final class CreateTopicNameChanged extends CreateTopicEvent {
  const CreateTopicNameChanged(this.name, this.language);
  final String name;
  final SupportedLanguage language;
  @override
  List<Object?> get props => [name, language];
}

/// Event for when the topic's description is changed.
final class CreateTopicDescriptionChanged extends CreateTopicEvent {
  const CreateTopicDescriptionChanged(this.description, this.language);
  final String description;
  final SupportedLanguage language;
  @override
  List<Object?> get props => [description, language];
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
