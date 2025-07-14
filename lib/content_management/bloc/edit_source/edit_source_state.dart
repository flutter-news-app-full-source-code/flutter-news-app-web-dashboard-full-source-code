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
    this.status = EditSourceStatus.initial,
    this.initialSource,
    this.name = '',
    this.description = '',
    this.url = '',
    this.sourceType,
    this.language = '',
    this.headquarters,
    this.countries = const [],
    this.contentStatus = ContentStatus.active,
    this.exception,
    this.updatedSource,
  });

  final EditSourceStatus status;
  final Source? initialSource;
  final String name;
  final String description;
  final String url;
  final SourceType? sourceType;
  final String language;
  final Country? headquarters;
  final List<Country> countries;
  final ContentStatus contentStatus;
  final HtHttpException? exception;
  final Source? updatedSource;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      name.isNotEmpty &&
      description.isNotEmpty &&
      url.isNotEmpty &&
      sourceType != null &&
      language.isNotEmpty &&
      headquarters != null;

  EditSourceState copyWith({
    EditSourceStatus? status,
    Source? initialSource,
    String? name,
    String? description,
    String? url,
    ValueGetter<SourceType?>? sourceType,
    String? language,
    ValueGetter<Country?>? headquarters,
    List<Country>? countries,
    ContentStatus? contentStatus,
    HtHttpException? exception,
    Source? updatedSource,
  }) {
    return EditSourceState(
      status: status ?? this.status,
      initialSource: initialSource ?? this.initialSource,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      sourceType: sourceType != null ? sourceType() : this.sourceType,
      language: language ?? this.language,
      headquarters: headquarters != null ? headquarters() : this.headquarters,
      countries: countries ?? this.countries,
      contentStatus: contentStatus ?? this.contentStatus,
      exception: exception,
      updatedSource: updatedSource ?? this.updatedSource,
    );
  }

  @override
  List<Object?> get props => [
    status,
    initialSource,
    name,
    description,
    url,
    sourceType,
    language,
    headquarters,
    countries,
    contentStatus,
    exception,
    updatedSource,
  ];
}
