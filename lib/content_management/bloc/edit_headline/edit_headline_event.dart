part of 'edit_headline_bloc.dart';

/// Base class for all events related to the [EditHeadlineBloc].
sealed class EditHeadlineEvent extends Equatable {
  const EditHeadlineEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the initial headline data for editing.
final class EditHeadlineLoaded extends EditHeadlineEvent {
  const EditHeadlineLoaded();
}

/// Event for when the headline's title is changed.
final class EditHeadlineTitleChanged extends EditHeadlineEvent {
  const EditHeadlineTitleChanged(this.title);
  final String title;
  @override
  List<Object?> get props => [title];
}

/// Event for when the headline's excerpt is changed.
final class EditHeadlineExcerptChanged extends EditHeadlineEvent {
  const EditHeadlineExcerptChanged(this.excerpt);
  final String excerpt;
  @override
  List<Object?> get props => [excerpt];
}

/// Event for when the headline's URL is changed.
final class EditHeadlineUrlChanged extends EditHeadlineEvent {
  const EditHeadlineUrlChanged(this.url);
  final String url;
  @override
  List<Object?> get props => [url];
}

/// Event for when the headline's image URL is changed.
final class EditHeadlineImageUrlChanged extends EditHeadlineEvent {
  const EditHeadlineImageUrlChanged(this.imageUrl);
  final String imageUrl;
  @override
  List<Object?> get props => [imageUrl];
}

/// Event for when the headline's source is changed.
final class EditHeadlineSourceChanged extends EditHeadlineEvent {
  const EditHeadlineSourceChanged(this.source);
  final Source? source;
  @override
  List<Object?> get props => [source];
}

/// Event for when the headline's topic is changed.
final class EditHeadlineTopicChanged extends EditHeadlineEvent {
  const EditHeadlineTopicChanged(this.topic);
  final Topic? topic;
  @override
  List<Object?> get props => [topic];
}

/// Event for when the headline's country is changed.
final class EditHeadlineCountryChanged extends EditHeadlineEvent {
  const EditHeadlineCountryChanged(this.country);
  final Country? country;
  @override
  List<Object?> get props => [country];
}

/// Event to save the headline as a draft.
final class EditHeadlineSavedAsDraft extends EditHeadlineEvent {
  const EditHeadlineSavedAsDraft();
}

/// Event to publish the headline.
final class EditHeadlinePublished extends EditHeadlineEvent {
  const EditHeadlinePublished();
}

/// Event for when the headline's breaking news status is changed.
final class EditHeadlineIsBreakingChanged extends EditHeadlineEvent {
  const EditHeadlineIsBreakingChanged(this.isBreaking);

  final bool isBreaking;
  @override
  List<Object?> get props => [isBreaking];
}
