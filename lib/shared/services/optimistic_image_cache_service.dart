import 'dart:typed_data';

/// {@template optimistic_image_cache_service}
/// A session-scoped, in-memory cache to enable a resilient "optimistic UI" for
/// the application's two-stage image upload process.
///
/// ### The Problem: Latency in Image Processing
///
/// When a user uploads an image (e.g., for a headline, source, or topic), the
/// following asynchronous process occurs:
///
/// 1.  **Upload Request**: The client sends the raw image bytes to a dedicated
///     backend endpoint (`MediaRepository.uploadFile`).
/// 2.  **Asset Creation**: The backend creates a `MediaAsset` record and returns
///     its `mediaAssetId` to the client immediately.
/// 3.  **Content Update**: The client then updates the parent content (e.g., the
///     `Headline` document) with this new `mediaAssetId`.
/// 4.  **Backend Processing (Webhook)**: A separate, asynchronous backend
///     process (like a webhook) picks up the uploaded file, processes it
///     (e.g., creates thumbnails), and finally updates the parent content
///     document with a permanent, public `imageUrl`.
///
/// The critical issue is the time gap between Step 3 and Step 4. During this
/// interval, the `Headline` document has a `mediaAssetId` but no `imageUrl`.
/// If the UI relied solely on `imageUrl`, the user's newly uploaded image would
/// disappear until the backend processing completes, which is a poor user
/// experience.
///
/// ### The Solution: Optimistic Caching
///
/// This service acts as a short-term, in-memory bridge for that latency gap.
///
/// - **On Upload**: When an image is uploaded in a BLoC (e.g., `EditHeadlineBloc`),
///   the raw image bytes (`Uint8List`) are cached in this service against the
///   content's unique ID (e.g., `headlineId`).
///
/// - **On Display**: The UI (`ImageUploadField`) is designed to first check this
///   service for cached bytes corresponding to the content ID. If found, it
///   displays the cached image. If not, it falls back to using the `imageUrl`
///   from the model.
///
/// - **On Invalidation**: When the content is re-fetched from the repository
///   (e.g., in `ContentManagementBloc`), the BLoC checks if the `imageUrl` is
///   now present. If it is, it calls `removeImage(id)` on this service. This
///   ensures that the next time the UI builds, it will no longer find the cached
///   bytes and will seamlessly switch to displaying the permanent network image.
///
/// This makes the UI feel instantaneous and resilient, even if the user
/// navigates away and returns to the edit page before backend processing is
/// complete.
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
