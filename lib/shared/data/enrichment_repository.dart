import 'package:core/core.dart';
import 'package:logging/logging.dart';

/// Abstract interface for enrichment operations.
abstract class EnrichmentClient {
  /// Sends a (potentially partial) [Headline] to the AI enrichment endpoint.
  Future<Headline> enrichHeadline(Headline headline);

  /// Sends a (potentially partial) [Topic] to the AI enrichment endpoint.
  Future<Topic> enrichTopic(Topic topic);

  /// Sends a (potentially partial) [Source] to the AI enrichment endpoint.
  Future<Source> enrichSource(Source source);

  /// Sends a (potentially partial) [Person] to the AI enrichment endpoint.
  Future<Person> enrichPerson(Person person);
}

/// API implementation of [EnrichmentClient].
class EnrichmentApi implements EnrichmentClient {
  EnrichmentApi({
    required HttpClient httpClient,
    Logger? logger,
  }) : _httpClient = httpClient,
       _logger = logger ?? Logger('EnrichmentApi');

  final HttpClient _httpClient;
  final Logger _logger;

  /// Internal helper to perform the enrichment HTTP POST request.
  Future<T> _performEnrichment<T>({
    required String path,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final responseData = await _httpClient.post<Map<String, dynamic>>(
        path,
        data: data,
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      final apiResponse = SuccessApiResponse<T>.fromJson(
        responseData,
        (json) => fromJson(json! as Map<String, dynamic>),
      );

      return apiResponse.data;
    } on HttpException catch (e) {
      _logger.severe('Enrichment failed for path: $path', e);
      rethrow;
    }
  }

  @override
  Future<Headline> enrichHeadline(Headline headline) async {
    _logger.info('Enriching headline: ${headline.id}');
    return _performEnrichment<Headline>(
      path: '/api/v1/intelligence/headlines/enrich',
      data: headline.toJson(),
      fromJson: Headline.fromJson,
    );
  }

  @override
  Future<Topic> enrichTopic(Topic topic) async {
    _logger.info('Enriching topic: ${topic.id}');
    return _performEnrichment<Topic>(
      path: '/api/v1/intelligence/topics/enrich',
      data: topic.toJson(),
      fromJson: Topic.fromJson,
    );
  }

  @override
  Future<Source> enrichSource(Source source) async {
    _logger.info('Enriching source: ${source.id}');
    return _performEnrichment<Source>(
      path: '/api/v1/intelligence/sources/enrich',
      data: source.toJson(),
      fromJson: Source.fromJson,
    );
  }

  @override
  Future<Person> enrichPerson(Person person) async {
    _logger.info('Enriching person: ${person.id}');
    return _performEnrichment<Person>(
      path: '/api/v1/intelligence/persons/enrich',
      data: person.toJson(),
      fromJson: Person.fromJson,
    );
  }
}

/// Repository for managing enrichment operations.
class EnrichmentRepository {
  const EnrichmentRepository({required EnrichmentClient enrichmentClient})
    : _client = enrichmentClient;

  final EnrichmentClient _client;

  /// Orchestrates the headline enrichment process.
  ///
  /// Delegates to the underlying [EnrichmentClient].
  Future<Headline> enrichHeadline(Headline headline) async {
    return _client.enrichHeadline(headline);
  }

  /// Orchestrates the topic enrichment process.
  Future<Topic> enrichTopic(Topic topic) async {
    return _client.enrichTopic(topic);
  }

  /// Orchestrates the source enrichment process.
  Future<Source> enrichSource(Source source) async {
    return _client.enrichSource(source);
  }

  /// Orchestrates the person enrichment process.
  Future<Person> enrichPerson(Person person) async {
    return _client.enrichPerson(person);
  }
}
