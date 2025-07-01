part of 'create_headline_bloc.dart';

/// Base class for all events related to the [CreateHeadlineBloc].
abstract class CreateHeadlineEvent extends Equatable {
  const CreateHeadlineEvent();

  @override
  List<Object?> get props => [];
}

/// Event to signal that the data for dropdowns should be loaded.
class CreateHeadlineDataLoaded extends CreateHeadlineEvent {
  const CreateHeadlineDataLoaded();
}

/// Event for when the headline's title is changed.
class CreateHeadlineTitleChanged extends CreateHeadlineEvent {
  const CreateHeadlineTitleChanged(this.title);
  final String title;
  @override
  List<Object> get props => [title];
}

/// Event for when the headline's description is changed.
class CreateHeadlineDescriptionChanged extends CreateHeadlineEvent {
  const CreateHeadlineDescriptionChanged(this.description);
  final String description;
  @override
  List<Object> get props => [description];
}

/// Event for when the headline's URL is changed.
class CreateHeadlineUrlChanged extends CreateHeadlineEvent {
  const CreateHeadlineUrlChanged(this.url);
  final String url;
  @override
  List<Object> get props => [url];
}

/// Event for when the headline's image URL is changed.
class CreateHeadlineImageUrlChanged extends CreateHeadlineEvent {
  const CreateHeadlineImageUrlChanged(this.imageUrl);
  final String imageUrl;
  @override
  List<Object> get props => [imageUrl];
}

/// Event for when the headline's source is changed.
class CreateHeadlineSourceChanged extends CreateHeadlineEvent {
  const CreateHeadlineSourceChanged(this.source);
  final Source? source;
  @override
  List<Object?> get props => [source];
}

/// Event for when the headline's category is changed.
class CreateHeadlineCategoryChanged extends CreateHeadlineEvent {
  const CreateHeadlineCategoryChanged(this.category);
  final Category? category;
  @override
  List<Object?> get props => [category];
}

/// Event to signal that the form should be submitted.
class CreateHeadlineSubmitted extends CreateHeadlineEvent {
  const CreateHeadlineSubmitted();
}

