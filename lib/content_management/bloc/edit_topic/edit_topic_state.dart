part of 'edit_topic_bloc.dart';

/// Represents the status of the edit category operation.
enum EditCategoryStatus {
  /// Initial state, before any data is loaded.
  initial,

  /// Data is being loaded.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred.
  failure,

  /// The form is being submitted.
  submitting,
}

/// The state for the [EditCategoryBloc].
final class EditCategoryState extends Equatable {
  const EditCategoryState({
    this.status = EditCategoryStatus.initial,
    this.initialCategory,
    this.name = '',
    this.description = '',
    this.iconUrl = '',
    this.contentStatus = ContentStatus.active,
    this.errorMessage,
    this.updatedCategory,
  });

  final EditCategoryStatus status;
  final Category? initialCategory;
  final String name;
  final String description;
  final String iconUrl;
  final ContentStatus contentStatus;
  final String? errorMessage;
  final Category? updatedCategory;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid => name.isNotEmpty;

  EditCategoryState copyWith({
    EditCategoryStatus? status,
    Category? initialCategory,
    String? name,
    String? description,
    String? iconUrl,
    ContentStatus? contentStatus,
    String? errorMessage,
    Category? updatedCategory,
  }) {
    return EditCategoryState(
      status: status ?? this.status,
      initialCategory: initialCategory ?? this.initialCategory,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      contentStatus: contentStatus ?? this.contentStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      updatedCategory: updatedCategory ?? this.updatedCategory,
    );
  }

  @override
  List<Object?> get props => [
    status,
    initialCategory,
    name,
    description,
    iconUrl,
    contentStatus,
    errorMessage,
    updatedCategory,
  ];
}
