part of 'create_headline_bloc.dart';

/// Base class for all events related to the [CreateHeadlineBloc].
sealed class CreateHeadlineEvent extends Equatable {
  const CreateHeadlineEvent();

  @override
  List<Object?> get props => [];
}

/// Event for when the headline's title is changed.
final class CreateHeadlineTitleChanged extends CreateHeadlineEvent {
  const CreateHeadlineTitleChanged(this.title);
  final String title;
  @override
  List<Object?> get props => [title];
}

/// Event for when the headline's URL is changed.
final class CreateHeadlineUrlChanged extends CreateHeadlineEvent {
  const CreateHeadlineUrlChanged(this.url);
  final String url;
  @override
  List<Object?> get props => [url];
}

/// Event for when the headline's image is changed.
final class CreateHeadlineImageChanged extends CreateHeadlineEvent {
  const CreateHeadlineImageChanged({
    required this.imageFileBytes,
    required this.imageFileName,
  });
  final Uint8List imageFileBytes;
  final String imageFileName;
  @override
  List<Object?> get props => [imageFileBytes, imageFileName];
}

/// Event for when the headline's image is removed.
final class CreateHeadlineImageRemoved extends CreateHeadlineEvent {
  const CreateHeadlineImageRemoved();
}

/// Event for when the headline's source is changed.
final class CreateHeadlineSourceChanged extends CreateHeadlineEvent {
  const CreateHeadlineSourceChanged(this.source);
  final Source? source;
  @override
  List<Object?> get props => [source];
}

/// Event for when the headline's topic is changed.
final class CreateHeadlineTopicChanged extends CreateHeadlineEvent {
  const CreateHeadlineTopicChanged(this.topic);
  final Topic? topic;
  @override
  List<Object?> get props => [topic];
}

/// Event for when the headline's country is changed.
final class CreateHeadlineCountryChanged extends CreateHeadlineEvent {
  const CreateHeadlineCountryChanged(this.country);
  final Country? country;
  @override
  List<Object?> get props => [country];
}

/// Event to save the headline as a draft.
final class CreateHeadlineSavedAsDraft extends CreateHeadlineEvent {
  const CreateHeadlineSavedAsDraft();
}

/// Event to publish the headline.
final class CreateHeadlinePublished extends CreateHeadlineEvent {
  const CreateHeadlinePublished();
}

/// Event for when the headline's breaking news status is changed.
final class CreateHeadlineIsBreakingChanged extends CreateHeadlineEvent {
  const CreateHeadlineIsBreakingChanged(this.isBreaking);

  final bool isBreaking;
  @override
  List<Object?> get props => [isBreaking];
}
