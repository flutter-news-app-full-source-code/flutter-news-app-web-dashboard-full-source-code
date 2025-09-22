part of 'create_source_bloc.dart';

/// Base class for all events related to the [CreateSourceBloc].
sealed class CreateSourceEvent extends Equatable {
  const CreateSourceEvent();

  @override
  List<Object?> get props => [];
}

/// Event for when the source's name is changed.
final class CreateSourceNameChanged extends CreateSourceEvent {
  const CreateSourceNameChanged(this.name);
  final String name;
  @override
  List<Object?> get props => [name];
}

/// Event for when the source's description is changed.
final class CreateSourceDescriptionChanged extends CreateSourceEvent {
  const CreateSourceDescriptionChanged(this.description);
  final String description;
  @override
  List<Object?> get props => [description];
}

/// Event for when the source's URL is changed.
final class CreateSourceUrlChanged extends CreateSourceEvent {
  const CreateSourceUrlChanged(this.url);
  final String url;
  @override
  List<Object?> get props => [url];
}

/// Event for when the source's type is changed.
final class CreateSourceTypeChanged extends CreateSourceEvent {
  const CreateSourceTypeChanged(this.sourceType);
  final SourceType? sourceType;
  @override
  List<Object?> get props => [sourceType];
}

/// Event for when the source's language is changed.
final class CreateSourceLanguageChanged extends CreateSourceEvent {
  const CreateSourceLanguageChanged(this.language);
  final Language? language;
  @override
  List<Object?> get props => [language];
}

/// Event for when the source's headquarters is changed.
final class CreateSourceHeadquartersChanged extends CreateSourceEvent {
  const CreateSourceHeadquartersChanged(this.headquarters);
  final Country? headquarters;
  @override
  List<Object?> get props => [headquarters];
}

/// Event to save the source as a draft.
final class CreateSourceSavedAsDraft extends CreateSourceEvent {
  const CreateSourceSavedAsDraft();
}

/// Event to publish the source.
final class CreateSourcePublished extends CreateSourceEvent {
  const CreateSourcePublished();
}
