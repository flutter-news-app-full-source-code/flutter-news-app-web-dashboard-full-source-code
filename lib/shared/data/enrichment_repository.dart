import 'package:core/core.dart';
import 'package:logging/logging.dart';

/// Abstract interface for enrichment operations.
abstract class EnrichmentClient {
  /// Sends a (potentially partial) [Headline] to the AI enrichment endpoint.
  Future<Headline> enrichHeadline(Headline headline);
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

  @override
  Future<Headline> enrichHeadline(Headline headline) async {
    _logger.info('Requesting enrichment for headline: ${headline.title}');
    try {
      final responseData = await _httpClient.post<Map<String, dynamic>>(
        '/api/v1/enrich_headline',
        data: headline.toJson(),
      );

      final apiResponse = SuccessApiResponse<Headline>.fromJson(
        responseData,
        (json) => Headline.fromJson(json! as Map<String, dynamic>),
      );

      _logger.info('Enrichment successful.');
      return apiResponse.data;
    } on HttpException catch (e) {
      _logger.severe('Enrichment failed.', e);
      rethrow;
    }
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
}
