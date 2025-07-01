part of 'create_headline_bloc.dart';

/// Represents the status of the create headline operation.
enum CreateHeadlineStatus {
  /// Initial state, before any data is loaded.
  initial,

  /// Data is being loaded.
  loading,

  /// An operation completed successfully.
  success,

  /// An error occurred.
  failure,

  /// The form is being submitted.
  submitting,
}

/// The state for the [CreateHeadlineBloc].
final class CreateHeadlineState extends Equatable {
  const CreateHeadlineState({
    this.status = CreateHeadlineStatus.initial,
    this.title = '',
    this.description = '',
    this.url = '',
    this.imageUrl = '',
    this.source,
    this.category,
    this.sources = const [],
    this.categories = const [],
    this.errorMessage,
  });

  final CreateHeadlineStatus status;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final Source? source;
  final Category? category;
  final List<Source> sources;
  final List<Category> categories;
  final String? errorMessage;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid => title.isNotEmpty;

  CreateHeadlineState copyWith({
    CreateHeadlineStatus? status,
    String? title,
    String? description,
    String? url,
    String? imageUrl,
    ValueGetter<Source?>? source,
    ValueGetter<Category?>? category,
    List<Source>? sources,
    List<Category>? categories,
    String? errorMessage,
  }) {
    return CreateHeadlineState(
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source != null ? source() : this.source,
      category: category != null ? category() : this.category,
      sources: sources ?? this.sources,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        title,
        description,
        url,
        imageUrl,
        source,
        category,
        sources,
        categories,
        errorMessage,
      ];
}

