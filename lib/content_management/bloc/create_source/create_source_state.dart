part of 'create_source_bloc.dart';

/// Represents the status of the create source operation.
enum CreateSourceStatus {
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

/// The state for the [CreateSourceBloc].
final class CreateSourceState extends Equatable {
  /// {@macro create_source_state}
  const CreateSourceState({
    this.status = CreateSourceStatus.initial,
    this.name = '',
    this.description = '',
    this.url = '',
    this.sourceType,
    this.language = '',
    this.headquarters,
    this.countries = const [],
    this.contentStatus = ContentStatus.active,
    this.errorMessage,
    this.createdSource,
  });

  final CreateSourceStatus status;
  final String name;
  final String description;
  final String url;
  final SourceType? sourceType;
  final String language;
  final Country? headquarters;
  final List<Country> countries;
  final ContentStatus contentStatus;
  final String? errorMessage;
  final Source? createdSource;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      name.isNotEmpty &&
      description.isNotEmpty &&
      url.isNotEmpty &&
      sourceType != null &&
      language.isNotEmpty &&
      headquarters != null;

  CreateSourceState copyWith({
    CreateSourceStatus? status,
    String? name,
    String? description,
    String? url,
    ValueGetter<SourceType?>? sourceType,
    String? language,
    ValueGetter<Country?>? headquarters,
    List<Country>? countries,
    ContentStatus? contentStatus,
    String? errorMessage,
    Source? createdSource,
  }) {
    return CreateSourceState(
      status: status ?? this.status,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      sourceType: sourceType != null ? sourceType() : this.sourceType,
      language: language ?? this.language,
      headquarters: headquarters != null ? headquarters() : this.headquarters,
      countries: countries ?? this.countries,
      contentStatus: contentStatus ?? this.contentStatus,
      errorMessage: errorMessage,
      createdSource: createdSource ?? this.createdSource,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    description,
    url,
    sourceType,
    language,
    headquarters,
    countries,
    contentStatus,
    errorMessage,
    createdSource,
  ];
}
