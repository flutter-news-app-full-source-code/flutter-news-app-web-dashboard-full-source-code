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
    this.errorMessage,
  });

  final CreateCategoryStatus status;
  final String name;
  final String description;
  final String iconUrl;
  final String? errorMessage;

  /// Returns true if the form is valid and can be submitted.
  /// Based on the Category model, only the name is required.
  bool get isFormValid => name.isNotEmpty;

  CreateCategoryState copyWith({
    CreateCategoryStatus? status,
    String? name,
    String? description,
    String? iconUrl,
    String? errorMessage,
  }) {
    return CreateCategoryState(
      status: status ?? this.status,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, name, description, iconUrl, errorMessage];
}
