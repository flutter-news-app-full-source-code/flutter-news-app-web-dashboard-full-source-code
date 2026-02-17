import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';
import 'package:mocktail/mocktail.dart';

export 'package:bloc_test/bloc_test.dart';
export 'package:flutter_test/flutter_test.dart';
export 'package:mocktail/mocktail.dart';

void registerFallbackValues() {
  registerFallbackValue(Uri.parse('http://example.com'));
  registerFallbackValue(const Duration(seconds: 1));
  registerFallbackValue(FakeHeadline(id: 'fake-id'));
  registerFallbackValue(FakeSource());
  registerFallbackValue(FakeTopic());
  registerFallbackValue(FakeCountry());
  registerFallbackValue(MediaAssetPurpose.headlineImage);
  registerFallbackValue(Uint8List(0));
}

class MockDataRepository<T> extends Mock implements DataRepository<T> {}

class MockMediaRepository extends Mock implements MediaRepository {}

class MockOptimisticImageCacheService extends Mock
    implements OptimisticImageCacheService {}

class FakeHeadline extends Fake implements Headline {

  FakeHeadline({required this.id});
  @override
  final String id;
}

class FakeSource extends Fake implements Source {}

class FakeTopic extends Fake implements Topic {}

class FakeCountry extends Fake implements Country {}
