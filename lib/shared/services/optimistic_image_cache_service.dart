import 'dart:typed_data';

/// {@template optimistic_image_cache_service}
/// A session-scoped, in-memory cache to hold image data for optimistic UI
/// updates.
///
/// This service stores the `Uint8List` of an image that has been uploaded but
/// not yet processed by the backend. It maps a unique entity ID (like a
/// headline ID) to its corresponding image bytes. This allows the UI to
/// display the uploaded image immediately, even before the permanent `imageUrl`
/// is available from the server.
///
/// The cache is invalidated (cleared for a specific ID) once the permanent
/// URL is fetched, ensuring a seamless transition from the optimistic local
/// image to the final network image.
/// {@endtemplate}
class OptimisticImageCacheService {
  final _cache = <String, Uint8List>{};

  /// Caches the image bytes for a given entity ID.
  void cacheImage(String entityId, Uint8List imageBytes) {
    _cache[entityId] = imageBytes;
  }

  /// Retrieves the cached image bytes for a given entity ID.
  Uint8List? getImage(String entityId) => _cache[entityId];

  /// Removes the cached image bytes for a given entity ID.
  void removeImage(String entityId) => _cache.remove(entityId);
}
