part of 'create_topic_bloc.dart';

/// Represents the status of the create topic operation.
enum CreateTopicStatus {
  initial,
  loading,
  success,
  failure,
  imageUploading,
  imageUploadFailure,
  entitySubmitting,
  entitySubmitFailure,
}

/// The state for the [CreateTopicBloc].
final class CreateTopicState extends Equatable {
  /// {@macro create_topic_state}
  const CreateTopicState({
    this.status = CreateTopicStatus.initial,
    this.name = const {},
    this.description = const {},
    this.imageFileBytes,
    this.imageFileName,
    this.createdTopic,
    this.exception,
    this.enabledLanguages = const [SupportedLanguage.en],
    this.defaultLanguage = SupportedLanguage.en,
    SupportedLanguage? selectedLanguage,
  }) : selectedLanguage = selectedLanguage ?? defaultLanguage;

  final CreateTopicStatus status;
  final Map<SupportedLanguage, String> name;
  final Map<SupportedLanguage, String> description;
  final Uint8List? imageFileBytes;
  final String? imageFileName;
  final HttpException? exception; // Used for both image and entity failures
  final Topic? createdTopic;
  final List<SupportedLanguage> enabledLanguages;
  final SupportedLanguage defaultLanguage;
  final SupportedLanguage selectedLanguage;

  /// Returns true if the form is valid and can be submitted.
  /// Based on the Topic model, name, description, and iconUrl are required.
  bool get isFormValid =>
      (name[defaultLanguage]?.isNotEmpty ?? false) &&
      (description[defaultLanguage]?.isNotEmpty ?? false) &&
      imageFileBytes != null &&
      imageFileName != null;

  CreateTopicState copyWith({
    CreateTopicStatus? status,
    Map<SupportedLanguage, String>? name,
    Map<SupportedLanguage, String>? description,
    ValueWrapper<Uint8List?>? imageFileBytes,
    ValueWrapper<String?>? imageFileName,
    ValueWrapper<HttpException?>? exception,
    Topic? createdTopic,
    List<SupportedLanguage>? enabledLanguages,
    SupportedLanguage? defaultLanguage,
    SupportedLanguage? selectedLanguage,
  }) {
    return CreateTopicState(
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
      createdTopic: createdTopic ?? this.createdTopic,
      enabledLanguages: enabledLanguages ?? this.enabledLanguages,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
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
    createdTopic,
    enabledLanguages,
    defaultLanguage,
    selectedLanguage,
  ];
}
