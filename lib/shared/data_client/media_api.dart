import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_client/http_client.dart';
import 'package:logging/logging.dart';

/// A web-specific implementation of the [MediaClient] interface.
///
/// This client handles the two-stage file upload process required by the
/// backend, which uses GCS V4 Policy Signed POSTs.
class MediaApi implements MediaClient {
  /// {@macro media_api}
  MediaApi({
    required HttpClient httpClient,
    Logger? logger,
  }) : _httpClient = httpClient,
       _logger = logger ?? Logger('MediaApi');

  final HttpClient _httpClient;
  final Logger _logger;

  static const String _basePath = '/api/v1/media';

  @override
  Future<RequestUploadUrlResponse> requestUploadUrl(
    RequestUploadUrlRequest request,
  ) async {
    _logger.info('Requesting upload URL for file: ${request.fileName}');
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '$_basePath/request-upload-url',
        data: request.toJson(),
      );
      _logger.fine('Received upload URL response: $response');
      return RequestUploadUrlResponse.fromJson(response);
    } on HttpException {
      _logger.severe('Failed to request upload URL for ${request.fileName}');
      rethrow;
    } catch (e, s) {
      _logger.severe(
        'An unexpected error occurred while requesting upload URL.',
        e,
        s,
      );
      throw UnknownException(
        'An unexpected error occurred while requesting upload URL: $e',
      );
    }
  }

  @override
  Future<void> uploadFileWithSignedPolicy({
    required String url,
    required Map<String, String> fields,
    required String fileName,
    required Uint8List fileBytes,
    required String contentType,
  }) async {
    _logger.info('Uploading file "$fileName" to signed URL...');
    try {
      final formData = dio.FormData();

      formData.fields.addAll(fields.entries);

      formData.files.add(
        MapEntry(
          'file',
          dio.MultipartFile.fromBytes(
            fileBytes,
            filename: fileName,
          ),
        ),
      );

      await _httpClient.post<dynamic>(
        url,
        data: formData,
        options: dio.Options(
          contentType: 'multipart/form-data',
          validateStatus: (status) => status == 204,
        ),
      );
      _logger.info('Successfully uploaded file "$fileName".');
    } on BadRequestException {
      _logger.warning('File upload failed for "$fileName": File is too large.');
      rethrow;
    } on HttpException {
      _logger.severe('File upload failed for "$fileName".');
      rethrow;
    } catch (e, s) {
      _logger.severe('An unexpected error occurred during file upload.', e, s);
      throw UnknownException('An unexpected error occurred: $e');
    }
  }
}
