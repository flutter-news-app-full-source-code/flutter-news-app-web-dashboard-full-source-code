part of 'edit_person_bloc.dart';

/// Base class for all events related to the [EditPersonBloc].
sealed class EditPersonEvent extends Equatable {
  const EditPersonEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the initial person data for editing.
final class EditPersonLoaded extends EditPersonEvent {
  const EditPersonLoaded({
    required this.enabledLanguages,
    required this.defaultLanguage,
  });
  final List<SupportedLanguage> enabledLanguages;
  final SupportedLanguage defaultLanguage;
  @override
  List<Object?> get props => [enabledLanguages, defaultLanguage];
}

/// Event for when the person's name is changed.
final class EditPersonNameChanged extends EditPersonEvent {
  const EditPersonNameChanged(this.name);
  final Map<SupportedLanguage, String> name;
  @override
  List<Object?> get props => [name];
}

/// Event for when the person's description is changed.
final class EditPersonDescriptionChanged extends EditPersonEvent {
  const EditPersonDescriptionChanged(this.description);
  final Map<SupportedLanguage, String> description;
  @override
  List<Object?> get props => [description];
}

/// Event for when the person's image is changed.
final class EditPersonImageChanged extends EditPersonEvent {
  const EditPersonImageChanged({
    required this.imageFileBytes,
    required this.imageFileName,
  });
  final Uint8List imageFileBytes;
  final String imageFileName;
  @override
  List<Object?> get props => [imageFileBytes, imageFileName];
}

/// Event for when the person's image is removed.
final class EditPersonImageRemoved extends EditPersonEvent {
  const EditPersonImageRemoved();
}

/// Event for when the language tab is changed.
final class EditPersonLanguageTabChanged extends EditPersonEvent {
  const EditPersonLanguageTabChanged(this.language);
  final SupportedLanguage language;
  @override
  List<Object?> get props => [language];
}

/// Event to save the person as a draft.
final class EditPersonSavedAsDraft extends EditPersonEvent {
  const EditPersonSavedAsDraft();
}

/// Event to publish the person.
final class EditPersonPublished extends EditPersonEvent {
  const EditPersonPublished();
}
