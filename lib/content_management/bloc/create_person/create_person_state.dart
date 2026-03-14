part of 'create_person_bloc.dart';

/// Represents the status of the create person operation.
enum CreatePersonStatus {
  initial,
  loading,
  success,
  imageUploading,
  imageUploadFailure,
  entitySubmitting,
  entitySubmitFailure,
  enriching,
  enrichmentFailure,
}

/// The state for the [CreatePersonBloc].
final class CreatePersonState extends Equatable {
  const CreatePersonState({
    this.status = CreatePersonStatus.initial,
    this.name = const {},
    this.description = const {},
    this.imageFileBytes,
    this.imageFileName,
    this.exception,
    this.createdPerson,
    this.enabledLanguages = const [SupportedLanguage.en],
    this.defaultLanguage = SupportedLanguage.en,
    SupportedLanguage? selectedLanguage,
    this.isEnrichmentSuccessful = false,
    this.wasNameEnriched = false,
    this.wasDescriptionEnriched = false,
  }) : selectedLanguage = selectedLanguage ?? defaultLanguage;

  final CreatePersonStatus status;
  final Map<SupportedLanguage, String> name;
  final Map<SupportedLanguage, String> description;
  final Uint8List? imageFileBytes;
  final String? imageFileName;
  final HttpException? exception;
  final Person? createdPerson;
  final List<SupportedLanguage> enabledLanguages;
  final SupportedLanguage defaultLanguage;
  final SupportedLanguage selectedLanguage;
  final bool isEnrichmentSuccessful;
  final bool wasNameEnriched;
  final bool wasDescriptionEnriched;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid => name[defaultLanguage]?.isNotEmpty ?? false;

  CreatePersonState copyWith({
    CreatePersonStatus? status,
    Map<SupportedLanguage, String>? name,
    Map<SupportedLanguage, String>? description,
    ValueWrapper<Uint8List?>? imageFileBytes,
    ValueWrapper<String?>? imageFileName,
    ValueWrapper<HttpException?>? exception,
    Person? createdPerson,
    List<SupportedLanguage>? enabledLanguages,
    SupportedLanguage? defaultLanguage,
    SupportedLanguage? selectedLanguage,
    bool? isEnrichmentSuccessful,
    bool? wasNameEnriched,
    bool? wasDescriptionEnriched,
  }) {
    return CreatePersonState(
      status: status ?? this.status,
      name: name ?? this.name,
      description: description ?? this.description,
      imageFileBytes: imageFileBytes != null
          ? imageFileBytes.value
          : this.imageFileBytes,
      imageFileName: imageFileName != null
          ? imageFileName.value
          : this.imageFileName,
      exception: exception != null ? exception.value : this.exception,
      createdPerson: createdPerson ?? this.createdPerson,
      enabledLanguages: enabledLanguages ?? this.enabledLanguages,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isEnrichmentSuccessful:
          isEnrichmentSuccessful ?? this.isEnrichmentSuccessful,
      wasNameEnriched: wasNameEnriched ?? this.wasNameEnriched,
      wasDescriptionEnriched:
          wasDescriptionEnriched ?? this.wasDescriptionEnriched,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    description,
    imageFileBytes,
    imageFileName,
    exception,
    createdPerson,
    enabledLanguages,
    defaultLanguage,
    selectedLanguage,
    isEnrichmentSuccessful,
    wasNameEnriched,
    wasDescriptionEnriched,
  ];
}
