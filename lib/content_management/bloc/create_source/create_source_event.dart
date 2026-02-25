part of 'create_source_bloc.dart';

/// Base class for all events related to the [CreateSourceBloc].
sealed class CreateSourceEvent extends Equatable {
  const CreateSourceEvent();

  @override
  List<Object?> get props => [];
}

/// Event when the page is loaded.
final class CreateSourceLoaded extends CreateSourceEvent {
  const CreateSourceLoaded({
    required this.enabledLanguages,
    required this.defaultLanguage,
  });

  final List<SupportedLanguage> enabledLanguages;
  final SupportedLanguage defaultLanguage;

  @override
  List<Object?> get props => [enabledLanguages, defaultLanguage];
}

/// Event for when the source's name is changed.
final class CreateSourceNameChanged extends CreateSourceEvent {
  const CreateSourceNameChanged(this.name, this.language);
  final String name;
  final SupportedLanguage language;
  @override
  List<Object?> get props => [name, language];
}

/// Event for when the source's description is changed.
final class CreateSourceDescriptionChanged extends CreateSourceEvent {
  const CreateSourceDescriptionChanged(this.description, this.language);
  final String description;
  final SupportedLanguage language;
  @override
  List<Object?> get props => [description, language];
}

/// Event for when the source's URL is changed.
final class CreateSourceUrlChanged extends CreateSourceEvent {
  const CreateSourceUrlChanged(this.url);
  final String url;
  @override
  List<Object?> get props => [url];
}

/// Event for when the source's logo image is changed.
final class CreateSourceImageChanged extends CreateSourceEvent {
  const CreateSourceImageChanged({
    required this.imageFileBytes,
    required this.imageFileName,
  });

  final Uint8List imageFileBytes;
  final String imageFileName;

  @override
  List<Object?> get props => [imageFileBytes, imageFileName];
}

/// Event for when the source's logo image is removed.
final class CreateSourceImageRemoved extends CreateSourceEvent {
  const CreateSourceImageRemoved();
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
  final SupportedLanguage? language;
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
