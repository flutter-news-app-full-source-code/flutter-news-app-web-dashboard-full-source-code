part of 'edit_topic_bloc.dart';

/// Represents the status of the edit topic operation.
enum EditTopicStatus {
  initial,
  loading,
  success,
  failure,
  imageUploading,
  imageUploadFailure,
  entitySubmitting,
  entitySubmitFailure,
}

/// The state for the [EditTopicBloc].
final class EditTopicState extends Equatable {
  const EditTopicState({
    required this.topicId,
    this.status = EditTopicStatus.initial,
    this.name = const {},
    this.description = const {},
    this.iconUrl,
    this.imageFileBytes,
    this.imageFileName,
    this.exception,
    this.updatedTopic,
    this.imageRemoved = false,
    this.initialTopic,
    this.enabledLanguages = const [SupportedLanguage.en],
    this.defaultLanguage = SupportedLanguage.en,
    SupportedLanguage? selectedLanguage,
  }) : selectedLanguage = selectedLanguage ?? defaultLanguage;

  final EditTopicStatus status;
  final String topicId;
  final Map<SupportedLanguage, String> name;
  final Map<SupportedLanguage, String> description;
  final String? iconUrl;
  final Uint8List? imageFileBytes;
  final String? imageFileName;
  final HttpException? exception;
  final Topic? updatedTopic;
  final bool imageRemoved;
  final Topic? initialTopic;
  final List<SupportedLanguage> enabledLanguages;
  final SupportedLanguage defaultLanguage;
  final SupportedLanguage selectedLanguage;

  /// Returns true if the form is valid and can be submitted.
  /// Based on the Topic model, name, description, and iconUrl are required.
  bool get isFormValid {
    // An image is considered present if there's a new one selected,
    // or if there was an initial one that hasn't been explicitly removed.
    final hasImage =
        imageFileBytes != null || (iconUrl != null && !imageRemoved);
    return (name[defaultLanguage]?.isNotEmpty ?? false) &&
        (description[defaultLanguage]?.isNotEmpty ?? false) &&
        hasImage;
  }

  EditTopicState copyWith({
    EditTopicStatus? status,
    String? topicId,
    Map<SupportedLanguage, String>? name,
    Map<SupportedLanguage, String>? description,
    ValueWrapper<String?>? iconUrl,
    ValueWrapper<Uint8List?>? imageFileBytes,
    ValueWrapper<String?>? imageFileName,
    ValueWrapper<HttpException?>? exception,
    Topic? updatedTopic,
    bool? imageRemoved,
    Topic? initialTopic,
    List<SupportedLanguage>? enabledLanguages,
    SupportedLanguage? defaultLanguage,
    SupportedLanguage? selectedLanguage,
  }) {
    return EditTopicState(
      status: status ?? this.status,
      topicId: topicId ?? this.topicId,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl != null ? iconUrl.value : this.iconUrl,
      imageFileBytes: imageFileBytes != null
          ? imageFileBytes.value
          : this.imageFileBytes,
      imageFileName: imageFileName != null
          ? imageFileName.value
          : this.imageFileName,
      exception: exception != null ? exception.value : this.exception,
      updatedTopic: updatedTopic ?? this.updatedTopic,
      imageRemoved: imageRemoved ?? this.imageRemoved,
      initialTopic: initialTopic ?? this.initialTopic,
      enabledLanguages: enabledLanguages ?? this.enabledLanguages,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    topicId,
    name,
    description,
    iconUrl,
    imageFileBytes,
    imageFileName,
    exception,
    updatedTopic,
    imageRemoved,
    initialTopic,
  ];
}
