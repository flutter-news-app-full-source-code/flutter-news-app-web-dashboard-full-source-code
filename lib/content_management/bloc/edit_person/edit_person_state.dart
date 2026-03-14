part of 'edit_person_bloc.dart';

/// Represents the status of the edit person operation.
enum EditPersonStatus {
  initial,
  loading,
  success,
  failure,
  imageUploading,
  imageUploadFailure,
  entitySubmitting,
  entitySubmitFailure,
}

/// The state for the [EditPersonBloc].
final class EditPersonState extends Equatable {
  const EditPersonState({
    required this.personId,
    this.status = EditPersonStatus.initial,
    this.name = const {},
    this.description = const {},
    this.imageUrl,
    this.imageFileBytes,
    this.imageFileName,
    this.exception,
    this.updatedPerson,
    this.imageRemoved = false,
    this.initialPerson,
    this.enabledLanguages = const [SupportedLanguage.en],
    this.defaultLanguage = SupportedLanguage.en,
    SupportedLanguage? selectedLanguage,
  }) : selectedLanguage = selectedLanguage ?? defaultLanguage;

  final EditPersonStatus status;
  final String personId;
  final Map<SupportedLanguage, String> name;
  final Map<SupportedLanguage, String> description;
  final String? imageUrl;
  final Uint8List? imageFileBytes;
  final String? imageFileName;
  final HttpException? exception;
  final Person? updatedPerson;
  final bool imageRemoved;
  final Person? initialPerson;
  final List<SupportedLanguage> enabledLanguages;
  final SupportedLanguage defaultLanguage;
  final SupportedLanguage selectedLanguage;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid {
    return personId.isNotEmpty && (name[defaultLanguage]?.isNotEmpty ?? false);
  }

  EditPersonState copyWith({
    EditPersonStatus? status,
    String? personId,
    Map<SupportedLanguage, String>? name,
    Map<SupportedLanguage, String>? description,
    ValueWrapper<String?>? imageUrl,
    ValueWrapper<Uint8List?>? imageFileBytes,
    ValueWrapper<String?>? imageFileName,
    ValueWrapper<HttpException?>? exception,
    Person? updatedPerson,
    bool? imageRemoved,
    Person? initialPerson,
    List<SupportedLanguage>? enabledLanguages,
    SupportedLanguage? defaultLanguage,
    SupportedLanguage? selectedLanguage,
  }) {
    return EditPersonState(
      status: status ?? this.status,
      personId: personId ?? this.personId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl != null ? imageUrl.value : this.imageUrl,
      imageFileBytes: imageFileBytes != null
          ? imageFileBytes.value
          : this.imageFileBytes,
      imageFileName: imageFileName != null
          ? imageFileName.value
          : this.imageFileName,
      exception: exception != null ? exception.value : this.exception,
      updatedPerson: updatedPerson ?? this.updatedPerson,
      imageRemoved: imageRemoved ?? this.imageRemoved,
      initialPerson: initialPerson ?? this.initialPerson,
      enabledLanguages: enabledLanguages ?? this.enabledLanguages,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    personId,
    name,
    description,
    imageUrl,
    imageFileBytes,
    imageFileName,
    exception,
    updatedPerson,
    imageRemoved,
    initialPerson,
    enabledLanguages,
    defaultLanguage,
    selectedLanguage,
  ];
}
