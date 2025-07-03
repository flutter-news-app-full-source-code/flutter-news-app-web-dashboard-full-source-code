part of 'create_category_bloc.dart';

/// Represents the status of the create category operation.
enum CreateCategoryStatus {
  /// Initial state.
  initial,

  /// The form is being submitted.
  submitting,

  /// The operation completed successfully.
  success,

  /// An error occurred.
  failure,
}

/// The state for the [CreateCategoryBloc].
final class CreateCategoryState extends Equatable {
  /// {@macro create_category_state}
  const CreateCategoryState({
    this.status = CreateCategoryStatus.initial,
    this.name = '',
    this.description = '',
    this.iconUrl = '',
    this.contentStatus = ContentStatus.active,
    this.errorMessage,
    this.createdCategory,
  });

  final CreateCategoryStatus status;
  final String name;
  final String description;
  final String iconUrl;
  final ContentStatus contentStatus;
  final String? errorMessage;
  final Category? createdCategory;

  /// Returns true if the form is valid and can be submitted.
  /// Based on the Category model, only the name is required.
  bool get isFormValid => name.isNotEmpty;

  CreateCategoryState copyWith({
    CreateCategoryStatus? status,
    String? name,
    String? description,
    String? iconUrl,
    ContentStatus? contentStatus,
    String? errorMessage,
    Category? createdCategory,
  }) {
    return CreateCategoryState(
      status: status ?? this.status,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      contentStatus: contentStatus ?? this.contentStatus,
      errorMessage: errorMessage,
      createdCategory: createdCategory ?? this.createdCategory,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    description,
    iconUrl,
    contentStatus,
    errorMessage,
    createdCategory,
  ];
}
