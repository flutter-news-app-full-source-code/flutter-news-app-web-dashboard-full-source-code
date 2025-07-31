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
    this.language,
    this.headquarters,
    this.countries = const [],
    this.countriesHasMore = true,
    this.countriesCursor,
    this.countrySearchTerm = '',
    this.languages = const [],
    this.languagesHasMore = true,
    this.languagesCursor,
    this.languageSearchTerm = '',
    this.contentStatus = ContentStatus.active,
    this.exception,
    this.updatedSource,
  });

  final EditSourceStatus status;
  final Source? initialSource;
  final String name;
  final String description;
  final String url;
  final SourceType? sourceType;
  final Language? language;
  final Country? headquarters;
  final List<Country> countries;
  final bool countriesHasMore;
  final String? countriesCursor;
  final String countrySearchTerm;
  final List<Language> languages;
  final bool languagesHasMore;
  final String? languagesCursor;
  final String languageSearchTerm;
  final ContentStatus contentStatus;
  final HttpException? exception;
  final Source? updatedSource;

  /// Returns true if the form is valid and can be submitted.
  bool get isFormValid =>
      name.isNotEmpty &&
      description.isNotEmpty &&
      url.isNotEmpty &&
      sourceType != null &&
      language != null &&
      headquarters != null;

  EditSourceState copyWith({
    EditSourceStatus? status,
    Source? initialSource,
    String? name,
    String? description,
    String? url,
    ValueGetter<SourceType?>? sourceType,
    ValueGetter<Language?>? language,
    ValueGetter<Country?>? headquarters,
    List<Country>? countries,
    bool? countriesHasMore,
    String? countriesCursor,
    String? countrySearchTerm,
    List<Language>? languages,
    bool? languagesHasMore,
    String? languagesCursor,
    String? languageSearchTerm,
    ContentStatus? contentStatus,
    HttpException? exception,
    Source? updatedSource,
  }) {
    return EditSourceState(
      status: status ?? this.status,
      initialSource: initialSource ?? this.initialSource,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      sourceType: sourceType != null ? sourceType() : this.sourceType,
      language: language != null ? language() : this.language,
      headquarters: headquarters != null ? headquarters() : this.headquarters,
      countries: countries ?? this.countries,
      countriesHasMore: countriesHasMore ?? this.countriesHasMore,
      countriesCursor: countriesCursor ?? this.countriesCursor,
      countrySearchTerm: countrySearchTerm ?? this.countrySearchTerm,
      languages: languages ?? this.languages,
      languagesHasMore: languagesHasMore ?? this.languagesHasMore,
      languagesCursor: languagesCursor ?? this.languagesCursor,
      languageSearchTerm: languageSearchTerm ?? this.languageSearchTerm,
      contentStatus: contentStatus ?? this.contentStatus,
      exception: exception,
      updatedSource: updatedSource ?? this.updatedSource,
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
    countriesHasMore,
    countriesCursor,
    countrySearchTerm,
    languages,
    languagesHasMore,
    languagesCursor,
    languageSearchTerm,
    contentStatus,
    exception,
    updatedSource,
  ];
}
