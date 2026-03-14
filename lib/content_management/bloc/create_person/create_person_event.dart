part of 'create_person_bloc.dart';

/// Base class for all events related to the [CreatePersonBloc].
sealed class CreatePersonEvent extends Equatable {
  const CreatePersonEvent();
  @override
  List<Object?> get props => [];
}

/// Event to initialize the BLoC with configured languages.
final class CreatePersonInitialized extends CreatePersonEvent {
  const CreatePersonInitialized({
    required this.enabledLanguages,
    required this.defaultLanguage,
  });
  final List<SupportedLanguage> enabledLanguages;
  final SupportedLanguage defaultLanguage;
  @override
  List<Object?> get props => [enabledLanguages, defaultLanguage];
}

/// Event for when the person's name is changed.
final class CreatePersonNameChanged extends CreatePersonEvent {
  const CreatePersonNameChanged(this.name);
  final Map<SupportedLanguage, String> name;
  @override
  List<Object?> get props => [name];
}

/// Event for when the person's description is changed.
final class CreatePersonDescriptionChanged extends CreatePersonEvent {
  const CreatePersonDescriptionChanged(this.description);
  final Map<SupportedLanguage, String> description;
  @override
  List<Object?> get props => [description];
}

/// Event for when the person's image is changed.
final class CreatePersonImageChanged extends CreatePersonEvent {
  const CreatePersonImageChanged({
    required this.imageFileBytes,
    required this.imageFileName,
  });
  final Uint8List imageFileBytes;
  final String imageFileName;
  @override
  List<Object?> get props => [imageFileBytes, imageFileName];
}

/// Event for when the person's image is removed.
final class CreatePersonImageRemoved extends CreatePersonEvent {
  const CreatePersonImageRemoved();
}

/// Event for when the language tab is changed.
final class CreatePersonLanguageTabChanged extends CreatePersonEvent {
  const CreatePersonLanguageTabChanged(this.language);
  final SupportedLanguage language;
  @override
  List<Object?> get props => [language];
}

/// Event to save the person as a draft.
final class CreatePersonSavedAsDraft extends CreatePersonEvent {
  const CreatePersonSavedAsDraft();
}

/// Event to publish the person.
final class CreatePersonPublished extends CreatePersonEvent {
  const CreatePersonPublished();
}

/// Event to request AI enrichment for the current person data.
final class CreatePersonEnrichmentRequested extends CreatePersonEvent {
  const CreatePersonEnrichmentRequested();
}
