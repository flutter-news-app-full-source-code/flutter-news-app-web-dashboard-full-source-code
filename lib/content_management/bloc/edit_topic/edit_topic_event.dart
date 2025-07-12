part of 'edit_topic_bloc.dart';

/// Base class for all events related to the [EditCategoryBloc].
sealed class EditCategoryEvent extends Equatable {
  const EditCategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the initial category data for editing.
final class EditCategoryLoaded extends EditCategoryEvent {
  const EditCategoryLoaded();
}

/// Event triggered when the category name input changes.
final class EditCategoryNameChanged extends EditCategoryEvent {
  const EditCategoryNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

/// Event triggered when the category description input changes.
final class EditCategoryDescriptionChanged extends EditCategoryEvent {
  const EditCategoryDescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

/// Event triggered when the category icon URL input changes.
final class EditCategoryIconUrlChanged extends EditCategoryEvent {
  const EditCategoryIconUrlChanged(this.iconUrl);

  final String iconUrl;

  @override
  List<Object?> get props => [iconUrl];
}

/// Event for when the category's status is changed.
final class EditCategoryStatusChanged extends EditCategoryEvent {
  const EditCategoryStatusChanged(this.status);

  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// Event to submit the edited category data.
final class EditCategorySubmitted extends EditCategoryEvent {
  const EditCategorySubmitted();
}
