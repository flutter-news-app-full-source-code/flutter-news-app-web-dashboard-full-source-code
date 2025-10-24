part of 'edit_source_bloc.dart';

/// Represents the status of the edit source operation.
enum EditSourceStatus {
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

/// The state for the [EditSourceBloc].
final class EditSourceState extends Equatable {
  const EditSourceState({
    required this.sourceId,
    this.status = EditSourceStatus.initial,
    this.name = '',
    this.description = '',
    this.url = '',
    this.logoUrl = '',
    this.sourceType,
    this.language,
    this.headquarters,
    this.exception,
    this.updatedSource,
  });

  final EditSourceStatus status;
  final String sourceId;
  final String name;
  final String description;
  final String url;
  final String logoUrl;
  final SourceType? sourceType;
  final Language? language;
  final Country? headquarters;
  final HttpException? exception;
  final Source? updatedSource;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      sourceId.isNotEmpty &&
      name.isNotEmpty &&
      description.isNotEmpty &&
      url.isNotEmpty &&
      logoUrl.isNotEmpty &&
      sourceType != null &&
      language != null &&
      headquarters != null;

  EditSourceState copyWith({
    EditSourceStatus? status,
    String? sourceId,
    String? name,
    String? description,
    String? url,
    String? logoUrl,
    ValueGetter<SourceType?>? sourceType,
    ValueGetter<Language?>? language,
    ValueGetter<Country?>? headquarters,
    HttpException? exception,
    Source? updatedSource,
  }) {
    return EditSourceState(
      status: status ?? this.status,
      sourceId: sourceId ?? this.sourceId,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      logoUrl: logoUrl ?? this.logoUrl,
      sourceType: sourceType != null ? sourceType() : this.sourceType,
      language: language != null ? language() : this.language,
      headquarters: headquarters != null ? headquarters() : this.headquarters,
      exception: exception,
      updatedSource: updatedSource ?? this.updatedSource,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sourceId,
    name,
    description,
    url,
    logoUrl,
    sourceType,
    language,
    headquarters,
    exception,
    updatedSource,
  ];
}
