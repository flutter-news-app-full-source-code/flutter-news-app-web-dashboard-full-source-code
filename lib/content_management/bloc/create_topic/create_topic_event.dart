part of 'create_topic_bloc.dart';

/// Base class for all events related to the [CreateCategoryBloc].
sealed class CreateCategoryEvent extends Equatable {
  const CreateCategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Event for when the category's name is changed.
final class CreateCategoryNameChanged extends CreateCategoryEvent {
  const CreateCategoryNameChanged(this.name);
  final String name;
  @override
  List<Object?> get props => [name];
}

/// Event for when the category's description is changed.
final class CreateCategoryDescriptionChanged extends CreateCategoryEvent {
  const CreateCategoryDescriptionChanged(this.description);
  final String description;
  @override
  List<Object?> get props => [description];
}

/// Event for when the category's icon URL is changed.
final class CreateCategoryIconUrlChanged extends CreateCategoryEvent {
  const CreateCategoryIconUrlChanged(this.iconUrl);
  final String iconUrl;
  @override
  List<Object?> get props => [iconUrl];
}

/// Event for when the category's status is changed.
final class CreateCategoryStatusChanged extends CreateCategoryEvent {
  const CreateCategoryStatusChanged(this.status);

  final ContentStatus status;
  @override
  List<Object?> get props => [status];
}

/// Event to signal that the form should be submitted.
final class CreateCategorySubmitted extends CreateCategoryEvent {
  const CreateCategorySubmitted();
}
