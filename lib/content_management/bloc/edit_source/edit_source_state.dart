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
    this.errorMessage,
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
  final String? errorMessage;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid => name.isNotEmpty;

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
    String? errorMessage,
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
      errorMessage: errorMessage ?? this.errorMessage,
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
    errorMessage,
  ];
}
