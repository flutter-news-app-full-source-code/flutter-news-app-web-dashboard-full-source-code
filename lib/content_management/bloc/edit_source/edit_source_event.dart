part of 'edit_source_bloc.dart';

/// Base class for all events related to the [EditSourceBloc].
sealed class EditSourceEvent extends Equatable {
  const EditSourceEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the initial source data for editing.
final class EditSourceLoaded extends EditSourceEvent {
  const EditSourceLoaded();
}

/// Event triggered when the source name input changes.
final class EditSourceNameChanged extends EditSourceEvent {
  const EditSourceNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

/// Event triggered when the source description input changes.
final class EditSourceDescriptionChanged extends EditSourceEvent {
  const EditSourceDescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

/// Event triggered when the source URL input changes.
final class EditSourceUrlChanged extends EditSourceEvent {
  const EditSourceUrlChanged(this.url);

  final String url;

  @override
  List<Object?> get props => [url];
}

/// Event triggered when the source logo URL input changes.
final class EditSourceLogoUrlChanged extends EditSourceEvent {
  const EditSourceLogoUrlChanged(this.logoUrl);

  final String logoUrl;

  @override
  List<Object?> get props => [logoUrl];
}

/// Event triggered when the source type input changes.
final class EditSourceTypeChanged extends EditSourceEvent {
  const EditSourceTypeChanged(this.sourceType);

  final SourceType? sourceType;

  @override
  List<Object?> get props => [sourceType];
}

/// Event triggered when the source language input changes.
final class EditSourceLanguageChanged extends EditSourceEvent {
  const EditSourceLanguageChanged(this.language);
  final Language? language;

  @override
  List<Object?> get props => [language];
}

/// Event triggered when the source headquarters input changes.
final class EditSourceHeadquartersChanged extends EditSourceEvent {
  const EditSourceHeadquartersChanged(this.headquarters);

  final Country? headquarters;

  @override
  List<Object?> get props => [headquarters];
}

/// Event to save the source as a draft.
final class EditSourceSavedAsDraft extends EditSourceEvent {
  const EditSourceSavedAsDraft();
}

/// Event to publish the source.
final class EditSourcePublished extends EditSourceEvent {
  const EditSourcePublished();
}
