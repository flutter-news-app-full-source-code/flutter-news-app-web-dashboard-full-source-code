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
    this.logoUrl = '',
    this.sourceType,
    this.language,
    this.headquarters,
    this.exception,
    this.createdSource,
  });

  final CreateSourceStatus status;
  final String name;
  final String description;
  final String url;
  final String logoUrl;
  final SourceType? sourceType;
  final Language? language;
  final Country? headquarters;
  final HttpException? exception;
  final Source? createdSource;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      name.isNotEmpty &&
      description.isNotEmpty &&
      url.isNotEmpty &&
      logoUrl.isNotEmpty &&
      sourceType != null &&
      language != null &&
      headquarters != null;

  CreateSourceState copyWith({
    CreateSourceStatus? status,
    String? name,
    String? description,
    String? url,
    String? logoUrl,
    ValueGetter<SourceType?>? sourceType,
    ValueGetter<Language?>? language,
    ValueGetter<Country?>? headquarters,
    HttpException? exception,
    Source? createdSource,
  }) {
    return CreateSourceState(
      status: status ?? this.status,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      logoUrl: logoUrl ?? this.logoUrl,
      sourceType: sourceType != null ? sourceType() : this.sourceType,
      language: language != null ? language() : this.language,
      headquarters: headquarters != null ? headquarters() : this.headquarters,
      exception: exception,
      createdSource: createdSource ?? this.createdSource,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    description,
    url,
    logoUrl,
    sourceType,
    language,
    headquarters,
    exception,
    createdSource,
  ];
}
