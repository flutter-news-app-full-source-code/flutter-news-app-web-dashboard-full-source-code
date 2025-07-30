part of 'create_source_bloc.dart';

import 'package:language_picker/language_picker.dart' as language_picker;
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
    this.language,
    this.headquarters,
    this.contentStatus = ContentStatus.active,
    this.exception,
    this.createdSource,
  });

  final CreateSourceStatus status;
  final String name;
  final String description;
  final String url;
  final SourceType? sourceType;
  final language_picker.Language? language;
  final Country? headquarters;
  final ContentStatus contentStatus;
  final HttpException? exception;
  final Source? createdSource;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      name.isNotEmpty &&
      description.isNotEmpty &&
      url.isNotEmpty &&
      sourceType != null &&
      language != null &&
      headquarters != null;

  CreateSourceState copyWith({
    CreateSourceStatus? status,
    String? name,
    String? description,
    String? url,
    ValueGetter<SourceType?>? sourceType,
    ValueGetter<language_picker.Language?>? language,
    ValueGetter<Country?>? headquarters,
    ContentStatus? contentStatus,
    HttpException? exception,
    Source? createdSource,
  }) {
    return CreateSourceState(
      status: status ?? this.status,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      sourceType: sourceType != null ? sourceType() : this.sourceType,
      language: language != null ? language() : this.language,
      headquarters: headquarters != null ? headquarters() : this.headquarters,
      contentStatus: contentStatus ?? this.contentStatus,
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
    sourceType,
    language,
    headquarters,
    contentStatus,
    exception,
    createdSource,
  ];
}
