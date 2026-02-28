part of 'edit_headline_bloc.dart';

/// Represents the status of the edit headline operation.
enum EditHeadlineStatus {
  initial,
  loading,
  success,
  failure,
  imageUploading,
  imageUploadFailure,
  entitySubmitting,
  entitySubmitFailure,
}

/// The state for the [EditHeadlineBloc].
final class EditHeadlineState extends Equatable {
  const EditHeadlineState({
    required this.headlineId,
    this.status = EditHeadlineStatus.initial,
    this.title = const {},
    this.url = '',
    this.imageUrl,
    this.imageFileBytes,
    this.imageFileName,
    this.source,
    this.topic,
    this.eventCountry,
    this.exception,
    this.isBreaking = false,
    this.updatedHeadline,
    this.imageRemoved = false,
    this.initialHeadline,
    this.enabledLanguages = const [SupportedLanguage.en],
    this.defaultLanguage = SupportedLanguage.en,
    SupportedLanguage? selectedLanguage,
  }) : selectedLanguage = selectedLanguage ?? defaultLanguage;

  final EditHeadlineStatus status;
  final String headlineId;
  final Map<SupportedLanguage, String> title;
  final String url;
  final String? imageUrl;
  final Uint8List? imageFileBytes;
  final String? imageFileName;
  final Source? source;
  final Topic? topic;
  final Country? eventCountry;
  final HttpException? exception;
  final bool isBreaking;
  final Headline? updatedHeadline;
  final bool imageRemoved;
  final Headline? initialHeadline;
  final List<SupportedLanguage> enabledLanguages;
  final SupportedLanguage defaultLanguage;
  final SupportedLanguage selectedLanguage;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid {
    // An image is considered present if there's a new one selected,
    // or if there was an initial one that hasn't been explicitly removed.
    final hasImage =
        imageFileBytes != null || (imageUrl != null && !imageRemoved);

    return headlineId.isNotEmpty &&
        (title[defaultLanguage]?.isNotEmpty ?? false) &&
        url.isNotEmpty &&
        hasImage &&
        source != null &&
        topic != null &&
        eventCountry != null;
  }

  // isBreaking is not part of form validity for editing, as it doesn't
  // trigger new notifications on update.

  EditHeadlineState copyWith({
    EditHeadlineStatus? status,
    String? headlineId,
    Map<SupportedLanguage, String>? title,
    String? url,
    ValueWrapper<String?>? imageUrl,
    ValueWrapper<Uint8List?>? imageFileBytes,
    ValueWrapper<String?>? imageFileName,
    ValueGetter<Source?>? source,
    ValueGetter<Topic?>? topic,
    ValueGetter<Country?>? eventCountry,
    bool? isBreaking,
    ValueWrapper<HttpException?>? exception,
    Headline? updatedHeadline,
    bool? imageRemoved,
    Headline? initialHeadline,
    List<SupportedLanguage>? enabledLanguages,
    SupportedLanguage? defaultLanguage,
    SupportedLanguage? selectedLanguage,
  }) {
    return EditHeadlineState(
      status: status ?? this.status,
      headlineId: headlineId ?? this.headlineId,
      title: title ?? this.title,
      url: url ?? this.url,
      imageUrl: imageUrl != null
          ? imageUrl.value
          : this.imageUrl, // This is the actual image URL from the backend, not the upload field.
      imageFileBytes: imageFileBytes != null
          ? imageFileBytes.value
          : this.imageFileBytes,
      imageFileName: imageFileName != null
          ? imageFileName.value
          : this.imageFileName,
      source: source != null ? source() : this.source,
      topic: topic != null ? topic() : this.topic,
      eventCountry: eventCountry != null ? eventCountry() : this.eventCountry,
      isBreaking: isBreaking ?? this.isBreaking,
      exception: exception != null ? exception.value : this.exception,
      updatedHeadline: updatedHeadline ?? this.updatedHeadline,
      imageRemoved: imageRemoved ?? this.imageRemoved,
      initialHeadline: initialHeadline ?? this.initialHeadline,
      enabledLanguages: enabledLanguages ?? this.enabledLanguages,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    headlineId,
    title,
    url,
    imageUrl,
    imageFileBytes,
    imageFileName,
    source,
    topic,
    eventCountry,
    isBreaking,
    exception,
    updatedHeadline,
    imageRemoved,
    initialHeadline,
    enabledLanguages,
    defaultLanguage,
    selectedLanguage,
  ];
}
