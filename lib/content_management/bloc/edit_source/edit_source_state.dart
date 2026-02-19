part of 'edit_source_bloc.dart';

/// Represents the status of the edit source operation.
enum EditSourceStatus {
  initial,
  loading,
  success,
  failure,
  imageUploading,
  imageUploadFailure,
  entitySubmitting,
  entitySubmitFailure,
}

/// The state for the [EditSourceBloc].
final class EditSourceState extends Equatable {
  const EditSourceState({
    required this.sourceId,
    this.status = EditSourceStatus.initial,
    this.name = '',
    this.description = '',
    this.url = '',
    this.logoUrl,
    this.imageFileBytes,
    this.imageFileName,
    this.sourceType,
    this.language,
    this.headquarters,
    this.updatedSource,
    this.exception,
    this.imageRemoved = false,
    this.initialSource,
  });

  final EditSourceStatus status;
  final String sourceId;
  final String name;
  final String description;
  final String url;
  final String? logoUrl;
  final Uint8List? imageFileBytes;
  final String? imageFileName;
  final SourceType? sourceType;
  final Language? language;
  final Country? headquarters;
  final HttpException? exception; // Used for all failure types
  final Source? updatedSource;
  final bool imageRemoved;
  final Source? initialSource;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid {
    // An image is considered present if there's a new one selected,
    // or if there was an initial one that hasn't been explicitly removed.
    final hasImage =
        imageFileBytes != null || (logoUrl != null && !imageRemoved);

    return sourceId.isNotEmpty &&
        name.isNotEmpty &&
        description.isNotEmpty &&
        url.isNotEmpty &&
        hasImage &&
        sourceType != null &&
        language != null &&
        headquarters != null;
  }

  EditSourceState copyWith({
    EditSourceStatus? status,
    String? sourceId,
    String? name,
    String? description,
    String? url,
    ValueWrapper<String?>? logoUrl,
    ValueWrapper<Uint8List?>? imageFileBytes,
    ValueWrapper<String?>? imageFileName,
    ValueGetter<SourceType?>? sourceType,
    ValueGetter<Language?>? language,
    ValueGetter<Country?>? headquarters,
    ValueWrapper<HttpException?>? exception,
    Source? updatedSource,
    bool? imageRemoved,
    Source? initialSource,
  }) {
    return EditSourceState(
      status: status ?? this.status,
      sourceId: sourceId ?? this.sourceId,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      logoUrl: logoUrl != null ? logoUrl.value : this.logoUrl,
      imageFileBytes: imageFileBytes != null
          ? imageFileBytes.value
          : this.imageFileBytes,
      imageFileName: imageFileName != null
          ? imageFileName.value
          : this.imageFileName,
      sourceType: sourceType != null ? sourceType() : this.sourceType,
      language: language != null ? language() : this.language,
      headquarters: headquarters != null ? headquarters() : this.headquarters,
      exception: exception != null ? exception.value : this.exception,
      updatedSource: updatedSource ?? this.updatedSource,
      imageRemoved: imageRemoved ?? this.imageRemoved,
      initialSource: initialSource ?? this.initialSource,
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
    imageFileBytes,
    imageFileName,
    sourceType,
    language,
    headquarters,
    exception,
    updatedSource,
    imageRemoved,
    initialSource,
  ];
}
