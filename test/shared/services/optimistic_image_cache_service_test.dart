import 'dart:typed_data';

import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OptimisticImageCacheService', () {
    late OptimisticImageCacheService service;

    setUp(() {
      service = OptimisticImageCacheService();
    });

    test('can cache and retrieve an image', () {
      const entityId = 'test-id';
      final imageBytes = Uint8List.fromList([1, 2, 3]);

      service.cacheImage(entityId, imageBytes);
      final cachedImage = service.getImage(entityId);

      expect(cachedImage, equals(imageBytes));
    });

    test('can remove a cached image', () {
      const entityId = 'test-id';
      final imageBytes = Uint8List.fromList([1, 2, 3]);

      service.cacheImage(entityId, imageBytes);
      service.removeImage(entityId);
      final cachedImage = service.getImage(entityId);

      expect(cachedImage, isNull);
    });
  });
}
