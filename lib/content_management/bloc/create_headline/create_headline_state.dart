part of 'create_headline_bloc.dart';

/// Represents the status of the create headline operation.
enum CreateHeadlineStatus {
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

/// The state for the [CreateHeadlineBloc].
final class CreateHeadlineState extends Equatable {
  const CreateHeadlineState({
    this.status = CreateHeadlineStatus.initial,
    this.title = const {},
    this.url = '',
    this.imageFileBytes,
    this.imageFileName,
    this.source,
    this.topic,
    this.mentionedCountries = const [],
    this.mentionedPersons = const [],
    this.exception,
    this.isBreaking = false,
    this.createdHeadline,
    this.enabledLanguages = const [SupportedLanguage.en],
    this.defaultLanguage = SupportedLanguage.en,
    SupportedLanguage? selectedLanguage,
  }) : selectedLanguage = selectedLanguage ?? defaultLanguage;

  final CreateHeadlineStatus status;
  final Map<SupportedLanguage, String> title;
  final String url;
  final Uint8List? imageFileBytes;
  final String? imageFileName;
  final Source? source;
  final Topic? topic;
  final List<Country> mentionedCountries;
  final List<Person> mentionedPersons;
  final HttpException? exception;
  final bool isBreaking;
  final Headline? createdHeadline;
  final List<SupportedLanguage> enabledLanguages;
  final SupportedLanguage defaultLanguage;
  final SupportedLanguage selectedLanguage;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      (title[defaultLanguage]?.isNotEmpty ?? false) &&
      url.isNotEmpty &&
      imageFileBytes != null &&
      imageFileName != null &&
      source != null &&
      topic != null &&
      mentionedCountries.isNotEmpty;

  CreateHeadlineState copyWith({
    CreateHeadlineStatus? status,
    Map<SupportedLanguage, String>? title,
    String? url,
    ValueWrapper<Uint8List?>? imageFileBytes,
    ValueWrapper<String?>? imageFileName,
    ValueGetter<Source?>? source,
    ValueGetter<Topic?>? topic,
    List<Country>? mentionedCountries,
    List<Person>? mentionedPersons,
    bool? isBreaking,
    ValueWrapper<HttpException?>? exception,
    Headline? createdHeadline,
    List<SupportedLanguage>? enabledLanguages,
    SupportedLanguage? defaultLanguage,
    SupportedLanguage? selectedLanguage,
  }) {
    return CreateHeadlineState(
      status: status ?? this.status,
      title: title ?? this.title,
      url: url ?? this.url,
      imageFileBytes: imageFileBytes != null
          ? imageFileBytes.value
          : this.imageFileBytes,
      imageFileName: imageFileName != null
          ? imageFileName.value
          : this.imageFileName,
      source: source != null ? source() : this.source,
      topic: topic != null ? topic() : this.topic,
      mentionedCountries: mentionedCountries ?? this.mentionedCountries,
      mentionedPersons: mentionedPersons ?? this.mentionedPersons,
      isBreaking: isBreaking ?? this.isBreaking,
      exception: exception != null ? exception.value : this.exception,
      createdHeadline: createdHeadline ?? this.createdHeadline,
      enabledLanguages: enabledLanguages ?? this.enabledLanguages,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    title,
    url,
    imageFileBytes,
    imageFileName,
    source,
    topic,
    mentionedCountries,
    mentionedPersons,
    isBreaking,
    exception,
    createdHeadline,
    enabledLanguages,
    defaultLanguage,
    selectedLanguage,
  ];
}
