part of 'create_source_bloc.dart';

/// Represents the status of the create source operation.
enum CreateSourceStatus {
  initial,
  loading,
  success,
  failure,
  imageUploading,
  imageUploadFailure,
  entitySubmitting,
  entitySubmitFailure,
}

/// The state for the [CreateSourceBloc].
final class CreateSourceState extends Equatable {
  /// {@macro create_source_state}
  const CreateSourceState({
    this.status = CreateSourceStatus.initial,
    this.name = const {},
    this.description = const {},
    this.url = '',
    this.imageFileBytes,
    this.imageFileName,
    this.sourceType,
    this.language,
    this.headquarters,
    this.createdSource,
    this.exception,
    this.enabledLanguages = const [SupportedLanguage.en],
    this.defaultLanguage = SupportedLanguage.en,
  });

  final CreateSourceStatus status;
  final Map<SupportedLanguage, String> name;
  final Map<SupportedLanguage, String> description;
  final String url;
  final Uint8List? imageFileBytes;
  final String? imageFileName;
  final SourceType? sourceType;
  final SupportedLanguage? language;
  final Country? headquarters;
  final HttpException? exception; // Used for both image and entity failures
  final Source? createdSource;
  final List<SupportedLanguage> enabledLanguages;
  final SupportedLanguage defaultLanguage;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      (name[defaultLanguage]?.isNotEmpty ?? false) &&
      (description[defaultLanguage]?.isNotEmpty ?? false) &&
      url.isNotEmpty &&
      imageFileBytes != null &&
      imageFileName != null &&
      sourceType != null &&
      language != null &&
      headquarters != null;

  CreateSourceState copyWith({
    CreateSourceStatus? status,
    Map<SupportedLanguage, String>? name,
    Map<SupportedLanguage, String>? description,
    String? url,
    ValueWrapper<Uint8List?>? imageFileBytes,
    ValueWrapper<String?>? imageFileName,
    ValueGetter<SourceType?>? sourceType,
    ValueGetter<SupportedLanguage?>? language,
    ValueGetter<Country?>? headquarters,
    ValueWrapper<HttpException?>? exception,
    Source? createdSource,
    List<SupportedLanguage>? enabledLanguages,
    SupportedLanguage? defaultLanguage,
  }) {
    return CreateSourceState(
      status: status ?? this.status,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      imageFileBytes: imageFileBytes != null
          ? imageFileBytes.value
          : this.imageFileBytes,
      imageFileName: imageFileName != null
          ? imageFileName.value
          : this.imageFileName,
      sourceType: sourceType != null ? sourceType() : this.sourceType,
      language: language != null ? language() : this.language,
      headquarters: headquarters != null ? headquarters() : this.headquarters,
      enabledLanguages: enabledLanguages ?? this.enabledLanguages,
      exception: exception != null ? exception.value : this.exception,
      createdSource: createdSource ?? this.createdSource,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    description,
    url,
    imageFileBytes,
    imageFileName,
    sourceType,
    language,
    headquarters,
    enabledLanguages,
    exception,
    createdSource,
    defaultLanguage,
  ];
}
