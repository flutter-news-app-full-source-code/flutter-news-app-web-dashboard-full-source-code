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

/// Event for when the source's status is changed.
final class EditSourceStatusChanged extends EditSourceEvent {
  const EditSourceStatusChanged(this.status);

  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// Event to submit the edited source data.
final class EditSourceSubmitted extends EditSourceEvent {
  const EditSourceSubmitted();
}

/// Event to request loading more countries.
final class EditSourceLoadMoreCountriesRequested extends EditSourceEvent {
  const EditSourceLoadMoreCountriesRequested();
}

/// Event to request loading more languages.
final class EditSourceLoadMoreLanguagesRequested extends EditSourceEvent {
  const EditSourceLoadMoreLanguagesRequested();
}
